unit StandardEmployeeDistributionService;

interface
uses

  Employee,
  DepartmentUnit,
  EmployeeDistributionService,
  EmployeeFinder,
  DepartmentFinder,
  SysUtils,
  Classes;

type

  { Refactor: возможно разбить на
    несколько предметных служб (или спецификации)
  }

  TStandardEmployeeDistributionService = class (
    TInterfacedObject, IEmployeeDistributionService
  )

    protected

      FEmployeeFinder: IEmployeeFinder;
      FDepartmentFinder: IDepartmentFinder;

    public

      constructor Create(
        EmployeeFinder: IEmployeeFinder;
        DepartmentFinder: IDepartmentFinder
      );

      function GetEmployeesThatBelongsToSameHeadKindredDepartmentAsTargetEmployee(
        Employees: TEmployees;
        TargetEmployee: TEmployee
      ): TEmployees; virtual;
      
      function AreEmployeesBelongsToSameHeadKindredDepartment(
        Employees: TEmployees
      ): Boolean; virtual;

      function AreEmployeesBelongsToSameDepartment(
        Employees: TEmployees
      ): Boolean; virtual;

      function IsEmployeeWorkspaceIncludesOtherEmployee(
        TargetEmployee: TEmployee;
        OtherEmployee: TEmployee
      ): Boolean; virtual;

      function IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
        TargetEmployee: TEmployee;
        OtherEmployees: TEmployees
      ): Boolean; virtual;

  end;

implementation

uses

  Variants,
  IDomainObjectUnit,
  IDomainObjectListUnit;
  
{ TStandardEmployeeDistributionService }

function TStandardEmployeeDistributionService.
  AreEmployeesBelongsToSameDepartment(
    Employees: TEmployees
  ): Boolean;
var Employee: TEmployee;
    PreviousDepartmentId: Variant;
begin

  PreviousDepartmentId := Null;

  for Employee in Employees do begin

    if VarIsNull(PreviousDepartmentId) then begin

      PreviousDepartmentId := Employee.DepartmentIdentity;
      
    end

    else if PreviousDepartmentId <> Employee.DepartmentIdentity then begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;

end;

function TStandardEmployeeDistributionService.
  AreEmployeesBelongsToSameHeadKindredDepartment(
    Employees: TEmployees
  ): Boolean;
var Employee: TEmployee;
    PreviousHeadKindredDepartmentId: Variant;
    HeadEmployeeDepartment: TDepartment;
    FreeDepartment: IDomainObject;
begin

  PreviousHeadKindredDepartmentId := Null;
  HeadEmployeeDepartment := nil;

  if AreEmployeesBelongsToSameDepartment(Employees) then begin

    Result := True;
    Exit;
    
  end;

  for Employee in Employees do begin

    HeadEmployeeDepartment :=
        FDepartmentFinder.
          FindHeadKindredDepartmentForInnerDepartment(
            Employee.DepartmentIdentity
          );
          
    if VarIsNull(PreviousHeadKindredDepartmentId) then begin

      PreviousHeadKindredDepartmentId := HeadEmployeeDepartment.Identity;

    end

    else if HeadEmployeeDepartment.Identity <> PreviousHeadKindredDepartmentId then
    begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;

end;

constructor TStandardEmployeeDistributionService.Create(
  EmployeeFinder: IEmployeeFinder;
  DepartmentFinder: IDepartmentFinder
);
begin

  inherited Create;

  FEmployeeFinder := EmployeeFinder;
  FDepartmentFinder := DepartmentFinder;
  
end;

function TStandardEmployeeDistributionService.
  GetEmployeesThatBelongsToSameHeadKindredDepartmentAsTargetEmployee(
    Employees: TEmployees;
    TargetEmployee: TEmployee
  ): TEmployees;
var Employee: TEmployee;
    HeadKindredDepartment: TDepartment;
    TargetEmployeeHeadKindredDepartment: TDepartment;
    TargetEmployeeHeadKindredDepartmentId: Variant;
begin

  if not Assigned(Employees) or Employees.IsEmpty then begin

    Result := nil;
    Exit;
    
  end;

  TargetEmployeeHeadKindredDepartment :=
    FDepartmentFinder.FindHeadKindredDepartmentForInnerDepartment(
      TargetEmployee.DepartmentIdentity
    );

  TargetEmployeeHeadKindredDepartmentId := TargetEmployeeHeadKindredDepartment.Identity;

  for Employee in Employees do begin

    if TargetEmployeeHeadKindredDepartmentId = Employee.DepartmentIdentity
    then begin

      if not Assigned(Result) then
        Result := TEmployees.Create;

      Result.AddDomainObject(Employee);

    end

    else begin

      HeadKindredDepartment :=
        FDepartmentFinder.FindHeadKindredDepartmentForInnerDepartment(
          Employee.DepartmentIdentity
        );

      if HeadKindredDepartment.Identity = TargetEmployeeHeadKindredDepartmentId
      then begin

        if not Assigned(Result) then
          Result := TEmployees.Create;
          
        Result.AddDomainObject(Employee);

      end;

    end;
    
  end;

end;

function TStandardEmployeeDistributionService.
  IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
    TargetEmployee: TEmployee;
    OtherEmployees: TEmployees
  ): Boolean;
var OtherEmployee: TEmployee;
begin

  for OtherEmployee in OtherEmployees do begin

    if IsEmployeeWorkspaceIncludesOtherEmployee(TargetEmployee, OtherEmployee)
    then begin

      Result := True;
      Exit;

    end;

  end;

  Result := False;
  
end;

function TStandardEmployeeDistributionService.
  IsEmployeeWorkspaceIncludesOtherEmployee(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
var TopLevelEmployees: TEmployees;
    FreeTopLevelEmployees: IDomainObjectList;
begin

  if TargetEmployee.IsOrdinaryEmployee then begin

    Result := False;
    Exit;
    
  end;

  if TargetEmployee.IsSameAs(OtherEmployee) then begin

    Result := True;
    Exit;

  end;

  TopLevelEmployees :=
    FEmployeeFinder.
      FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
        OtherEmployee.Identity
      );

  FreeTopLevelEmployees := TopLevelEmployees;

  if TargetEmployee.IsLeader then begin

    Result :=
        Assigned(TopLevelEmployees)
        and TopLevelEmployees.Contains(TargetEmployee);

  end

  else begin

    Result :=
      (
       TargetEmployee.IsSubLeaderForTopLevelEmployee
       or TargetEmployee.IsSecretaryForTopLevelEmployee
      )
      and (
        (
          Assigned(TopLevelEmployees)
          and TopLevelEmployees.Contains(TargetEmployee.TopLevelEmployee)
        )
        or TargetEmployee.TopLevelEmployee.IsSameAs(OtherEmployee)
      );

  end;

end;

end.
