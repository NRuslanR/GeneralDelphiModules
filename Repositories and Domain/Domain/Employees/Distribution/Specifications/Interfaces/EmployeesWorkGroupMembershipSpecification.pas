unit EmployeesWorkGroupMembershipSpecification;

interface

uses

  Employee;

type

  IEmployeesWorkGroupMembershipSpecification = interface
    ['{6625D5E2-3B4A-43DA-AA05-A01A013F2853}']
    
    function IsEmployeeAnyWorkGroupLeaderForOtherEmployee(
      SupposedWorkGroupLeader: TEmployee;
      WorkGroupMember: TEmployee
    ): Boolean;

  end;

implementation

end.
