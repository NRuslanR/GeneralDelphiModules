unit Employee;

interface

uses

  DomainException,
  DomainObjectUnit,
  DomainObjectValueUnit,
  DomainObjectListUnit,
  IDomainObjectBaseUnit,
  Role,
  TimeFrame,
  SysUtils,
  Classes,
  VariantListUnit,
  Variants;

type

  TEmployee = class;
  TEmployeeReplacements = class;

  TEmployeeException = class (TDomainException)

  end;
  
  TEmployeeReplacement = class (TDomainObject)

    private

      FReplaceableEmployeeId: Variant;
      FDeputyId: Variant;
      FPeriod: TTimeFrame;

      function GetReplaceableEmployeeId: Variant;
      function GetDeputyId: Variant;
      function GetPeriodStart: Variant;
      function GetIsPermanent: Boolean;
      function GetPeriodEnd: Variant;

      procedure SetReplaceableEmployeeId(const Value: Variant);
      procedure SetDeputyId(const Value: Variant);
      procedure SetPeriodStart(const Value: Variant);
      procedure SetIsPermanent(const Value: Boolean);
      procedure SetPeriodEnd(const Value: Variant);

      function GetIsPeriodExpiring: Boolean;
      function GetIsPeriodExpired: Boolean;

      procedure CreatePeriodObject(
        const PeriodStart: TDateTime = 0;
        const PeriodEnd: TDateTime = 0
      );

      procedure CustomizeBy(
        const ReplaceableEmployeeId: Variant;
        const DeputyId: Variant;
        const IsPermanent: Boolean = True;
        const PeriodStart: TDateTime = 0;
        const PeriodEnd: TDateTime = 0
      );
        
    public

      destructor Destroy; override;
      
      constructor Create; overload; override;

      constructor Create(
        const ReplaceableEmployeeId: Variant;
        const DeputyId: Variant;
        const PeriodStart, PeriodEnd: TDateTime
      ); overload;

      constructor CreateAsPermanent(
        const ReplaceableEmployeeId: Variant;
        const DeputyId: Variant
      );

      function InternalClone: TObject; override;

      procedure SetInvariantsComplianceRequested(
        const Value: Boolean
      ); override;

    published

      property ReplaceableEmployeeId: Variant
      read GetReplaceableEmployeeId write SetReplaceableEmployeeId;

      property DeputyId: Variant
      read GetDeputyId write SetDeputyId;

      property PeriodStart: Variant
      read GetPeriodStart write SetPeriodStart;

      property PeriodEnd: Variant
      read GetPeriodEnd write SetPeriodEnd;

      property IsPermanent: Boolean
      read GetIsPermanent write SetIsPermanent;

      property IsPeriodExpired: Boolean read GetIsPeriodExpired;
      property IsPeriodExpiring: Boolean read GetIsPeriodExpiring;

  end;

  TEmployeeReplacementsEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentEmployeeReplacement: TEmployeeReplacement;

    public

      constructor Create(EmployeeReplacements: TEmployeeReplacements);

      property Current: TEmployeeReplacement
      read GetCurrentEmployeeReplacement;
      
  end;

  TEmployeeReplacements = class (TDomainObjectList)

    private

      function GetEmployeeReplacementByIndex(Index: Integer): TEmployeeReplacement;
      procedure SetEmployeeReplacementByIndex(
        Index: Integer;
        EmployeeReplacement: TEmployeeReplacement
      );

      function FindReplacementBy(
        const ReplaceableEmployeeId: Variant;
        const DeputyId: Variant
      ): TEmployeeReplacement;

      function IsReplacementFor(
        Replacement: TEmployeeReplacement;
        const ReplaceableEmployeeId, DeputyId: Variant
      ): Boolean;

    public

      procedure AddTemporaryReplacement(
        ReplaceableEmployee: TEmployee;
        Deputy: TEmployee;
        const PeriodStart, PeriodEnd: TDateTime
      );

      procedure AddPermanentReplacement(
        Employee: TEmployee;
        Deputy: TEmployee
      );

      procedure RemoveReplacementForEmployee(
        Employee: TEmployee;
        Deputy: TEmployee
      );

      function GetEnumerator: TEmployeeReplacementsEnumerator;

      function IsReplacementExistsForEmployee(
        Employee: TEmployee;
        Deputy: TEmployee
      ): Boolean;

      function FindReplacementForEmployee(
        Employee: TEmployee;
        Deputy: TEmployee
      ): TEmployeeReplacement;

      property Items[Index: Integer]: TEmployeeReplacement
      read GetEmployeeReplacementByIndex
      write SetEmployeeReplacementByIndex; default;
    
  end;
  
  TEmployeeContactInfo = class (TDomainObjectValue)

    private

      FEmail: String;
      FTelephoneNumber: String;

    public

      destructor Destroy; override;
      
      constructor Create; overload;
      constructor Create(const Email: String); overload;

    public

      class function EmailPropName: String; static;
      class function TelephoneNumberPropName: String; static;

    published

      property Email: String read FEmail write FEmail;
      property TelephoneNumber: String read FTelephoneNumber write FTelephoneNumber;
      
  end;

  TEmployee = class (TDomainObject)

    private

      FreeRole: IDomainObjectBase;
      FreeTopLevelEmployee: IDomainObjectBase;
      
      FName: String;
      FSurname: String;
      FPatronymic: String;
      FSpeciality: String;
      FPersonnelNumber: String;
      FDepartmentIdentity: Variant;
      FTopLevelEmployee: TEmployee;
      FIsForeign: Boolean;
      FIsDismissed: Boolean;
      FLegacyIdentity: Variant;

      FContactInfo: TEmployeeContactInfo;
      FEmployeeReplacements: TEmployeeReplacements;

      FWorkGroupIds: TVariantList;
      
      FRole: TRole;

      function GetName: String;
      function GetPatronymic: String;
      function GetPersonnelNumber: String;
      function GetSpeciality: String;
      function GetSurname: String;
      function GetTelephoneNumber: String;
      function GetRole: TRole;
      function GetDepartmentIdentity: Variant;
      function GetTopLevelEmployee: TEmployee;
      function GetFullName: String;
      function GetEmail: String;
      function GetIsForeign: Boolean;
      function GetIsDismissed: Boolean;
      function GetLegacyIdentity: Variant;
      
      procedure SetIdentity(Identity: Variant); override;
      
      procedure SetName(const Value: String);
      procedure SetPatronymic(const Value: String);
      procedure SetPersonnelNumber(const Value: String);
      procedure SetSpeciality(const Value: String);
      procedure SetSurname(const Value: String);
      procedure SetTelephoneNumber(const Value: String);
      procedure SetRole(const Value: TRole);
      procedure SetDepartmentIdentity(const Value: Variant);
      procedure SetTopLevelEmployee(const Value: TEmployee);
      procedure SetEmail(const Value: String);
      procedure SetIsForeign(const Value: Boolean);
      procedure SetIsDismissed(const Value: Boolean);
      procedure SetWorkGroupIds(const Value: TVariantList);
      procedure SetLegacyIdentity(const Value: Variant);

      procedure SetEmployeeReplacements(
        Value: TEmployeeReplacements
      );
      
      procedure CreateContactInfoObject;
      procedure CreateEmployeeReplacementsObject;

      procedure Customize;

      procedure ChangeReplaceableEmployeeIdForAllReplacements(
        const NewReplaceableEmployeeId: Variant
      );

      function IsDepartmentSameAs(
        const OtherDepartmentIdentity: Variant
      ): Boolean;

    protected

      function InternalClone: TObject; override;
      
    public

      destructor Destroy; override;

      constructor Create; overload; override;
      constructor Create(Identity: Variant); overload;

      function IsSecretary: Boolean;
      function IsSecretarySigner: Boolean;
      function IsSubLeader: Boolean;
      function IsLeader: Boolean;
      function IsOrdinaryEmployee: Boolean;

      function IsInAnyOfAssignedWorkGroups: Boolean;
      function IsInWorkGroup(const WorkGroupId: Variant): Boolean;
      function IsInAllWorkGroups(const WorkGroupIds: TVariantList): Boolean;
      function IsInAnyOfWorkGroups(const WorkGroupIds: TVariantList): Boolean;
      
      function IsEmployeeLeaderForThis(Employee: TEmployee): Boolean;

      function IsSubLeaderForTopLevelEmployee: Boolean;
      function IsSubLeaderFor(Employee: TEmployee): Boolean;
      function IsSecretaryForTopLevelEmployee: Boolean;
      function IsSecretarySignerForTopLevelEmployee: Boolean;
      function IsSecretaryFor(Employee: TEmployee): Boolean;
      function IsSecretarySignerFor(Employee: TEmployee): Boolean;
      function IsSubstitutesFor(Employee: TEmployee): Boolean;

      procedure AssignAsTemporaryDeputyOrChangeReplacementPeriodFor(
        Employee: TEmployee;
        const PeriodStart, PeriodEnd: TDateTime
      );

      procedure AssignAsPermanentDeputy(Employee: TEmployee);

      procedure RemoveReplacementForEmployee(Employee: TEmployee);

      property EmployeeReplacements: TEmployeeReplacements
      read FEmployeeReplacements write SetEmployeeReplacements;

      property WorkGroupIds: TVariantList
      read FWorkGroupIds write SetWorkGroupIds;

    public

      class function LegacyIdentityPropName: String; static;
      class function NamePropName: String; static;
      class function SurnamePropName: String; static;
      class function PatronymicPropName: String; static;
      class function SpecialityPropName: String; static;
      class function IsForeignPropName: String; static;
      class function IsDismissedPropName: String; static;
      class function PersonnelNumberPropName: String; static;
      class function TelephoneNumberPropName: String; static;
      class function EmailPropName: String; static;
      class function DepartmentIdentityPropName: String; static;
      class function TopLevelEmployeeIdentityPropName: String; static;

    published

      property LegacyIdentity: Variant
      read GetLegacyIdentity write SetLegacyIdentity;

      property Name: String
      read GetName write SetName;

      property Surname: String
      read GetSurname write SetSurname;

      property Patronymic: String
      read GetPatronymic write SetPatronymic;

      property Speciality: String
      read GetSpeciality write SetSpeciality;

      property IsForeign: Boolean
      read GetIsForeign write SetIsForeign;

      property IsDismissed: Boolean
      read GetIsDismissed write SetIsDismissed;

      property FullName: String read GetFullName;

      property PersonnelNumber: String
      read GetPersonnelNumber write SetPersonnelNumber;

      property TelephoneNumber: String
      read GetTelephoneNumber write SetTelephoneNumber;

      property Email: String read GetEmail write SetEmail;

      property DepartmentIdentity: Variant
      read GetDepartmentIdentity write SetDepartmentIdentity;

      property TopLevelEmployee: TEmployee
      read GetTopLevelEmployee write SetTopLevelEmployee;

      property Role: TRole read GetRole write SetRole;

      property ContactInfo: TEmployeeContactInfo
      read FContactInfo write FContactInfo;

  end;

  TEmployees = class;

  TEmployeesEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentEmployee: TEmployee;

    public

      constructor Create(Employees: TEmployees);

      property Current: TEmployee read GetCurrentEmployee;
      
  end;

  TEmployees = class (TDomainObjectList)

    private

      function GetEmployeeByIndex(Index: Integer): TEmployee;
      procedure SetEmployeeByIndex(Index: Integer; Employee: TEmployee);

    public

      constructor Create; override;
      
      procedure Prepend(Employee:  TEmployee);
      procedure PrependMany(Employees: TEmployees);
      procedure Add(Employee: TEmployee);
      procedure AppendMany(Employees: TEmployees);

      function First: TEmployee;
      function Last: TEmployee;

      function FindEmployeesByIdentities(const EmployeeIdentities: TVariantList): TEmployees;
      function FindEmployeeByIdentity(const EmployeeIdentity: Variant): TEmployee;
      function FindEmployeesByRoles(Roles: TRoleList): TEmployees; overload;
      function FindEmployeesByRoles(Roles: array of TRole): TEmployees; overload;
      function FindLeaders: TEmployees;
      
      function FindTopLevelEmployeeForEmployee(Employee: TEmployee): TEmployee; overload;
      function FindTopLevelEmployeeForEmployee(const EmployeeIdentity: Variant): TEmployee; overload;
      
      function GetEnumerator: TEmployeesEnumerator;

      property Items[Index: Integer]: TEmployee
      read GetEmployeeByIndex write SetEmployeeByIndex; default;
      
  end;

