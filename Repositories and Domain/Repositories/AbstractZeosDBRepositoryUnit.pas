unit AbstractZeosDBRepositoryUnit;

interface

uses

  {$IF CompilerVersion >= 21.0}
    {$LEGACYIFEND ON}
  {$IFEND}

  Windows, Classes, DB, SysUtils, Variants,
  AbstractRepositoryUnit, AbstractDBRepositoryUnit,
  DomainObjectUnit, ZDbcIntfs, ZDataset,
  ZAbstractRODataset, ZConnection, RegExpr,
  AbstractRepositoryCriteriaUnit, ConstRepositoryCriterionUnit,
  AbstractNegativeRepositoryCriterionUnit,
  ArithmeticRepositoryCriterionOperationsUnit,
  BoolLogicalNegativeRepositoryCriterionUnit,
  BoolLogicalRepositoryCriterionBindingsUnit,
  UnaryRepositoryCriterionUnit, BinaryRepositoryCriterionUnit,
  UnitingRepositoryCriterionUnit, DomainObjectListUnit,
  DBTableColumnMappingsUnit,
  TableColumnMappingsUnit
  {$IF CompilerVersion >= 21.0}
    , ZDatasetParam
  {$IFEND}
  ;

  type

    TZeosDBRepositoryErrorCreator = class(TDBRepositoryErrorCreator)

      protected

        function CreateDefaultErrorFromException(
          const SourceException: Exception
        ): TRepositoryError; override;

        function CreateErrorFromZeosException(ZeosException: EZSQLException): TRepositoryError;

      public

        destructor Destroy; override;

        function CreateErrorFromException(
          const SourceException: Exception;
          ExceptionalDomainObject: TDomainObject
        ): TRepositoryError; override;

    end;

    TAbstractZeosDBRepository = class
                                abstract(TAbstractDecoratingDBRepository)

      protected

        type

          TVALUESRowsLayoutCreatingMode = (

            UsePrimaryKeyColumns,
            DontUsePrimaryKeyColumns

          );

      protected

        procedure SetSurrogateIdForDomainObject(
          DomainObject: TDomainObject
        ); override;

        procedure SetSurrogateIdForDomainObjects(
          DomainObjectList: TDomainObjectList
        ); override;

      protected

        FOperationalQuery: TZQuery;

        constructor Create; overload;
        constructor Create(Connection: TComponent); overload;
        constructor Create(
          Connection: TComponent;
          DecoratedDBRepository: TAbstractZeosDBRepository
        ); overload;

        procedure CreateOperationalQueryObject;
        function GetDatabaseDataHolder: TObject; override;
        //
        procedure PrepareAddDomainObjectQuery(
          DomainObject: TDomainObject
        ); override;

        procedure PrepareAddDomainObjectListQuery(
          DomainObjectList: TDomainObjectList
        ); override;

        procedure PrepareRemoveDomainObjectListQuery(
          DomainObjectList: TDomainObjectList
        ); override;

        function CreateVALUESRowsLayoutStringFromDomainObjectList(
          DomainObjectList: TDomainObjectList;
          const Mode: TVAlUESRowsLayoutCreatingMode
        ): String;

        procedure PrepareUpdateDomainObjectQuery(
          DomainObject: TDomainObject
        ); override;
        
        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject
        ); override;

        procedure PrepareFindDomainObjectByIdentityQuery(
          Identity: Variant
        ); override;

        procedure PrepareLoadAllDomainObjectsQuery; override;

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion
        ); override;

        function CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator; override;

        procedure SetConnection(Connection: TComponent); override;
        function GetConnection: TComponent; override;

        procedure StartTransaction; override;
        procedure CommitTransaction; override;
        procedure RollbackTransaction; override;

        procedure ExecuteModifiyngQuery; override;
        procedure ExecuteSelectingQuery; override;

        function CheckThatSingleRecordSelected: Boolean; override;
        function CheckThatRecordGroupSelected: Boolean; override;
        function CheckThatRecordModified: Boolean; override;
        procedure GenerateExceptionAboutDatabaseOperationFailure; override;

        procedure OnEventRaisedAboutDomainObjectWasLoadedEarlier(
          DomainObject: TDomainObject;
          DataHolder: TObject
        ); virtual;
        
        procedure FillDomainObjectListFromDataHolder(
          DomainObjects: TDomainObjectList;
          DataHolder: TObject
        ); override;

        procedure SetParamValuesFromDomainObjectAndColumnMappings(
          DomainObject: TDomainObject;
          ColumnMappings: TTableColumnMappings
        );

        procedure
          SetParamValuesFromDomainObjectIdentityAndPrimaryKeyColumnMappings(
            const DomainObjectIdentity: Variant;
            PrimaryKeyColumnMappings: TTableColumnMappings
          );

        function GetValueForParameterOfQueryFromDomainObject(
          DomainObject: TDomainObject;
          const DomainObjectPropertyName: String
        ): Variant; virtual;

      public

        destructor Destroy; override;

        function GetNegativeRepositoryCriterionClass: TBoolNegativeRepositoryCriterionClass; override;
        function GetConstRepositoryCriterionClass: TConstRepositoryCriterionClass; override;
        function GetEqualityRepositoryCriterionOperationClass: TEqualityRepositoryCriterionOperationClass; override;
        function GetLessRepositoryCriterionOperationClass: TLessRepositoryCriterionOperationClass; override;
        function GetGreaterRepositoryCriterionOperationClass: TGreaterRepositoryCriterionOperationClass; override;
        function GetLessOrEqualRepositoryCriterionOperationClass: TLessOrEqualRepositoryCriterionOperationClass; override;
        function GetGreaterOrEqualRepositoryCriterionOperationClass: TGreaterOrEqualRepositoryCriterionOperationClass; override;
        function GetAndBindingRepositoryCriterionClass: TBoolAndBindingClass; override;
        function GetOrBindingRepositoryCriterionClass: TBoolOrBindingClass; override;
        function GetUnaryRepositoryCriterionClass: TUnaryRepositoryCriterionClass; override;
        function GetBinaryRepositoryCriterionClass: TBinaryRepositoryCriterionClass; override;
        function GetUnitingRepositoryCriterionClass: TUnitingRepositoryCriterionClass; override;

    end;

