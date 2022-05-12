unit DatabaseTransaction;

interface

uses

  QueryExecutor,
  Session,
  Classes;

type

  TIsolationLevel = (

    ReadUncommitted,
    ReadCommitted,
    RepeatableRead,
    Serializable

  );

  TDatabaseTransaction = class abstract (TInterfacedObject, ISession)

    protected

      FQueryExecutor: IQueryExecutor;
      FIsStarted: Boolean;
      FIsolationLevel: TIsolationLevel;

      function GetSelf: TObject;

      function GetIsolationLevelText: String; virtual; abstract;
      function GetStartTransactionText: String; virtual; abstract;
      function GetCommitTransactionText: String; virtual; abstract;
      function GetRollbackTransactionText: String; virtual; abstract;

      procedure InternalStart; virtual;
      procedure InternalCommit; virtual;
      procedure InternalRollback; virtual; 

      function InternalGetIsStarted: Boolean; virtual;
      
      procedure ResetIsStartedState; virtual;
      procedure SetIsStartedState; virtual;
      
    public

      constructor Create(QueryExecutor: IQueryExecutor); virtual;

      procedure Start;
      procedure Commit;
      procedure Rollback;

      function GetIsStarted: Boolean;
      
      property QueryExecutor: IQueryExecutor
      read FQueryExecutor write FQueryExecutor;

      property IsolationLevel: TIsolationLevel
      read FIsolationLevel write FIsolationLevel;

    published

      property IsStarted: Boolean read GetIsStarted;

  end;

implementation

{ TDatabaseTransaction }

constructor TDatabaseTransaction.Create(QueryExecutor: IQueryExecutor);
begin

  inherited Create;

  FIsolationLevel := Serializable;

  FQueryExecutor := QueryExecutor;

end;

function TDatabaseTransaction.GetIsStarted: Boolean;
begin

  Result := InternalGetIsStarted;
  
end;

function TDatabaseTransaction.GetSelf: TObject;
begin

  Result := Self;

end;

procedure TDatabaseTransaction.InternalCommit;
begin

  FQueryExecutor.ExecuteModificationQuery(GetCommitTransactionText);
  
end;

function TDatabaseTransaction.InternalGetIsStarted: Boolean;
begin

  Result := FIsStarted;
  
end;

procedure TDatabaseTransaction.InternalRollback;
begin

  FQueryExecutor.ExecuteModificationQuery(GetRollbackTransactionText);
  
end;

procedure TDatabaseTransaction.InternalStart;
begin

  FQueryExecutor.ExecuteModificationQuery(GetStartTransactionText);

end;

procedure TDatabaseTransaction.ResetIsStartedState;
begin

  FIsStarted := False;
  
end;

procedure TDatabaseTransaction.Rollback;
begin

  InternalRollback;

  ResetIsStartedState;
  
end;

procedure TDatabaseTransaction.Commit;
begin

  InternalCommit;

  ResetIsStartedState;

end;

procedure TDatabaseTransaction.SetIsStartedState;
begin

  FIsStarted := True;
  
end;

procedure TDatabaseTransaction.Start;
begin

  InternalStart;

  SetIsStartedState;

end;

end.
