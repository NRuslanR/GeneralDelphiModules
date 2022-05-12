unit AbstractDBRepositoryUnit;

interface

  uses Windows, Classes, DB, SysUtils, Variants,
  AbstractRepositoryUnit, DomainObjectUnit, ZDbcIntfs, ZDataset,
  ZAbstractRODataset, ZConnection, RegExpr,
  AbstractRepositoryCriteriaUnit, ConstRepositoryCriterionUnit,
  AbstractNegativeRepositoryCriterionUnit,
  ArithmeticRepositoryCriterionOperationsUnit,
  BoolLogicalNegativeRepositoryCriterionUnit,
  TableColumnMappingsUnit,
  BoolLogicalRepositoryCriterionBindingsUnit,
  UnaryRepositoryCriterionUnit, BinaryRepositoryCriterionUnit,
  UnitingRepositoryCriterionUnit, DomainObjectListUnit,
  DBTableMappingUnit, DomainObjectFromDataSetLoaderUnit,
  ContainsRepositoryCriterionOperationUnit;

  type

    TDBRepositoryErrorCreator = class(TRepositoryErrorCreator)

      protected

        FRegExpr: TRegExpr;

        function CreateDefaultErrorFromException(
          const SourceException: Exception
        ): TRepositoryError; override;

      public

        destructor Destroy; override;
        constructor Create(AAbstractRepository: TAbstractRepository);

        function CreateErrorFromException(
          const SourceException: Exception;
          ExceptionalDomainObject: TDomainObject
        ): TRepositoryError; override;

    end;

    TAbstractDBRepository = class abstract(TAbstractRepository)

      protected

        type

          TDomainObjectDatabaseOperationType =
          procedure(DomainObject: TDomainObject) of object;

      protected

        FIsAddingTransactional: Boolean;
        FIsUpdatingTransactional: Boolean;
        FIsRemovingTransactional: Boolean;
        FIdentityColumnsModificationEnabled: Boolean;
        FReturnSurrogateIdOfDomainObjectAfterAdding: Boolean;

        FDBTableMapping: TDBTableMapping;
        FDomainObjectFromDataSetLoader: TDomainObjectFromDataSetLoader;

        procedure Initialize; override;

        function CreateDBTableMapping: TDBTableMapping; virtual;
        function CreateDomainObjectFromDataSetLoader(
          ColumnMappings: TTableColumnMappings
        ): TDomainObjectFromDataSetLoader; virtual;
        
        procedure MarkAllModificationOperationsAsTransactional;
        procedure MarkAllModificationOperationsAsNonTransactional;

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); virtual;

        constructor Create; overload;
        constructor Create(RepositoryErrorCreator: TRepositoryErrorCreator); overload;
        constructor Create(Connection: TComponent); overload;

        procedure SetConnection(Connection: TComponent); virtual; abstract;
        function GetConnection: TComponent; virtual; abstract;
        
        procedure StartTransaction; virtual;
        procedure CommitTransaction; virtual;
        procedure RollbackTransaction; virtual;

        procedure ExecuteModifiyngQuery; virtual; abstract;
        procedure ExecuteSelectingQuery; virtual; abstract;

        function CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator; override;

        procedure ExecuteDomainObjectDatabaseOperation(
          DomainObjectDatabaseOperation: TDomainObjectDatabaseOperationType;
          DomainObject: TDomainObject;
          const UseTransaction: Boolean
        );

        procedure CheckQueryResults;
        function CheckThatSingleRecordSelected: Boolean; virtual; abstract;
        function CheckThatRecordGroupSelected: Boolean; virtual; abstract;
        function CheckThatRecordModified: Boolean; virtual; abstract;
        procedure GenerateExceptionAboutDatabaseOperationFailure; virtual;

        procedure ExecuteQueryAndCheckResults;

        procedure SetSurrogateIdForDomainObject(
          DomainObject: TDomainObject
        ); virtual;

        procedure SetSurrogateIdForDomainObjects(
          DomainObjectList: TDomainObjectList
        ); virtual;

        procedure PrepareAddDomainObjectQuery(
            DomainObject: TDomainObject
        ); virtual; abstract;

        procedure PrepareAddDomainObjectListQuery(
          DomainObjectList: TDomainObjectList
        ); virtual; abstract;
        
        procedure PrepareUpdateDomainObjectQuery(
          DomainObject: TDomainObject
        ); virtual; abstract;

        procedure PrepareUpdateDomainObjectListQuery(
          DomainObjectList: TDomainObjectList
        ); virtual;
        
        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject
        ); virtual; abstract;

        procedure PrepareRemoveDomainObjectListQuery(
          DomainObjectList: TDomainObjectList
        ); virtual; abstract;
        
        procedure PrepareFindDomainObjectByIdentityQuery(
          Identity: Variant
        ); virtual; abstract;

        procedure GetSelectListFromTableMappingForSelectByIdentity(
          var SelectList: String;
          var WhereClauseForSelectIdentity: String
        ); virtual;

        function GetSelectListFromTableMappingForSelectGroup: String; virtual;
        function GetTableNameFromTableMappingForSelect: String; virtual;
        function GetCustomWhereClauseForSelect: String; virtual;
        function GetCustomWhereClauseForDelete: String; virtual;
        function GetCustomTrailingSelectQueryTextPart: String; virtual;
        function GetCustomTrailingInsertQueryTextPart: String; virtual;
        function GetCustomTrailingUpdateQueryTextPart: String; virtual;
        function GetCustomTrailingDeleteQueryTextPart: String; virtual;
          
        procedure PrepareLoadAllDomainObjectsQuery; virtual; abstract;

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion
        ); virtual; abstract;

        procedure PrepareAndExecuteAddDomainObjectQuery(DomainObject: TDomainObject); virtual;
        procedure PrepareAndExecuteAddDomainObjectListQuery(DomainObjectList: TDomainObjectList); virtual;
        procedure PrepareAndExecuteUpdateDomainObjectQuery(DomainObject: TDomainObject); virtual;
        procedure PrepareAndExecuteUpdateDomainObjectListQuery(DomainObjectList: TDomainObjectList); virtual;
        procedure PrepareAndExecuteRemoveDomainObjectQuery(DomainObject: TDomainObject); virtual;
        procedure PrepareAndExecuteRemoveDomainObjectListQuery(DomainObjectList: TDomainObjectList); virtual;
        function PrepareAndExecuteFindDomainObjectByIdentityQuery(Identity: Variant): TDomainObject; virtual;
        function PrepareAndExecuteFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion
        ): TDomainObjectList; virtual;
        function PrepareAndExecuteLoadAllDomainObjectsQuery: TDomainObjectList; virtual;

        function InternalAdd(DomainObject: TDomainObject): Boolean; override;
        function InternalAddDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; override;
        function InternalUpdate(DomainObject: TDomainObject): Boolean; override;
        function InternalUpdateDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; override;
        function InternalRemove(DomainObject: TDomainObject): Boolean; override;
        function InternalRemoveDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; override;
        function InternalFindDomainObjectByIdentity(Identity: Variant): TDomainObject; override;
        function InternalFindDomainObjectsByCriteria(Criteria: TAbstractRepositoryCriterion): TDomainObjectList; override;
        function InternalLoadAll: TDomainObjectList; override;
        
        procedure FillDomainObjectFromDataHolder(
          DomainObject: TDomainObject;
          DataHolder: TObject
        ); override;

        function GetDatabaseDataHolder: TObject; virtual; abstract;

        function CreateDomainObject: TDomainObject; override;
        function CreateDomainObjectList: TDomainObjectList; override;
        
        function AsSQLDateTime(const DateTime: TDateTime): String;

      public

        destructor Destroy; override;

        function GetContainsRepositoryCriterionOperationClass:
          TContainsRepositoryCriterionOperationClass; override;

        function GetNegativeRepositoryCriterionClass:
          TBoolNegativeRepositoryCriterionClass; override;

        function GetConstRepositoryCriterionClass:
          TConstRepositoryCriterionClass; override;

        function GetEqualityRepositoryCriterionOperationClass:
          TEqualityRepositoryCriterionOperationClass; override;

        function GetLessRepositoryCriterionOperationClass:
          TLessRepositoryCriterionOperationClass; override;

        function GetGreaterRepositoryCriterionOperationClass:
          TGreaterRepositoryCriterionOperationClass; override;

        function GetLessOrEqualRepositoryCriterionOperationClass:
          TLessOrEqualRepositoryCriterionOperationClass; override;

        function GetGreaterOrEqualRepositoryCriterionOperationClass:
          TGreaterOrEqualRepositoryCriterionOperationClass; override;

        function GetAndBindingRepositoryCriterionClass:
          TBoolAndBindingClass; override;

        function GetOrBindingRepositoryCriterionClass:
          TBoolOrBindingClass; override;

        function GetUnaryRepositoryCriterionClass:
          TUnaryRepositoryCriterionClass; override;

        function GetBinaryRepositoryCriterionClass:
          TBinaryRepositoryCriterionClass; override;

        function GetUnitingRepositoryCriterionClass:
          TUnitingRepositoryCriterionClass; override;

        property Connection: TComponent read GetConnection write SetConnection;

        property IdentityColumnsModificationEnabled: Boolean
        read FIdentityColumnsModificationEnabled
        write FIdentityColumnsModificationEnabled;

        property TableMapping: TDBTableMapping read FDBTableMapping;
        
    end;

    TAbstractDecoratingDBRepository = class (TAbstractDBRepository)

      protected

        FDecoratedDBRepository: TAbstractDBRepository;

        constructor Create; overload;
        constructor Create(Connection: TComponent); overload;
        constructor Create(
          Connection: TComponent;
          DecoratedDBRepository: TAbstractDBRepository
        ); overload;

        procedure FillDomainObjectFromDataHolder(
          DomainObject: TDomainObject;
          DataHolder: TObject
        ); override;

      public

        destructor Destroy; override;

        procedure PrepareAndExecuteAddDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteUpdateDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteRemoveDomainObjectQuery(DomainObject: TDomainObject); override;

        property DecoratedDBRepository: TAbstractDBRepository
        read FDecoratedDBRepository write FDecoratedDBRepository;

    end;