implementation

uses

 AuxDebugFunctionsUnit;

{ TEmployee }

constructor TEmployee.Create;
begin

  inherited;
  
  Customize;
  
end;

procedure TEmployee.AssignAsPermanentDeputy(Employee: TEmployee);
begin

  if FEmployeeReplacements.IsReplacementExistsForEmployee(Self, Employee)
  then
    raise TEmployeeException.CreateFmt(
            'Сотрудник "%s" уже является ' +
            'заместителем для "%s"',
            [
              FullName,
              Employee.FullName
            ]
          );

  FEmployeeReplacements.AddPermanentReplacement(Self, Employee);

end;

procedure TEmployee.AssignAsTemporaryDeputyOrChangeReplacementPeriodFor(
  Employee: TEmployee;
  const PeriodStart, PeriodEnd: TDateTime
);
var EmployeeReplacement: TEmployeeReplacement;
begin

  EmployeeReplacement :=
    FEmployeeReplacements.FindReplacementForEmployee(
      Self, Employee
    );

  if Assigned(EmployeeReplacement) then begin

    EmployeeReplacement.PeriodStart := PeriodStart;
    EmployeeReplacement.PeriodEnd := PeriodEnd;
    
  end

  else
    FEmployeeReplacements.AddTemporaryReplacement(
      Self, Employee, PeriodStart, PeriodEnd
    );
  
