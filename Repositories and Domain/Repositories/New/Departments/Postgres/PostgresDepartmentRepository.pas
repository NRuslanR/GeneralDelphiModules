unit PostgresDepartmentRepository;

interface

uses

  AbstractRepositoryCriteriaUnit,
  AbstractDBRepository,
  AbstractRepository,
  AbstractPostgresRepository,
  DBTableMapping,
  DomainObjectUnit,
  DomainObjectListUnit,
  DepartmentRepository,
  DepartmentTableDef,
  QueryExecutor,
  DataReader,
  PostgresBaseDepartmentRepository,
  Department,
  Classes,
  SysUtils;

type

  TPostgresDepartmentRepository =
    class (
      TPostgresBaseDepartmentRepository,
      IDepartmentRepository
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

        procedure PrepareFindAllKindredDepartmentsBeginningWithQuery(
          const StartDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareFindHeadKindredDepartmentForGivenDepartmentQuery(
          const DepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareFindAllNotKindredInnerDepartmentsForDepartmentQuery(
          const DepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );
      
      public

        constructor Create(
          DepartmentTableDef: TDepartmentTableDef;
          QueryExecutor: IQueryExecutor
        );
        
        function FindHeadKindredDepartmentForGivenDepartment(
          const DepartmentId: Variant
        ): TDepartment;

        function FindAllKindredDepartmentsBeginningWith(
          const TargetDepartmentId: Variant
        ): TDepartments;

        function FindAllNotKindredInnerDepartmentsForDepartment(
          const TargetDepartmentId: Variant
        ): TDepartments;

    end;

implementation

uses

  DB,
  Variants,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;

type
  
  TFindHeadKindredDepartmentForGivenDepartmentCriterion =
    class (TFindHeadDepartmentForGivenDepartmentCriterion)

    end;

    TFindAllKindredDepartmentsBeginningWithCriterion =
      class (TFindAllDepartmentsBeginningWithCriterion)

      end;

    TFindAllNotKindredInnerDepartmentsForDepartmentCriterion =
      class (TFindAllDepartmentsBeginningWithCriterion)

      end;

{ TPostgresDepartmentRepository }

procedure TPostgresDepartmentRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  if Criteria is TFindAllKindredDepartmentsBeginningWithCriterion
  then begin

    PrepareFindAllKindredDepartmentsBeginningWithQuery(
      TFindAllKindredDepartmentsBeginningWithCriterion(Criteria).TargetDepartmentId,
      QueryPattern,
      QueryParams
    );

  end

  else if Criteria is TFindHeadKindredDepartmentForGivenDepartmentCriterion then
  begin

    PrepareFindHeadKindredDepartmentForGivenDepartmentQuery(
      TFindHeadKindredDepartmentForGivenDepartmentCriterion(Criteria).TargetDepartmentId,
      QueryPattern,
      QueryParams
    );
    
  end

  else if Criteria is TFindAllNotKindredInnerDepartmentsForDepartmentCriterion
  then begin

    PrepareFindAllNotKindredInnerDepartmentsForDepartmentQuery(
      TFindAllNotKindredInnerDepartmentsForDepartmentCriterion(Criteria).TargetDepartmentId,
      QueryPattern,
      QueryParams
    );
    
  end
       
  else begin

    inherited PrepareFindDomainObjectsByCriteria(Criteria, QueryPattern, QueryParams);

  end;
  
end;

procedure TPostgresDepartmentRepository.
  PrepareFindAllKindredDepartmentsBeginningWithQuery(
    const StartDepartmentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
begin

  with TDepartmentTableDef(FTableDef) do begin

    PrepareAllSpecifiedDepartmentsBeginningWithFindingQuery(
      StartDepartmentId,
      QueryPattern,
      QueryParams,
      'department_tree',
      Format(
        '%s',
        [
          IsTopLevelDepartmentKindredColumnName
        ]
      )
    );

  end;

end;

procedure TPostgresDepartmentRepository.PrepareFindHeadKindredDepartmentForGivenDepartmentQuery(
  const DepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  with TDepartmentTableDef(FTableDef) do begin

    PrepareSpecifiedTopLevelDepartmentForGivenDepartmentFindingQuery(
      DepartmentId,
      QueryPattern,
      QueryParams,
      Format(
        '%s',
        [
          IsTopLevelDepartmentKindredColumnName
        ]
      )
    );

  end;

end;

procedure TPostgresDepartmentRepository.PrepareFindAllNotKindredInnerDepartmentsForDepartmentQuery(
  const DepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  PrepareAllSpecifiedDepartmentsBeginningWithFindingQuery(
    DepartmentId, QueryPattern, QueryParams, 'department_tree'
  );

  
  with TDepartmentTableDef(FTableDef) do begin

    QueryPattern :=
      Format(
        '%s,' + #13#10 +
        'kindred_department_tree(%s, level) as (' + #13#10 +
          'select' + #13#10 +
          '*' + #13#10 +
          'from department_tree' + #13#10 +
          'where not %s and %s <> :p%s' + #13#10 +
          '' + #13#10 +
          'union' + #13#10 +
          '' + #13#10 +
          'select' + #13#10 +
          '%s,' + #13#10 +
          'b.level + 1' + #13#10 +
          'from %s a' + #13#10 +
          'join kindred_department_tree b on a.%s = b.%s' + #13#10 +
          'where a.%s' + #13#10 +
        ')' + #13#10 +
        'select * from kindred_department_tree order by level',
        [
          QueryPattern,

          TableMapping.GetSelectColumnNameListWithoutTablePrefix,

          IsTopLevelDepartmentKindredColumnName,
          IdColumnName, IdColumnName,

          TableMapping.GetSelectListForSelectGroup('a'),
          GetTableNameFromTableMappingForSelect,
          TopLevelDepartmentIdColumnName, IdColumnName,
          IsTopLevelDepartmentKindredColumnName
        ]
      );

  end;

end;

constructor TPostgresDepartmentRepository.Create(
  DepartmentTableDef: TDepartmentTableDef; QueryExecutor: IQueryExecutor);
begin

  inherited Create(DepartmentTableDef, QueryExecutor);
  
end;

procedure TPostgresDepartmentRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited CustomizeTableMapping(TableMapping);

  with TableMapping, TDepartmentTableDef(FTableDef) do begin

    AddColumnNameForSelect(IsTopLevelDepartmentKindredColumnName);

  end;

end;

function TPostgresDepartmentRepository.FindAllKindredDepartmentsBeginningWith(
  const TargetDepartmentId: Variant
): TDepartments;
var Criteria: TFindAllKindredDepartmentsBeginningWithCriterion;
    DomainObjectList: TDomainObjectList;
begin

  Criteria :=
    TFindAllKindredDepartmentsBeginningWithCriterion.Create(TargetDepartmentId);

  try

    Result := FindSpecifiedDepartmentsBeginningWith(TargetDepartmentId, Criteria);
      
  finally

    FreeAndNil(Criteria);
    
  end;

end;

function TPostgresDepartmentRepository.
  FindAllNotKindredInnerDepartmentsForDepartment(
    const TargetDepartmentId: Variant
  ): TDepartments;
var
    Criteria: TFindAllNotKindredInnerDepartmentsForDepartmentCriterion;
    DomainObjectList: TDomainObjectList;
begin

  Criteria :=
    TFindAllNotKindredInnerDepartmentsForDepartmentCriterion.Create(
      TargetDepartmentId
    );

  try

    Result := FindSpecifiedDepartmentsBeginningWith(TargetDepartmentId, Criteria);
      
  finally

    FreeAndNil(Criteria);
    
  end;

end;

function TPostgresDepartmentRepository
  .FindHeadKindredDepartmentForGivenDepartment(
    const DepartmentId: Variant
  ): TDepartment;

var
    Criteria: TFindHeadKindredDepartmentForGivenDepartmentCriterion;
    MoreThanOneDepartmentException: Exception;
begin

  Criteria :=
    TFindHeadKindredDepartmentForGivenDepartmentCriterion.Create(DepartmentId);

  try

    MoreThanOneDepartmentException :=
      TDepartmentRepositoryException.Create(
        'Для подразделения было ' +
        'найдено несколько головных ' +
        'подразделений'
      );

    Result :=
      FindSpecifiedTopLevelDepartmentForGivenDepartment(
        DepartmentId,
        Criteria
        );

    MoreThanOneDepartmentException.Free;

  finally

    FreeAndNil(Criteria);

  end;
  
end;

end.