implementation

uses
     AuxZeosFunctions,
     BinaryDBRepositoryCriterionUnit,
     ConstDBRepositoryCriterionUnit,
     BoolLogicalNegativeDBRepositoryCriterionUnit,
     UnaryDBRepositoryCriterionUnit,
     ContainsDBRepositoryCriterionOperationUnit;

{ TDBRepositoryErrorCreator }

constructor TDBRepositoryErrorCreator.Create(
  AAbstractRepository: TAbstractRepository);
begin

  inherited;

  FRegExpr := TRegExpr.Create;

end;

function TDBRepositoryErrorCreator.CreateDefaultErrorFromException(
  const SourceException: Exception): TRepositoryError;
begin

  Result := inherited CreateDefaultErrorFromException(SourceException);

end;

function TDBRepositoryErrorCreator.CreateErrorFromException(
          const SourceException: Exception;
          ExceptionalDomainObject: TDomainObject
        ): TRepositoryError;
begin

  Result := inherited CreateErrorFromException(SourceException, ExceptionalDomainObject);
  
end;

destructor TDBRepositoryErrorCreator.Destroy;
begin

  FreeAndNil(FRegExpr);
  inherited;

end;

{ TAbstractDBRepository }

function TAbstractDBRepository.AsSQLDateTime(const DateTime: TDateTime): String;
begin

  Result :=
    QuotedStr(
      FormatDateTime(
        'yyyy-MM-dd hh:mm:ss',
        DateTime
      )
    );
    