implementation

  uses BinaryDBRepositoryCriterionUnit,
       DBTableMappingUnit,
       BoolLogicalNegativeDBRepositoryCriterionUnit,
       ConstDBRepositoryCriterionUnit,
       UnaryZeosDBRepositoryCriterionUnit,
       StrUtils,
       AuxZeosFunctions,
       ReflectionServicesUnit;

{ TZeosDBRepositoryErrorCreator }


function TZeosDBRepositoryErrorCreator.CreateDefaultErrorFromException(
  const SourceException: Exception
): TRepositoryError;
begin

  Result := inherited CreateDefaultErrorFromException(SourceException);

  if SourceException is EZSQLException then begin

    with SourceException as EZSQLException do
      Result.ErrorData := StatusCode;

  end;

end;

function TZeosDBRepositoryErrorCreator.CreateErrorFromException(
          const SourceException: Exception;
          ExceptionalDomainObject: TDomainObject
        ): TRepositoryError;
begin

  Result := inherited CreateErrorFromException(SourceException, ExceptionalDomainObject);
  
end;

function TZeosDBRepositoryErrorCreator.CreateErrorFromZeosException(
  ZeosException: EZSQLException): TRepositoryError;
begin

  Result := TRepositoryError.Create(ZeosException.Message, ZeosException.Message, ZeosException.StatusCode);
  
end;

destructor TZeosDBRepositoryErrorCreator.Destroy;
begin

  inherited;

end;

{ TAbstractZeosDBRepository }

destructor TAbstractZeosDBRepository.Destroy;
begin

  FreeAndNil(FOperationalQuery);
  inherited;

end;

function TAbstractZeosDBRepository.GetAndBindingRepositoryCriterionClass: TBoolAndBindingClass;
begin

  Result := inherited GetAndBindingRepositoryCriterionClass;

end;

function TAbstractZeosDBRepository.GetBinaryRepositoryCriterionClass: TBinaryRepositoryCriterionClass;
begin

  Result := inherited GetBinaryRepositoryCriterionClass;

end;

function TAbstractZeosDBRepository.GetConstRepositoryCriterionClass: TConstRepositoryCriterionClass;
begin

  Result := inherited GetConstRepositoryCriterionClass;

end;

function TAbstractZeosDBRepository.GetDatabaseDataHolder: TObject;
begin

  Result := FOperationalQuery;
  
