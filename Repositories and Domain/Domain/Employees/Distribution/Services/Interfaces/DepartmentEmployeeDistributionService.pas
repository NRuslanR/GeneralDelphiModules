unit DepartmentEmployeeDistributionService;

interface

uses

  IGetSelfUnit,
  Employee;

type

  IDepartmentEmployeeDistributionService = interface (IGetSelf)

    function GetEmployeesThatBelongsToSameHeadKindredDepartmentAsTargetEmployee(
      Employees: TEmployees;
      TargetEmployee: TEmployee
    ): TEmployees;

  end;

implementation

end.
