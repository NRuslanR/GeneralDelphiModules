unit StandardEmployeeIsLeaderForOtherSpecification;

interface

uses

  EmployeeIsLeaderForOtherSpecification,
  EmployeeSubordinationService,
  Employee,
  EmployeeFinder,
  SysUtils,
  Classes;

type

  TStandardEmployeeIsLeaderForOtherSpecification =
    class (TInterfacedObject, IEmployeeIsLeaderForOtherSpecification)

      protected

        FEmployeeSubordinationService: IEmployeeSubordinationService;
        
      public

        constructor Create(EmployeeSubordinationService: IEmployeeSubordinationService);
        
        function IsEmployeeLeaderForOtherEmployee(
          SuggestedLeader: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean; virtual;

        function IsEmployeeSameHeadKindredDepartmentDirectLeaderForOtherEmployee(
          SuggestedDirectLeader: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean; virtual;

    end;
    
implementation

uses

  IDomainObjectListUnit;

{ TStandardEmployeeIsLeaderForOtherSpecification }

constructor TStandardEmployeeIsLeaderForOtherSpecification.Create(
  EmployeeSubordinationService: IEmployeeSubordinationService
);
begin

  inherited Create;

  FEmployeeSubordinationService := EmployeeSubordinationService;

end;

function TStandardEmployeeIsLeaderForOtherSpecification.
  IsEmployeeLeaderForOtherEmployee(
    SuggestedLeader, OtherEmployee: TEmployee
  ): Boolean;
var BusinessLeaders: TEmployees;
    FreeEmployees: IDomainObjectList;
begin

  BusinessLeaders :=
    FEmployeeSubordinationService.FindAllBusinessLeadersForEmployee(
      OtherEmployee
    );

  FreeEmployees := BusinessLeaders;

  Result := BusinessLeaders.Contains(SuggestedLeader);

end;

function TStandardEmployeeIsLeaderForOtherSpecification.
  IsEmployeeSameHeadKindredDepartmentDirectLeaderForOtherEmployee(
    SuggestedDirectLeader, OtherEmployee: TEmployee
  ): Boolean;
var BusinessLeaders: TEmployees;
    FreeEmployees: IDomainObjectList;
begin

  BusinessLeaders :=
    FEmployeeSubordinationService.
      FindAllSameHeadKindredDepartmentBusinessLeadersForEmployee(
        OtherEmployee
      );

  FreeEmployees := BusinessLeaders;

  Result := BusinessLeaders.Contains(SuggestedDirectLeader);
  

end;

end.