end;

procedure TAbstractDBRepository.CheckQueryResults;
var QuerySuccessCompleted: Boolean;
begin

  if FLastOperation = roSelectSingle then
    QuerySuccessCompleted := CheckThatSingleRecordSelected

  else if (FLastOperation = roSelectGroup) or (FLastOperation = roSelectAll) then
    QuerySuccessCompleted := CheckThatRecordGroupSelected

  else QuerySuccessCompleted := CheckThatRecordModified;

  if not QuerySuccessCompleted then
    GenerateExceptionAboutDatabaseOperationFailure;

end;

constructor TAbstractDBRepository.Create(Connection: TComponent);
begin

  inherited Create;

  Initialize;

  Self.Connection := Connection;
  
end;

constructor TAbstractDBRepository.Create;
begin

  inherited Create;

  Initialize;

end;

constructor TAbstractDBRepository.Create(
  RepositoryErrorCreator: TRepositoryErrorCreator
);
begin

  inherited Create(RepositoryErrorCreator);

  Initialize;

end;

function TAbstractDBRepository.CreateDBTableMapping: TDBTableMapping;
begin

  Result := TDBTableMapping.Create;
  
end;

function TAbstractDBRepository.CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator;
begin

  Result := TDBRepositoryErrorCreator.Create(Self);
  
