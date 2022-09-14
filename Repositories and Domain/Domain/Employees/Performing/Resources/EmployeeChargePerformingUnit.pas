unit EmployeeChargePerformingUnit;

interface

uses

  DomainObjectValueUnit,
  EmployeeStaff,
  VariantListUnit,
  IDomainObjectBaseListUnit,
  SysUtils,
  Classes;

type

  TEmployeeChargePerformingUnit = class (TDomainObjectValue)

    private

      FPerformingStaffs: TEmployeeStaffs;
      FFreePerformingStaffs: IDomainObjectBaseList;
      FEmployeeWorkGroupIds: TVariantList;

      procedure SetPerformingStaffs(const Value: TEmployeeStaffs);
      procedure SetEmployeeWorkGroupIds(const Value: TVariantList);

    public

      destructor Destroy; override;

      constructor Create; overload;
      
      constructor Create(
        PerformingStaffs: TEmployeeStaffs;
        EmployeeWorkGroupIds: TVariantList
      ); overload;
      
    public

      property PerformingStaffs: TEmployeeStaffs
      read FPerformingStaffs write SetPerformingStaffs;

      property EmployeeWorkGroupIds: TVariantList
      read FEmployeeWorkGroupIds write SetEmployeeWorkGroupIds;
    
  end;

implementation

{ TEmployeeChargePerformingUnit }

constructor TEmployeeChargePerformingUnit.Create;
begin

  inherited;

  FEmployeeWorkGroupIds := TVariantList.Create;
  
end;

constructor TEmployeeChargePerformingUnit.Create(
  PerformingStaffs: TEmployeeStaffs; EmployeeWorkGroupIds: TVariantList);
begin

  inherited Create;

  Self.PerformingStaffs := PerformingStaffs;
  Self.EmployeeWorkGroupIds := EmployeeWorkGroupIds;
  
end;

destructor TEmployeeChargePerformingUnit.Destroy;
begin

  FreeAndNil(FEmployeeWorkGroupIds);
  
  inherited;

end;

procedure TEmployeeChargePerformingUnit.SetPerformingStaffs(
  const Value: TEmployeeStaffs);
begin

  FPerformingStaffs := Value;

  FFreePerformingStaffs := FPerformingStaffs;

end;

procedure TEmployeeChargePerformingUnit.SetEmployeeWorkGroupIds(
  const Value: TVariantList);
begin

  FreeAndNil(FEmployeeWorkGroupIds);
  
  FEmployeeWorkGroupIds := Value;

end;

end.
