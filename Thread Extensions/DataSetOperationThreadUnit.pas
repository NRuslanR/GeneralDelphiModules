unit DataSetOperationThreadUnit;

interface

  uses Windows, SysUtils, Classes, DB, StrUtils,
       ZAbstractDataset, ZAbstractRODataset, CancellationThreadUnit;

  const

    PG_QUERY_CANCELLED_ERROR_CODE = '57014';

  type

    TDataOperationType = (opSelectData, opChangeData);

    TOnDataOperationErrorOccurredEvent =
      procedure(
        Sender: TObject;
        DataSet: TDataSet;
        const Error: Exception;
        RelatedState: TObject
      ) of object;

    TOnDataOperationSuccessEvent =
      procedure(
        Sender: TObject;
        DataSet: TDataSet;
        RelatedState: TObject
      ) of object;

    TDataSetOperationThread = class(TCancellationThread)

      strict protected

        FDataSet: TZAbstractRODataSet;
        FDataLoadingError: Exception;
        FDataOperationType: TDataOperationType;
        FFreeDataSetOnFail: Boolean;
        FFreeDataSetOnCancellation: Boolean;
        FFreeDataSetOnSuccess: Boolean;
        FDBServiceProcessID: Variant; // at least for abort Postgres session load operation
        FOnDataOperationErrorOccurredEvent: TOnDataOperationErrorOccurredEvent;
        FOnDataOperationSuccessEvent: TOnDataOperationSuccessEvent;

        FRelatedState: TObject; // arbitrary user-defined data
        
        procedure Execute; override;
        procedure InternalExecute; virtual;

        procedure RaiseOnDataOperationErrorOccurredEvent;
        procedure RaiseOnDataOperationSuccessEvent;

        procedure GetDBServiceProcessID;

        procedure SetIsCancelled(const AIsCancelled: Boolean); override;

        procedure SetDataSet(const ADataSet: TZAbstractRODataSet);

      public

        constructor Create; overload;

        constructor Create(
          ADataSet: TZAbstractRODataSet;
          ADataOperationType: TDataOperationType = opSelectData;
          ACreateSuspended: Boolean = False
        ); overload;

        destructor Destroy; override;

        property DataSet: TZAbstractRODataSet read FDataSet write SetDataSet;
        property OnDataOperationErrorOccurredEvent: TOnDataOperationErrorOccurredEvent
        read FOnDataOperationErrorOccurredEvent write FOnDataOperationErrorOccurredEvent;

        property OnDataOperationSuccessEvent: TOnDataOperationSuccessEvent
        read FOnDataOperationSuccessEvent write FOnDataOperationSuccessEvent;
        property DataOperationType: TDataOperationType
        read FDataOperationType write FDataOperationType;

        property FreeDataSetOnFail: Boolean
        read FFreeDataSetOnFail write FFreeDataSetOnFail;

        property FreeDataSetOnCancellation: Boolean
        read FFreeDataSetOnCancellation write FFreeDataSetOnCancellation;

        property FreeDataSetOnSuccess: Boolean
        read FFreeDataSetOnSuccess write FFreeDataSetOnSuccess;

        property RelatedState: TObject
        read FRelatedState write FRelatedState;

  end;

implementation

  uses ZDbcIntfs, ZDataset, ZConnection, AuxZeosFunctions,
  AuxWindowsFunctionsUnit, Variants;

{ TDBDataOperationThread }

constructor TDataSetOperationThread.Create(
  ADataSet: TZAbstractRODataSet;
  ADataOperationType: TDataOperationType;
  ACreateSuspended: Boolean
);
begin

  DataSet := ADataSet;
  FDataOperationType := ADataOperationType;
  FDBServiceProcessID := Null;

  inherited Create(ACreateSuspended);

end;

constructor TDataSetOperationThread.Create;
begin

  inherited Create(True);

  FDBServiceProcessID := Null;

end;

destructor TDataSetOperationThread.Destroy;
begin

  FreeAndNil(FDataLoadingError);
  inherited;

end;

procedure TDataSetOperationThread.Execute;
var j: TZConnection;
begin

  InternalExecute;

  if (FFreeDataSetOnFail and Assigned(FDataLoadingError)) or
      (FFreeDataSetOnCancellation and IsCancelled) or
        (FFreeDataSetOnSuccess) then
          FreeAndNil(FDataSet)

end;

procedure TDataSetOperationThread.GetDBServiceProcessID;
begin

  try

    FDBServiceProcessID :=
      CreateAndExecuteQueryWithResults(
        FDataSet.Connection as TZConnection,
        'select pg_backend_pid() as service_pid',
        [],
        [],
        ['service_pid']
      )[0];

  except

    on e: Exception do begin

      FDBServiceProcessID := Null;
      
    end;

  end;

end;

procedure TDataSetOperationThread.InternalExecute;
begin

  try

    if RaiseOnCancellationEventHandlerIf then Exit;

    GetDBServiceProcessID;
    
    case FDataOperationType of

      opSelectData:
      begin

        DataSet.Close;
        DataSet.Open

      end;

      opChangeData:
      begin
        DataSet.ExecSQL;
      end;

    end;

    if RaiseOnCancellationEventHandlerIf then Exit;

    if Assigned(FOnDataOperationSuccessEvent) then
      Synchronize(RaiseOnDataOperationSuccessEvent);

  except

    on e: Exception do
      if Assigned(FOnDataOperationErrorOccurredEvent) then begin

        if e is EZSQLException then begin

          if (e as EZSQLException).StatusCode = PG_QUERY_CANCELLED_ERROR_CODE then
          begin

            RaiseOnCancellationEventHandlerIf;
            Exit;

          end;

          FDataLoadingError := EZSQLException.CreateClone(e as EZSQLThrowable);

        end

        else FDataLoadingError := Exception.Create(e.Message);

        Synchronize(RaiseOnDataOperationErrorOccurredEvent);

      end;

  end;

end;

procedure TDataSetOperationThread.RaiseOnDataOperationErrorOccurredEvent;
begin

  if Assigned(FOnDataOperationErrorOccurredEvent) then
    FOnDataOperationErrorOccurredEvent(
      Self, FDataSet, FDataLoadingError, FRelatedState
    );

end;

procedure TDataSetOperationThread.RaiseOnDataOperationSuccessEvent;
begin

  if Assigned(FOnDataOperationSuccessEvent) then
    FOnDataOperationSuccessEvent(Self, FDataSet, FRelatedState);

end;

procedure TDataSetOperationThread.SetDataSet(
  const ADataSet: TZAbstractRODataSet);
begin

  FDataSet := ADataSet;

  //GetDBServiceProcessID;

end;

procedure TDataSetOperationThread.SetIsCancelled(const AIsCancelled: Boolean);
var Connection: TZConnection;
    CancellationResult: Boolean;
begin

  if IsCancelled or VarIsNull(FDBServiceProcessID) then
    Exit;

  if ContainsText(FDataSet.Connection.Protocol, 'postgresql') then begin

    try

      try

        Connection := CreateConnection(FDataSet.Connection as TZConnection);

        FIsCanceled := True;
        
        CreateAndExecuteQueryWithResults(
          Connection,
          'select pg_cancel_backend(pid) as res from ' +
          'pg_stat_activity where pid = :service_pid and usename = :user and state = ''active''',
          ['service_pid', 'user'],
          [
            FDBServiceProcessID,
            Connection.User
          ],
          ['res']
        );

      except

        on e: Exception do
          ShowErrorMessage(0, e.Message, '������');

      end;

    finally

      FreeAndNil(Connection);
      
    end;

  end

  else inherited;

end;

end.