end;

function TAbstractDBRepository.CreateDomainObject: TDomainObject;
begin

  Result := TDomainObjectClass(FDBTableMapping.ObjectClass).Create;

end;

function TAbstractDBRepository.CreateDomainObjectFromDataSetLoader(
  ColumnMappings: TTableColumnMappings
): TDomainObjectFromDataSetLoader;
begin

  Result := TDomainObjectFromDataSetLoader.Create(ColumnMappings);
  
end;

function TAbstractDBRepository.CreateDomainObjectList: TDomainObjectList;
begin

  if not Assigned(FDBTableMapping.ObjectListClass) then
    Result := TDomainObjectList.Create
  
  else
    Result := TDomainObjectListClass(FDBTableMapping.ObjectListClass).Create;

end;

procedure TAbstractDBRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin


end;

destructor TAbstractDBRepository.Destroy;
begin

  FreeAndNil(FDomainObjectFromDataSetLoader);
  FreeAndNil(FDBTableMapping);
  inherited;

end;

procedure TAbstractDBRepository.ExecuteDomainObjectDatabaseOperation(
  DomainObjectDatabaseOperation: TDomainObjectDatabaseOperationType;
  DomainObject: TDomainObject;
  const UseTransaction: Boolean
);
begin

  try

    if UseTransaction then
      StartTransaction;

    DomainObjectDatabaseOperation(DomainObject);

    if UseTransaction then
      CommitTransaction;

  except

    on e: Exception do begin

      if UseTransaction then
        RollbackTransaction;

      raise;

    end;

  end;

end;


procedure TAbstractDBRepository.ExecuteQueryAndCheckResults;
begin

  if (FLastOperation = roSelectAll) or
      (FLastOperation = roSelectSingle) or
       (FLastOperation = roSelectGroup)
  then begin

    ExecuteSelectingQuery;

  end

  else ExecuteModifiyngQuery;

  CheckQueryResults;
  
end;

procedure TAbstractDBRepository.FillDomainObjectFromDataHolder(
  DomainObject: TDomainObject;
  DataHolder: TObject
);
begin

  FDomainObjectFromDataSetLoader.LoadDomainObject(
    DomainObject,
    DataHolder as TDataSet
  );

end;

procedure TAbstractDBRepository.GenerateExceptionAboutDatabaseOperationFailure;
var ErrorMessage: String;
begin

  case FLastOperation of
    
    roAdding:

      ErrorMessage := 'Не удалось добавить запись об объекте в БД';

    roChanging:

      ErrorMessage := 'Не удалось изменить запись об объекте в БД';

    roRemoving:

      ErrorMessage := 'Не удалось удалить запись об объекте из БД';

    roSelectSingle:

      ErrorMessage := 'Не удалось выбрать запись об объекте из БД';

    roSelectAll, roSelectGroup:

      ErrorMessage := 'Не удалось выбрать записи об объектаз из БД';

  end;

  raise Exception.Create(ErrorMessage);
  
end;

function TAbstractDBRepository.GetAndBindingRepositoryCriterionClass: TBoolAndBindingClass;
begin

  Result := inherited GetAndBindingRepositoryCriterionClass;

end;

function TAbstractDBRepository.GetBinaryRepositoryCriterionClass: TBinaryRepositoryCriterionClass;
begin

  Result := TBinaryDBRepositoryCriterion;

end;

function TAbstractDBRepository.GetConstRepositoryCriterionClass: TConstRepositoryCriterionClass;
begin

  Result := TConstDBRepositoryCriterion;

end;

