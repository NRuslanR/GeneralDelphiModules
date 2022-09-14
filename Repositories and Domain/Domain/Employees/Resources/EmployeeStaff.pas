unit EmployeeStaff;

interface

uses

  RoleUnit,
  DomainObjectValueUnit,
  IDomainObjectListUnit,
  DomainObjectValueListUnit,
  VariantListUnit,
  DepartmentUnit,
  SysUtils,
  Classes;

type

  TEmployeeStaff = class (TDomainObjectValue)

    private
      
    protected

      FDepartmentIds: TVariantList;

      FEmployeeRoles: TRoleList;
      FFreeEmployeeRoles: IDomainObjectList;

      procedure SetEmployeeRoles(EmployeeRoles: TRoleList);
      procedure SetDepartmentIds(const Value: TVariantList);

      function CreateEmployeeRoleListFrom(
        AllowedEmployeeRoles: array of TRole
      ): TRoleList;

    public

      destructor Destroy; override;
      
      constructor Create; overload;

      constructor Create(
        const DepartmentIds: TVariantList;
        EmployeeRoles: TRoleList
      ); overload;

      constructor Create(
        DepartmentIds: array of Variant;
        EmployeeRoles: array of TRole
      ); overload;

      constructor Create(
        DepartmentIds: TVariantList;
        EmployeeRoles: array of TRole
      ); overload;

    published

      property DepartmentIds: TVariantList
      read FDepartmentIds write SetDepartmentIds;

      property EmployeeRoles: TRoleList
      read FEmployeeRoles write SetEmployeeRoles;

  end;

  TEmployeeStaffs = class;

  TEmployeeStaffsEnumerator = class (TDomainObjectValueListEnumerator)

    protected

      function GetCurrentEmployeeStaff: TEmployeeStaff;

    public

      constructor Create(EmployeeStaffs: TEmployeeStaffs);

      property Current: TEmployeeStaff read GetCurrentEmployeeStaff;

  end;
  
  TEmployeeStaffs = class (TDomainObjectValueList)

    private

    protected

      function GetEmployeeStaffByIndex(Index: Integer): TEmployeeStaff;
      
      procedure SetEmployeeStaffByIndex(
        Index: Integer;
        const Value: TEmployeeStaff
      );
      
    public

      procedure Add(EmployeeStaff: TEmployeeStaff);
      procedure AddMany(EmployeeStaffs: TEmployeeStaffs);
      
      function GetEnumerator: TEmployeeStaffsEnumerator;
      
      property Items[Index: Integer]: TEmployeeStaff
      read GetEmployeeStaffByIndex write SetEmployeeStaffByIndex;
      
  end;

implementation

{ TEmployeeStaff }

constructor TEmployeeStaff.Create;
begin

  inherited;

  Self.DepartmentIds := TVariantList.Create;
  Self.EmployeeRoles := TRoleList.Create;
                                 
end;

constructor TEmployeeStaff.Create(
   DepartmentIds: array of Variant;
   EmployeeRoles: array of TRole
);
begin

  inherited Create;

  Self.DepartmentIds := TVariantList.CreateFrom(DepartmentIds);
  Self.EmployeeRoles := CreateEmployeeRoleListFrom(EmployeeRoles);

  
end;

constructor TEmployeeStaff.Create(
  const DepartmentIds: TVariantList;
  EmployeeRoles: TRoleList
);
begin

  inherited Create;

  Self.DepartmentIds := DepartmentIds;
  Self.EmployeeRoles := EmployeeRoles;

end;

constructor TEmployeeStaff.Create(
  DepartmentIds: TVariantList;
  EmployeeRoles: array of TRole
);
begin

  inherited Create;

  Self.DepartmentIds := DepartmentIds;
  Self.EmployeeRoles := CreateEmployeeRoleListFrom(EmployeeRoles);

end;

function TEmployeeStaff.CreateEmployeeRoleListFrom(
  AllowedEmployeeRoles: array of TRole
): TRoleList;
var AllowedEmployeeRole: TRole;
begin

  Result := TRoleList.Create;

  for AllowedEmployeeRole in AllowedEmployeeRoles do
    Result.AddRole(AllowedEmployeeRole);

end;

destructor TEmployeeStaff.Destroy;
begin

  FreeAndNil(FDepartmentIds);
  inherited;

end;

procedure TEmployeeStaff.SetDepartmentIds(const Value: TVariantList);
begin

  FreeAndNil(FDepartmentIds);
  
  FDepartmentIds := Value;

end;

procedure TEmployeeStaff.SetEmployeeRoles(EmployeeRoles: TRoleList);
begin

  FEmployeeRoles := EmployeeRoles;
  FFreeEmployeeRoles := FEmployeeRoles;
  
end;

{ TEmployeeStaffs }

procedure TEmployeeStaffs.Add(EmployeeStaff: TEmployeeStaff);
begin

  inherited AddDomainObjectValue(EmployeeStaff);
  
end;

procedure TEmployeeStaffs.AddMany(EmployeeStaffs: TEmployeeStaffs);
var EmployeeStaff: TEmployeeStaff;
begin

  for EmployeeStaff in EmployeeStaffs do
    Add(EmployeeStaff);

end;

function TEmployeeStaffs.GetEmployeeStaffByIndex(
  Index: Integer): TEmployeeStaff;
begin

  Result := TEmployeeStaff(GetDomainObjectValueByIndex(Index));
  
end;

function TEmployeeStaffs.GetEnumerator: TEmployeeStaffsEnumerator;
begin

  Result := TEmployeeStaffsEnumerator.Create(Self);

end;

procedure TEmployeeStaffs.SetEmployeeStaffByIndex(Index: Integer;
  const Value: TEmployeeStaff);
begin

  SetDomainObjectValueByIndex(Index, Value);

end;

{ TEmployeeStaffsEnumerator }

constructor TEmployeeStaffsEnumerator.Create(EmployeeStaffs: TEmployeeStaffs);
begin

  inherited Create(EmployeeStaffs);
  
end;

function TEmployeeStaffsEnumerator.GetCurrentEmployeeStaff: TEmployeeStaff;
begin

  Result := GetCurrentDomainObjectValue as TEmployeeStaff;
  
end;

end.
