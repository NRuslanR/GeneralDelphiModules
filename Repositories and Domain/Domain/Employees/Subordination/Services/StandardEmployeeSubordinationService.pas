unit StandardEmployeeSubordinationService;

interface

uses

  EmployeeSubordinationService,
  WorkGroupEmployeeDistributionService,
  EmployeeFinder,
  Role,
  DepartmentFinder,
  Employee,
  DomainException,
  Department,
  EmployeeStaff,
  SysUtils,
  Classes;

type

  TStandardEmployeeSubordinationService =
    class (TInterfacedObject, IEmployeeSubordinationService)

      protected

        FEmployeeFinder: IEmployeeFinder;
        FDepartmentFinder: IDepartmentFinder;
        FWorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService;

        function GetLeadersFromEmployeeSet(Employees: TEmployees): TEmployees;

      protected

        function InternalFindKindredPerformingStaffsForEmployee(
          Employee: TEmployee;
          EmployeeHeadKindredDepartment: TDepartment
        ): TEmployeeStaffs; 
        
      public

        constructor Create(
          EmployeeFinder: IEmployeeFinder;
          DepartmentFinder: IDepartmentFinder;
          WorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService
        );

        function IsEmployeeDepartmentSubordinatedToOtherEmployeeDepartment(
          SubordinateDepartmentEmployee: TEmployee;
          TopLevelDepartmentEmployee: TEmployee
        ): Boolean; virtual;

        function FindHighestBusinessLeaderForEmployee(
          Employee: TEmployee
        ): TEmployee; virtual;

        function FindHighestSameHeadKindredDepartmentBusinessLeaderForEmployee(
          Employee: TEmployee
        ): TEmployee; virtual;
        
        function FindAllBusinessLeadersForEmployee(
          Employee: TEmployee
        ): TEmployees;

        function FindAllSameHeadKindredDepartmentBusinessLeadersForEmployee(
          Employee: TEmployee
        ): TEmployees;

        function FindSameHeadKindredDepartmentDirectBusinessLeaderForEmployee(
          Employee: TEmployee
        ): TEmployee;
        
        function FindPerformingStaffsForEmployee(
          Employee: TEmployee
        ): TEmployeeStaffs;

        function FindKindredPerformingStaffsForEmployee(
          Employee: TEmployee
        ): TEmployeeStaffs;

    end;
    
implementation

uses

  AuxDebugFunctionsUnit,
  IDomainObjectUnit,
  IDomainObjectValueListUnit,
  IDomainObjectListUnit;
  
{ TStandardEmployeeSubordinationService }

constructor TStandardEmployeeSubordinationService.Create(
  EmployeeFinder: IEmployeeFinder;
  DepartmentFinder: IDepartmentFinder;
  WorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService
);
begin

  inherited Create;

  FEmployeeFinder := EmployeeFinder;
  FDepartmentFinder := DepartmentFinder;
  FWorkGroupEmployeeDistributionService := WorkGroupEmployeeDistributionService;
  
end;

function TStandardEmployeeSubordinationService.
  FindAllBusinessLeadersForEmployee(
    Employee: TEmployee
  ): TEmployees;
var TopLevelEmployees: TEmployees;
    FreeEmployees: IDomainObjectList;

    WorkGroupLeaders: TEmployees;
    FreeWorkGroupLeaders: IDomainObjectList;

    LeadersFromEmployeesWorkGroups: TEmployees;
    FreeLeadersFromEmployeesWorkGroups: IDomainObjectList;

    BusinessLeaders: TEmployees;
