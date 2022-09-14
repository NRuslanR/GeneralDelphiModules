unit WorkGroupEmployeeDistributionService;

interface

uses

  IGetSelfUnit,
  EmployeesWorkGroup,
  Employee,
  VariantListUnit;

type

  IWorkGroupEmployeeDistributionService = interface (IGetSelf)

    function FindLeadersOfEmployeesWorkGroups(EmployeesWorkGroups: TEmployeesWorkGroups): TEmployees; overload;
    function FindLeadersOfEmployeesWorkGroups(const EmployeesWorkGroupIdentities: TVariantList): TEmployees; overload;
  
  end;
  
implementation

end.
