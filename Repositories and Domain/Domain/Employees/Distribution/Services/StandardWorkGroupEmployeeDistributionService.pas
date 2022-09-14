unit StandardWorkGroupEmployeeDistributionService;

interface

uses

  WorkGroupEmployeeDistributionService,
  EmployeesWorkGroup,
  EmployeesWorkGroupFinder,
  AbstractDomainService,
  EmployeeFinder,
  Employee,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TStandardWorkGroupEmployeeDistributionService =
    class (TAbstractDomainService, IWorkGroupEmployeeDistributionService)

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
  
{ TStandardWorkGroupEmployeeDistributionService }

constructor TStandardWorkGroupEmployeeDistributionService.Create(
  EmployeeFinder: IEmployeeFinder;
  EmployeesWorkGroupFinder: IEmployeesWorkGroupFinder
);
begin

  inherited Create;

  FEmployeeFinder := EmployeeFinder;
  FEmployeesWorkGroupFinder := EmployeesWorkGroupFinder;
  
end;

function TStandardWorkGroupEmployeeDistributionService.FindLeadersOfEmployeesWorkGroups(
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

function TStandardWorkGroupEmployeeDistributionService.FindLeadersOfEmployeesWorkGroups(
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