begin

  if Employee.IsLeader or
     Employee.IsSubLeaderForTopLevelEmployee or
     Employee.IsSecretarySignerForTopLevelEmployee
  then begin

    TopLevelEmployees :=
      FEmployeeFinder.FindAllTopLevelEmployeesForEmployee(
        Employee.Identity
      );

    FreeEmployees := TopLevelEmployees;

    if not Assigned(TopLevelEmployees) then begin

      Result := TEmployees.Create;

      if Employee.IsLeader then
        Result.Add(Employee);

    end

    else begin

      Result := GetLeadersFromEmployeeSet(TopLevelEmployees);

      if Employee.IsLeader then
        Result.Prepend(Employee);

    end;

  end

  else begin

    Result :=
      FindAllSameHeadKindredDepartmentBusinessLeadersForEmployee(
        Employee
      );
        
  end;

  if Employee.IsInAnyOfAssignedWorkGroups then begin

    WorkGroupLeaders :=
      FWorkGroupEmployeeDistributionService.FindLeadersOfEmployeesWorkGroups(
        Employee.WorkGroupIds
      );

    FreeWorkGroupLeaders := WorkGroupLeaders;

    LeadersFromEmployeesWorkGroups :=
      GetLeadersFromEmployeeSet(WorkGroupLeaders);

    FreeLeadersFromEmployeesWorkGroups := LeadersFromEmployeesWorkGroups;

  end

  else begin

    WorkGroupLeaders := nil;
    LeadersFromEmployeesWorkGroups := nil;
    
  end;

  if not Assigned(Result) and
     not Assigned(LeadersFromEmployeesWorkGroups)
  then begin

    raise TEmployeeSubordinationServiceException.CreateFmt(
      'ƒл€ сотрудника "%s" не был найден ' +
      'ни один руководитель',
      [Employee.FullName]
    );
    
  end;

  if Assigned(Result) and
     Assigned(LeadersFromEmployeesWorkGroups)
  then
    Result.AppendMany(LeadersFromEmployeesWorkGroups)

  else if Assigned(LeadersFromEmployeesWorkGroups)
  then
    Result := LeadersFromEmployeesWorkGroups.Clone as TEmployees

end;

function TStandardEmployeeSubordinationService.
  FindAllSameHeadKindredDepartmentBusinessLeadersForEmployee(
    Employee: TEmployee
  ): TEmployees;
var SameHeadKindredDepartmentToplevelEmployees: TEmployees;
    FreeEmployees: IDomainObjectList;
begin

  SameHeadKindredDepartmentToplevelEmployees :=
    FEmployeeFinder.
      FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
        Employee.Identity
      );

  FreeEmployees := SameHeadKindredDepartmentToplevelEmployees;

  if not Assigned(SameHeadKindredDepartmentToplevelEmployees) then
    Result := nil

  else
    Result := GetLeadersFromEmployeeSet(SameHeadKindredDepartmentToplevelEmployees);

  if Employee.IsLeader then begin

    if not Assigned(Result) then
      Result := TEmployees.Create;

    Result.Prepend(Employee);

  end;

end;

function TStandardEmployeeSubordinationService.
  FindHighestBusinessLeaderForEmployee(
    Employee: TEmployee
  ): TEmployee;
var
    BusinessLeaders: TEmployees;
    FreeBusinessLeaders: IDomainObjectList;
begin

  BusinessLeaders := FindAllBusinessLeadersForEmployee(Employee);

  FreeBusinessLeaders := BusinessLeaders;

  if Assigned(BusinessLeaders) then
    Result := BusinessLeaders.Last.Clone as TEmployee

  else Result := nil;

end;

function TStandardEmployeeSubordinationService.
  FindHighestSameHeadKindredDepartmentBusinessLeaderForEmployee(
    Employee: TEmployee
  ): TEmployee;
var
    BusinessLeaders: TEmployees;
    Free: IDomainObjectList;
begin

  BusinessLeaders := FindAllSameHeadKindredDepartmentBusinessLeadersForEmployee(Employee);

  Free := BusinessLeaders;

  if Assigned(BusinessLeaders) and not BusinessLeaders.IsEmpty then
    Result := BusinessLeaders.Last.Clone as TEmployee

  else Result := nil;

end;

function TStandardEmployeeSubordinationService.
  FindKindredPerformingStaffsForEmployee(
    Employee: TEmployee
  ): TEmployeeStaffs;
var HeadKindredDepartment: TDepartment;
    FreeDepartment: IDomainObject;
begin

  HeadKindredDepartment :=
    FDepartmentFinder.
      FindHeadKindredDepartmentForInnerDepartment(
        Employee.DepartmentIdentity
      );

  FreeDepartment := HeadKindredDepartment;

  Result :=
    InternalFindKindredPerformingStaffsForEmployee(
      Employee, HeadKindredDepartment
    );

end;

function TStandardEmployeeSubordinationService.
  FindPerformingStaffsForEmployee(
    Employee: TEmployee
  ): TEmployeeStaffs;
var HeadKindredDepartment: TDepartment;
    FreeHeadKindredDepartment: IDomainObject;

    PerformingDepartments: TDepartments;
    FreeDepartments: IDomainObjectList;
    
    PerformingDepartment: TDepartment;

    EmployeeStaffsFromNotKindredDepartments: TEmployeeStaffs;
    FreeEmployeeStaffsFromNotKindredDepartments: IDomainObjectValueList;