function TAbstractDBRepository.GetContainsRepositoryCriterionOperationClass: TContainsRepositoryCriterionOperationClass;
begin

  Result := TContainsDBRepositoryCriterionOperation;

end;

function TAbstractDBRepository.GetCustomTrailingDeleteQueryTextPart: String;
begin

  Result := '';

end;

function TAbstractDBRepository.GetCustomTrailingInsertQueryTextPart: String;
begin

  Result := '';
  
end;

function TAbstractDBRepository.GetCustomTrailingSelectQueryTextPart: String;
begin

  Result := '';
  
end;

function TAbstractDBRepository.GetCustomTrailingUpdateQueryTextPart: String;
begin

  Result := '';
  
end;

function TAbstractDBRepository.GetCustomWhereClauseForDelete: String;
begin

  Result := FDBTableMapping.GetWhereClauseForSelectUniqueObject;
  
end;

function TAbstractDBRepository.GetCustomWhereClauseForSelect: String;
begin

  Result := '';

end;

function TAbstractDBRepository.GetEqualityRepositoryCriterionOperationClass: TEqualityRepositoryCriterionOperationClass;
begin

  Result := inherited GetEqualityRepositoryCriterionOperationClass;

end;

function TAbstractDBRepository.GetGreaterOrEqualRepositoryCriterionOperationClass: TGreaterOrEqualRepositoryCriterionOperationClass;
begin

  Result := inherited GetGreaterOrEqualRepositoryCriterionOperationClass;

end;

function TAbstractDBRepository.GetGreaterRepositoryCriterionOperationClass: TGreaterRepositoryCriterionOperationClass;
begin

  Result := inherited GetGreaterRepositoryCriterionOperationClass;

end;

function TAbstractDBRepository.GetLessOrEqualRepositoryCriterionOperationClass: TLessOrEqualRepositoryCriterionOperationClass;
begin

  Result := inherited GetLessOrEqualRepositoryCriterionOperationClass;

end;

function TAbstractDBRepository.GetLessRepositoryCriterionOperationClass: TLessRepositoryCriterionOperationClass;
begin

  Result := inherited GetLessRepositoryCriterionOperationClass;

end;

function TAbstractDBRepository.GetNegativeRepositoryCriterionClass: TBoolNegativeRepositoryCriterionClass;
begin

  Result := TBoolNegativeDBRepositoryCriterion;

end;

function TAbstractDBRepository.GetOrBindingRepositoryCriterionClass: TBoolOrBindingClass;
begin

  Result := inherited GetOrBindingRepositoryCriterionClass;

end;

function TAbstractDBRepository.GetSelectListFromTableMappingForSelectGroup: String;
begin

  Result := FDBTableMapping.GetSelectListForSelectGroup;
  
end;

procedure TAbstractDBRepository.GetSelectListFromTableMappingForSelectByIdentity(
  var SelectList, WhereClauseForSelectIdentity: String
);
begin

  FDBTableMapping.GetSelectListForSelectByIdentity(
    SelectList, WhereClauseForSelectIdentity
  );

end;

function TAbstractDBRepository.GetTableNameFromTableMappingForSelect: String;
begin

  Result := FDBTableMapping.TableNameWithAlias;

end;

function TAbstractDBRepository.GetUnaryRepositoryCriterionClass: TUnaryRepositoryCriterionClass;
begin

  Result := TUnaryDBRepositoryCriterion;

end;

function TAbstractDBRepository.GetUnitingRepositoryCriterionClass: TUnitingRepositoryCriterionClass;
begin

  Result := inherited GetUnitingRepositoryCriterionClass;

end;

procedure TAbstractDBRepository.PrepareAndExecuteAddDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
begin

  if FReturnSurrogateIdOfDomainObjectAfterAdding then
    FLastOperation := roSelectGroup;

  try
  
    PrepareAddDomainObjectListQuery(DomainObjectList);
    ExecuteQueryAndCheckResults;

    if FReturnSurrogateIdOfDomainObjectAfterAdding then
      SetSurrogateIdForDomainObjects(DomainObjectList);

  finally

    if FReturnSurrogateIdOfDomainObjectAfterAdding then
      FLastOperation := roAdding;

  end;

end;

