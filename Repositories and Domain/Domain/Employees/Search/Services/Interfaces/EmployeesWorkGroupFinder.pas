unit EmployeesWorkGroupFinder;

interface

uses

  EmployeesWorkGroup,
  VariantListUnit;

type

  IEmployeesWorkGroupFinder = interface

    function FindEmployeesWorkGroup(const Identity: Variant): TEmployeesWorkGroup;
    function FindEmployeesWorkGroups(const Identities: TVariantList): TEmployeesWorkGroups;

  end;
  
implementation

end.
