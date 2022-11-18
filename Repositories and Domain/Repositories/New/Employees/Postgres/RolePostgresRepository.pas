unit RolePostgresRepository;

interface

uses

  AbstractDBRepository,
  AbstractPostgresRepository,
  DBTableMapping,
  Classes,
  DomainObjectUnit,
  AbstractRepositoryCriteriaUnit,
  DomainObjectListUnit,
  Role,
  Employee,
  VariantListUnit,
  UnaryRepositoryCriterionUnit,
  TableMapping,
  TableColumnMappings,
  RoleRepository,
  QueryExecutor,
  DataReader,
  RoleTableDef,
  EmployeeRoleAssocTableDef,
  SysUtils;

const

  EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME =
    'p' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD;

  EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_PARAM_NAME =
    'p' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_FIELD;

  ADD_ROLE_FOR_EMPLOYEE_QUERY =
    'INSERT INTO doc.employees_roles (' +
    EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD+ ',' +
    EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_FIELD +
    ') values (:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME
    + ',:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_PARAM_NAME + ')';

  REMOVE_ROLE_FROM_EMPLOYEE_QUERY =

    'DELETE FROM ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME +
    ' WHERE ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD
    + '=:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME;

  REMOVE_ALL_ROLES_FROM_EMPLOYEE_QUERY =
    'DELETE FROM ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME +
    ' WHERE ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD
    + '=:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME;
    
type

  TRolePostgresRepository =
    class (TAbstractPostgresRepository, IRoleRepository)

      protected

        FEmployeeRoleAssocTableDef: TEmployeeRoleAssocTableDef;
        
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        procedure PrepareAddDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;
      
        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

      public

        constructor Create(
          RoleTableDef: TRoleTableDef;
          EmployeeRoleAssocTableDef: TEmployeeRoleAssocTableDef;
          QueryExecutor: IQueryExecutor
        );

        procedure AddRoleForEmployee(Employee: TEmployee);
        procedure RemoveAllRolesForEmployee(Employee: TEmployee);
        function FindRolesForEmployee(Employee: TEmployee): TRoleList;
        function FindRoleById(const Id: Variant): TRole;
        function FindRolesByIds(const Ids: TVariantList): TRoleList;
        function FindRoleByName(const RoleName: String): TRole;
        function LoadAllRoles: TRoleList;

    end;

implementation

uses

  IDomainObjectBaseListUnit,
  SQLAllMultiFieldsEqualityCriterion,
  AbstractRepository,
  AuxiliaryStringFunctions;

type

  TEmployeeOperationWrapper = class (TDomainObject)

    private

      FEmployee: TEmployee;

    public

      constructor Create(Employee: TEmployee);

      property Employee: TEmployee read FEmployee write FEmployee;
      
  end;

  TFindRolesForEmployeeCriterion = class (TSQLAllMultiFieldsEqualityCriterion)

    private

      FEmployee: TEmployee;

    public

      destructor Destroy; override;

      constructor Create(
        Employee: TEmployee;
        RolePostgresRepository: TRolePostgresRepository
      );

      property Employee: TEmployee read FEmployee write FEmployee;
      
  end;
  
{ TRolePostgresRepository }

constructor TRolePostgresRepository.Create(
  RoleTableDef: TRoleTableDef;
  EmployeeRoleAssocTableDef: TEmployeeRoleAssocTableDef;
  QueryExecutor: IQueryExecutor
);
begin

  inherited Create(RoleTableDef, QueryExecutor);

  FEmployeeRoleAssocTableDef := EmployeeRoleAssocTableDef;
  
end;

procedure TRolePostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  with TRoleTableDef(FTableDef) do begin

    TableMapping.SetTableNameMapping(TableName, TRole, TRoleList);

    TableMapping.AddColumnMappingForSelect(IdColumnName, TRole.IdentityPropName);
    TableMapping.AddColumnMappingForSelect(NameColumnName, TRole.NamePropName);
    TableMapping.AddColumnMappingForSelect(DescriptionColumnName, TRole.DescriptionPropName);

    TableMapping.AddPrimaryKeyColumnMapping(IdColumnName, TRole.IdentityPropName);

  end;

end;

procedure TRolePostgresRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var
    Employee: TEmployee;
begin

  if not (DomainObject is TEmployeeOperationWrapper) then begin

    inherited PrepareAddDomainObjectQuery(
      DomainObject, QueryPattern, QueryParams
    );

    Exit;

  end;

  Employee := TEmployeeOperationWrapper(DomainObject).Employee;

  with TEmployeeRoleAssocTableDef(FEmployeeRoleAssocTableDef) do begin

    QueryPattern :=
      Format(
        'INSERT INTO %s (%s,%s) VALUES (:p%s,:p%s)',
        [
          EmployeeIdColumnName,
          RoleIdColumnName
        ]
      );

    QueryParams := TQueryParams.Create;

    QueryParams
      .AddFluently(EmployeeIdColumnName, Employee.Identity)
      .AddFluently(RoleIdColumnName, Employee.Role.Identity);

  end;

