unit ZQueryExecutor;

interface

uses

  DB,
  DataSetQueryExecutor,
  DataReader,
  QueryExecutor,
  ZDataset,
  ZConnection,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TZQueryExecutor = class (TDataSetQueryExecutor)

    protected

      FConnection: TZConnection;

    protected

      procedure OnDataModificationErrorOccurredEventHandler(
        Sender: TObject;
        DataSet: TDataSet;
        const Error: Exception;
        RelatedState: TObject
      ); 

      procedure OnDataModificationSuccessEventHandler(
        Sender: TObject;
        DataSet: TDataSet;
        RelatedState: TObject
      );

      procedure OnDataSelectionErrorOccurredEventHandler(
        Sender: TObject;
        DataSet: TDataSet;
        const Error: Exception;
        RelatedState: TObject
      );

      procedure OnDataSelectionSuccessEventHandler(
        Sender: TObject;
        DataSet: TDataSet;
        RelatedState: TObject
      );

    protected

      procedure FreeConnectionForDataSet(DataSet: TDataSet);

    protected

      function CreateQueryExecutingErrorFromException(const E: Exception): TQueryExecutingError; override;

    public

      constructor Create; overload;
      constructor Create(Connection: TZConnection); overload;

      function PrepareDataSet(
        const QueryPattern: String;
        QueryParams: TQueryParams = nil
      ): TDataSet; override;
      
      function ExecuteSelectionQuery(
        const Query: String;
        Params: TQueryParams = nil
      ): IDataReader; override;

      procedure ExecuteSelectionQueryAsync(
        const Query: String;
        Params: TQueryParams;
        RelatedState: TObject = nil;
        OnSelectionQuerySuccessedEventHandler: TOnSelectionQuerySuccessedEventHandler = nil;
        OnSelectionQueryFailedEventHandler: TOnSelectionQueryFailedEventHandler = nil
      ); override;

      function ExecuteModificationQuery(
        const Query: String;
        Params: TQueryParams
      ): Integer; override;

      procedure ExecuteModificationQueryAsync(
        const Query: String;
        Params: TQueryParams;
        RelatedState: TObject = nil;
        OnModificationQuerySuccessedEventHandler: TOnModificationQuerySuccessedEventHandler = nil;
        OnModificationQueryFailedEventHandler: TOnModificationQueryFailedEventHandler = nil
      ); override;

      property Connection: TZConnection
      read FConnection write FConnection;

  end;
  
implementation

uses

  ZDbcIntfs,
  AuxZeosFunctions,
  ZSqlUpdate,
  AuxAsyncZeosFunctions,
  ZDataSetReader,
  ZAbstractRODataset;

type

  TAsyncModificationQueryEventHandlersData = class

    public

      RelatedState: TObject;
      OnModificationQuerySuccessedEventHandler: TOnModificationQuerySuccessedEventHandler;
      OnModificationQueryFailedEventHandler: TOnModificationQueryFailedEventHandler;

      destructor Destroy; override;
      constructor Create(
        RelatedState: TObject;
        OnModificationQuerySuccessedEventHandler: TOnModificationQuerySuccessedEventHandler;
        OnModificationQueryFailedEventHandler: TOnModificationQueryFailedEventHandler
      );

  end;

  TAsyncSelectionQueryEventHandlersData = class

    public

      RelatedState: TObject;
      OnSelectionQuerySuccessedEventHandler: TOnSelectionQuerySuccessedEventHandler;
      OnSelectionQueryFailedEventHandler: TOnSelectionQueryFailedEventHandler;

      destructor Destroy; override;
      constructor Create(
        RelatedState: TObject;
        OnSelectionQuerySuccessedEventHandler: TOnSelectionQuerySuccessedEventHandler;
        OnSelectionQueryFailedEventHandler: TOnSelectionQueryFailedEventHandler
      );

  end;

{ TZQueryExecutor }

constructor TZQueryExecutor.Create;
begin

end;