end;

function TAbstractZeosDBRepository.GetEqualityRepositoryCriterionOperationClass: TEqualityRepositoryCriterionOperationClass;
begin

  Result := inherited GetEqualityRepositoryCriterionOperationClass;
  
end;

function TAbstractZeosDBRepository.GetGreaterOrEqualRepositoryCriterionOperationClass: TGreaterOrEqualRepositoryCriterionOperationClass;
begin

  Result := inherited GetGreaterOrEqualRepositoryCriterionOperationClass;

end;

function TAbstractZeosDBRepository.GetGreaterRepositoryCriterionOperationClass: TGreaterRepositoryCriterionOperationClass;
begin

  Result := inherited GetGreaterRepositoryCriterionOperationClass;

end;

function TAbstractZeosDBRepository.GetLessOrEqualRepositoryCriterionOperationClass: TLessOrEqualRepositoryCriterionOperationClass;
begin

  Result := inherited GetLessOrEqualRepositoryCriterionOperationClass;

end;

function TAbstractZeosDBRepository.GetLessRepositoryCriterionOperationClass: TLessRepositoryCriterionOperationClass;
begin

  Result := inherited GetLessRepositoryCriterionOperationClass;

end;

function TAbstractZeosDBRepository.GetNegativeRepositoryCriterionClass: TBoolNegativeRepositoryCriterionClass;
begin

  Result := inherited GetNegativeRepositoryCriterionClass;
  
end;

function TAbstractZeosDBRepository.GetOrBindingRepositoryCriterionClass: TBoolOrBindingClass;
begin

  Result := inherited GetOrBindingRepositoryCriterionClass;
  
end;

function TAbstractZeosDBRepository.GetUnaryRepositoryCriterionClass: TUnaryRepositoryCriterionClass;
begin

  Result := TUnaryZeosDBRepositoryCriterion;

end;

function TAbstractZeosDBRepository.GetUnitingRepositoryCriterionClass: TUnitingRepositoryCriterionClass;
begin

  Result := inherited GetUnitingRepositoryCriterionClass;

end;

function TAbstractZeosDBRepository.GetValueForParameterOfQueryFromDomainObject(
  DomainObject: TDomainObject;
  const DomainObjectPropertyName: String
): Variant;
begin

  Result := TReflectionServices.GetObjectPropertyValue(
              DomainObject, DomainObjectPropertyName
            );
            
end;

procedure TAbstractZeosDBRepository.OnEventRaisedAboutDomainObjectWasLoadedEarlier(
  DomainObject: TDomainObject;
  DataHolder: TObject
);
begin

end;

procedure TAbstractZeosDBRepository.PrepareAddDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
var ColumnNameList, ColumnValuePlaceholderList: String;
    VALUESRowsLayoutString: String;
    QueryText: String;
begin

  FDBTableMapping.GetInsertList(ColumnNameList, ColumnValuePlaceholderList);

  VALUESRowsLayoutString :=
    CreateVALUESRowsLayoutStringFromDomainObjectList(
      DomainObjectList, DontUsePrimaryKeyColumns
    );

  QueryText :=
    Format(
      'INSERT INTO %s (%s) VALUES %s',
      [
        FDBTableMapping.TableName,
        ColumnNameList,
        VALUESRowsLayoutString
      ]
    ) + ' ' + GetCustomTrailingInsertQueryTextPart;

  FOperationalQuery.SQL.Text := QueryText;

end;

procedure TAbstractZeosDBRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject);
var ColumnNameList, ColumnValuePlaceholderList: String;
begin

  // Keep only once this in some variable
  FDBTableMapping.GetInsertList(ColumnNameList, ColumnValuePlaceholderList);

  FOperationalQuery.SQL.Text :=
    Format(
      'INSERT INTO %s (%s) VALUES (%s)',
      [FDBTableMapping.TableName, ColumnNameList, ColumnValuePlaceholderList]
    ) + ' ' + GetCustomTrailingInsertQueryTextPart;

  SetParamValuesFromDomainObjectAndColumnMappings(
    DomainObject, FDBTableMapping.ColumnMappingsForModification
  );
  
end;

