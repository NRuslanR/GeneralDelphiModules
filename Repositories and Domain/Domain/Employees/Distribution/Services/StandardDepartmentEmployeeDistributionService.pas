unit StandardDepartmentEmployeeDistributionService;

interface
uses

  Employee,
  DepartmentUnit,
  DepartmentEmployeeDistributionService,
  DepartmentFinder,
  AbstractDomainService,
  SysUtils,
  Classes;

type

  TStandardDepartmentEmployeeDistributionService = class (
    TAbstractDomainService, IDepartmentEmployeeDistributionService
  )

    protected

      FDepartmentFinder: IDepartmentFinder;

    public

      constructor Create(
        DepartmentFinder: IDepartmentFinder
      );

      function GetEmployeesThatBelongsToSameHeadKindredDepartmentAsTargetEmployee(
        Employees: TEmployees;
        TargetEmployee: TEmployee
      ): TEmployees; virtual;

  end;

implementation

uses

  Variants,
  IDomainObjectUnit,
  IDomainObjectListUnit;
  
{ TStandardDepartmentEmployeeDistributionService }

constructor TStandardDepartmentEmployeeDistributionService.Create(
  DepartmentFinder: IDepartmentFinder
);
begin

  inherited Create;

  FDepartmentFinder := DepartmentFinder;
  
end;

function TStandardDepartmentEmployeeDistributionService.
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

end.
