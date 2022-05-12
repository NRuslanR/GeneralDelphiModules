unit DBTableReplicationRequest;

interface

uses

  DBTableReplicationOptions,
  SysUtils,
  Classes;

type

  TDBTableReplicationRequestException = class (Exception)
  
  end;

  TDBTableReplicationRequests = class;
  
  TDBTableReplicationRequest = class

    private

      FIncludingRequestList: TDBTableReplicationRequests;
      
    private

      FSourceTable: String;
      FTargetTable: String;
      FOptions: IDBTableReplicationOptions;

    protected
    
      function GetSourceTable: String; virtual;
      function GetTargetTable: String; virtual;

      procedure SetSourceTable(const Value: String); virtual;
      procedure SetTargetTable(const Value: String); virtual;

    protected

      procedure SetReplicationOptions(
        const Value: IDBTableReplicationOptions
      ); virtual;
      
      function GetReplicationOptions: IDBTableReplicationOptions; virtual;
      
    protected

      procedure RaiseExceptionIfSourceTableNameIsEmpty(
        const SourceTableName: String
      );
      
      procedure RaiseExceptionIfTargetTableNameIsEmpty(
        const TargetTableName: String
      );
      
      procedure RaiseExceptionIfSourceAndTargetTablesEquals(
        const SourceTable, TargetTable: String
      );

      procedure RaiseExceptionIfIncludingListIsAlreadyContainsSameReplicationRequest(
        const SourceTable, TargetTable: String
      );
      
    public

      destructor Destroy; override;
      
      constructor Create(
        const SourceTable, TargetTable: String;
        const Options: IDBTableReplicationOptions
      ); virtual;

    public

      property SourceTable: String read GetSourceTable write SetSourceTable;
      property TargetTable: String read GetTargetTable write SetTargetTable;
      property Options: IDBTableReplicationOptions
      read GetReplicationOptions write SetReplicationOptions;

      function IsInReplicationRequestList(
        ReplicationRequests: TDBTableReplicationRequests
      ): Boolean;
      
    public
    
      function AreSourceTargetTablesEquals(
        const SourceTable, TargetTable: String
      ): Boolean;
      
    public

      class function CreateDefault(
        const SourceTable, TargetTable: String
      ): TDBTableReplicationRequest; virtual;
      
  end;

  TDBTableReplicationRequestClass = class of TDBTableReplicationRequest;

  TDBTableReplicationRequestsEnumerator = class (TListEnumerator)

    protected

      function GetCurrentReplicationRequest: TDBTableReplicationRequest; virtual;

    public

      constructor Create(ReplicationRequests: TDBTableReplicationRequests);

      property Current: TDBTableReplicationRequest
      read GetCurrentReplicationRequest;
      
  end;

  TDBTableCompositeReplicationRequests = class;
  
  TDBTableCompositeReplicationRequest = class (TDBTableReplicationRequest)

    private

      FReferencedTableReplicationRequests: TDBTableReplicationRequests;
      
      function GetReferencedTableReplicationRequests: TDBTableReplicationRequests;

    protected

      procedure SetSourceTable(const Value: String); override;
      procedure SetTargetTable(const Value: String); override;

    protected

      procedure SetReplicationOptions(
        const Value: IDBTableReplicationOptions
      ); override;
      
    protected

      procedure RaiseReplicationRequestIsAlreadyExists(
        const SourceTable, TargetTable: String
      );
      
    public

      destructor Destroy; override;

      constructor Create(
        const SourceTable, TargetTable: String;
        const Options: IDBTableReplicationOptions
      ); override;

      procedure AddReferencedTableReplicationRequest(
        ReferencedTableReplicationRequest: TDBTableReplicationRequest
      );

    public

      property ReferencedTableReplicationRequests: TDBTableReplicationRequests
      read GetReferencedTableReplicationRequests;

    public

      class function CreateDefault(
        const SourceTable, TargetTable: String
      ): TDBTableReplicationRequest; override;
      
  end;
  
  TDBTableReplicationRequests = class (TList)

    protected

      FCompositeReplicationRequest: TDBTableCompositeReplicationRequest;
       
    protected

      function GetReplicationRequestByIndex(
        Index: Integer
      ): TDBTableReplicationRequest;

      procedure SetReplicationRequestByIndex(
        Index: Integer;
        const Value: TDBTableReplicationRequest
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    protected

      procedure RaiseExceptionIfReplicationRequestIsAlreadyExists(
        const ReplicationRequest: TDBTableReplicationRequest
      ); overload;

      procedure RaiseExceptionIfReplicationRequestIsAlreadyExists(
        const SourceTable, TargetTable: String
      ); overload;

      procedure RaiseReplicationRequestIsAlreadyExistsException(
        const SourceTable, TargetTable: String
      ); 
      procedure RaiseInsertOperationExceptionIfReplicationRequestIsNull(
        const ReplicationRequest: TDBTableReplicationRequest
      );

      procedure RaiseExceptionIfReplicationRequestIsNotInSelfIndirectly(
        const ReplicationRequest: TDBTableReplicationRequest
      );

    protected

      procedure AssignIncludingListForReplicationRequest(
        ReplicationRequest: TDBTableReplicationRequest
      ); virtual;

      procedure ResetIncludingListForReplicationRequest(
        ReplicationRequest: TDBTableReplicationRequest
      ); virtual;

    public

      function FindReplicationRequestBySourceTargetTables(
        const SourceTable, TargetTable: String
      ): TDBTableReplicationRequest; virtual;

      function IsReplicationRequestExists(
        const SourceTable, TargetTable: String
      ): Boolean; virtual;
      
      function Add(ReplicationRequest: TDBTableReplicationRequest): Integer; virtual;
      procedure RemoveBySourceTargetTables(const SourceTable, TargetTable: String); virtual;
      procedure Remove(ReplicationRequest: TDBTableReplicationRequest); virtual;
      function Extract(ReplicationRequest: TDBTableReplicationRequest): TDBTableReplicationRequest; virtual;
      function ExtractBySourceTargetTables(const SourceTable, TargetTable: String): TDBTableReplicationRequest; virtual;
      function GetEnumerator: TDBTableReplicationRequestsEnumerator; virtual;

      property Items[Index: Integer]: TDBTableReplicationRequest
      read GetReplicationRequestByIndex write SetReplicationRequestByIndex;

  end;
    
  TDBTableCompositeReplicationRequests = class (TDBTableReplicationRequests)

    public

      function FindReplicationRequestBySourceTargetTables(
        const SourceTable, TargetTable: String
      ): TDBTableReplicationRequest; override;

  end;
  
implementation

type

  TDBTableReplicationDefaultRequest = class (TDBTableReplicationRequest)

    public

      constructor Create(const SourceTable, TargetTable: String);

  end;

  TDBTableCompositeReplicationDefaultRequest =
    class (TDBTableCompositeReplicationRequest)

      
      public

        constructor Create(const SourceTable, TargetTable: String);
        
    end;
    
{ TDBTableReplicationRequest }

function TDBTableReplicationRequest.AreSourceTargetTablesEquals(
  const SourceTable, TargetTable: String): Boolean;
begin

  Result :=
    (Self.SourceTable = SourceTable) and
    (Self.TargetTable = TargetTable);

end;

constructor TDBTableReplicationRequest.Create(
  const SourceTable, TargetTable: String;
  const Options: IDBTableReplicationOptions
);
begin

  inherited Create;

  Self.SourceTable := SourceTable;
  Self.TargetTable := TargetTable;
  Self.Options := Options;

end;

class function TDBTableReplicationRequest.CreateDefault(
  const SourceTable, TargetTable: String
): TDBTableReplicationRequest;
begin

  Result := TDBTableReplicationDefaultRequest.Create(SourceTable, TargetTable);
  
end;

destructor TDBTableReplicationRequest.Destroy;
begin

  FIncludingRequestList := nil;
  
  inherited;

end;

function TDBTableReplicationRequest.
  GetReplicationOptions: IDBTableReplicationOptions;
begin

  Result := FOptions;
  
end;

function TDBTableReplicationRequest.GetSourceTable: String;
begin

  Result := FSourceTable;
  
end;

function TDBTableReplicationRequest.GetTargetTable: String;
begin

  Result := FTargetTable;
  
end;

function TDBTableReplicationRequest.IsInReplicationRequestList(
  ReplicationRequests: TDBTableReplicationRequests): Boolean;
begin

  Result := FIncludingRequestList = ReplicationRequests;

end;

procedure TDBTableReplicationRequest.
  RaiseExceptionIfIncludingListIsAlreadyContainsSameReplicationRequest(
    const SourceTable, TargetTable: String
  );
begin

  if Assigned(FIncludingRequestList) then begin

    FIncludingRequestList.RaiseExceptionIfReplicationRequestIsAlreadyExists(
      SourceTable, TargetTable
    );
    
  end;
  
end;

procedure TDBTableReplicationRequest.
  RaiseExceptionIfSourceAndTargetTablesEquals(
    const SourceTable, TargetTable: String
  );
begin

  if SourceTable = TargetTable then begin

    raise TDBTableReplicationRequestException.CreateFmt(
      'Replication request can not be for same table "%s"',
      [TargetTable]
    );

  end;


end;

procedure TDBTableReplicationRequest.RaiseExceptionIfSourceTableNameIsEmpty(
  const SourceTableName: String);
begin

  if Trim(SourceTableName) = '' then begin

    raise TDBTableReplicationRequestException.Create(
      'Source table''s name is empty'
    );

  end;

end;

procedure TDBTableReplicationRequest.RaiseExceptionIfTargetTableNameIsEmpty(
  const TargetTableName: String);
begin

  if Trim(TargetTableName) = '' then begin

    raise TDBTableReplicationRequestException.Create(
      'Target table''s name is empty'
    );

  end;
  
end;

procedure TDBTableReplicationRequest.SetReplicationOptions(
  const Value: IDBTableReplicationOptions);
begin

  FOptions := Value;
  
end;

procedure TDBTableReplicationRequest.SetSourceTable(const Value: String);
begin

  RaiseExceptionIfSourceTableNameIsEmpty(Value);
  RaiseExceptionIfSourceAndTargetTablesEquals(Value, TargetTable);
  RaiseExceptionIfIncludingListIsAlreadyContainsSameReplicationRequest(
    Value, TargetTable
  );

  FSourceTable := Value;

end;

procedure TDBTableReplicationRequest.SetTargetTable(const Value: String);
begin

  RaiseExceptionIfTargetTableNameIsEmpty(Value);
  RaiseExceptionIfSourceAndTargetTablesEquals(SourceTable, Value);
  RaiseExceptionIfIncludingListIsAlreadyContainsSameReplicationRequest(
    SourceTable, Value
  );

  FTargetTable := Value;
  
end;

{ TDBTableReplicationDefaultRequest }

constructor TDBTableReplicationDefaultRequest.Create(
  const SourceTable, TargetTable: String
);
begin

  inherited Create(SourceTable, TargetTable, TDBTableReplicationOptions.Default);

end;

{ TDBTableReplicationRequests }

function TDBTableReplicationRequests.Add(
  ReplicationRequest: TDBTableReplicationRequest
): Integer;
begin

  RaiseInsertOperationExceptionIfReplicationRequestIsNull(ReplicationRequest);
  RaiseExceptionIfReplicationRequestIsAlreadyExists(ReplicationRequest);

  Result := inherited Add(ReplicationRequest);

  AssignIncludingListForReplicationRequest(ReplicationRequest);

end;

procedure TDBTableReplicationRequests.AssignIncludingListForReplicationRequest(
  ReplicationRequest: TDBTableReplicationRequest);
begin

  ReplicationRequest.FIncludingRequestList := Self;
  
end;

function TDBTableReplicationRequests.Extract(
  ReplicationRequest: TDBTableReplicationRequest
): TDBTableReplicationRequest;
begin

  RaiseExceptionIfReplicationRequestIsNotInSelfIndirectly(ReplicationRequest);
  
  Result := TDBTableReplicationRequest(inherited Extract(ReplicationRequest));

  if Assigned(Result) then
    ResetIncludingListForReplicationRequest(Result);
    
end;

function TDBTableReplicationRequests.ExtractBySourceTargetTables(
  const SourceTable, TargetTable: String): TDBTableReplicationRequest;
begin

  Result :=
    Extract(
      FindReplicationRequestBySourceTargetTables(
        SourceTable, TargetTable
      )
    );
      
end;

function TDBTableReplicationRequests.
  FindReplicationRequestBySourceTargetTables(
    const SourceTable, TargetTable: String
  ): TDBTableReplicationRequest;
begin

  for Result in Self do
    if Result.AreSourceTargetTablesEquals(SourceTable, TargetTable)
    then Exit;

  if Assigned(FCompositeReplicationRequest) then begin

    if
      FCompositeReplicationRequest.AreSourceTargetTablesEquals(
        SourceTable, TargetTable
      )
    then
      Result := FCompositeReplicationRequest

    else if Assigned(FCompositeReplicationRequest.FIncludingRequestList)
    then begin

      Result :=
        FCompositeReplicationRequest.
          FIncludingRequestList.
            FindReplicationRequestBySourceTargetTables(
              SourceTable, TargetTable
            );
            
    end

    else Result := nil;
         
  end

  else Result := nil;

end;

function TDBTableReplicationRequests.GetEnumerator: TDBTableReplicationRequestsEnumerator;
begin

  Result := TDBTableReplicationRequestsEnumerator.Create(Self);
  
end;

function TDBTableReplicationRequests.GetReplicationRequestByIndex(
  Index: Integer): TDBTableReplicationRequest;
begin

  Result := TDBTableReplicationRequest(Get(Index));
  
end;

function TDBTableReplicationRequests.IsReplicationRequestExists(
  const SourceTable, TargetTable: String): Boolean;
begin

  Result :=
    Assigned(
      FindReplicationRequestBySourceTargetTables(SourceTable, TargetTable)
    );
    
end;

procedure TDBTableReplicationRequests.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  inherited;

  if Action = lnDeleted then
    TDBTableReplicationRequest(Ptr).Free;

end;

procedure TDBTableReplicationRequests.
  RaiseExceptionIfReplicationRequestIsAlreadyExists(
    const SourceTable, TargetTable: String
  );
begin

  if
    IsReplicationRequestExists(SourceTable, TargetTable)
  then
    RaiseReplicationRequestIsAlreadyExistsException(SourceTable, TargetTable);
  
end;

procedure TDBTableReplicationRequests.
  RaiseExceptionIfReplicationRequestIsNotInSelfIndirectly(
    const ReplicationRequest: TDBTableReplicationRequest
  );
begin

  if not ReplicationRequest.IsInReplicationRequestList(Self)
  then begin

    raise TDBTableReplicationRequestException.CreateFmt(
      'Replication request for source table "%s" and ' +
      'target table "%s" is not in this list indirectly',
      [
        ReplicationRequest.SourceTable,
        ReplicationRequest.TargetTable
      ]
    );
    
  end;
  
end;

procedure TDBTableReplicationRequests.
  RaiseInsertOperationExceptionIfReplicationRequestIsNull(
    const ReplicationRequest: TDBTableReplicationRequest
  );
begin

  if not Assigned(ReplicationRequest) then begin

    raise TDBTableReplicationRequestException.Create(
      'Insert null replication request attempt is detected'
    );

  end;

end;

procedure TDBTableReplicationRequests.
  RaiseReplicationRequestIsAlreadyExistsException(
    const SourceTable, TargetTable: String
  );
begin

  raise TDBTableReplicationRequestException.CreateFmt(
    'Replication request for source table "%s" and ' +
    'target table "%s" is already exists',
    [SourceTable, TargetTable]
  );
    
end;

procedure TDBTableReplicationRequests.
  RaiseExceptionIfReplicationRequestIsAlreadyExists(
    const ReplicationRequest: TDBTableReplicationRequest
  );
begin

  RaiseExceptionIfReplicationRequestIsAlreadyExists(
    ReplicationRequest.SourceTable,
    ReplicationRequest.TargetTable
  );
  
end;

procedure TDBTableReplicationRequests.Remove(
  ReplicationRequest: TDBTableReplicationRequest);
var Index: Integer;
begin

  RaiseExceptionIfReplicationRequestIsNotInSelfIndirectly(ReplicationRequest);

  Index := IndexOf(ReplicationRequest);

  if Index >= 0 then Delete(Index);
    
end;

procedure TDBTableReplicationRequests.RemoveBySourceTargetTables(
  const SourceTable, TargetTable: String
);
begin

  Remove(
    FindReplicationRequestBySourceTargetTables(SourceTable, TargetTable)
  );

end;

procedure TDBTableReplicationRequests.ResetIncludingListForReplicationRequest(
  ReplicationRequest: TDBTableReplicationRequest);
begin

  ReplicationRequest.FIncludingRequestList := nil;

end;

procedure TDBTableReplicationRequests.SetReplicationRequestByIndex(
  Index: Integer; const Value: TDBTableReplicationRequest);
begin

  RaiseInsertOperationExceptionIfReplicationRequestIsNull(Value);
  RaiseExceptionIfReplicationRequestIsAlreadyExists(Value);
  
  Put(Index, Value);

  AssignIncludingListForReplicationRequest(Value);
  
end;

{ TDBTableReplicationRequestsEnumerator }

constructor TDBTableReplicationRequestsEnumerator.Create(
  ReplicationRequests: TDBTableReplicationRequests);
begin

  inherited Create(ReplicationRequests);
  
end;

function TDBTableReplicationRequestsEnumerator.
  GetCurrentReplicationRequest: TDBTableReplicationRequest;
begin

  Result := TDBTableReplicationRequest(GetCurrent);
  
end;

{ TDBTableCompositeReplicationRequest }

procedure TDBTableCompositeReplicationRequest.
  AddReferencedTableReplicationRequest(
    ReferencedTableReplicationRequest: TDBTableReplicationRequest
  );
begin

  if
    AreSourceTargetTablesEquals(
      ReferencedTableReplicationRequest.SourceTable,
      ReferencedTableReplicationRequest.TargetTable
    )
  then begin

    FReferencedTableReplicationRequests.
      RaiseReplicationRequestIsAlreadyExistsException(
        ReferencedTableReplicationRequest.SourceTable,
        ReferencedTableReplicationRequest.TargetTable
      );
      
  end;
  
  FReferencedTableReplicationRequests.Add(ReferencedTableReplicationRequest);

  
end;

constructor TDBTableCompositeReplicationRequest.Create(
  const SourceTable, TargetTable: String;
  const Options: IDBTableReplicationOptions
);
begin

  inherited;

  FReferencedTableReplicationRequests :=
    TDBTableCompositeReplicationRequests.Create;

  FReferencedTableReplicationRequests.FCompositeReplicationRequest := Self;
  
end;

class function TDBTableCompositeReplicationRequest.CreateDefault(
  const SourceTable, TargetTable: String): TDBTableReplicationRequest;
begin

  Result :=
    TDBTableCompositeReplicationDefaultRequest.Create(
      SourceTable, TargetTable
    );
  
end;

destructor TDBTableCompositeReplicationRequest.Destroy;
begin

  FreeAndNil(FReferencedTableReplicationRequests);
  
  inherited;

end;

function TDBTableCompositeReplicationRequest.
  GetReferencedTableReplicationRequests: TDBTableReplicationRequests;
begin

  Result := FReferencedTableReplicationRequests;
  
end;

procedure TDBTableCompositeReplicationRequest.
  RaiseReplicationRequestIsAlreadyExists(
    const SourceTable, TargetTable: String
  );
begin

  raise TDBTableReplicationRequestException.CreateFmt(
    'Replication request for source table "%s" ' +
    'and target table "%s"',
    [
      SourceTable,
      TargetTable
    ]
  );
  
end;

procedure TDBTableCompositeReplicationRequest.SetReplicationOptions(
  const Value: IDBTableReplicationOptions
);
var Placeholder: IDBTableCompositeReplicationOptions;
begin

  if not Supports(Value, IDBTableCompositeReplicationOptions, Placeholder)
  then begin

    raise TDBTableReplicationRequestException.Create(
      'Composite replication options is necessary for ' +
      'composite replication request, but simple ' +
      'replication options was attempted to assign'
    );
    
  end;

  inherited;

end;

procedure TDBTableCompositeReplicationRequest.SetSourceTable(
  const Value: String);
begin

  inherited;

end;

procedure TDBTableCompositeReplicationRequest.SetTargetTable(
  const Value: String);
begin

  inherited;

end;

{ TDBTableCompositeReplicationRequests }

function TDBTableCompositeReplicationRequests.
  FindReplicationRequestBySourceTargetTables(
    const SourceTable, TargetTable: String
  ): TDBTableReplicationRequest;
var CompositeRequest: TDBTableCompositeReplicationRequest;
    ResultRequest: TDBTableReplicationRequest;
begin

  Result :=
    inherited FindReplicationRequestBySourceTargetTables(
      SourceTable, TargetTable
    );

  if Assigned(Result) then
    Exit;

  ResultRequest := nil;
  
  for Result in Self do begin

    if not (Result is TDBTableCompositeReplicationRequest) then
      Continue;

    CompositeRequest := Result as TDBTableCompositeReplicationRequest;

    ResultRequest :=
      CompositeRequest.
        ReferencedTableReplicationRequests.
          FindReplicationRequestBySourceTargetTables(
            SourceTable, TargetTable
          );

    if Assigned(ResultRequest) then
      Break;

  end;

  Result := ResultRequest;
  
end;

{ TDBTableCompositeReplicationDefaultRequest }

constructor TDBTableCompositeReplicationDefaultRequest.Create(const SourceTable,
  TargetTable: String);
begin

  inherited Create(
    SourceTable, TargetTable, TDBTableCompositeReplicationOptions.Default
  );
  
end;

end.
