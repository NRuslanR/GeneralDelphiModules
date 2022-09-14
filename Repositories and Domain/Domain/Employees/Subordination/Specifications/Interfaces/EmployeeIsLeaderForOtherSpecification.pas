unit EmployeeIsLeaderForOtherSpecification;

interface

uses

  Employee,
  SysUtils,
  Classes;

type

  IEmployeeIsLeaderForOtherSpecification = interface
    ['{49528A66-5A5D-4104-A68B-AA96F12DBBFF}']

    function IsEmployeeLeaderForOtherEmployee(
      SuggestedLeader: TEmployee;
      OtherEmployee: TEmployee
    ): Boolean;

    function IsEmployeeSameHeadKindredDepartmentDirectLeaderForOtherEmployee(
      SuggestedDirectLeader: TEmployee;
      OtherEmployee: TEmployee
    ): Boolean;

  end;
  
implementation

end.
