unit EmployeeDistributionService;

interface

uses

  Employee;

type

  { Refactor: рассмотреть возможность
    разбиения данного интерфейса на несколько
    "интерфейсов-спецификаций"
  }
  IEmployeeDistributionService = interface

    function GetEmployeesThatBelongsToSameHeadKindredDepartmentAsTargetEmployee(
      Employees: TEmployees;
      TargetEmployee: TEmployee
    ): TEmployees;
    
    function AreEmployeesBelongsToSameHeadKindredDepartment(
      Employees: TEmployees
    ): Boolean;

    function AreEmployeesBelongsToSameDepartment(
      Employees: TEmployees
    ): Boolean;

    function IsEmployeeWorkspaceIncludesOtherEmployee(
      TargetEmployee: TEmployee;
      OtherEmployee: TEmployee
    ): Boolean;

    function IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
      TargetEmployee: TEmployee;
      OtherEmployees: TEmployees
    ): Boolean;


  end;

implementation

end.