end;

procedure TEmployee.ChangeReplaceableEmployeeIdForAllReplacements(
  const NewReplaceableEmployeeId: Variant
);
var EmployeeReplacement: TEmployeeReplacement;
begin

  if not Assigned(FEmployeeReplacements) then Exit;

  for EmployeeReplacement in FEmployeeReplacements do
    EmployeeReplacement.ReplaceableEmployeeId := NewReplaceableEmployeeId;

end;

constructor TEmployee.Create(Identity: Variant);
begin

  inherited;

  Customize;

end;

procedure TEmployee.CreateContactInfoObject;
begin

  FContactInfo := TEmployeeContactInfo.Create;
  
end;

procedure TEmployee.CreateEmployeeReplacementsObject;
begin

  FEmployeeReplacements := TEmployeeReplacements.Create;

end;

procedure TEmployee.Customize;
begin

  CreateEmployeeReplacementsObject;
  CreateContactInfoObject;
  
  FWorkGroupIds := TVariantList.Create;

  FLegacyIdentity := Null;
  FDepartmentIdentity := Null;
  
end;

destructor TEmployee.Destroy;
begin

  FreeAndNil(FEmployeeReplacements);
  FreeAndNil(FWorkGroupIds);

  inherited;
     
end;

function TEmployee.GetDepartmentIdentity: Variant;
begin

  Result := FDepartmentIdentity;