end;

procedure TRolePostgresRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  if not (Criteria is TFindRolesForEmployeeCriterion) then begin

    inherited PrepareFindDomainObjectsByCriteria(Criteria, QueryPattern, QueryParams);

    Exit;

  end;

  QueryPattern :=
    Format(
      'SELECT ' +
      '%s ' +
      'FROM %s ' +
      'JOIN %s ON %s.%s=%s.%s' +
      'WHERE %s',
      [
        FDBTableMapping.GetSelectListForSelectGroup,
        FDBTableMapping.TableName,
        FEmployeeRoleAssocTableDef.TableName,
        FEmployeeRoleAssocTableDef.TableName,
        FEmployeeRoleAssocTableDef.RoleIdColumnName,
        FDBTableMapping.TableName,
        FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName,
        Criteria.Expression
      ]
    );

end;

procedure TRolePostgresRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var Employee: TEmployee;
begin

  if not (DomainObject is TEmployeeOperationWrapper) then begin

    inherited PrepareRemoveDomainObjectQuery(
      DomainObject, QueryPattern, QueryParams
    );

    Exit;

  end;

  Employee := TEmployeeOperationWrapper(DomainObject).Employee;

  with FEmployeeRoleAssocTableDef do begin

    QueryPattern :=
      Format(
        'DELETE FROM %s WHERE %s=:p%s',
        [
          TableName,
          EmployeeIdColumnName,
          EmployeeIdColumnName
        ]
      );

    QueryParams := TQueryParams.Create;

    QueryParams.Add(
      EmployeeIdColumnName,
      Employee.Identity
    );

  end;

end;

procedure TRolePostgresRepository.AddRoleForEmployee(Employee: TEmployee);
var
    EmployeeOperationWrapper: TEmployeeOperationWrapper;
begin

  EmployeeOperationWrapper := TEmployeeOperationWrapper.Create(Employee);

  try

    Add(EmployeeOperationWrapper);

  finally

    FreeAndNil(EmployeeOperationWrapper);
    
  end;

end;

procedure TRolePostgresRepository.RemoveAllRolesForEmployee(
  Employee: TEmployee
);
var
    EmployeeOperationWrapper: TEmployeeOperationWrapper;
begin

  EmployeeOperationWrapper := TEmployeeOperationWrapper.Create(Employee);

  try

    Remove(EmployeeOperationWrapper);

  finally

    FreeAndNil(EmployeeOperationWrapper);

  end;

end;

function TRolePostgresRepository.FindRolesForEmployee(
  Employee: TEmployee): TRoleList;
var
    Criteria: TFindRolesForEmployeeCriterion;
begin

  Criteria := TFindRolesForEmployeeCriterion.Create(Employee, Self);

  try

    Result := TRoleList(FindDomainObjectsByCriteria(Criteria));
    
  finally

    FreeAndNil(EmployeeOperationWrapper);

  end;

end;

function TRolePostgresRepository.FindRoleById(const Id: Variant): TRole;
begin

   Result := TRole(FindDomainObjectByIdentity(Id));
   
end;

function TRolePostgresRepository.FindRoleByName(const RoleName: String): TRole;
var
    FindRoleByNameCriterion: TAbstractRepositoryCriterion;
    
    DomainObjectList: TDomainObjectList;
    FreeDomainObjectList: IDomainObjectBaseList;
begin

  with TRoleTableDef(FTableDef) do begin
                                        
    FindRoleByNameCriterion :=
      TSQLAllMultiFieldsEqualityCriterion.Create(
        [NameColumnName],
        [RoleName]
      );

  end;

  try

    DomainObjectList := FindDomainObjectsByCriteria(FindRoleByNameCriterion);

    FreeDomainObjectList := DomainObjectList;

    if DomainObjectList.Count = 1 then
      Result := TRole(DomainObjectList.First.Clone)

    else if DomainObjectList.Count > 1 then begin

      Raise TRoleRepositoryException.CreateFmt(
        'Найдено более одной роли с именем "%s"',
        [RoleName]
      );
      
    end

    else Result := nil;

  finally

    FreeAndNil(FindRoleByNameCriterion);

  end;

end;

function TRolePostgresRepository.FindRolesByIds(const Ids: TVariantList): TRoleList;
begin

  Result := TRoleList(FindDomainObjectsByIdentities(Ids));

end;

function TRolePostgresRepository.LoadAllRoles: TRoleList;
begin

  Result := TRoleList(LoadAll);

end;

{ TFindRolesForEmployeeCriterion }

constructor TFindRolesForEmployeeCriterion.Create(
  Employee: TEmployee;
  RolePostgresRepository: TRolePostgresRepository
);
begin

  with RolePostgresRepository.FEmployeeRoleAssocTableDef do begin

    inherited Create(
      [EmployeeIdColumnName],
      [Employee.Identity]
    );

  end;

end;

end.
