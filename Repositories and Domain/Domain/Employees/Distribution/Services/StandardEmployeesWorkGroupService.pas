unit StandardEmployeesWorkGroupService;

interface

uses

  EmployeesWorkGroupService,
  EmployeesWorkGroup,
  EmployeesWorkGroupFinder,
  EmployeeFinder,
  Employee,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TStandardEmployeesWorkGroupService =
    class (TInterfacedObject, IEmployeesWorkGroupService)

      private

        FEmployeeFinder: IEmployeeFinder;
        FEmployeesWorkGroupFinder: IEmployeesWorkGroupFinder;

      public

        constructor Create(
          EmployeeFinder: IEmployeeFinder;
          EmployeesWorkGroupFinder: IEmployeesWorkGroupFinder
        );

        function FindLeadersOfEmployeesWorkGroups(const EmployeesWorkGroupIdentities: TVariantList): TEmployees; overload;
        function FindLeadersOfEmployeesWorkGroups(EmployeesWorkGroups: TEmployeesWorkGroups): TEmployees; overload;

    end;

implementation

uses

  IDomainObjectBaseListUnit;
  
{ TStandardEmployeesWorkGroupService }

constructor TStandardEmployeesWorkGroupService.Create(
  EmployeeFinder: IEmployeeFinder;
  EmployeesWorkGroupFinder: IEmployeesWorkGroupFinder
);
begin

  inherited Create;

  FEmployeeFinder := EmployeeFinder;
  FEmployeesWorkGroupFinder := EmployeesWorkGroupFinder;
  
end;

function TStandardEmployeesWorkGroupService.FindLeadersOfEmployeesWorkGroups(
  const EmployeesWorkGroupIdentities: TVariantList
): TEmployees;
var EmployeesWorkGroups: TEmployeesWorkGroups;
    FreeEmployeesWorkGroups: IDomainObjectBaseList;
begin

  EmployeesWorkGroups :=
    FEmployeesWorkGroupFinder.FindEmployeesWorkGroups(
      EmployeesWorkGroupIdentities
    );

  FreeEmployeesWorkGroups := EmployeesWorkGroups;

  Result := FindLeadersOfEmployeesWorkGroups(EmployeesWorkGroups);
    
end;

function TStandardEmployeesWorkGroupService.FindLeadersOfEmployeesWorkGroups(
  EmployeesWorkGroups: TEmployeesWorkGroups): TEmployees;
var WorkGroupLeaderIdentities: TVariantList;
    EmployeesWorkGroup: TEmployeesWorkGroup;
begin

  WorkGroupLeaderIdentities := TVariantList.Create;

  try

    for EmployeesWorkGroup in EmployeesWorkGroups do
      WorkGroupLeaderIdentities.Add(EmployeesWorkGroup.LeaderIdentity);

    Result :=
      FEmployeeFinder.FindEmployees(WorkGroupLeaderIdentities);

  finally

    FreeAndNil(WorkGroupLeaderIdentities);

  end;

end;

end.