end;

function TEmployee.GetEmail: String;
begin

  Result := FContactInfo.Email;
  
end;

function TEmployee.GetFullName: String;
begin

  Result := Surname + ' ' + Name + ' ' + Patronymic;
  
end;

function TEmployee.GetIsDismissed: Boolean;
begin

  Result := FIsDismissed;

end;

function TEmployee.GetIsForeign: Boolean;
begin

  Result := FIsForeign;
  
end;

function TEmployee.GetLegacyIdentity: Variant;
begin

  Result := FLegacyIdentity;
  
end;

function TEmployee.GetTopLevelEmployee: TEmployee;
begin

  Result := FTopLevelEmployee;

end;

function TEmployee.GetName: String;
begin

  Result := FName;

end;

function TEmployee.GetPatronymic: String;
begin

  Result := FPatronymic;
  
end;

function TEmployee.GetPersonnelNumber: String;
begin

  Result := FPersonnelNumber;

end;

function TEmployee.GetRole: TRole;
begin

  Result := FRole;

end;

function TEmployee.GetSpeciality: String;
begin

  Result := FSpeciality;
  
end;

function TEmployee.GetSurname: String;
begin

  Result := FSurname;

end;

function TEmployee.GetTelephoneNumber: String;
begin

  Result := FContactInfo.TelephoneNumber;

end;

function TEmployee.InternalClone: TObject;
var CloneeEmployee: TEmployee;
    EmployeeReplacement: TEmployeeReplacement;
    CloneeEmployeeReplacement: TEmployeeReplacement;
begin

  Result := inherited InternalClone;

  CloneeEmployee := Result as TEmployee;

  CloneeEmployee.InvariantsComplianceRequested := False;

  for EmployeeReplacement in FEmployeeReplacements do begin

    CloneeEmployeeReplacement :=
      EmployeeReplacement.Clone as TEmployeeReplacement;

    CloneeEmployee.EmployeeReplacements.AddDomainObject(
      CloneeEmployeeReplacement
    );

    CloneeEmployee.WorkGroupIds := WorkGroupIds.Clone;

  end;

  CloneeEmployee.InvariantsComplianceRequested := True;                                              

end;

function TEmployee.IsDepartmentSameAs(
  const OtherDepartmentIdentity: Variant): Boolean;
begin

  Result := DepartmentIdentity = OtherDepartmentIdentity;
  
end;

function TEmployee.IsEmployeeLeaderForThis(Employee: TEmployee): Boolean;
begin

  Result :=
    Assigned(TopLevelEmployee) and
    TopLevelEmployee.IsSameAs(Employee) and
    Employee.IsLeader;

end;

function TEmployee.IsInAllWorkGroups(
  const WorkGroupIds: TVariantList): Boolean;
begin

  Result := FWorkGroupIds.ContainsAll(WorkGroupIds);
  
end;

function TEmployee.IsInAnyOfAssignedWorkGroups: Boolean;
begin

  Result := not FWorkGroupIds.IsEmpty;

end;

function TEmployee.IsInAnyOfWorkGroups(
  const WorkGroupIds: TVariantList): Boolean;
begin

  Result := FWorkGroupIds.ContainsAnyOf(WorkGroupIds);
  
end;

function TEmployee.IsInWorkGroup(const WorkGroupId: Variant): Boolean;
begin

  Result := FWorkGroupIds.Contains(WorkGroupId);
  
end;

function TEmployee.IsLeader: Boolean;
begin

  Result := Role.IsLeader;
  
