unit EmployeesWorkGroupMembershipSpecification;

interface

uses

  Employee;

type

  IEmployeesWorkGroupMembershipSpecification = interface

    function IsEmployeeAnyWorkGroupLeaderForOtherEmployee(
      SupposedWorkGroupLeader: TEmployee;
      WorkGroupMember: TEmployee
    ): Boolean;

  end;

implementation

end.
