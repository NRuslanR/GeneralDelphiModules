unit EmployeeDistributionService;

interface

uses

  Employee;

type

  { Refactor: ����������� �����������
    ��������� ������� ���������� �� ���������
    "�����������-������������"
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
