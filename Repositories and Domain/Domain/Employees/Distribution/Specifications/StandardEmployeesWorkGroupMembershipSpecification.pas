unit StandardEmployeesWorkGroupMembershipSpecification;

interface

uses

  EmployeesWorkGroupMembershipSpecification,
  WorkGroupEmployeeDistributionService,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeesWorkGroupMembershipSpecification =
    class (TInterfacedObject, IEmployeesWorkGroupMembershipSpecification)

      protected

        FWorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService;

      public

        constructor Create(WorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService);

        function IsEmployeeAnyWorkGroupLeaderForOtherEmployee(
          SupposedWorkGroupLeader: TEmployee;
          WorkGroupMember: TEmployee
        ): Boolean;

    end;
  
implementation

uses

  IDomainObjectBaseListUnit;
  
{ TStandardEmployeesWorkGroupMembershipSpecification }

constructor TStandardEmployeesWorkGroupMembershipSpecification.Create(
  WorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService);
begin

  inherited Create;

  FWorkGroupEmployeeDistributionService := WorkGroupEmployeeDistributionService;

end;

function TStandardEmployeesWorkGroupMembershipSpecification.
  IsEmployeeAnyWorkGroupLeaderForOtherEmployee(
    SupposedWorkGroupLeader, WorkGroupMember: TEmployee
  ): Boolean;
var WorkGroupLeaders: TEmployees;
    FreeWorkGroupLeaders: IDomainObjectBaseList;
begin

  if not WorkGroupMember.IsInAnyOfAssignedWorkGroups then begin

    Result := False;
    Exit;
    
  end;

  WorkGroupLeaders := 
    FWorkGroupEmployeeDistributionService.FindLeadersOfEmployeesWorkGroups(
      WorkGroupMember.WorkGroupIds
    );

  FreeWorkGroupLeaders := WorkGroupLeaders;

  Result := WorkGroupLeaders.Contains(SupposedWorkGroupLeader);
  
end;

end.