constructor TZQueryExecutor.Create(Connection: TZConnection);
begin

  inherited Create;

  FConnection := Connection;
  
end;

function TZQueryExecutor.CreateQueryExecutingErrorFromException(
  const E: Exception): TQueryExecutingError;
begin

  Result := inherited CreateQueryExecutingErrorFromException(E);

  if E is EZSQLThrowable then
    Result.Code := (E as EZSQLThrowable).StatusCode;
    
end;

function TZQueryExecutor.ExecuteModificationQuery(
  const Query: String;
  Params: TQueryParams
): Integer;
var ParamNames: TStrings;
    ParamValues: TVariantList;
    ZQuery: TZQuery;
begin

  ParamNames := nil;
  ParamValues := nil;
  ZQuery := nil;

  try

    try

      if Assigned(Params) then begin

        ParamNames := Params.FetchParamNames;
        ParamValues := Params.FetchParamValues;

      end;

      ZQuery :=
        CreateAndExecuteQuery(
          FConnection,
          Query,
          ParamNames,
          ParamValues,
          False
        );

      Result := ZQuery.RowsAffected;

    except

      on e: Exception do begin

        raise CreateQueryExecutingErrorFromException(e);
        
      end;

    end;

  finally

    FreeAndNil(ZQuery);
    FreeAndNil(ParamNames);
    FreeAndNil(ParamValues);

  end;

end;

procedure TZQueryExecutor.ExecuteModificationQueryAsync(
  const Query: String;
  Params: TQueryParams;
  RelatedState: TObject;
  OnModificationQuerySuccessedEventHandler: TOnModificationQuerySuccessedEventHandler;
  OnModificationQueryFailedEventHandler: TOnModificationQueryFailedEventHandler
);
var ParamNames: TStrings;
    ParamValues: TVariantList;
begin

  ParamNames := nil;
  ParamValues := nil;

  try

    if Assigned(Params) then begin

      ParamNames := Params.FetchParamNames;
      ParamValues := Params.FetchParamValues;

    end;

    ExecuteQueryAsync(

      CreateConnection(FConnection),
      Query,
      ParamNames,
      ParamValues,
      False,

      OnDataModificationSuccessEventHandler,
      OnDataModificationErrorOccurredEventHandler,

      TAsyncModificationQueryEventHandlersData.Create(
        RelatedState,
        OnModificationQuerySuccessedEventHandler,
        OnModificationQueryFailedEventHandler
      )
    );

  finally

    FreeAndNil(ParamNames);
    FreeAndNil(ParamValues);
    
  end;
  
end;

function TZQueryExecutor.ExecuteSelectionQuery(
  const Query: String;
  Params: TQueryParams
): IDataReader;
var ParamNames: TStrings;
    ParamValues: TVariantList;
    ZQuery: TZQuery;
begin

  ParamNames := nil;
  ParamValues := nil;
  
  try

    try

      if Assigned(Params) then begin

        ParamNames := Params.FetchParamNames;
        ParamValues := Params.FetchParamValues;

      end;

      ZQuery :=
        CreateAndExecuteQuery(
          FConnection,
          Query,
          ParamNames,
          ParamValues
        );

      Result := TZDataSetReader.Create(ZQuery);

    except

      on e: Exception do begin

        raise CreateQueryExecutingErrorFromException(e);
        
      end;
      
    end;

  finally

    FreeAndNil(ParamNames);
    FreeAndNil(ParamValues);
    
  end;
  
end;

procedure TZQueryExecutor.ExecuteSelectionQueryAsync(
  const Query: String;
  Params: TQueryParams;
  RelatedState: TObject;
  OnSelectionQuerySuccessedEventHandler: TOnSelectionQuerySuccessedEventHandler;
  OnSelectionQueryFailedEventHandler: TOnSelectionQueryFailedEventHandler
);
var ParamNames: TStrings;
    ParamValues: TVariantList;