end;

function TEmployee.IsOrdinaryEmployee: Boolean;
begin

  Result := Role.IsEmployee;
  
end;

function TEmployee.IsSecretary: Boolean;
begin

  Result := Role.IsSecretary or Role.IsSecretarySigner;

end;

function TEmployee.IsSecretaryFor(Employee: TEmployee): Boolean;
begin

  Result := IsSecretary and
            IsEmployeeLeaderForThis(Employee) and
            IsDepartmentSameAs(Employee.DepartmentIdentity);

end;

function TEmployee.IsSecretaryForTopLevelEmployee: Boolean;
begin

  if not Assigned(FTopLevelEmployee) then
    Result := False

  else Result := IsSecretaryFor(FTopLevelEmployee);
  
end;

function TEmployee.IsSecretarySigner: Boolean;
begin

  Result := FRole.IsSecretarySigner;
  
end;

function TEmployee.IsSecretarySignerFor(Employee: TEmployee): Boolean;
begin

  Result := IsSecretarySigner and
            IsEmployeeLeaderForThis(Employee) and
            IsDepartmentSameAs(Employee.DepartmentIdentity);

end;

function TEmployee.IsSecretarySignerForTopLevelEmployee: Boolean;
begin

  if not Assigned(TopLevelEmployee) then
    Result := False

  else Result := IsSecretarySignerFor(TopLevelEmployee);
  
end;

function TEmployee.IsSubLeader: Boolean;
begin

  Result := Role.IsSubLeader;
  
end;

function TEmployee.IsSubLeaderFor(Employee: TEmployee): Boolean;
begin

  Result := (IsSubLeader or IsLeader) and
            IsEmployeeLeaderForThis(Employee) and
            IsDepartmentSameAs(Employee.DepartmentIdentity);

end;

function TEmployee.IsSubLeaderForTopLevelEmployee: Boolean;
begin

  if not Assigned(FTopLevelEmployee) then
    Result := False

  else Result := IsSubLeaderFor(FTopLevelEmployee);
  
end;

function TEmployee.IsSubstitutesFor(Employee: TEmployee): Boolean;
var EmployeeReplacement: TEmployeeReplacement;
begin

  EmployeeReplacement :=
    Employee.FEmployeeReplacements.FindReplacementForEmployee(
      Employee, Self
    );

  if not Assigned(EmployeeReplacement) then
    Result := False

  else
    Result :=
      EmployeeReplacement.IsPermanent or
      EmployeeReplacement.IsPeriodExpiring;

end;

procedure TEmployee.RemoveReplacementForEmployee(Employee: TEmployee);
begin

  FEmployeeReplacements.RemoveReplacementForEmployee(
    Self, Employee
  );
  
end;

procedure TEmployee.SetDepartmentIdentity(const Value: Variant);
begin

  FDepartmentIdentity := Value;

end;

procedure TEmployee.SetEmail(const Value: String);
begin

  FContactInfo.Email := Value;
  
end;

procedure TEmployee.SetEmployeeReplacements(
  Value: TEmployeeReplacements
);
begin

  if InvariantsComplianceRequested then
    raise TEmployeeException.CreateFmt(
            'Нельзя назначать список ' +
            'замещений обособленно от ' +
            'объекта %s',
            [ClassName]
          );

  if not Assigned(Value) then
    FEmployeeReplacements.Clear

  else begin

    FreeAndNil(FEmployeeReplacements);

    FEmployeeReplacements := Value;

  end;

end;

procedure TEmployee.SetIdentity(Identity: Variant);
begin

  inherited;

  ChangeReplaceableEmployeeIdForAllReplacements(Identity);
  
end;

procedure TEmployee.SetIsDismissed(const Value: Boolean);
begin

  FIsDismissed := Value;
  
end;

procedure TEmployee.SetIsForeign(const Value: Boolean);
begin

  FIsForeign := Value;
  
end;

procedure TEmployee.SetLegacyIdentity(const Value: Variant);
begin

  FLegacyIdentity := Value;

end;

procedure TEmployee.SetTopLevelEmployee(const Value: TEmployee);
begin
  
  FTopLevelEmployee := Value;
  FreeTopLevelEmployee := FTopLevelEmployee;
  
end;

procedure TEmployee.SetWorkGroupIds(const Value: TVariantList);
begin

  if InvariantsComplianceRequested then begin

    raise TEmployeeException.Create(
      'Свойство WorkGroupIds не может ' +
      'устанавливаться непосредственно для ' +
      'объекта типа Employee'
    );
    
  end;

  FreeAndNil(FWorkGroupIds);

  FWorkGroupIds := Value;

end;

procedure TEmployee.SetName(const Value: String);
begin

  FName := Value;

