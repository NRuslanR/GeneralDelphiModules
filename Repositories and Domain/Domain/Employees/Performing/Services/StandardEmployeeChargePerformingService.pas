unit StandardEmployeeChargePerformingService;

interface

uses

  EmployeeChargePerformingService,
  EmployeeChargePerformingUnit,
  EmployeeSubordinationService,
  EmployeeStaff,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeChargePerformingService =
    class (TInterfacedObject, IEmployeeChargePerformingService)

      protected

        FEmployeeSubordinationService: IEmployeeSubordinationService;
        
      public

        function FindChargePerformingUnitForEmployeeLeader(Employee: TEmployee): TEmployeeChargePerformingUnit; virtual;
        function FindSubordinateChargePerformingUnitForEmployee(Employee: TEmployee): TEmployeeChargePerformingUnit; virtual;

      public
      
        function FindKindredChargePerformingUnitForEmployeeLeader(Employee: TEmployee): TEmployeeChargePerformingUnit; virtual;
        function FindSubordinateKindredChargePerformingUnitForEmployee(Employee: TEmployee): TEmployeeChargePerformingUnit; virtual;
        
      public

        constructor Create(EmployeeSubordinationService: IEmployeeSubordinationService);
  
    end;
    
implementation

uses

  RoleUnit,
  VariantListUnit,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TStandardEmployeeChargePerformingService }

constructor TStandardEmployeeChargePerformingService.Create(
  EmployeeSubordinationService: IEmployeeSubordinationService);
begin

  inherited Create;

  FEmployeeSubordinationService := EmployeeSubordinationService;
  
end;

function TStandardEmployeeChargePerformingService.
  FindChargePerformingUnitForEmployeeLeader(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
var EmployeeStaffs: TEmployeeStaffs;
    FreeEmployeeStaffs: IDomainObjectBaseList;
    
    EmployeeStaff: TEmployeeStaff;
    FreeEmployeeStaff: IDomainObjectBase;
begin

  EmployeeStaffs := TEmployeeStaffs.Create;

  FreeEmployeeStaffs := EmployeeStaffs;
  
  EmployeeStaff := TEmployeeStaff.Create;

  FreeEmployeeStaff := EmployeeStaff;
  
  EmployeeStaff.EmployeeRoles.AddRole(TRoleMemento.GetLeaderRole);

  EmployeeStaffs.Add(EmployeeStaff);

  Result := TEmployeeChargePerformingUnit.Create;

  Result.PerformingStaffs := EmployeeStaffs;

end;

function TStandardEmployeeChargePerformingService.
  FindSubordinateChargePerformingUnitForEmployee(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
var PerformingStaffs: TEmployeeStaffs;
    FreePerformingStaffs: IDomainObjectBaseList;
begin

  PerformingStaffs :=
    FEmployeeSubordinationService.FindPerformingStaffsForEmployee(Employee);

  FreePerformingStaffs := PerformingStaffs;

  if not Assigned(PerformingStaffs) and
     not Employee.IsInAnyOfAssignedWorkGroups
  then
    Result := nil

  else begin

    Result :=
      TEmployeeChargePerformingUnit.Create(
        PerformingStaffs,
        Employee.WorkGroupIds.Clone
      );

  end;
  
end;

function TStandardEmployeeChargePerformingService.
  FindKindredChargePerformingUnitForEmployeeLeader(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
var KindredPerformingStaffs: TEmployeeStaffs;
    FreeKindredPerformingStaffs: IDomainObjectBaseList;
    
    KindredPerformingStaff: TEmployeeStaff;

    PerformingEmployeeRoleList: TRoleList;
    FreeRoleList: IDomainObjectBaseList;
begin

  KindredPerformingStaffs :=
    FEmployeeSubordinationService.
      FindKindredPerformingStaffsForEmployee(Employee);

  if Assigned(KindredPerformingStaffs)
  then begin

    FreeKindredPerformingStaffs := KindredPerformingStaffs;
    
    PerformingEmployeeRoleList := TRoleList.Create;

    FreeRoleList := PerformingEmployeeRoleList;

    PerformingEmployeeRoleList.AddRole(TRoleMemento.GetLeaderRole);

    for KindredPerformingStaff in KindredPerformingStaffs do
      KindredPerformingStaff.EmployeeRoles := PerformingEmployeeRoleList;

  end;

  if not Assigned(KindredPerformingStaffs) and
     not Employee.IsInAnyOfAssignedWorkGroups
  then
    Result := nil

  else begin

    Result :=
      TEmployeeChargePerformingUnit.Create(
        KindredPerformingStaffs,
        Employee.WorkGroupIds.Clone
      );
      
  end;
  
end;

function TStandardEmployeeChargePerformingService.
  FindSubordinateKindredChargePerformingUnitForEmployee(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
var PerformingStaffs: TEmployeeStaffs;
    FreePerformingStaffs: IDomainObjectBaseList;
begin

  PerformingStaffs :=
    FEmployeeSubordinationService.FindKindredPerformingStaffsForEmployee(
      Employee
    );

  FreePerformingStaffs := PerformingStaffs;
  
  if not Assigned(PerformingStaffs) and
     not Employee.IsInAnyOfAssignedWorkGroups
  then
    Result := nil

  else begin

    Result :=
      TEmployeeChargePerformingUnit.Create(
        PerformingStaffs,
        Employee.WorkGroupIds.Clone
      );
      
  end;

  
end;

end.