begin

  ParamNames := nil;
  ParamValues := nil;

  try

    if Assigned(params) then begin

      ParamNames := Params.FetchParamNames;
      ParamValues := Params.FetchParamValues;

    end;

    ExecuteQueryAsync(
      CreateConnection(FConnection),
      Query,
      ParamNames,
      ParamValues,
      True,
      OnDataSelectionSuccessEventHandler,
      OnDataSelectionErrorOccurredEventHandler,
      TAsyncSelectionQueryEventHandlersData.Create(
        RelatedState,
        OnSelectionQuerySuccessedEventHandler,
        OnSelectionQueryFailedEventHandler
      )
    );

  finally

    FreeAndNil(ParamNames);
    FreeAndNil(ParamValues);
    
  end;

end;

procedure TZQueryExecutor.FreeConnectionForDataSet(DataSet: TDataSet);
var ZDataSet: TZQuery;
    ZConnection: TZConnection;
begin

  ZDataSet := DataSet as TZQuery;

  ZConnection := ZDataSet.Connection as TZConnection;

  ZDataSet.Connection := nil;
  
  FreeAndNil(ZConnection);

end;

procedure TZQueryExecutor.OnDataModificationErrorOccurredEventHandler(
  Sender: TObject;
  DataSet: TDataSet;
  const Error: Exception;
  RelatedState: TObject
);
var AsyncModificationQueryEventHandlersData: TAsyncModificationQueryEventHandlersData;
    QueryExecutingError: TQueryExecutingError;
begin

  AsyncModificationQueryEventHandlersData :=
    RelatedState as TAsyncModificationQueryEventHandlersData;

  QueryExecutingError := nil;
  
  try

    if Assigned(AsyncModificationQueryEventHandlersData.OnModificationQueryFailedEventHandler)
    then begin

      QueryExecutingError := CreateQueryExecutingErrorFromException(Error);

      AsyncModificationQueryEventHandlersData.
        OnModificationQueryFailedEventHandler(
          Self,
          QueryExecutingError,
          AsyncModificationQueryEventHandlersData.RelatedState
        );

    end;

  finally

    FreeAndNil(AsyncModificationQueryEventHandlersData);
    FreeAndNil(QueryExecutingError);
    
    FreeConnectionForDataSet(DataSet);

  end;
  
end;

procedure TZQueryExecutor.OnDataModificationSuccessEventHandler(
  Sender: TObject;
  DataSet: TDataSet;
  RelatedState: TObject
);
var AsyncModificationQueryEventHandlersData: TAsyncModificationQueryEventHandlersData;
begin

  AsyncModificationQueryEventHandlersData :=
    RelatedState as TAsyncModificationQueryEventHandlersData;

  try

    if Assigned(AsyncModificationQueryEventHandlersData.OnModificationQuerySuccessedEventHandler)
    then begin

      AsyncModificationQueryEventHandlersData.
        OnModificationQuerySuccessedEventHandler(
          Sender,
          (DataSet as TZQuery).RowsAffected,
          AsyncModificationQueryEventHandlersData.RelatedState
        );

    end;

  finally

    FreeAndNil(AsyncModificationQueryEventHandlersData);

    FreeConnectionForDataSet(DataSet);

  end;

end;

procedure TZQueryExecutor.OnDataSelectionErrorOccurredEventHandler(
  Sender: TObject;
  DataSet: TDataSet;
  const Error: Exception;
  RelatedState: TObject
);
var AsyncSelectionQueryEventHandlersData: TAsyncSelectionQueryEventHandlersData;
    QueryExecutingError: TQueryExecutingError;
begin

  AsyncSelectionQueryEventHandlersData :=
    RelatedState as TAsyncSelectionQueryEventHandlersData;

  QueryExecutingError := nil;
  
  try

    if Assigned(AsyncSelectionQueryEventHandlersData.OnSelectionQueryFailedEventHandler)
    then begin

      QueryExecutingError := CreateQueryExecutingErrorFromException(Error);
      
      AsyncSelectionQueryEventHandlersData.OnSelectionQueryFailedEventHandler(
        Sender,
        QueryExecutingError,
        AsyncSelectionQueryEventHandlersData.RelatedState
      );
      
    end;

  finally

    FreeAndNil(AsyncSelectionQueryEventHandlersData);
    FreeAndNil(QueryExecutingError);
    
    FreeConnectionForDataSet(DataSet);
    
  end;