end;

procedure TEmployee.SetPatronymic(const Value: String);
begin

  FPatronymic := Value;

end;

procedure TEmployee.SetPersonnelNumber(const Value: String);
begin

  FPersonnelNumber := Value;
  
end;

procedure TEmployee.SetRole(const Value: TRole);
begin

  FRole := Value;
  FreeRole := FRole;
  
end;

procedure TEmployee.SetSpeciality(const Value: String);
begin

  FSpeciality := Value;

end;

procedure TEmployee.SetSurname(const Value: String);
begin

  FSurname := Value;
  
end;

procedure TEmployee.SetTelephoneNumber(const Value: String);
begin

  FContactInfo.TelephoneNumber := Value;

end;

{ TEmployeesEnumerator }

constructor TEmployeesEnumerator.Create(Employees: TEmployees);
begin

  inherited Create(Employees);

end;

function TEmployeesEnumerator.GetCurrentEmployee: TEmployee;
begin

  Result := TEmployee(GetCurrentDomainObject);

end;


class function TEmployee.DepartmentIdentityPropName: String;
begin

  Result := 'DepartmentIdentity';

end;

class function TEmployee.EmailPropName: String;
begin

  Result := 'Email';

end;

class function TEmployee.IsDismissedPropName: String;
begin

  Result := 'IsDismissed';

end;

class function TEmployee.IsForeignPropName: String;
begin

  Result := 'IsForeign';

end;

class function TEmployee.LegacyIdentityPropName: String;
begin

  Result := 'LegacyIdentity';
end;

class function TEmployee.NamePropName: String;
begin

  Result := 'Name';

end;

class function TEmployee.PatronymicPropName: String;
begin

  Result := 'Patronymic';

end;

class function TEmployee.PersonnelNumberPropName: String;
begin

  Result := 'PersonnelNumber';

end;

class function TEmployee.SpecialityPropName: String;
begin

  Result := 'Speciality';

end;

class function TEmployee.SurnamePropName: String;
begin

  Result := 'Surname';

end;

class function TEmployee.TelephoneNumberPropName: String;
begin

  Result := 'TelephoneNumber';

end;

class function TEmployee.TopLevelEmployeeIdentityPropName: String;
begin

  Result := 'TopLevelEmployee.Identity';

end;

{ TEmployees }

procedure TEmployees.Add(Employee: TEmployee);
begin

  AddDomainObject(Employee);
  
end;

procedure TEmployees.AppendMany(Employees: TEmployees);
var Employee: TEmployee;
begin

  if not Assigned(Employees) then Exit;

  for Employee in Employees do
    Add(Employee);
  
end;

constructor TEmployees.Create;
begin

  inherited;

end;

function TEmployees.FindEmployeeByIdentity(
  const EmployeeIdentity: Variant): TEmployee;
begin

  Result := TEmployee(FindByIdentity(EmployeeIdentity));
  
end;

function TEmployees.FindEmployeesByIdentities(
  const EmployeeIdentities: TVariantList
): TEmployees;
begin

  Result := TEmployees(FindByIdentities(EmployeeIdentities));
  
end;

function TEmployees.FindEmployeesByRoles(Roles: array of TRole): TEmployees;
var
    RoleList: TRoleList;
    Role: TRole;
begin

  RoleList := TRoleList.Create;

  try

    for Role in Roles do
      RoleList.AddRole(Role);

    Result := FindEmployeesByRoles(RoleList);
    
  finally

    FreeAndNil(RoleList);

  end;

end;

function TEmployees.FindLeaders: TEmployees;
begin

  Result := FindEmployeesByRoles([TRoleMemento.GetLeaderRole]);
  
end;

function TEmployees.FindEmployeesByRoles(Roles: TRoleList): TEmployees;
var
    Employee: TEmployee;
begin

  Result := TEmployees.Create;

  try

    for Employee in Self do
      if Roles.Contains(Employee.Role) then
        Result.Add(Employee);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TEmployees.FindTopLevelEmployeeForEmployee(
  Employee: TEmployee): TEmployee;
begin

  if not Assigned(Employee.TopLevelEmployee) then
    Result := nil

  else
    Result := FindEmployeeByIdentity(Employee.TopLevelEmployee.Identity);
  
end;

function TEmployees.FindTopLevelEmployeeForEmployee(
  const EmployeeIdentity: Variant): TEmployee;
var Employee: TEmployee;
begin

  Employee := FindEmployeeByIdentity(EmployeeIdentity);

  Result := FindTopLevelEmployeeForEmployee(Employee);
  
end;

function TEmployees.First: TEmployee;
begin

  Result := TEmployee(inherited First);
  
end;

