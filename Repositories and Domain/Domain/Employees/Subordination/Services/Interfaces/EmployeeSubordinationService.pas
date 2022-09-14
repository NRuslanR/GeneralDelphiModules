unit EmployeeSubordinationService;

interface

uses

  Employee,
  DomainException,
  EmployeeStaff;

type

  TEmployeeSubordinationServiceException = class (TDomainException)


  end;
  
  IEmployeeSubordinationService = interface

    function IsEmployeeDepartmentSubordinatedToOtherEmployeeDepartment(
      SubordinateDepartmentEmployee: TEmployee;
      TopLevelDepartmentEmployee: TEmployee
    ): Boolean;

    function FindHighestBusinessLeaderForEmployee(
      Employee: TEmployee
    ): TEmployee;

    function FindHighestSameHeadKindredDepartmentBusinessLeaderForEmployee(
      Employee: TEmployee
    ): TEmployee;

    function FindAllBusinessLeadersForEmployee(
      Employee: TEmployee
    ): TEmployees;

    function FindPerformingStaffsForEmployee(
      Employee: TEmployee
    ): TEmployeeStaffs;

    function FindKindredPerformingStaffsForEmployee(
      Employee: TEmployee
    ): TEmployeeStaffs;

    function FindAllSameHeadKindredDepartmentBusinessLeadersForEmployee(
      Employee: TEmployee
    ): TEmployees;

    function FindSameHeadKindredDepartmentDirectBusinessLeaderForEmployee(
      Employee: TEmployee
    ): TEmployee;
    
  end;
  
implementation

end.