procedure TAbstractZeosDBRepository.PrepareRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
var QueryText: String;

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

  QueryText :=
    Format(
      'DELETE FROM %s WHERE %s IN (%s)',
      [
        FDBTableMapping.TableNameWithAlias,
        FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName,
        CreateDomainObjectIdentitiesListStringForRemoving(DomainObjectList)
      ]
    );

  FOperationalQuery.SQL.Text := QueryText;

end;

procedure TAbstractZeosDBRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
var PrimaryKeyColumnMapping: TTableColumnMapping;
begin

  FOperationalQuery.SQL.Text :=
    Format(
      'DELETE FROM %s WHERE %s',
      [
       FDBTableMapping.TableNameWithAlias,
       GetCustomWhereClauseForDelete
      ]
    ) + ' ' + GetCustomTrailingDeleteQueryTextPart;

  SetParamValuesFromDomainObjectAndColumnMappings(
    DomainObject, FDBTableMapping.PrimaryKeyColumnMappings
  );

end;

procedure TAbstractZeosDBRepository.PrepareUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
var PrimaryKeyColumnMapping: TTableColumnMapping;
begin
                     
  FOperationalQuery.SQL.Text :=
    Format(
      'UPDATE %s SET %s WHERE %s',
      [
       FDBTableMapping.TableNameWithAlias,
       FDBTableMapping.GetUpdateList,
       FDBTableMapping.GetWhereClauseForSelectUniqueObject
      ]
    ) + ' ' + GetCustomTrailingUpdateQueryTextPart;

  SetParamValuesFromDomainObjectAndColumnMappings(
    DomainObject, FDBTableMapping.ColumnMappingsForModification
  );

  SetParamValuesFromDomainObjectAndColumnMappings(
    DomainObject, FDBTableMapping.PrimaryKeyColumnMappings
  );

end;

procedure TAbstractZeosDBRepository.PrepareFindDomainObjectByIdentityQuery(
  Identity: Variant);
var TableName, SelectList, WhereClauseForSelectIdentity,
    CustomWhereClause, QueryText: String;
    PrimaryKeyColumnMapping: TTableColumnMapping;

begin

  TableName := GetTableNameFromTableMappingForSelect;

  GetSelectListFromTableMappingForSelectByIdentity(
    SelectList, WhereClauseForSelectIdentity
  );

  CustomWhereClause := GetCustomWhereClauseForSelect;

  if CustomWhereClause <> '' then
    WhereClauseForSelectIdentity :=
      WhereClauseForSelectIdentity + ' AND ' + CustomWhereClause; 

  QueryText :=
    Format(
      'SELECT %s FROM %s WHERE %s',
      [SelectList, TableName, WhereClauseForSelectIdentity]
    )
    + ' ' + GetCustomTrailingSelectQueryTextPart;

  FOperationalQuery.SQL.Text := QueryText;

  SetParamValuesFromDomainObjectIdentityAndPrimaryKeyColumnMappings(
    Identity, FDBTableMapping.PrimaryKeyColumnMappings
  );

end;

procedure TAbstractZeosDBRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion
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

  QueryText :=
    Format(
      'SELECT %s FROM %s WHERE %s',
      [
       SelectList,
       TableName,
       CriteriaWhereClause
      ]
    )
    + ' ' + GetCustomTrailingSelectQueryTextPart;

  FOperationalQuery.SQL.Text := QueryText;

end;

procedure TAbstractZeosDBRepository.PrepareLoadAllDomainObjectsQuery;
var TableName, SelectList, CustomWhereClause, QueryText: String;
begin

  TableName := GetTableNameFromTableMappingForSelect;
  SelectList := GetSelectListFromTableMappingForSelectGroup;
  CustomWhereClause := GetCustomWhereClauseForSelect;

  QueryText :=
    Format(
      'SELECT %s FROM %s',
      [
       SelectList,
       TableName
      ]
    );

  if CustomWhereClause <> '' then
    QueryText := QueryText + ' WHERE ' + CustomWhereClause;
    
  QueryText := QueryText + ' ' + GetCustomTrailingSelectQueryTextPart;

  FOperationalQuery.SQL.Text := QueryText;

end;

//
procedure TAbstractZeosDBRepository.GenerateExceptionAboutDatabaseOperationFailure;
begin

  raise EZSQLException.CreateWithStatus('', '');

end;