function TEmployees.GetEmployeeByIndex(Index: Integer): TEmployee;
begin

  Result := TEmployee(GetDomainObjectByIndex(Index));

end;

function TEmployees.GetEnumerator: TEmployeesEnumerator;
begin

  Result := TEmployeesEnumerator.Create(Self);
  
end;

function TEmployees.Last: TEmployee;
begin

  Result := TEmployee(inherited Last);
  
end;

procedure TEmployees.Prepend(Employee: TEmployee);
begin

  InsertDomainObject(0, Employee);
  
end;

procedure TEmployees.PrependMany(Employees: TEmployees);
var I: Integer;
begin

  if not Assigned(Employees) then Exit;

  for I := 0 to Employees.Count - 1 do
    InsertDomainObject(I, Employees[I]);
    
end;

procedure TEmployees.SetEmployeeByIndex(Index: Integer; Employee: TEmployee);
begin

  SetDomainObjectByIndex(Index, Employee);
  
end;

{ TEmployeeContactInfo }

constructor TEmployeeContactInfo.Create;
begin

  inherited;
  
end;

constructor TEmployeeContactInfo.Create(const Email: String);
begin

  inherited Create;

  FEmail := Email;

end;

destructor TEmployeeContactInfo.Destroy;
begin

  inherited;

end;

class function TEmployeeContactInfo.EmailPropName: String;
begin

  Result := 'Email';

end;

class function TEmployeeContactInfo.TelephoneNumberPropName: String;
begin

  Result := 'TelephoneNumber';
  
end;

{ TEmployeeReplacement }

constructor TEmployeeReplacement.Create;
begin

  inherited;

  CustomizeBy(Null, Null);
  
end;

constructor TEmployeeReplacement.Create(
  const ReplaceableEmployeeId: Variant;
  const DeputyId: Variant;
  const PeriodStart, PeriodEnd: TDateTime
);
begin

  inherited Create;

  CustomizeBy(
    ReplaceableEmployeeId,
    DeputyId,
    False,
    PeriodStart, PeriodEnd
  );
  
end;

constructor TEmployeeReplacement.CreateAsPermanent(
  const ReplaceableEmployeeId: Variant;
  const DeputyId: Variant
);
begin

  inherited Create;

  CustomizeBy(ReplaceableEmployeeId, DeputyId);
  
end;

procedure TEmployeeReplacement.CreatePeriodObject(
  const PeriodStart,
  PeriodEnd: TDateTime
);
begin

  FreeAndNil(FPeriod);
  
  FPeriod := TTimeFrame.Create(PeriodStart, PeriodEnd);

end;

procedure TEmployeeReplacement.CustomizeBy(
  const ReplaceableEmployeeId: Variant;
  const DeputyId: Variant;
  const IsPermanent: Boolean;
  const PeriodStart, PeriodEnd: TDateTime
);
begin

  FReplaceableEmployeeId := ReplaceableEmployeeId;
  FDeputyId := DeputyId;

  if IsPermanent then
    CreatePeriodObject
  
  else CreatePeriodObject(PeriodStart, PeriodEnd);

end;

destructor TEmployeeReplacement.Destroy;
begin

  FreeAndNil(FPeriod);
  inherited;
  
end;

function TEmployeeReplacement.GetDeputyId: Variant;
begin

  Result := FDeputyId;

end;

function TEmployeeReplacement.GetIsPeriodExpired: Boolean;
begin

  if IsPermanent then
    Result := False

  else Result := FPeriod.IsExpired;

end;

function TEmployeeReplacement.GetIsPeriodExpiring: Boolean;
begin

  if IsPermanent then
    Result := False

  else Result := FPeriod.IsExpiring;
  
end;

function TEmployeeReplacement.GetIsPermanent: Boolean;
begin

  Result := (FPeriod.Start = 0) or (FPeriod.Deadline = 0);
  
end;

function TEmployeeReplacement.GetPeriodEnd: Variant;
begin

  if FPeriod.Deadline = 0 then
    Result := Null

  else Result := FPeriod.Deadline;
  
end;

function TEmployeeReplacement.GetPeriodStart: Variant;
begin

  if FPeriod.Start = 0 then
    Result := Null

  else Result := FPeriod.Start;

end;

function TEmployeeReplacement.GetReplaceableEmployeeId: Variant;
begin

  Result := FReplaceableEmployeeId;
  
end;

function TEmployeeReplacement.InternalClone: TObject;
var CloneeEmployeeReplacement: TEmployeeReplacement;
begin

  Result := inherited InternalClone;

  CloneeEmployeeReplacement := Result as TEmployeeReplacement;

  CloneeEmployeeReplacement.SetPeriodStart(PeriodStart);
  CloneeEmployeeReplacement.SetPeriodEnd(PeriodEnd);
  
end;

