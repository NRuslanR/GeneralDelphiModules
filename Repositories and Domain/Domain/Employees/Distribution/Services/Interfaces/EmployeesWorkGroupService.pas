unit EmployeesWorkGroupService;

interface

uses

  EmployeesWorkGroup,
  Employee,
  VariantListUnit;

type

  IEmployeesWorkGroupService = interface

    function FindLeadersOfEmployeesWorkGroups(EmployeesWorkGroups: TEmployeesWorkGroups): TEmployees; overload;
    function FindLeadersOfEmployeesWorkGroups(const EmployeesWorkGroupIdentities: TVariantList): TEmployees; overload;
  
  end;
  
implementation

end.