procedure TAbstractZeosDBRepository.StartTransaction;
begin

  { Commit due to occurring Exception in Zeos Component 6.6.6 version }
  { Need to turn the transaction control methods to
    SQL Transaction Control Queries }
  //FOperationalQuery.Connection.AutoCommit := False;
  FOperationalQuery.Connection.StartTransaction;

end;

function TAbstractZeosDBRepository.CheckThatRecordGroupSelected: Boolean;
begin

  Result := FOperationalQuery.RecordCount > 0;

end;

function TAbstractZeosDBRepository.CheckThatRecordModified: Boolean;
begin

  Result := FOperationalQuery.RowsAffected > 0;

end;

function TAbstractZeosDBRepository.CheckThatSingleRecordSelected: Boolean;
begin

  Result := FOperationalQuery.RecordCount = 1;
  
end;

procedure TAbstractZeosDBRepository.CommitTransaction;
begin

  FOperationalQuery.Connection.Commit;

end;

procedure TAbstractZeosDBRepository.RollbackTransaction;
begin

  FOperationalQuery.Connection.Rollback;

end;

constructor TAbstractZeosDBRepository.Create;
begin

  inherited Create;

  CreateOperationalQueryObject;
  
end;

constructor TAbstractZeosDBRepository.Create(Connection: TComponent);
begin

  CreateOperationalQueryObject;

  inherited Create(Connection);

end;

constructor TAbstractZeosDBRepository.Create(
  Connection: TComponent;
  DecoratedDBRepository: TAbstractZeosDBRepository
);
begin

  CreateOperationalQueryObject;
  
  inherited Create(Connection, DecoratedDBRepository);

end;

function TAbstractZeosDBRepository.CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator;
begin

  Result := TZeosDBRepositoryErrorCreator.Create(Self);

end;

procedure TAbstractZeosDBRepository.CreateOperationalQueryObject;
begin

  FOperationalQuery := TZQuery.Create(nil);
  
end;

function TAbstractZeosDBRepository.
  CreateVALUESRowsLayoutStringFromDomainObjectList(
    DomainObjectList: TDomainObjectList;
    const Mode: TVAlUESRowsLayoutCreatingMode
  ): String;
