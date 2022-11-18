unit PostgresBaseDepartmentRepository;

interface

uses

  BaseDepartmentRepository,
  AbstractPostgresRepository,
  Department,
  VariantListUnit,
  QueryExecutor,
  DBTableMapping,
  BaseDepartmentTableDef,
  AbstractRepositoryCriteriaUnit,
  SysUtils,
  Classes;

type

  TFindAllDepartmentsBeginningWithCriterion = class (TAbstractRepositoryCriterion)

    private

      FTargetDepartmentId: Variant;

    public

      constructor Create(const TargetDepartmentId: Variant);

      property TargetDepartmentId: Variant
      read FTargetDepartmentId write FTargetDepartmentId;

  end;

  TFindHeadDepartmentForGivenDepartmentCriterion = class (TAbstractRepositoryCriterion)

    private

      FTargetDepartmentId: Variant;

    public

      constructor Create(const TargetDepartmentId: Variant);

      property TargetDepartmentId: Variant
      read FTargetDepartmentId write FTargetDepartmentId;

  end;
  
  TPostgresBaseDepartmentRepository =
    class (
      TAbstractPostgresRepository,
      IBaseDepartmentRepository
    )

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

      protected

        procedure PrepareAllDepartmentsBeginningWithFindingQuery(
          const TargetDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareAllSpecifiedDepartmentsBeginningWithFindingQuery(
          const TargetDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams;
          const SQLViewName: String;
          const InnerDepartmentsWhereConditions: String = ''
        );

      protected

        procedure PrepareHeadDepartmentForGivenDepartmentFindingQuery(
          const TargetDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareSpecifiedTopLevelDepartmentForGivenDepartmentFindingQuery(
          const TargetDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams;
          const WhereConditions: String
        );

        procedure PrepareHeadDepartmentForGivenDepartmentSQLView(
          const TargetDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareSpecifiedTopLevelDepartmentForGivenDepartmentSQLView(
          const TargetDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams;
          const WhereConditions: String
        );

        function GetTopLevelDepartmentIdNotEqualsThresholdExpression(
          const TopLevelDepartmentIdColumnName: String
        ): String;

      protected

        function FindSpecifiedTopLevelDepartmentForGivenDepartment(
          const DepartmentId: Variant;
          const Criteria: TAbstractRepositoryCriterion;
          const MoreThanOneDepartmentFoundException: Exception = nil
        ): TDepartment;

        function FindSpecifiedDepartmentsBeginningWith(
          const TargetDepartmentId: Variant;
          const Criteria: TAbstractRepositoryCriterion
        ): TDepartments;

      public

        constructor Create(
          TableDef: TBaseDepartmentTableDef;
          QueryExecutor: IQueryExecutor
        );

        function LoadAllDepartments: TDepartments;
        function FindDepartmentById(const Id: Variant): TDepartment;
        function FindDepartmentsByIds(const Ids: TVariantList): TDepartments;

        function IsDepartmentIncludesOtherDepartment(
          const TargetDepartmentId, OtherDepartmentId: Variant
        ): Boolean;

        function FindDepartmentByCode(const Code: String): TDepartment;

        function FindAllDepartmentsBeginningWith(
          const TargetDepartmentId: Variant
        ): TDepartments;

        function FindHeadDepartmentForGivenDepartment(
          const DepartmentId: Variant
        ): TDepartment;

        procedure AddDepartment(Department: TDepartment);
        procedure UpdateDepartment(Department: TDepartment);
        procedure RemoveDepartment(Department: TDepartment);

    end;

implementation

uses

  NameValue,
  StrUtils,
  Variants,
  DataReader,
  SQLCastingFunctions,
  IDomainObjectBaseListUnit,
  AbstractRepository,
  AbstractDBRepository;

{ TPostgresBaseDepartmentRepository }

constructor TPostgresBaseDepartmentRepository.Create(
  TableDef: TBaseDepartmentTableDef; QueryExecutor: IQueryExecutor);
begin

  inherited Create(QueryExecutor, TableDef);
  
end;

procedure TPostgresBaseDepartmentRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited CustomizeTableMapping(TableMapping);

  with TableMapping, TBaseDepartmentTableDef(FTableDef) do begin

    SetTableNameMapping(TableName, TDepartment, TDepartments);

    AddColumnMappingForSelect(IdColumnName, TDepartment.IdentityPropName);
    AddColumnMappingForSelect(TopLevelDepartmentIdColumnName, TDepartment.TopLevelDepartmentIdPropName);
    AddColumnMappingForSelect(CodeColumnName, TDepartment.CodePropName);
    AddColumnMappingForSelect(ShortNameColumnName, TDepartment.ShortNamePropName);
    AddColumnMappingForSelect(FullNameColumnName, TDepartment.FullNamePropName);

    AddColumnMappingForModification(TopLevelDepartmentIdColumnName, TDepartment.TopLevelDepartmentIdPropName);
    AddColumnMappingForModification(CodeColumnName, TDepartment.CodePropName);
    AddColumnMappingForModification(ShortNameColumnName, TDepartment.ShortNamePropName);
    AddColumnMappingForModification(FullNameColumnName, TDepartment.FullNamePropName);

    TableMapping.AddPrimaryKeyColumnMapping(IdColumnName, TDepartment.IdentityPropName);

  end;

end;

procedure TPostgresBaseDepartmentRepository.AddDepartment(
  Department: TDepartment);
begin

  Add(Department);
  
end;

function TPostgresBaseDepartmentRepository.FindDepartmentById(
  const Id: Variant): TDepartment;
begin

  Result := TDepartment(FindDomainObjectByIdentity(Id));

end;

function TPostgresBaseDepartmentRepository.FindDepartmentsByIds(
  const Ids: TVariantList): TDepartments;
begin

  Result := TDepartments(FindDomainObjectsByIdentities(Ids));
  
end;

function TPostgresBaseDepartmentRepository.FindDepartmentByCode(
  const Code: String): TDepartment;
begin

  Result :=
    TDepartment(
      FindDomainObjectsByAllMatchingProperties(
        [TNameValue.Create(TDepartment.CodePropName, Code)]
      )
    );
    
end;

function TPostgresBaseDepartmentRepository.LoadAllDepartments: TDepartments;
begin

  Result := TDepartments(LoadAll);
  
end;

procedure TPostgresBaseDepartmentRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion; var QueryPattern: String;
  var QueryParams: TQueryParams);
begin

  if Criteria is TFindAllDepartmentsBeginningWithCriterion then begin

    PrepareAllDepartmentsBeginningWithFindingQuery(
      TFindAllDepartmentsBeginningWithCriterion(Criteria).TargetDepartmentId,
      QueryPattern,
      QueryParams
    );

  end

  else if Criteria is TFindHeadDepartmentForGivenDepartmentCriterion then begin

    PrepareHeadDepartmentForGivenDepartmentFindingQuery(
      TFindHeadDepartmentForGivenDepartmentCriterion(Criteria).TargetDepartmentId,
      QueryPattern,
      QueryParams
    );

  end

  else inherited PrepareFindDomainObjectsByCriteria(Criteria, QueryPattern, QueryParams);

end;

procedure TPostgresBaseDepartmentRepository.PrepareAllDepartmentsBeginningWithFindingQuery(
  const TargetDepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  PrepareAllSpecifiedDepartmentsBeginningWithFindingQuery(
    TargetDepartmentId,
    QueryPattern,
    QueryParams,
    'department_tree'
  );

end;

procedure TPostgresBaseDepartmentRepository
  .PrepareAllSpecifiedDepartmentsBeginningWithFindingQuery(
    const TargetDepartmentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams;
    const SQLViewName: String;
    const InnerDepartmentsWhereConditions: String
  );
begin

  with TBaseDepartmentTableDef(FTableDef), TableMapping do begin

    QueryPattern :=
      Format(
        'with recursive %s(%s, level) as (' + #13#10 +
          'select' + #13#10 +
          '%s,' + #13#10 +
          '1 as level' + #13#10 +
          'from %s' + #13#10 +
          'where %s = :p%s' + #13#10 +
          'union' + #13#10 +
          '' + #13#10 +
          'select' + #13#10 +
          '%s,' + #13#10 +
          'b.level + 1' + #13#10 +
          'from %s a' + #13#10 +
          'join department_tree b on a.%s = b.%s' + #13#10 +
          '%s' + #13#10 +
        ')' + #13#10 +
        'select' + #13#10 +
        '*' + #13#10 +
        'from department_tree' + #13#10 +
        'order by level',
        [
          SQLViewName,
          
          TableMapping.GetSelectColumnNameListWithoutTablePrefix,

          TableMapping.GetSelectListForSelectGroup,
          GetTableNameFromTableMappingForSelect,
          IdColumnName, IdColumnName,

          TableMapping.GetSelectListForSelectGroup('a'),
          GetTableNameFromTableMappingForSelect,
          TopLevelDepartmentIdColumnName, IdColumnName,

          TopLevelDepartmentIdColumnName, IdColumnName,

          IfThen(
            InnerDepartmentsWhereConditions <> '',
            'where ' + InnerDepartmentsWhereConditions,
            ''
          )
        ]
      );

    QueryParams.Add('p' + IdColumnName, TargetDepartmentId);
    
  end;

end;

procedure TPostgresBaseDepartmentRepository
  .PrepareHeadDepartmentForGivenDepartmentFindingQuery(
    const TargetDepartmentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
begin

  with TBaseDepartmentTableDef(FTableDef) do begin

    PrepareSpecifiedTopLevelDepartmentForGivenDepartmentFindingQuery(
      TargetDepartmentId,
      QueryPattern,
      QueryParams,
      GetTopLevelDepartmentIdNotEqualsThresholdExpression(
        TopLevelDepartmentIdColumnName
      )
    );

  end;

end;

procedure TPostgresBaseDepartmentRepository.PrepareSpecifiedTopLevelDepartmentForGivenDepartmentFindingQuery(
  const TargetDepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams;
  const WhereConditions: String
);
begin

  PrepareSpecifiedTopLevelDepartmentForGivenDepartmentSQLView(
    TargetDepartmentId, QueryPattern, QueryParams, WhereConditions
  );

  with TBaseDepartmentTableDef(FTableDef) do begin

    QueryPattern :=
      Format(
        QueryPattern + #13#10 +
        'select' + #13#10 +
        '*' + #13#10 +
        'from department_branch' + #13#10 +
        'where not %s',
        [
          WhereConditions
        ]
      );

  end;

end;

procedure TPostgresBaseDepartmentRepository.PrepareHeadDepartmentForGivenDepartmentSQLView(
  const TargetDepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  with TBaseDepartmentTableDef(FTableDef) do begin

    PrepareSpecifiedTopLevelDepartmentForGivenDepartmentSQLView(
      TargetDepartmentId,
      QueryPattern,
      QueryParams,
      GetTopLevelDepartmentIdNotEqualsThresholdExpression(
        TopLevelDepartmentIdColumnName
      )
    );

  end;

end;

procedure TPostgresBaseDepartmentRepository.PrepareSpecifiedTopLevelDepartmentForGivenDepartmentSQLView(
  const TargetDepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams;
  const WhereConditions: String
);
begin

  with TBaseDepartmentTableDef(FTableDef) do begin

    QueryPattern :=
      Format(
        'with recursive department_branch(%s) as (' + #13#10 +
          'select' + #13#10 +
          '%s' + #13#10 +
          'from %s' + #13#10 +
          'where %s = :p%s' + #13#10 +
        'union' + #13#10 +
          'select' + #13#10 +
          '%s' + #13#10 +
          'from %s a' + #13#10 +
          'join department_branch b on b.%s = a.%s' + #13#10 +
          'where %s' +
        ')',
        [
          TableMapping.GetSelectColumnNameListWithoutTablePrefix,

          TableMapping.GetSelectListForSelectGroup,
          GetTableNameFromTableMappingForSelect,
          IdColumnName, IdColumnName,

          TableMapping.GetSelectListForSelectGroup('a'),
          GetTableNameFromTableMappingForSelect,
          TopLevelDepartmentIdColumnName, IdColumnName,

          WhereConditions
        ]
      );

    QueryParams.Add('p' + IdColumnName, TargetDepartmentId);

  end;

end;

function TPostgresBaseDepartmentRepository
  .GetTopLevelDepartmentIdNotEqualsThresholdExpression(
    const TopLevelDepartmentIdColumnName: String
  ): String;
begin

  with TBaseDepartmentTableDef(FTableDef) do begin

    Result :=
      TopLevelDepartmentIdColumnName +
      ' ' +
      IfThen(
        VarIsNull(TopLevelDepartmentThresholdId),
        'is not null',
        '<>' + AsSQLString(TopLevelDepartmentThresholdId)
      );

  end;

end;

procedure TPostgresBaseDepartmentRepository.RemoveDepartment(
  Department: TDepartment);
begin

  Remove(Department);

end;

procedure TPostgresBaseDepartmentRepository.UpdateDepartment(
  Department: TDepartment);
begin

  Update(Department);

end;

function TPostgresBaseDepartmentRepository.FindAllDepartmentsBeginningWith(
  const TargetDepartmentId: Variant): TDepartments;
var
    Criteria: TAbstractRepositoryCriterion;
begin

  Criteria := TFindAllDepartmentsBeginningWithCriterion.Create(TargetDepartmentId);

  try

    Result := FindSpecifiedDepartmentsBeginningWith(TargetDepartmentId, Criteria);

  finally

    FreeAndNil(Criteria);

  end;

end;

function TPostgresBaseDepartmentRepository.FindSpecifiedDepartmentsBeginningWith(
  const TargetDepartmentId: Variant;
  const Criteria: TAbstractRepositoryCriterion
): TDepartments;
begin

  Result := TDepartments(FindDomainObjectsByCriteria(Criteria));

end;

function TPostgresBaseDepartmentRepository.FindHeadDepartmentForGivenDepartment(
  const DepartmentId: Variant): TDepartment;
var
    Criteria: TAbstractRepositoryCriterion;
    MoreThenOneDepartmentFoundException: Exception;
begin

  Criteria := TFindHeadDepartmentForGivenDepartmentCriterion.Create(DepartmentId);

  try

    MoreThenOneDepartmentFoundException :=
      TBaseDepartmentRepositoryException.Create(
        'Найдено более одного головного подразделения ' +
        'для затребованного'
      );

    Result :=
      FindSpecifiedTopLevelDepartmentForGivenDepartment(
        DepartmentId,
        Criteria,
        MoreThenOneDepartmentFoundException
      );

    MoreThenOneDepartmentFoundException.Free;

  finally

    FreeAndNil(Criteria);

  end;

end;

function TPostgresBaseDepartmentRepository
  .FindSpecifiedTopLevelDepartmentForGivenDepartment(
    const DepartmentId: Variant;
    const Criteria: TAbstractRepositoryCriterion;
    const MoreThanOneDepartmentFoundException: Exception
  ): TDepartment;
var
  Departments: TDepartments;
  FreeDepartments: IDomainObjectBaseList;
begin

  try

    Departments := TDepartments(FindDomainObjectsByCriteria(Criteria));

    FreeDepartments := Departments;

    if Departments.Count > 1 then begin

      if Assigned(MoreThanOneDepartmentFoundException) then
        Raise MoreThanOneDepartmentFoundException;

      Raise TBaseDepartmentRepositoryException.Create(
        'Найдено более одного вышестоящего подразделения ' +
        'для затребованного'
      );

    end

    else if Departments.Count = 1 then
      Result := TDepartment(Departments.First.Clone)

    else Result := nil;

  except

    on E: Exception do begin

      if not (E is TBaseDepartmentRepositoryException) then
        MoreThanOneDepartmentFoundException.Free;

      Raise;
      
    end;

  end;

end;

function TPostgresBaseDepartmentRepository.IsDepartmentIncludesOtherDepartment(
  const TargetDepartmentId, OtherDepartmentId: Variant): Boolean;
var
    DataReader: IDataReader;
    QueryPattern: String;
    QueryParams: TQueryParams;
begin

  FLastOperation := roSelectSingle;

  QueryParams := TQueryParams.Create;

  try

    try

      PrepareHeadDepartmentForGivenDepartmentSQLView(
        OtherDepartmentId, QueryPattern, QueryParams
      );

      with TBaseDepartmentTableDef(FTableDef) do begin

        QueryPattern :=
          Format(
            QueryPattern + #13#10 +
            'select ' + #13#10 +
            'exists (select 1 from department_branch where %s = :ptarget_%s) as result' + #13#10 +
            'from department_branch',
            [
              IdColumnName, IdColumnName
            ]
          );

        QueryParams.Add('ptarget_' + IdColumnName, TargetDepartmentId);

      end;

      DataReader :=
        SafeQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

      Result := DataReader['result'];

    except

      on E: Exception do begin

        SetLastErrorFromException(E);

        Result := False;

        if EnableThrowingExceptionsForDataManipulationErrors then
          ThrowExceptionIfHasDataManipulationError;

      end;

    end;

  finally

    FreeAndNil(QueryParams);

  end;

end;

{ TFindAllDepartmentsBeginningWithCriterion }

constructor TFindAllDepartmentsBeginningWithCriterion.Create(
  const TargetDepartmentId: Variant);
begin

  inherited Create;

  FTargetDepartmentId := TargetDepartmentId;
  
end;

{ TFindHeadDepartmentForGivenDepartmentCriterion }

constructor TFindHeadDepartmentForGivenDepartmentCriterion.Create(
  const TargetDepartmentId: Variant);
begin

  inherited Create;

  FTargetDepartmentId := TargetDepartmentId;

end;

end.
