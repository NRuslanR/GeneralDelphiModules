unit AbstractDBRepository;

interface

uses

  Windows,
  Classes,
  DB,
  SysUtils,
  Variants,
  AbstractRepository,
  DomainObjectUnit,
  ZDbcIntfs,
  ZDataset,
  ZAbstractRODataset,
  ZConnection,
  RegExpr,
  AbstractRepositoryCriteriaUnit,
  ConstRepositoryCriterionUnit,
  AbstractNegativeRepositoryCriterionUnit,
  ArithmeticRepositoryCriterionOperationsUnit,
  BoolLogicalNegativeRepositoryCriterionUnit,
  TableColumnMappings,
  UnaryRepositoryCriterionUnit,
  BinaryRepositoryCriterionUnit,
  UnitingRepositoryCriterionUnit,
  DomainObjectListUnit,
  DBTableMapping,
  DomainObjectCompiler,
  DBTableColumnMappings,
  ContainsRepositoryCriterionOperationUnit,
  BoolLogicalRepositoryCriterionBindingsUnit,
  QueryExecutor,
  DataReader,
  ReflectionServicesUnit,
  TableDef,
  NameValue,
  IGetSelfUnit,
  VariantListUnit;

  type

    TDBRepositoryError = class (TRepositoryError)
    
    end;

    TUnknownDBRepositoryError = class (TDBRepositoryError)
    
    end;

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

    TDatabaseOperationUnknownFailException = class (Exception)

    end;

    TAbstractDBRepository = class abstract(TAbstractRepository)

      private

        FQueryExecutor: IQueryExecutor;
        
        function GetTableDef: TTableDef;
        procedure SetTableDef(const Value: TTableDef);
        
      protected

        type

          TDomainObjectDatabaseOperationType =
            procedure(DomainObject: TDomainObject) of object;

          TVALUESRowsLayoutCreatingMode = (

            UsePrimaryKeyColumns,
            DontUsePrimaryKeyColumns

          );
          
      protected

        FTableDef: TTableDef;
        FFreeTableDef: IGetSelf;
        
        FIsAddingTransactional: Boolean;
        FIsUpdatingTransactional: Boolean;
        FIsRemovingTransactional: Boolean;
        FIdentityColumnsModificationEnabled: Boolean;
        FReturnIdOfDomainObjectAfterAdding: Boolean;
        FReturnIdOfDomainObjectAfterUpdate: Boolean;

        FDBTableMapping: TDBTableMapping;
        FDomainObjectCompiler: TDomainObjectCompiler;
        
        procedure Initialize; override;
        procedure InitializeTableMappings(TableDef: TTableDef); virtual;
        
        function CreateDBTableMapping: TDBTableMapping; virtual;
        function CreateDomainObjectCompiler(
          ColumnMappings: TTableColumnMappings
        ): TDomainObjectCompiler; virtual;
        
        procedure MarkAllModificationOperationsAsTransactional;
        procedure MarkAllModificationOperationsAsNonTransactional;

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); virtual;

        procedure StartTransaction; virtual;
        procedure CommitTransaction; virtual;
        procedure RollbackTransaction; virtual;

        function CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator; override;

        procedure ExecuteDomainObjectDatabaseOperation(
          DomainObjectDatabaseOperation: TDomainObjectDatabaseOperationType;
          DomainObject: TDomainObject;
          const UseTransaction: Boolean
        );

        procedure CheckSelectionQueryResults(DataReader: IDataReader);
        procedure CheckModificationQueryResults(const AffectedRecordCount: Integer);

        function CheckThatSingleRecordSelected(
          DataReader: IDataReader
        ): Boolean; virtual;

        function CheckThatRecordGroupSelected(
          DataReader: IDataReader
        ): Boolean; virtual;
        
        function CheckAffectedRecordCount(const AffectedRecordCount: Integer): Boolean; virtual;

        procedure GenerateExceptionAboutDatabaseOperationUnknownFail; virtual;

        function ExecuteSelectionQueryAndCheckResults(
          const QueryPattern: String;
          const QueryParams: TQueryParams
        ): IDataReader;

        function ExecuteModificationQueryAndCheckResults(
          const QueryPattern: String;
          const QueryParams: TQueryParams
        ): Integer;
        
      protected

        function FetchDomainObjectId(
          DataReader: IDataReader;
          ColumnMappings: TTableColumnMappings
        ): Variant; virtual;
        
        procedure SetIdForDomainObject(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); virtual;

        procedure SetIdForDomainObjects(
          DomainObjectList: TDomainObjectList;
          DataReader: IDataReader
        ); virtual;

      protected

        procedure PrepareAddDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareAddDomainObjectListQuery(
          DomainObjectList: TDomainObjectList;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;
        
        procedure PrepareUpdateDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareUpdateDomainObjectListQuery(
          DomainObjectList: TDomainObjectList;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;
        
        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareRemoveDomainObjectListQuery(
          DomainObjectList: TDomainObjectList;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareRemoveDomainObjectListByCriteriaQuery(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;
        
        procedure PrepareFindDomainObjectByIdentityQuery(
          Identity: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareFindDomainObjectsByIdentitiesQuery(
          const Identities: TVariantList;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareLoadAllDomainObjectsQuery(
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;
        
      protected

        procedure GetSelectListFromTableMappingForSelectByIdentity(
          var SelectList: String;
          var WhereClauseForSelectIdentity: String
        ); virtual;

        function CreateVALUESRowsLayoutStringFromDomainObjectList(
          DomainObjectList: TDomainObjectList;
          const Mode: TVAlUESRowsLayoutCreatingMode
        ): String; virtual;

        function GetSelectListFromTableMappingForSelectGroup: String; virtual;
        function GetTableNameFromTableMappingForSelect: String; virtual;
        function GetCustomWhereClauseForSelect: String; virtual;
        function GetCustomWhereClauseForDelete: String; virtual;
        function GetCustomTrailingSelectQueryTextPart: String; virtual;
        function GetCustomTrailingInsertQueryTextPart: String; virtual;
        function GetCustomTrailingUpdateQueryTextPart: String; virtual;
        function GetCustomTrailingDeleteQueryTextPart: String; virtual;

      protected
      
        procedure PrepareAndExecuteAddDomainObjectQuery(DomainObject: TDomainObject); virtual;
        procedure PrepareAndExecuteAddDomainObjectListQuery(DomainObjectList: TDomainObjectList); virtual;
        procedure PrepareAndExecuteUpdateDomainObjectQuery(DomainObject: TDomainObject); virtual;
        procedure PrepareAndExecuteUpdateDomainObjectListQuery(DomainObjectList: TDomainObjectList); virtual;
        procedure PrepareAndExecuteRemoveDomainObjectQuery(DomainObject: TDomainObject); virtual;
        procedure PrepareAndExecuteRemoveDomainObjectListQuery(DomainObjectList: TDomainObjectList); virtual;
        procedure PrepareAndExecuteRemoveDomainObjectListByCriteriaQuery(Criteria: TAbstractRepositoryCriterion); virtual;
        function PrepareAndExecuteFindDomainObjectByIdentityQuery(Identity: Variant): IDataReader; virtual;
        function PrepareAndExecuteFindDomainObjectsByIdentitiesQuery(const Identities: TVariantList): IDataReader; virtual;
        function PrepareAndExecuteFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion
        ): IDataReader; virtual;
        function PrepareAndExecuteLoadAllDomainObjectsQuery: IDataReader; virtual;

        function InternalAdd(DomainObject: TDomainObject): Boolean; override;
        function InternalAddDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; override;
        function InternalUpdate(DomainObject: TDomainObject): Boolean; override;
        function InternalUpdateDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; override;
        function InternalRemove(DomainObject: TDomainObject): Boolean; override;
        function InternalRemoveDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; override;
        function InternalRemoveDomainObjectsForAggregateExcept(DomainObjects: TDomainObjectList; AggregateIdentityInfo: TNameValue): Boolean; override;
        function InternalRemoveDomainObjectListByCriteria(Criteria: TAbstractRepositoryCriterion): Boolean; override;
        function InternalRemoveDomainObjectsByAllMatchingProperties(PropertyInfos: array of TNameValue): Boolean; override;
        function InternalFindDomainObjectsByIdentities(const Identities: TVariantList): TDomainObjectList; override;
        function InternalFindDomainObjectByIdentity(Identity: Variant): TDomainObject; override;
        function InternalFindDomainObjectsByCriteria(Criteria: TAbstractRepositoryCriterion): TDomainObjectList; override;
        function InternalFindDomainObjectsByAllMatchingProperties(PropertyInfos: array of TNameValue): TDomainObjectList; override;
        function InternalLoadAll: TDomainObjectList; override;

      protected

        procedure FillDomainObjectListFromDataReader(
          DomainObjects: TDomainObjectList;
          DataReader: IDataReader
        ); override;

        procedure OnEventRaisedAboutDomainObjectWasLoadedEarlier(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); virtual;
        
        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

        function CreateDomainObject(DataReader: IDataReader): TDomainObject; override;
        function CreateDomainObjectList(DataReader: IDataReader): TDomainObjectList; override;
        
        function SafeQueryExecutor: IQueryExecutor;

        procedure SetQueryExecutor(const Value: IQueryExecutor); virtual;
        
        function CreateQueryParamsFromDomainObjectAndColumnMappings(
          DomainObject: TDomainObject;
          ColumnMappings: TTableColumnMappings
        ): TQueryParams; virtual;

        function CreateParamValuesFromDomainObjectIdentityAndPrimaryKeyColumnMappings(
          const DomainObjectIdentity: Variant;
          PrimaryKeyColumnMappings: TTableColumnMappings
        ): TQueryParams; virtual;

        function GetQueryParameterValueFromDomainObject(
          DomainObject: TDomainObject;
          const DomainObjectPropertyName: String
        ): Variant; virtual;
        
      public

        destructor Destroy; override;

        constructor Create(TableDef: TTableDef = nil); overload;

        constructor Create(
          RepositoryErrorCreator: TRepositoryErrorCreator;
          TableDef: TTableDef = nil
        ); overload;

        constructor Create(
          QueryExecutor: IQueryExecutor;
          TableDef: TTableDef = nil
        ); overload;

        constructor Create(
          QueryExecutor: IQueryExecutor;
          RepositoryErrorCreator: TRepositoryErrorCreator;
          TableDef: TTableDef = nil
        ); overload;
        
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

        procedure ThrowExceptionIfHasDataManipulationError; override;
        procedure ThrowExceptionIfErrorIsNotUnknown;

        property ReturnIdOfDomainObjectAfterAdding: Boolean
        read FReturnIdOfDomainObjectAfterAdding
        write FReturnIdOfDomainObjectAfterAdding;

        property ReturnIdOfDomainObjectAfterUpdate: Boolean
        read FReturnIdOfDomainObjectAfterUpdate
        write FReturnIdOfDomainObjectAfterUpdate;
        
        property IdentityColumnsModificationEnabled: Boolean
        read FIdentityColumnsModificationEnabled
        write FIdentityColumnsModificationEnabled;

        property TableMapping: TDBTableMapping read FDBTableMapping;

        property TableDef: TTableDef
        read GetTableDef write SetTableDef;
        
        property QueryExecutor: IQueryExecutor
        read FQueryExecutor write SetQueryExecutor;
        
    end;

    TAbstractDecoratingDBRepository = class (TAbstractDBRepository)

      protected

        FDecoratedDBRepository: TAbstractDBRepository;

        constructor Create; overload;
        constructor Create(QueryExecutor: IQueryExecutor); overload;
        constructor Create(
          QueryExecutor: IQueryExecutor;
          DecoratedDBRepository: TAbstractDBRepository
        ); overload;

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
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

  Disposable,
  SQLAnyMatchingCriterion,
  SQLAllMultiFieldsEqualityCriterion,
  AuxZeosFunctions,
  StrUtils,
  SQLCastingFunctions,
  AuxDebugFunctionsUnit,
  AuxiliaryStringFunctions,
  BinaryDBRepositoryCriterionUnit,
  ConstDBRepositoryCriterionUnit,
  BoolLogicalNegativeDBRepositoryCriterionUnit,
  UnaryDBRepositoryCriterionUnit,
  ContainsDBRepositoryCriterionOperationUnit;

type

  TFindDomainObjectsByIdentitiesCriterion = class (TAbstractRepositoryCriterion)

    private

      FRepository: TAbstractDBRepository;
      FIdentities: TVariantList;

    protected

      function GetExpression: String; override;

    public

      constructor Create(
        const Identities: TVariantList;
        Repository: TAbstractDBRepository
      );

  end;
  
{ TDBRepositoryErrorCreator }

constructor TDBRepositoryErrorCreator.Create(
  AAbstractRepository: TAbstractRepository);
begin

  inherited;

  FRegExpr := TRegExpr.Create;

end;

function TDBRepositoryErrorCreator.CreateDefaultErrorFromException(
  const SourceException: Exception): TRepositoryError;
var QueryExecutingError: TQueryExecutingError;
begin

  if SourceException is TQueryExecutingError then begin

    QueryExecutingError := SourceException as TQueryExecutingError;

    Result :=
      TRepositoryError.Create(
        QueryExecutingError.Message,
        QueryExecutingError.Message,
        QueryExecutingError.Code
      );

  end

  else Result := inherited CreateDefaultErrorFromException(SourceException);

end;

function TDBRepositoryErrorCreator.CreateErrorFromException(
          const SourceException: Exception;
          ExceptionalDomainObject: TDomainObject
        ): TRepositoryError;
begin

  if SourceException is TDatabaseOperationUnknownFailException then begin

    Result :=
      TUnknownDBRepositoryError.Create(
        SourceException.Message, SourceException.Message, Null
      );
      
  end

  else begin

    Result :=
      inherited CreateErrorFromException(SourceException, ExceptionalDomainObject);

  end;

end;

destructor TDBRepositoryErrorCreator.Destroy;
begin

  FreeAndNil(FRegExpr);
  inherited;

end;

{ TAbstractDBRepository }

function TAbstractDBRepository.CheckAffectedRecordCount(
  const AffectedRecordCount: Integer): Boolean;
begin

  Result := AffectedRecordCount > 0;

end;

procedure TAbstractDBRepository.CheckModificationQueryResults(
  const AffectedRecordCount: Integer);
begin

  if not CheckAffectedRecordCount(AffectedRecordCount) then
    GenerateExceptionAboutDatabaseOperationUnknownFail;
    
end;

procedure TAbstractDBRepository.CheckSelectionQueryResults(
  DataReader: IDataReader
);
var QuerySuccessCompleted: Boolean;
begin

  if FLastOperation = roSelectSingle then
    QuerySuccessCompleted := CheckThatSingleRecordSelected(DataReader)

  else if FLastOperation in [roSelectGroup, roSelectAll] then
    QuerySuccessCompleted := CheckThatRecordGroupSelected(DataReader);

  if not QuerySuccessCompleted then
    GenerateExceptionAboutDatabaseOperationUnknownFail;
  
end;

function TAbstractDBRepository.CheckThatRecordGroupSelected(
  DataReader: IDataReader): Boolean;
begin

  Result := DataReader.RecordCount > 0;

end;

function TAbstractDBRepository.CheckThatSingleRecordSelected(
  DataReader: IDataReader): Boolean;
begin

  Result := DataReader.RecordCount = 1;

end;

constructor TAbstractDBRepository.Create(TableDef: TTableDef);
begin

  inherited Create;

  InitializeTableMappings(TableDef);

end;

constructor TAbstractDBRepository.Create(
  RepositoryErrorCreator: TRepositoryErrorCreator;
  TableDef: TTableDef
);
begin

  inherited Create(RepositoryErrorCreator);

  InitializeTableMappings(TableDef);
  
end;

constructor TAbstractDBRepository.Create(
  QueryExecutor: IQueryExecutor;
  TableDef: TTableDef
);
begin
  
  inherited Create;
  
  Self.QueryExecutor := QueryExecutor;

  InitializeTableMappings(TableDef);
  
end;

constructor TAbstractDBRepository.Create(
  QueryExecutor: IQueryExecutor;
  RepositoryErrorCreator: TRepositoryErrorCreator;
  TableDef: TTableDef
);
begin

  inherited Create(RepositoryErrorCreator);

  Self.QueryExecutor := QueryExecutor;

  InitializeTableMappings(TableDef);
  
end;

function TAbstractDBRepository.CreateDBTableMapping: TDBTableMapping;
begin

  Result := TDBTableMapping.Create;
  
end;

function TAbstractDBRepository.CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator;
begin

  Result := TDBRepositoryErrorCreator.Create(Self);
  
end;

function TAbstractDBRepository.CreateDomainObject(DataReader: IDataReader): TDomainObject;
begin

  Result := TDomainObjectClass(FDBTableMapping.ObjectClass).Create;

end;

function TAbstractDBRepository.CreateDomainObjectCompiler(
  ColumnMappings: TTableColumnMappings
): TDomainObjectCompiler;
begin

  Result := TDomainObjectCompiler.Create(ColumnMappings);
  
end;

function TAbstractDBRepository.CreateDomainObjectList(DataReader: IDataReader): TDomainObjectList;
begin

  if not Assigned(FDBTableMapping.ObjectListClass) then
    Result := TDomainObjectList.Create
  
  else
    Result := TDomainObjectListClass(FDBTableMapping.ObjectListClass).Create;

end;

function TAbstractDBRepository.
  CreateParamValuesFromDomainObjectIdentityAndPrimaryKeyColumnMappings(
    const DomainObjectIdentity: Variant;
    PrimaryKeyColumnMappings: TTableColumnMappings
  ): TQueryParams;
var
    PrimaryKeyColumnMapping: TTableColumnMapping;
    PrimaryKeyColumnIndex: Integer;
begin

  if PrimaryKeyColumnMappings.Count = 0 then begin

    Result := nil;
    Exit;
    
  end;

  Result := TQueryParams.Create;

  try

    if not VarIsType(DomainObjectIdentity, varArray) then begin

      Result.Add(
        PrimaryKeyColumnMappings[0].ObjectPropertyName,
        DomainObjectIdentity
      );

      Exit;

    end;

    for PrimaryKeyColumnIndex := 0 to PrimaryKeyColumnMappings.Count - 1
    do begin

      PrimaryKeyColumnMapping :=
        PrimaryKeyColumnMappings[PrimaryKeyColumnIndex];

      Result.Add(
        PrimaryKeyColumnMapping.ObjectPropertyName,
        DomainObjectIdentity[PrimaryKeyColumnIndex]
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TAbstractDBRepository.
  CreateQueryParamsFromDomainObjectAndColumnMappings(
    DomainObject: TDomainObject;
    ColumnMappings: TTableColumnMappings
  ): TQueryParams;
var
    ColumnMapping: TTableColumnMapping;
    ParameterName: String;
    ParameterValue: Variant;
begin

  if ColumnMappings.Count = 0 then begin

    Result := nil;
    Exit;

  end;                                    

  Result := TQueryParams.Create;

  try

    for ColumnMapping in ColumnMappings
    do begin

      ParameterName := ColumnMapping.ObjectPropertyName;

      ParameterValue :=
        GetQueryParameterValueFromDomainObject(
          DomainObject, ParameterName
        );

      Result.Add(ParameterName, ParameterValue);

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TAbstractDBRepository.CreateVALUESRowsLayoutStringFromDomainObjectList(
  DomainObjectList: TDomainObjectList;
  const Mode: TVAlUESRowsLayoutCreatingMode
): String;

var
    DomainObject: TDomainObject;
    DomainObjectIdentityPropertyValueStringList,
    DomainObjectRestPropertyValueStringList: String;
    DomainObjectPropertyValueStringList: String;

    function GetDomainObjectPropertyValueString(
      DomainObject: TDomainObject;
      const PropertyName: String
    ): String;
    var
        DomainObjectPropertyValue: Variant;
    begin

      DomainObjectPropertyValue :=
        GetQueryParameterValueFromDomainObject(
          DomainObject, PropertyName
        );

      if VarIsNull(DomainObjectPropertyValue) or
         VarIsEmpty(DomainObjectPropertyValue)
      then
        Result := 'null'

      else begin

        if
           VarIsType(DomainObjectPropertyValue, varDate)
        then begin

          Result := AsSQLDateTime(DomainObjectPropertyValue);

        end

        else if 
                VarIsType(DomainObjectPropertyValue, varDouble) or
                VarIsType(DomainObjectPropertyValue, varSingle)
        then begin

          Result := AsSQLFloat(DomainObjectPropertyValue);
          
        end

        else begin

          Result := VarToStr(DomainObjectPropertyValue);

          if VarIsType(DomainObjectPropertyValue, varString) then begin

            Result := QuotedStr(Result);

          end;

        end;

      end;
      
    end;

    function GetDomainObjectPropertyValueStringList(
      DomainObject: TDomainObject;
      ColumnMappings: TDBTableColumnMappings
    ): String;
    var DomainObjectPropertyValueString: String;
        ColumnMapping: TDBTableColumnMapping;
        ConversionTypeName: String;
    begin

      Result := '';

      for ColumnMapping in ColumnMappings do begin

        ConversionTypeName := ColumnMapping.ConversionTypeName;

        DomainObjectPropertyValueString :=
          GetDomainObjectPropertyValueString(
            DomainObject, ColumnMapping.ObjectPropertyName
          );

        if ConversionTypeName <> '' then begin
        
          DomainObjectPropertyValueString :=
            Format(
              'CAST (%s AS %s)',
              [
                DomainObjectPropertyValueString,
                ConversionTypeName
              ]
            );

        end;

        if Result = ''  then
          Result := DomainObjectPropertyValueString

        else
          Result := Result + ',' + DomainObjectPropertyValueString

      end;

    end;
    
begin

  Result := '';

  for DomainObject in DomainObjectList do begin

    DomainObjectIdentityPropertyValueStringList := '';

    if Mode = UsePrimaryKeyColumns then begin

      DomainObjectIdentityPropertyValueStringList :=
        GetDomainObjectPropertyValueStringList(
          DomainObject, FDBTableMapping.PrimaryKeyColumnMappings
        );

    end;

    DomainObjectRestPropertyValueStringList :=
      GetDomainObjectPropertyValueStringList(
        DomainObject, FDBTableMapping.ColumnMappingsForModification
      );

    DomainObjectPropertyValueStringList :=
      '(' +
      DomainObjectIdentityPropertyValueStringList +

      IfThen(
        DomainObjectIdentityPropertyValueStringList <> '',
        ','
      ) +

      DomainObjectRestPropertyValueStringList
      + ')';

    if Result = '' then
      Result := DomainObjectPropertyValueStringList

    else Result := Result + ',' + DomainObjectPropertyValueStringList;

  end;
  
end;

procedure TAbstractDBRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin

end;

destructor TAbstractDBRepository.Destroy;
begin

  FreeAndNil(FDomainObjectCompiler);
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


function TAbstractDBRepository.ExecuteModificationQueryAndCheckResults(
  const QueryPattern: String;
  const QueryParams: TQueryParams
): Integer;
begin

  Result := SafeQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams);

  CheckModificationQueryResults(Result);
  
end;

function TAbstractDBRepository.ExecuteSelectionQueryAndCheckResults(
  const QueryPattern: String;
  const QueryParams: TQueryParams
): IDataReader;
begin

  Result := SafeQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

  CheckSelectionQueryResults(Result);
  
end;

function TAbstractDBRepository.FetchDomainObjectId(
  DataReader: IDataReader;
  ColumnMappings: TTableColumnMappings
): Variant;
var
    PrimaryKeyColumnName: String;
    PrimaryKeyColumnMapping: TTableColumnMapping;
    PrimaryKeyColumnMappings: TTableColumnMappings;
    PrimaryKeyColumnIndex: Integer;
begin

  if FDBTableMapping.PrimaryKeyColumnMappings.Count = 1 then  begin

    PrimaryKeyColumnName :=
      FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName;

    Result := DataReader[PrimaryKeyColumnName];
    
  end

  else begin

    PrimaryKeyColumnMappings := FDBTableMapping.PrimaryKeyColumnMappings;

    Result :=
      VarArrayCreate([0, PrimaryKeyColumnMappings.Count - 1], varVariant);

    for PrimaryKeyColumnIndex := 0 to PrimaryKeyColumnMappings.Count - 1
    do begin

      PrimaryKeyColumnMapping :=
        PrimaryKeyColumnMappings[PrimaryKeyColumnIndex];

      Result[PrimaryKeyColumnIndex] :=
        DataReader[PrimaryKeyColumnMapping.ColumnName];

    end;

  end;

end;

procedure TAbstractDBRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
begin

  FDomainObjectCompiler.CompileDomainObject(
    DomainObject,
    DataReader
  );

end;

procedure TAbstractDBRepository.FillDomainObjectListFromDataReader(
  DomainObjects: TDomainObjectList;
  DataReader: IDataReader
);
var
    DomainObjectId: Variant;
    AlreadyLoadedDomainObject: TDomainObject;
    RecordPointer: Pointer;
begin

  DataReader.Restart;
  
  while DataReader.Next do begin

    DomainObjectId :=
      FetchDomainObjectId(DataReader, FDBTableMapping.PrimaryKeyColumnMappings);
      
    AlreadyLoadedDomainObject :=
      DomainObjects.FindByIdentity(DomainObjectId);

    RecordPointer := DataReader.GetCurrentRecordPointer;
    
    try
    
      if AlreadyLoadedDomainObject <> nil then begin

        OnEventRaisedAboutDomainObjectWasLoadedEarlier(
          AlreadyLoadedDomainObject,
          DataReader
        )

      end

      else begin

        DomainObjects.AddDomainObject(
          CreateAndFillDomainObjectFromDataReader(DataReader)
        );

      end;

    finally

      DataReader.GoToRecord(RecordPointer);

    end;

  end;
  
end;

procedure TAbstractDBRepository.GenerateExceptionAboutDatabaseOperationUnknownFail;
var ErrorMessage: String;
begin

  case FLastOperation of
    
    roAdding:

      ErrorMessage := '�� ������� �������� ������ �� ������� � ��';

    roChanging:

      ErrorMessage := '�� ������� �������� ������ �� ������� � ��';

    roRemoving:

      ErrorMessage := '�� ������� ������� ������ �� ������� �� ��';

    roSelectSingle:

      ErrorMessage := '�� ������� ������� ������ �� ������� �� ��';

    roSelectAll, roSelectGroup:

      ErrorMessage := '�� ������� ������� ������ �� �������� �� ��';

  end;

  raise TDatabaseOperationUnknownFailException.Create(ErrorMessage);
  
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

function TAbstractDBRepository.GetTableDef: TTableDef;
begin

  Result := FTableDef;
  
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

function TAbstractDBRepository.GetQueryParameterValueFromDomainObject(
  DomainObject: TDomainObject;
  const DomainObjectPropertyName: String
): Variant;
begin

  Result := TReflectionServices.GetObjectPropertyValue(
              DomainObject, DomainObjectPropertyName
            );
end;

procedure TAbstractDBRepository.PrepareAddDomainObjectListQuery(
  DomainObjectList: TDomainObjectList;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var ColumnNameList, ColumnValuePlaceholderList: String;
    VALUESRowsLayoutString: String;
begin

  FDBTableMapping.GetInsertList(ColumnNameList, ColumnValuePlaceholderList);

  VALUESRowsLayoutString :=
    CreateVALUESRowsLayoutStringFromDomainObjectList(
      DomainObjectList, DontUsePrimaryKeyColumns
    );

  QueryPattern :=
    Format(
      'INSERT INTO %s (%s) VALUES %s',
      [
        FDBTableMapping.TableName,
        ColumnNameList,
        VALUESRowsLayoutString
      ]
    ) + ' ' + GetCustomTrailingInsertQueryTextPart;

  QueryParams := nil;

end;

procedure TAbstractDBRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var ColumnNameList, ColumnValuePlaceholderList: String;
begin

  FDBTableMapping.GetInsertList(ColumnNameList, ColumnValuePlaceholderList);

  QueryPattern :=
    Format(
      'INSERT INTO %s (%s) VALUES (%s)',
      [FDBTableMapping.TableName, ColumnNameList, ColumnValuePlaceholderList]
    ) + ' ' + GetCustomTrailingInsertQueryTextPart;

  QueryParams :=
    CreateQueryParamsFromDomainObjectAndColumnMappings(
      DomainObject, FDBTableMapping.ColumnMappingsForModification
    );

end;

function TAbstractDBRepository.PrepareAndExecuteFindDomainObjectByIdentityQuery(
  Identity: Variant
): IDataReader;
var QueryPattern: String;
    QueryParams: TQueryParams;
begin

  QueryParams := nil;

  try

    PrepareFindDomainObjectByIdentityQuery(Identity, QueryPattern, QueryParams);

    Result := ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TAbstractDBRepository.PrepareAndExecuteFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion
): IDataReader;
var QueryPattern: String;
    QueryParams: TQueryParams;
begin

  QueryParams := nil;

  try

    PrepareFindDomainObjectsByCriteria(Criteria, QueryPattern, QueryParams);

    Result := ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TAbstractDBRepository.
  PrepareAndExecuteFindDomainObjectsByIdentitiesQuery(
    const Identities: TVariantList
  ): IDataReader;
var QueryPattern: String;
    QueryParams: TQueryParams;
begin

  QueryParams := nil;

  try

    PrepareFindDomainObjectsByIdentitiesQuery(Identities, QueryPattern, QueryParams);

    Result := ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TAbstractDBRepository.
  PrepareAndExecuteLoadAllDomainObjectsQuery: IDataReader;
var QueryPattern: String;
    QueryParams: TQueryParams;
begin

  QueryParams := nil;

  try

    PrepareLoadAllDomainObjectsQuery(QueryPattern, QueryParams);

    Result := ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TAbstractDBRepository.PrepareAndExecuteAddDomainObjectQuery(
  DomainObject: TDomainObject
);
var
    QueryPattern: String;
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  if FReturnIdOfDomainObjectAfterAdding then
    FLastOperation := roSelectSingle;

  QueryParams := nil;

  try

    PrepareAddDomainObjectQuery(DomainObject, QueryPattern, QueryParams);

    if FReturnIdOfDomainObjectAfterAdding then begin

      DataReader :=
        ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

      SetIdForDomainObject(DomainObject, DataReader);

    end

    else ExecuteModificationQueryAndCheckResults(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

    if FReturnIdOfDomainObjectAfterAdding then
      FLastOperation := roAdding;

  end;

end;

procedure TAbstractDBRepository.PrepareAndExecuteAddDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
var
    QueryPattern: String;
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  if FReturnIdOfDomainObjectAfterAdding then
    FLastOperation := roSelectGroup;

  QueryParams := nil;

  try
  
    PrepareAddDomainObjectListQuery(DomainObjectList, QueryPattern, QueryParams);

    if FReturnIdOfDomainObjectAfterAdding then begin

      DataReader :=
        ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

      SetIdForDomainObjects(DomainObjectList, DataReader);

    end

    else ExecuteModificationQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
    if FReturnIdOfDomainObjectAfterAdding then
      FLastOperation := roAdding;

  end;

end;

procedure TAbstractDBRepository.PrepareAndExecuteUpdateDomainObjectQuery(
  DomainObject: TDomainObject
);
var
    QueryPattern: String;
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  if FReturnIdOfDomainObjectAfterUpdate then
    FLastOperation := roSelectSingle;

  QueryParams := nil;

  try

    PrepareUpdateDomainObjectQuery(DomainObject, QueryPattern, QueryParams);

    if FReturnIdOfDomainObjectAfterUpdate then begin

      DataReader :=
        ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

      SetIdForDomainObject(DomainObject, DataReader);

    end

    else ExecuteModificationQueryAndCheckResults(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

    if FReturnIdOfDomainObjectAfterUpdate then
      FLastOperation := roChanging;

  end;

end;

procedure TAbstractDBRepository.PrepareAndExecuteUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
var
    QueryPattern: String;
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  if FReturnIdOfDomainObjectAfterUpdate then
    FLastOperation := roSelectGroup;

  QueryParams := nil;

  try

    PrepareUpdateDomainObjectListQuery(DomainObjectList, QueryPattern, QueryParams);

    if FReturnIdOfDomainObjectAfterUpdate then begin

      DataReader :=
        ExecuteSelectionQueryAndCheckResults(QueryPattern, QueryParams);

      SetIdForDomainObjects(DomainObjectList, DataReader);

    end

    else ExecuteModificationQueryAndCheckResults(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

    if FReturnIdOfDomainObjectAfterUpdate then
      FLastOperation := roChanging;

  end;
end;

procedure TAbstractDBRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject
);
var QueryPattern: String;
    QueryParams: TQueryParams;
begin

  QueryParams := nil;

  try

    PrepareRemoveDomainObjectQuery(DomainObject, QueryPattern, QueryParams);
    ExecuteModificationQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TAbstractDBRepository.PrepareAndExecuteRemoveDomainObjectListByCriteriaQuery(
  Criteria: TAbstractRepositoryCriterion
);
var
    QueryPattern: String;
    QueryParams: TQueryParams;
begin

  QueryParams := nil;

  try

    PrepareRemoveDomainObjectListByCriteriaQuery(Criteria, QueryPattern, QueryParams);
    ExecuteModificationQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TAbstractDBRepository.PrepareAndExecuteRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
var QueryPattern: String;
    QueryParams: TQueryParams;
begin

  QueryParams := nil;

  try

    PrepareRemoveDomainObjectListQuery(DomainObjectList, QueryPattern, QueryParams);

    ExecuteModificationQueryAndCheckResults(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

procedure TAbstractDBRepository.
  PrepareFindDomainObjectByIdentityQuery(
    Identity: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var TableName, SelectList, WhereClauseForSelectIdentity,
    CustomWhereClause, QueryText: String;
    PrimaryKeyColumnMapping: TTableColumnMapping;
begin

  TableName := GetTableNameFromTableMappingForSelect;

  GetSelectListFromTableMappingForSelectByIdentity(
    SelectList, WhereClauseForSelectIdentity
  );

  CustomWhereClause := GetCustomWhereClauseForSelect;

  if CustomWhereClause <> '' then begin
  
    WhereClauseForSelectIdentity :=
      WhereClauseForSelectIdentity + ' AND ' + CustomWhereClause; 

  end;

  QueryPattern :=
    Format(
      'SELECT %s FROM %s WHERE %s',
      [SelectList, TableName, WhereClauseForSelectIdentity]
    )
    + ' ' + GetCustomTrailingSelectQueryTextPart;

  QueryParams :=
    CreateParamValuesFromDomainObjectIdentityAndPrimaryKeyColumnMappings(
      Identity, FDBTableMapping.PrimaryKeyColumnMappings
    );

end;

procedure TAbstractDBRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var TableName, SelectList, CriteriaWhereClause, CustomWhereClause: String;
    QueryText: String;
begin

  Criteria.FieldMappings := FDBTableMapping.ColumnMappingsForSelect;

  TableName := GetTableNameFromTableMappingForSelect;
  SelectList := GetSelectListFromTableMappingForSelectGroup;
  CustomWhereClause := GetCustomWhereClauseForSelect;

  CriteriaWhereClause := Criteria.Expression;

  if CustomWhereClause <> '' then
    CriteriaWhereClause := CriteriaWhereClause + ' AND ' + CustomWhereClause;

  QueryPattern :=
    Format(
      'SELECT %s FROM %s WHERE %s',
      [
       SelectList,
       TableName,
       CriteriaWhereClause
      ]
    )
    + ' ' + GetCustomTrailingSelectQueryTextPart;

  QueryParams := nil;
  
end;

procedure TAbstractDBRepository.PrepareFindDomainObjectsByIdentitiesQuery(
  const Identities: TVariantList;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var Criteria: TFindDomainObjectsByIdentitiesCriterion;
begin

  Criteria := TFindDomainObjectsByIdentitiesCriterion.Create(Identities, Self);

  try

    PrepareFindDomainObjectsByCriteria(
      Criteria, QueryPattern, QueryParams
    );

  finally

    FreeAndNil(Criteria);

  end;

end;

procedure TAbstractDBRepository.PrepareLoadAllDomainObjectsQuery(
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var TableName, SelectList, CustomWhereClause: String;
begin

  TableName := GetTableNameFromTableMappingForSelect;
  SelectList := GetSelectListFromTableMappingForSelectGroup;
  CustomWhereClause := GetCustomWhereClauseForSelect;

  QueryPattern :=
    Format(
      'SELECT %s FROM %s',
      [
       SelectList,
       TableName
      ]
    );

  if CustomWhereClause <> '' then
    QueryPattern := QueryPattern + ' WHERE ' + CustomWhereClause;

  QueryPattern := QueryPattern + ' ' + GetCustomTrailingSelectQueryTextPart;

  QueryParams := nil;
  
end;

procedure TAbstractDBRepository.PrepareRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);

  function CreateDomainObjectIdentitiesListStringForRemoving(
    DomainObjectList: TDomainObjectList
  ): String;
  var DomainObject: TDomainObject;
      IdentityString: String;
  begin

    for DomainObject in DomainObjectList do begin

      IdentityString := VarToStr(DomainObject.Identity);

      if Result = '' then
        Result := IdentityString

      else Result := Result + ',' + IdentityString;

    end;

  end;

begin

  QueryPattern :=
    Format(
      'DELETE FROM %s WHERE %s IN (%s)',
      [
        FDBTableMapping.TableNameWithAlias,
        FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName,
        CreateDomainObjectIdentitiesListStringForRemoving(DomainObjectList)
      ]
    );

  QueryParams := nil;
  
end;

procedure TAbstractDBRepository
  .PrepareRemoveDomainObjectListByCriteriaQuery(
    Criteria: TAbstractRepositoryCriterion;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
begin

  QueryPattern :=
    Format(
      'DELETE FROM %s WHERE %s',
      [
        FDBTableMapping.TableNameWithAlias,
        IfThen(
          Trim(Criteria.Expression) <> '',
          Criteria.Expression + ' AND ' + GetCustomWhereClauseForDelete,
          GetCustomWhereClauseForDelete
        )
      ]
    ) + ' ' + GetCustomTrailingDeleteQueryTextPart;

end;

procedure TAbstractDBRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var PrimaryKeyColumnMapping: TTableColumnMapping;
begin

  QueryPattern :=
    Format(
      'DELETE FROM %s WHERE %s',
      [
       FDBTableMapping.TableNameWithAlias,
       GetCustomWhereClauseForDelete
      ]
    ) + ' ' + GetCustomTrailingDeleteQueryTextPart;

  QueryParams :=
    CreateQueryParamsFromDomainObjectAndColumnMappings(
      DomainObject, FDBTableMapping.PrimaryKeyColumnMappings
    );

end;

procedure TAbstractDBRepository.PrepareUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  raise Exception.Create(
          '���������� ������ �������� ' +
          '�������� � ������ ������ ������� ' +
          '�� �������������� � ������ ' +
          '�����������'
        );
        
end;

procedure TAbstractDBRepository.PrepareUpdateDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var PrimaryKeyColumnMapping: TTableColumnMapping;
    PrimaryKeyColumnQueryParams: TQueryParams;
begin
                     
  QueryPattern :=
    Format(
      'UPDATE %s SET %s WHERE %s',
      [
       FDBTableMapping.TableNameWithAlias,
       FDBTableMapping.GetUpdateList,
       FDBTableMapping.GetWhereClauseForSelectUniqueObject
      ]
    ) + ' ' + GetCustomTrailingUpdateQueryTextPart;

  QueryParams := nil;
  PrimaryKeyColumnQueryParams := nil;

  try

    QueryParams :=
      CreateQueryParamsFromDomainObjectAndColumnMappings(
        DomainObject, FDBTableMapping.ColumnMappingsForModification
      );

    PrimaryKeyColumnQueryParams :=
      CreateQueryParamsFromDomainObjectAndColumnMappings(
        DomainObject, FDBTableMapping.PrimaryKeyColumnMappings
      );

    QueryParams.SpliceParams(PrimaryKeyColumnQueryParams);

  except

    on e: Exception do begin

      FreeAndNil(QueryParams);
      FreeAndNil(PrimaryKeyColumnQueryParams);

      raise;
      
    end;

  end;

end;

function TAbstractDBRepository.InternalFindDomainObjectByIdentity(
  Identity: Variant): TDomainObject;
var DataReader: IDataReader;
begin

  DataReader := PrepareAndExecuteFindDomainObjectByIdentityQuery(Identity);

  Result := CreateAndFillDomainObjectFromDataReader(DataReader);

end;

function TAbstractDBRepository.InternalFindDomainObjectsByAllMatchingProperties(
  PropertyInfos: array of TNameValue): TDomainObjectList;
var
    FieldNames: TStrings;
    FieldValues: TVariantList;
    Criteria: TSQLAllMultiFieldsEqualityCriterion;
    FreeCriteria: IDisposable;
begin

  if Length(PropertyInfos) = 0 then begin

    Result := InternalLoadAll;
    Exit;

  end;

  TNameValue.Deconstruct(PropertyInfos, FieldNames, FieldValues);

  try

    Criteria := TSQLAllMultiFieldsEqualityCriterion.Create(FieldNames, FieldValues);

    FreeCriteria := Criteria;

    Result := InternalFindDomainObjectsByCriteria(Criteria);

  finally

    FreeAndNil(FieldNames);
    FreeAndNil(FieldValues);

  end;

end;

function TAbstractDBRepository.InternalFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion
): TDomainObjectList;
var DataReader: IDataReader;
begin

  DataReader := PrepareAndExecuteFindDomainObjectsByCriteria(Criteria);

  Result := CreateAndFillDomainObjectListFromDataReader(DataReader);
  
end;

function TAbstractDBRepository.InternalFindDomainObjectsByIdentities(
  const Identities: TVariantList): TDomainObjectList;
var DataReader: IDataReader;
begin

  DataReader := PrepareAndExecuteFindDomainObjectsByIdentitiesQuery(Identities);

  Result := CreateAndFillDomainObjectListFromDataReader(DataReader);
  
end;

function TAbstractDBRepository.InternalLoadAll: TDomainObjectList;
var DataReader: IDataReader;
begin

  DataReader := PrepareAndExecuteLoadAllDomainObjectsQuery;

  Result := CreateAndFillDomainObjectListFromDataReader(DataReader);

end;

procedure TAbstractDBRepository.Initialize;
begin

  inherited Initialize;
  
  MarkAllModificationOperationsAsNonTransactional;

  FReturnIdOfDomainObjectAfterAdding := True;
  
end;

procedure TAbstractDBRepository.InitializeTableMappings(TableDef: TTableDef);
begin

  FDBTableMapping := CreateDBTableMapping;

  FDomainObjectCompiler :=
    CreateDomainObjectCompiler(
      FDBTableMapping.ColumnMappingsForSelect
    );

  FTableDef := TableDef;
  
  CustomizeTableMapping(FDBTableMapping);

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

function TAbstractDBRepository.InternalRemoveDomainObjectListByCriteria(
  Criteria: TAbstractRepositoryCriterion): Boolean;
begin

  Result := False;

  PrepareAndExecuteRemoveDomainObjectListByCriteriaQuery(Criteria);

  Result := True;

end;

function TAbstractDBRepository.InternalRemoveDomainObjectsByAllMatchingProperties(
  PropertyInfos: array of TNameValue): Boolean;
var
    FieldNames: TStrings;
    FieldValues: TVariantList;
    Criteria: TSQLAllMultiFieldsEqualityCriterion;
    FreeCriteria: IDisposable;
begin

  if Length(PropertyInfos) = 0 then begin

    Result := False;
    Exit;

  end;

  TNameValue.Deconstruct(PropertyInfos, FieldNames, FieldValues);

  try

    Criteria := TSQLAllMultiFieldsEqualityCriterion.Create(FieldNames, FieldValues);

    FreeCriteria := Criteria;

    Result := InternalRemoveDomainObjectListByCriteria(Criteria);
    
  finally

    FreeAndNil(FieldNames);
    FreeAndNil(FieldValues);

  end;

end;

function TAbstractDBRepository.InternalRemoveDomainObjectsForAggregateExcept(
  DomainObjects: TDomainObjectList;
  AggregateIdentityInfo: TNameValue
): Boolean;
var
    Criteria: TAbstractRepositoryCriterion;
    DomainObjectsIdentities: TVariantList;
begin

  if DomainObjects.IsEmpty then begin

    Result := InternalRemoveDomainObjectsByAllMatchingProperties(AggregateIdentityInfo);
    Exit;
    
  end;

  DomainObjectsIdentities := DomainObjects.CreateDomainObjectIdentityList;

  Criteria :=
    TBinaryDBRepositoryCriterion.Create(
      TSQLAllMultiFieldsEqualityCriterion.Create(
        [AggregateIdentityInfo.Name],
        [AggregateIdentityInfo.Value]
      ),
      TBoolNegativeDBRepositoryCriterion.Create(
        TSQLAnyMatchingCriterion.Create(
          FDBTableMapping
            .FindSelectColumnMappingByObjectPropertyName(
              TDomainObject.IdentityPropName
            ).ColumnName,
          DomainObjectsIdentities
        )
      ),
      TBoolAndBinding.Create
    );

  try

    Result := InternalRemoveDomainObjectListByCriteria(Criteria);

  finally

    FreeAndNil(DomainObjectsIdentities);
    FreeAndNil(Criteria);
    
  end;

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

procedure TAbstractDBRepository.OnEventRaisedAboutDomainObjectWasLoadedEarlier(
  DomainObject: TDomainObject; DataReader: IDataReader);
begin

end;

function TAbstractDBRepository.SafeQueryExecutor: IQueryExecutor;
begin

  if not Assigned(FQueryExecutor) then
    raise Exception.Create('QueryExecutor not assigned');

  Result := FQueryExecutor;
  
end;

procedure TAbstractDBRepository.SetQueryExecutor(const Value: IQueryExecutor);
begin

  FQueryExecutor := Value;

end;

procedure TAbstractDBRepository.SetTableDef(const Value: TTableDef);
begin

  FTableDef := Value;
  FFreeTableDef := Value;
  
end;

procedure TAbstractDBRepository.SetIdForDomainObject(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
begin

  DomainObject.Identity :=
    FetchDomainObjectId(DataReader, FDBTableMapping.PrimaryKeyColumnMappings);

end;

procedure TAbstractDBRepository.SetIdForDomainObjects(
  DomainObjectList: TDomainObjectList;
  DataReader: IDataReader
);
var DomainObject: TDomainObject;
begin

  DataReader.Restart;
  
  for DomainObject in DomainObjectList do begin

    DataReader.Next;
    
    SetIdForDomainObject(DomainObject, DataReader);

  end;

end;

procedure TAbstractDBRepository.StartTransaction;
begin

end;

procedure TAbstractDBRepository.ThrowExceptionIfErrorIsNotUnknown;
begin

  if HasError and not (LastError is TUnknownDBRepositoryError) then
    raise Exception.Create(LastError.InformativeErrorMessage);
  
end;

procedure TAbstractDBRepository.ThrowExceptionIfHasDataManipulationError;
begin

  ThrowExceptionIfErrorIsNotUnknown;

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

constructor TAbstractDecoratingDBRepository.Create(QueryExecutor: IQueryExecutor);
begin

  inherited Create(QueryExecutor);

end;

constructor TAbstractDecoratingDBRepository.Create(
  QueryExecutor: IQueryExecutor;
  DecoratedDBRepository: TAbstractDBRepository
);
begin

  inherited Create(QueryExecutor);

  Self.DecoratedDBRepository := DecoratedDBRepository;

end;

destructor TAbstractDecoratingDBRepository.Destroy;
begin

  FreeAndNil(FDecoratedDBRepository);
  inherited;

end;

procedure TAbstractDecoratingDBRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
begin

  if Assigned(FDecoratedDBRepository) then
    FDecoratedDBRepository.FillDomainObjectFromDataReader(
      DomainObject, DataReader
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

{ TFindDomainObjectsByIdentitiesCriterion }

constructor TFindDomainObjectsByIdentitiesCriterion.Create(
  const Identities: TVariantList; Repository: TAbstractDBRepository);
begin

  inherited Create;

  FIdentities := Identities;
  FRepository := Repository;
  
end;

function TFindDomainObjectsByIdentitiesCriterion.GetExpression: String;
var TableMapping: TDBTableMapping;
    TableName: String;
    IdentityColumnName: String;
begin

  TableMapping := FRepository.TableMapping;

  if TableMapping.AliasTableName <> '' then
    TableName := TableMapping.AliasTableName

  else TableName := TableMapping.TableName;

  IdentityColumnName := TableMapping.PrimaryKeyColumnMappings[0].ColumnName;

  Result :=
    Format(
      '%s.%s IN (%s)',
      [
        TableName,
        IdentityColumnName,
        CreateStringFromVariantList(FIdentities)
      ]
    );

end;

end.