var DomainObject: TDomainObject;
    DomainObjectIdentityPropertyValueStringList,
    DomainObjectRestPropertyValueStringList: String;
    DomainObjectPropertyValueStringList: String;
    
    function GetDomainObjectPropertyValueString(
      DomainObject: TDomainObject;
      const PropertyName: String
    ): String;
    var DomainObjectPropertyValue: Variant;
    begin

      DomainObjectPropertyValue :=
        GetValueForParameterOfQueryFromDomainObject(
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

procedure TAbstractZeosDBRepository.ExecuteModifiyngQuery;
begin

  FOperationalQuery.ExecSQL;

end;

procedure TAbstractZeosDBRepository.ExecuteSelectingQuery;
begin

  FOperationalQuery.Close;
  FOperationalQuery.Open;

end;

procedure TAbstractZeosDBRepository.FillDomainObjectListFromDataHolder(
  DomainObjects: TDomainObjectList;
  DataHolder: TObject
);
var LoadedDataSet: TDataSet;
    PrimaryKeyField: String;
    LoadedIdForDomainObject: Variant;
    AlreadyLoadedDomainObject: TDomainObject;
    CurrentRecordBookmark: TBookmark{Pointer};
begin

  LoadedDataSet := DataHolder as TDataSet;

  LoadedDataSet.DisableControls;
  LoadedDataSet.First;

  { to multiple keys in future }
  PrimaryKeyField := FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName;

  while not LoadedDataSet.Eof do begin

    LoadedIdForDomainObject :=
      LoadedDataSet.FieldByName(PrimaryKeyField).AsVariant;
      
    AlreadyLoadedDomainObject :=
      DomainObjects.FindByIdentity(LoadedIdForDomainObject);

    CurrentRecordBookmark := LoadedDataSet.GetBookmark;

    try

      if AlreadyLoadedDomainObject <> nil then begin

        OnEventRaisedAboutDomainObjectWasLoadedEarlier(
          AlreadyLoadedDomainObject,
          DataHolder
        )

      end

      else begin

        DomainObjects.AddDomainObject(
          CreateAndFillDomainObjectFromDataHolder(DataHolder)
        );

      end;

    finally

      LoadedDataSet.GotoBookmark(CurrentRecordBookmark);
      LoadedDataSet.FreeBookmark(CurrentRecordBookmark);
      
    end;

    LoadedDataSet.Next;

  end;

  LoadedDataSet.First;
  LoadedDataSet.EnableControls;

end;

function TAbstractZeosDBRepository.GetConnection: TComponent;
begin

  Result := FOperationalQuery.Connection;

end;

procedure TAbstractZeosDBRepository.SetConnection(Connection: TComponent);
begin

  FOperationalQuery.Connection := Connection as TZConnection;

end;

procedure TAbstractZeosDBRepository.SetParamValuesFromDomainObjectAndColumnMappings(
  DomainObject: TDomainObject; ColumnMappings: TTableColumnMappings);
var ColumnMapping: TTableColumnMapping;
    ParameterValue: Variant;
    {$IF CompilerVersion >= 21.0}
      Parameter: TZParam;
    {$ELSE}
      Parameter: TParam;
    {$IFEND}

begin

  for ColumnMapping in ColumnMappings
  do begin

    Parameter := FOperationalQuery.ParamByName(
                    ColumnMapping.ObjectPropertyName
                 );

    ParameterValue :=
      GetValueForParameterOfQueryFromDomainObject(
        DomainObject, ColumnMapping.ObjectPropertyName
      );

    if VarIsNull(ParameterValue) then
      Parameter.Clear

    else begin

      Parameter.Value := ParameterValue;
     
    end;

  end;

end;

procedure TAbstractZeosDBRepository.SetParamValuesFromDomainObjectIdentityAndPrimaryKeyColumnMappings(
  const DomainObjectIdentity: Variant;
  PrimaryKeyColumnMappings: TTableColumnMappings
);
var PrimaryKeyColumnMapping: TTableColumnMapping;
    PrimaryKeyColumnIndex: Integer;
begin

  if not VarIsType(DomainObjectIdentity, varArray) then begin

    FOperationalQuery.ParamByName(
      PrimaryKeyColumnMappings[0].ObjectPropertyName
    ).Value := DomainObjectIdentity;

    Exit;
    
  end;

  for PrimaryKeyColumnIndex := 0 to PrimaryKeyColumnMappings.Count - 1
  do begin

    PrimaryKeyColumnMapping :=
      PrimaryKeyColumnMappings[PrimaryKeyColumnIndex];

    FOperationalQuery.ParamByName(
      PrimaryKeyColumnMapping.ObjectPropertyName
    ).Value := DomainObjectIdentity[PrimaryKeyColumnIndex];

  end;

end;

procedure TAbstractZeosDBRepository.SetSurrogateIdForDomainObject(
  DomainObject: TDomainObject);
var PrimaryKeyColumnIndex: Integer;
    PrimaryKeyColumnMappings: TTableColumnMappings;
    PrimaryKeyColumnMapping: TTableColumnMapping;
    ComplexIdentity: Variant;
    PrimaryKeyColumnName: String;
begin

  if FDBTableMapping.PrimaryKeyColumnMappings.Count = 1 then  begin

    PrimaryKeyColumnName :=
      FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName;

    DomainObject.Identity :=
      FOperationalQuery.FieldByName(PrimaryKeyColumnName).AsVariant;

    Exit;

  end;

  PrimaryKeyColumnMappings := FDBTableMapping.PrimaryKeyColumnMappings;

  ComplexIdentity :=
    VarArrayCreate([0, PrimaryKeyColumnMappings.Count - 1], varVariant);

  for PrimaryKeyColumnIndex := 0 to PrimaryKeyColumnMappings.Count - 1
  do begin

    PrimaryKeyColumnMapping :=
      PrimaryKeyColumnMappings[PrimaryKeyColumnIndex];

    ComplexIdentity[PrimaryKeyColumnIndex] :=
      FOperationalQuery.FieldByName(
        PrimaryKeyColumnMapping.ColumnName
      ).AsVariant;

  end;

end;

procedure TAbstractZeosDBRepository.SetSurrogateIdForDomainObjects(
  DomainObjectList: TDomainObjectList
);
var DomainObject: TDomainObject;
begin

  for DomainObject in DomainObjectList do begin

    SetSurrogateIdForDomainObject(DomainObject);

    FOperationalQuery.Next;
    
  end;

end;

end.