procedure TAbstractDBRepository.PrepareAndExecuteAddDomainObjectQuery(
  DomainObject: TDomainObject
);
begin

  if FReturnSurrogateIdOfDomainObjectAfterAdding then
    FLastOperation := roSelectSingle;

  try

    PrepareAddDomainObjectQuery(DomainObject);
    ExecuteQueryAndCheckResults;

    if FReturnSurrogateIdOfDomainObjectAfterAdding then
      SetSurrogateIdForDomainObject(DomainObject);
    
  finally

    if FReturnSurrogateIdOfDomainObjectAfterAdding then
      FLastOperation := roAdding;
    
  end;

end;

function TAbstractDBRepository.PrepareAndExecuteFindDomainObjectByIdentityQuery(
  Identity: Variant
): TDomainObject;
begin

  PrepareFindDomainObjectByIdentityQuery(Identity);
  ExecuteQueryAndCheckResults;

end;

function TAbstractDBRepository.PrepareAndExecuteFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion): TDomainObjectList;
begin

  PrepareFindDomainObjectsByCriteria(Criteria);
  ExecuteQueryAndCheckResults;

end;

function TAbstractDBRepository.PrepareAndExecuteLoadAllDomainObjectsQuery: TDomainObjectList;
begin

  PrepareLoadAllDomainObjectsQuery;
  ExecuteQueryAndCheckResults;

end;

procedure TAbstractDBRepository.PrepareAndExecuteRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
begin

  PrepareRemoveDomainObjectListQuery(DomainObjectList);
  ExecuteQueryAndCheckResults;
  
end;

procedure TAbstractDBRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject
);
begin

  PrepareRemoveDomainObjectQuery(DomainObject);
  ExecuteQueryAndCheckResults;

end;

procedure TAbstractDBRepository.PrepareAndExecuteUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
begin

  PrepareUpdateDomainObjectListQuery(DomainObjectList);
  ExecuteQueryAndCheckResults;
  
end;

procedure TAbstractDBRepository.PrepareAndExecuteUpdateDomainObjectQuery(
  DomainObject: TDomainObject
);
begin

  PrepareUpdateDomainObjectQuery(DomainObject);
  ExecuteQueryAndCheckResults;

end;

procedure TAbstractDBRepository.PrepareUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
begin

  raise Exception.Create(
          'Обновление списка доменных ' +
          'объектов в рамках одного запроса ' +
          'не поддерживается в данном ' +
          'репозитории'
        );
        
end;

function TAbstractDBRepository.InternalFindDomainObjectByIdentity(
  Identity: Variant): TDomainObject;
begin

  PrepareAndExecuteFindDomainObjectByIdentityQuery(Identity);

  Result := CreateAndFillDomainObjectFromDataHolder(GetDatabaseDataHolder);

end;

function TAbstractDBRepository.InternalFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion
): TDomainObjectList;
begin

  PrepareAndExecuteFindDomainObjectsByCriteria(Criteria);

  Result := CreateAndFillDomainObjectListFromDataHolder(
              GetDatabaseDataHolder
            );
  
end;

function TAbstractDBRepository.InternalLoadAll: TDomainObjectList;
begin

  PrepareAndExecuteLoadAllDomainObjectsQuery;

  Result := CreateAndFillDomainObjectListFromDataHolder(
              GetDatabaseDataHolder
            );

end;

procedure TAbstractDBRepository.Initialize;
begin

  FDBTableMapping := CreateDBTableMapping;
  
  FDomainObjectFromDataSetLoader :=
    CreateDomainObjectFromDataSetLoader(
      FDBTableMapping.ColumnMappingsForSelect
    );

  CustomizeTableMapping(FDBTableMapping);
  MarkAllModificationOperationsAsNonTransactional;

  FReturnSurrogateIdOfDomainObjectAfterAdding := False;
  
end;

function TAbstractDBRepository.InternalAdd(DomainObject: TDomainObject): Boolean;
begin

  Result := False;

  ExecuteDomainObjectDatabaseOperation(
    PrepareAndExecuteAddDomainObjectQuery,
    DomainObject,
    FIsAddingTransactional
  );

  Result := True;

end;