procedure TEmployeeReplacement.SetDeputyId(const Value: Variant);
begin

  FDeputyId := Value;
  
end;

procedure TEmployeeReplacement.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  inherited;

  if Assigned(FPeriod) then
    FPeriod.InvariantsComplianceRequested := Value;

end;

procedure TEmployeeReplacement.SetIsPermanent(const Value: Boolean);
begin

  if Value then
    CreatePeriodObject(0, 0);
  
end;

procedure TEmployeeReplacement.SetPeriodEnd(const Value: Variant);
begin

  if not VarIsNull(Value) then
    FPeriod.Deadline := Value;

end;

procedure TEmployeeReplacement.SetPeriodStart(const Value: Variant);
begin

  if not VarIsNull(Value) then
    FPeriod.Start := Value;
  
end;

procedure TEmployeeReplacement.SetReplaceableEmployeeId(const Value: Variant);
begin

  FReplaceableEmployeeId := Value;
  
end;

{ TEmployeeReplacementsEnumerator }

constructor TEmployeeReplacementsEnumerator.Create(
  EmployeeReplacements: TEmployeeReplacements);
begin

  inherited Create(EmployeeReplacements);

end;

function TEmployeeReplacementsEnumerator.GetCurrentEmployeeReplacement: TEmployeeReplacement;
begin

  Result := GetCurrentDomainObject as TEmployeeReplacement;

end;

{ TEmployeeReplacements }

procedure TEmployeeReplacements.AddPermanentReplacement(
  Employee: TEmployee;
  Deputy: TEmployee
);
begin

  AddDomainObject(
    TEmployeeReplacement.CreateAsPermanent(
      Employee.Identity,
      Deputy.Identity
    )
  );
  
end;

procedure TEmployeeReplacements.AddTemporaryReplacement(
  ReplaceableEmployee: TEmployee;
  Deputy: TEmployee;
  const PeriodStart, PeriodEnd: TDateTime
);
begin

  AddDomainObject(
    TEmployeeReplacement.Create(
      ReplaceableEmployee.Identity,
      Deputy.Identity,
      PeriodStart, PeriodEnd
    )
  );
  
end;

function TEmployeeReplacements.GetEmployeeReplacementByIndex(
  Index: Integer): TEmployeeReplacement;
begin

  Result := GetDomainObjectByIndex(Index) as TEmployeeReplacement;

end;

function TEmployeeReplacements.GetEnumerator: TEmployeeReplacementsEnumerator;
begin

  Result := TEmployeeReplacementsEnumerator.Create(Self);
  
end;

function TEmployeeReplacements.FindReplacementBy(

  const ReplaceableEmployeeId: Variant;
  const DeputyId: Variant

): TEmployeeReplacement;
var EmployeeReplacement: TEmployeeReplacement;
begin

  for EmployeeReplacement in Self do
    if IsReplacementFor(
          EmployeeReplacement, ReplaceableEmployeeId, DeputyId
       )
    then begin

      Result := EmployeeReplacement;
      Exit;

    end;

  Result := nil;
  
end;

function TEmployeeReplacements.FindReplacementForEmployee(
  Employee: TEmployee;
  Deputy: TEmployee
): TEmployeeReplacement;
begin

  Result := FindReplacementBy(Employee.Identity, Deputy.Identity);

end;

function TEmployeeReplacements.IsReplacementExistsForEmployee(
  Employee: TEmployee;
  Deputy: TEmployee
): Boolean;
var EmployeeReplacement: TEmployeeReplacement;
begin

  Result := Assigned(FindReplacementForEmployee(Employee, Deputy));
  
end;

function TEmployeeReplacements.IsReplacementFor(
  Replacement: TEmployeeReplacement; const ReplaceableEmployeeId,
  DeputyId: Variant): Boolean;
begin

  Result :=
    (Replacement.ReplaceableEmployeeId = ReplaceableEmployeeId)
     and
    (Replacement.DeputyId = DeputyId);
    
end;

procedure TEmployeeReplacements.RemoveReplacementForEmployee(
  Employee: TEmployee;
  Deputy: TEmployee
);
var I: Integer;
    EmployeeReplacement: TEmployeeReplacement;
begin

  for I := 0 to Count - 1 do begin

    EmployeeReplacement := Self[I];

    if IsReplacementFor(
          EmployeeReplacement, Employee.Identity, Deputy.Identity
       )
    then begin

      DeleteDomainObjectEntryByIndex(I);
      Exit;
      
    end;
    
  end;

end;

procedure TEmployeeReplacements.SetEmployeeReplacementByIndex(Index: Integer;
  EmployeeReplacement: TEmployeeReplacement);
begin

  SetDomainObjectByIndex(Index, EmployeeReplacement);

end;

end.
