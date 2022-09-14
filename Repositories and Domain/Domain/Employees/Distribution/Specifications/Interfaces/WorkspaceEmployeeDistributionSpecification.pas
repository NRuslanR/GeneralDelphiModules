unit WorkspaceEmployeeDistributionSpecification;

interface

uses

  Employee;

type

  IWorkspaceEmployeeDistributionSpecification = interface
    ['{1DDA82D3-3107-4374-9EB3-9C010DC33372}']

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