function TAbstractDBRepository.InternalAddDomainObjectList(
  DomainObjectList: TDomainObjectList): Boolean;
begin

  Result := False;

  PrepareAndExecuteAddDomainObjectListQuery(DomainObjectList);

  Result := True;
  
end;

function TAbstractDBRepository.InternalRemove(DomainObject: TDomainObject): Boolean;
begin

  Result := False;

  ExecuteDomainObjectDatabaseOperation(
    PrepareAndExecuteRemoveDomainObjectQuery,
    DomainObject,
    FIsRemovingTransactional
  );

  Result := True;

end;

function TAbstractDBRepository.InternalRemoveDomainObjectList(
  DomainObjectList: TDomainObjectList): Boolean;
begin

  Result := False;

  PrepareAndExecuteRemoveDomainObjectListQuery(DomainObjectList);

  Result := True;
  
end;

function TAbstractDBRepository.InternalUpdate(DomainObject: TDomainObject): Boolean;
begin

  Result := False;

  ExecuteDomainObjectDatabaseOperation(
    PrepareAndExecuteUpdateDomainObjectQuery,
    DomainObject,
    FIsUpdatingTransactional
  );

  Result := True;
  
end;

function TAbstractDBRepository.InternalUpdateDomainObjectList(
  DomainObjectList: TDomainObjectList): Boolean;
begin

  Result := False;

  PrepareAndExecuteUpdateDomainObjectListQuery(DomainObjectList);

  Result := True;
  
end;

procedure TAbstractDBRepository.MarkAllModificationOperationsAsNonTransactional;
begin

  FIsAddingTransactional := False;
  FIsUpdatingTransactional := False;
  FIsRemovingTransactional := False;

end;

procedure TAbstractDBRepository.MarkAllModificationOperationsAsTransactional;
begin

  FIsAddingTransactional := True;
  FIsUpdatingTransactional := True;
  FIsRemovingTransactional := True;
  
end;

procedure TAbstractDBRepository.SetSurrogateIdForDomainObject(
  DomainObject: TDomainObject);
begin
  
end;

procedure TAbstractDBRepository.SetSurrogateIdForDomainObjects(
  DomainObjectList: TDomainObjectList);
var DomainObject: TDomainObject;
begin

  for DomainObject in DomainObjectList do begin

    SetSurrogateIdForDomainObject(DomainObject);

  end;

end;

procedure TAbstractDBRepository.StartTransaction;
begin

end;

procedure TAbstractDBRepository.CommitTransaction;
begin

end;

procedure TAbstractDBRepository.RollbackTransaction;
begin

end;

{ TAbstractDecoratingDBRepository }

constructor TAbstractDecoratingDBRepository.Create;
begin

  inherited Create;

end;

constructor TAbstractDecoratingDBRepository.Create(Connection: TComponent);
begin

  inherited Create(Connection);

end;

constructor TAbstractDecoratingDBRepository.Create(
  Connection: TComponent;
  DecoratedDBRepository: TAbstractDBRepository
);
begin

  inherited Create(Connection);

  Self.DecoratedDBRepository := DecoratedDBRepository;

end;

destructor TAbstractDecoratingDBRepository.Destroy;
begin

  FreeAndNil(FDecoratedDBRepository);
  inherited;

end;

procedure TAbstractDecoratingDBRepository.FillDomainObjectFromDataHolder(
  DomainObject: TDomainObject;
  DataHolder: TObject
);
begin

  if Assigned(FDecoratedDBRepository) then
    FDecoratedDBRepository.FillDomainObjectFromDataHolder(
      DomainObject, DataHolder
    )

  else inherited;

end;

procedure TAbstractDecoratingDBRepository.PrepareAndExecuteAddDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  if Assigned(FDecoratedDBRepository) then
    FDecoratedDBRepository.Add(DomainObject);

  inherited;

end;

procedure TAbstractDecoratingDBRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  inherited;

  if Assigned(FDecoratedDBRepository) then
    FDecoratedDBRepository.Remove(DomainObject);

end;

procedure TAbstractDecoratingDBRepository.PrepareAndExecuteUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  if Assigned(FDecoratedDBRepository) then
    FDecoratedDBRepository.Update(DomainObject);
  
  inherited;

end;

end.