begin

  HeadKindredDepartment :=
    FDepartmentFinder.FindHeadKindredDepartmentForInnerDepartment(
      Employee.DepartmentIdentity
    );

  FreeHeadKindredDepartment := HeadKindredDepartment;

  try

    Result := nil;
    
    if Employee.IsLeader or
       Employee.IsSubLeaderForTopLevelEmployee or
       Employee.IsSecretarySignerForTopLevelEmployee
    then begin

      PerformingDepartments :=
        FDepartmentFinder.FindAllNotKindredInnerDepartmentsForDepartment(
          HeadKindredDepartment.Identity
        );

      FreeDepartments := PerformingDepartments;

      EmployeeStaffsFromNotKindredDepartments :=
        TEmployeeStaffs.Create;

      FreeEmployeeStaffsFromNotKindredDepartments :=
        EmployeeStaffsFromNotKindredDepartments;

      EmployeeStaffsFromNotKindredDepartments.Add(
        TEmployeeStaff.Create(
          PerformingDepartments.CreateDomainObjectIdentityList,
          [
            TRole(TRoleMemento.GetLeaderRole.Clone),
            TRole(TRoleMemento.GetSubLeaderRole.Clone)
          ]
        )
      );

    end

    else begin

      EmployeeStaffsFromNotKindredDepartments := nil;

    end;
    
    Result :=
      InternalFindKindredPerformingStaffsForEmployee(
        Employee, HeadKindredDepartment
      );
    
    if Assigned(Result) and Assigned(EmployeeStaffsFromNotKindredDepartments) then
      Result.AddMany(EmployeeStaffsFromNotKindredDepartments);

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;

    end;

  end;

end;

function TStandardEmployeeSubordinationService.
  FindSameHeadKindredDepartmentDirectBusinessLeaderForEmployee(
    Employee: TEmployee
  ): TEmployee;
var SameHeadKindredDepartmentBusinessLeaders: TEmployees;
    FreeEmployees: IDomainObjectList;
begin

  SameHeadKindredDepartmentBusinessLeaders :=
    FindAllSameHeadKindredDepartmentBusinessLeadersForEmployee(Employee);

  FreeEmployees := SameHeadKindredDepartmentBusinessLeaders;

  if Assigned(SameHeadKindredDepartmentBusinessLeaders) then
    Result := SameHeadKindredDepartmentBusinessLeaders[0]

  else Result := nil;

end;

function TStandardEmployeeSubordinationService.GetLeadersFromEmployeeSet(
  Employees: TEmployees
): TEmployees;
var Employee: TEmployee;
begin

  Result := nil;

  try

    for Employee in Employees do begin

      if not Employee.IsLeader then Continue;

      if not Assigned(Result) then
        Result := TEmployees.Create;

      Result.Add(Employee);

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function TStandardEmployeeSubordinationService.
  InternalFindKindredPerformingStaffsForEmployee(
    Employee: TEmployee;
    EmployeeHeadKindredDepartment: TDepartment
  ): TEmployeeStaffs;
var TopDownKindredDepartmentHierarchy: TDepartments;
    FreeDepartments: IDomainObjectList;
begin

  TopDownKindredDepartmentHierarchy :=
    FDepartmentFinder.FindAllKindredDepartmentsBeginningWith(
      EmployeeHeadKindredDepartment.Identity
    );

  FreeDepartments := TopDownKindredDepartmentHierarchy;

  if not Assigned(TopDownKindredDepartmentHierarchy) then begin

    Result := nil;
    Exit;
    
  end;

  Result := TEmployeeStaffs.Create;

  try

    Result.Add(
      TEmployeeStaff.Create(
        TopDownKindredDepartmentHierarchy.CreateDomainObjectIdentityList,
        TRoleList(TRoleMemento.GetAllRoles.Clone)
      )
    );
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function TStandardEmployeeSubordinationService.
  IsEmployeeDepartmentSubordinatedToOtherEmployeeDepartment(
    SubordinateDepartmentEmployee,
    TopLevelDepartmentEmployee: TEmployee
  ): Boolean;
var TopDownDepartmentHierarchy: TDepartments;
    SubordinateDepartment: TDepartment;
begin

  TopDownDepartmentHierarchy :=
    FDepartmentFinder.FindAllDepartmentsBeginningWith(
      TopLevelDepartmentEmployee.DepartmentIdentity
    );

  try

    SubordinateDepartment :=
      TopDownDepartmentHierarchy.FindDepartmentByIdentity(
        SubordinateDepartmentEmployee.DepartmentIdentity
      );

    Result := Assigned(SubordinateDepartment);

  finally

    FreeAndNil(TopDownDepartmentHierarchy);

  end;

end;

end.