end;

procedure TZQueryExecutor.OnDataSelectionSuccessEventHandler(
  Sender: TObject;
  DataSet: TDataSet;
  RelatedState: TObject
);
var AsyncSelectionQueryEventHandlersData: TAsyncSelectionQueryEventHandlersData;
begin

  AsyncSelectionQueryEventHandlersData :=
    RelatedState as TAsyncSelectionQueryEventHandlersData;

  try

    if Assigned(AsyncSelectionQueryEventHandlersData.OnSelectionQuerySuccessedEventHandler)
    then begin

      AsyncSelectionQueryEventHandlersData.OnSelectionQuerySuccessedEventHandler(
        Sender,
        TZDataSetReader.Create(DataSet),
        AsyncSelectionQueryEventHandlersData.RelatedState
      );
      
    end;
    
  finally

    FreeAndNil(AsyncSelectionQueryEventHandlersData);
                 
    FreeConnectionForDataSet(DataSet);
    
  end;

end;

function TZQueryExecutor.PrepareDataSet(
  const QueryPattern: String;
  QueryParams: TQueryParams
): TDataSet;
var Connection: TZConnection;
    ParamNames: TStrings;
    ParamValues: TVariantList;
    ZDataSet: TZQuery;
begin

  Connection := CreateConnection(FConnection);

  ParamNames := nil;
  ParamValues := nil;

  try

    if Assigned(QueryParams) then begin

      ParamNames := QueryParams.FetchParamNames;
      ParamValues := QueryParams.FetchParamValues;

    end;

    try

      ZDataSet :=
        CreateQueryObject(Connection, QueryPattern, ParamNames, ParamValues);

      ZDataSet.InsertComponent(Connection);

      ZDataSet.UpdateObject := TZUpdateSQL.Create(ZDataSet);

      ZDataSet.InsertComponent(ZDataSet.UpdateObject);
      
      ZDataSet.CachedUpdates := True;
      
      Result := ZDataSet;

    except

      on e: Exception do begin

        FreeAndNil(Connection);

        raise;

      end;

    end;

  finally

    FreeAndNil(ParamNames);
    FreeAndNil(ParamValues);
    
  end;

end;

{ TAsyncModificationQueryEventHandlersData }

constructor TAsyncModificationQueryEventHandlersData.Create(
  RelatedState: TObject;
  OnModificationQuerySuccessedEventHandler: TOnModificationQuerySuccessedEventHandler;
  OnModificationQueryFailedEventHandler: TOnModificationQueryFailedEventHandler);
begin

  inherited Create;

  Self.RelatedState := RelatedState;
  Self.OnModificationQuerySuccessedEventHandler := OnModificationQuerySuccessedEventHandler;
  Self.OnModificationQueryFailedEventHandler := OnModificationQueryFailedEventHandler;

end;

destructor TAsyncModificationQueryEventHandlersData.Destroy;
begin

  inherited;

end;

{ TAsyncSelectionQueryEventHandlersData }

constructor TAsyncSelectionQueryEventHandlersData.Create(
  RelatedState: TObject;
  OnSelectionQuerySuccessedEventHandler: TOnSelectionQuerySuccessedEventHandler;
  OnSelectionQueryFailedEventHandler: TOnSelectionQueryFailedEventHandler
);
begin

  inherited Create;
            
  Self.RelatedState := RelatedState;
  Self.OnSelectionQuerySuccessedEventHandler := OnSelectionQuerySuccessedEventHandler;
  Self.OnSelectionQueryFailedEventHandler := OnSelectionQueryFailedEventHandler;

end;

destructor TAsyncSelectionQueryEventHandlersData.Destroy;
begin

  FreeAndNil(RelatedState);
  
  inherited;

end;

end.
