{
  SecretarySigner - секретарь-подписант -
  временное решение для тех случаев, когда
  секретарь в рамках подразделения своего
  руководителя переводит исходящую служебку
  от другого подразделения в ЭДО и отправляет
  на исполнение своему руководителю
}

{ refactor: change this object after employee domain's repositories refactor }

unit Role;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  VariantListUnit,
  SysUtils,
  Classes;

const

  LEADER_ROLE_ID = 2;
  LEADER_ROLE_NAME = 'Leader';
  LEADER_ROLE_DESCRIPTION = 'Руководитель';

  SUBLEADER_ROLE_ID = 3;
  SUBLEADER_ROLE_NAME = 'SubLeader';
  SUBLEADER_ROLE_DESCRIPTION = 'Заместитель';

  SECRETARY_ROLE_ID = 4;
  SECRETARY_ROLE_NAME = 'Secretary';
  SECRETARY_ROLE_DESCRIPTION = 'Секретарь';

  SECRETARY_SIGNER_ID = 6;
  SECRETARY_SIGNER_NAME = 'SecretarySigner';
  SECRETARY_SIGNER_DESCRIPTION = 'Секретарь-подписант';
  
  EMPLOYEE_ROLE_ID = 5;
  EMPLOYEE_ROLE_NAME = 'Employee';
  EMPLOYEE_ROLE_DESCRIPTION = 'Сотрудник';
  
type

  TRole = class (TDomainObject)

    protected

      FName: String;
      FDescription: String;

      procedure Initialize(
        const Identity: Variant;
        const RoleName: String = '';
        const RoleDescription: String = ''
      );
      
      function GetName: String;
      procedure SetName(const Name: String);

      function GetDescription: String;
      procedure SetDescription(const Description: String);

      constructor Create; overload;

      constructor Create(
        const RoleName: String;
        const RoleDescription: String = ''
      ); overload;

      constructor Create(
        const Identity: Variant;
        const RoleName: String;
        const RoleDescription: String
      ); overload;
      
    public

      destructor Destroy; override;
      
      function IsSecretary: Boolean;
      function IsSecretarySigner: Boolean;
      function IsLeader: Boolean;
      function IsSubLeader: Boolean;
      function IsEmployee: Boolean;

    public

      class function NamePropName: String; static;
      class function DescriptionPropName: String; static;

    published

      property Name: String read GetName write SetName;
      property Description: String read GetDescription write SetDescription;
      
  end;

  TRoleList = class;

  TRoleListEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentRole: TRole;

    public

      constructor Create(RoleList: TRoleList);

      property Current: TRole read GetCurrentRole;
      
  end;

  TRoleList = class (TDomainObjectList)

    private

      function GetRoleByIndex(Index: Integer): TRole;
      procedure SetRoleByIndex(Index: Integer; Role: TRole);

      function IsRoleExists(Role: TRole): Boolean;

    public

      destructor Destroy; override;
      procedure AddRole(Role: TRole);

      function GetEnumerator: TRoleListEnumerator;

      function GetRoleByName(const RoleName: String): TRole;

      property Items[Index: Integer]: TRole read GetRoleByIndex write SetRoleByIndex; default;

  end;

  TRoleMemento = class

      private

        class var FRoles: TRoleList;
        class var FAllRoleList: TRoleList;
        
        class function AddRole(
          const Identity: Variant;
          const RoleName: String;
          const RoleDescription: String
        ): TRole;

        class function GetRoleByName(const RoleName: String): TRole;

    public

      class function GetLeaderRole: TRole;
      class function GetSubLeaderRole: TRole;
      class function GetSecretaryRole: TRole;
      class function GetSecretarySignerRole: TRole;
      class function GetEmployeeRole: TRole;
      class function GetLeadershipRoles: TRoleList; { refactor: get from db }
      class function GetLeadershipRoleIds: TVariantList;
      class function GetAllRoles: TRoleList;

  end;


implementation

uses

  Variants;
  
{ TRole }

constructor TRole.Create;
begin

  inherited;

end;

constructor TRole.Create(
  const RoleName: String;
  const RoleDescription: String
);
begin

  inherited Create;

  Initialize(Null, RoleName, RoleDescription);
  
end;

constructor TRole.Create(
  const Identity: Variant;
  const RoleName, RoleDescription: String
);
begin

  inherited Create;

  Initialize(Identity, RoleName, RoleDescription);
  
end;

class function TRole.DescriptionPropName: String;
begin

  Result := 'Description';
  
end;

destructor TRole.Destroy;
begin

  inherited;

end;

function TRole.GetDescription: String;
begin

  Result := FDescription;
end;

function TRole.GetName: String;
begin

  Result := FName;

end;

procedure TRole.Initialize(
  const Identity: Variant;
  const RoleName, RoleDescription: String);
begin

  Self.Identity := Identity;
  Self.Name := RoleName;
  Self.Description := RoleDescription;
  
end;

function TRole.IsEmployee: Boolean;
begin

  Result := FName = EMPLOYEE_ROLE_NAME;
  
end;

function TRole.IsLeader: Boolean;
begin

  Result := FName = LEADER_ROLE_NAME;
  
end;

function TRole.IsSecretary: Boolean;
begin

  Result := FName = SECRETARY_ROLE_NAME;
  
end;

function TRole.IsSecretarySigner: Boolean;
begin

  Result := FName = SECRETARY_SIGNER_NAME;

end;

function TRole.IsSubLeader: Boolean;
begin

  Result := FName = SUBLEADER_ROLE_NAME;
  
end;

class function TRole.NamePropName: String;
begin

  Result := 'Name';
  
end;

procedure TRole.SetDescription(const Description: String);
begin

  FDescription := Description;
  
end;

procedure TRole.SetName(const Name: String);
begin

  FName := Name;

end;

{ TRoleMemento }

class function TRoleMemento.AddRole(
  const Identity: Variant;
  const RoleName, RoleDescription: String
): TRole;
var Role: TRole;
begin

  Role := TRole.Create(Identity, RoleName, RoleDescription);

  FRoles.AddRole(Role);

  Result := Role;

end;

class function TRoleMemento.GetAllRoles: TRoleList;
begin

  if Assigned(FAllRoleList) then begin

    Result := FAllRoleList;
    Exit;

  end;

  FAllRoleList := TRoleList.Create;

  try

    FAllRoleList.AddRole(GetLeaderRole);
    FAllRoleList.AddRole(GetSubLeaderRole);
    FAllRoleList.AddRole(GetSecretaryRole);
    FAllRoleList.AddRole(GetEmployeeRole);
    FAllRoleList.AddRole(GetSecretarySignerRole);

    Result := FAllRoleList;
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

class function TRoleMemento.GetEmployeeRole: TRole;
begin

  Result := GetRoleByName(EMPLOYEE_ROLE_NAME);

  if not Assigned(Result) then
    Result :=
      AddRole(
        EMPLOYEE_ROLE_ID,
        EMPLOYEE_ROLE_NAME,
        EMPLOYEE_ROLE_DESCRIPTION
      );

end;

class function TRoleMemento.GetLeaderRole: TRole;
begin

  Result := GetRoleByName(LEADER_ROLE_NAME);

  if not Assigned(Result) then
    Result :=
      AddRole(
        LEADER_ROLE_ID,
        LEADER_ROLE_NAME,
        LEADER_ROLE_DESCRIPTION
      );

end;

class function TRoleMemento.GetLeadershipRoleIds: TVariantList;
var
    LeadershipRoleList: TRoleList;
begin

  LeadershipRoleList := GetLeadershipRoles;

  try

    Result := LeadershipRoleList.CreateDomainObjectIdentityList;

  finally

    FreeAndNil(LeadershipRoleList);
    
  end;

end;

class function TRoleMemento.GetLeadershipRoles: TRoleList;
begin

  Result := TRoleList.Create;

  try

    Result.AddRole(GetLeaderRole);
    Result.AddRole(GetSubLeaderRole);
    Result.AddRole(GetSecretaryRole);
    Result.AddRole(GetSecretarySignerRole);

  except

    FreeAndNil(Result);

  end;

end;

class function TRoleMemento.GetSecretaryRole: TRole;
begin

  Result := GetRoleByName(SECRETARY_ROLE_NAME);

  if not Assigned(Result) then
    Result :=
      AddRole(
        SECRETARY_ROLE_ID,
        SECRETARY_ROLE_NAME,
        SECRETARY_ROLE_DESCRIPTION
      );

end;

class function TRoleMemento.GetSecretarySignerRole: TRole;
begin

  Result := GetRoleByName(SECRETARY_SIGNER_NAME);

  if not Assigned(Result) then
    Result :=
      AddRole(
        SECRETARY_SIGNER_ID,
        SECRETARY_SIGNER_NAME,
        SECRETARY_SIGNER_DESCRIPTION
      );

end;

class function TRoleMemento.GetSubLeaderRole: TRole;
var RoleIndex: Integer;
begin

  Result := GetRoleByName(SUBLEADER_ROLE_NAME);

  if not Assigned(Result) then
    Result :=
      AddRole(
        SUBLEADER_ROLE_ID,
        SUBLEADER_ROLE_NAME,
        SUBLEADER_ROLE_DESCRIPTION
      );

end;

class function TRoleMemento.GetRoleByName(const RoleName: String): TRole;
var RoleIndex: Integer;
begin

  if not Assigned(FRoles) then
    FRoles := TRoleList.Create;

  Result := FRoles.GetRoleByName(RoleName);

end;

{ TRoleListEnumerator }

constructor TRoleListEnumerator.Create(RoleList: TRoleList);
begin

  inherited Create(RoleList);

end;

function TRoleListEnumerator.GetCurrentRole: TRole;
begin

  Result := GetCurrentDomainObject as  TRole;

end;

{ TRoleList }

procedure TRoleList.AddRole(Role: TRole);
begin

  if not IsRoleExists(Role) then
    AddDomainObject(Role);
  
end;

destructor TRoleList.Destroy;
begin

  inherited;
end;

function TRoleList.GetEnumerator: TRoleListEnumerator;
begin

  Result := TRoleListEnumerator.Create(Self);

end;

function TRoleList.GetRoleByIndex(Index: Integer): TRole;
begin

  Result := GetDomainObjectByIndex(Index) as TRole;

end;

function TRoleList.GetRoleByName(const RoleName: String): TRole;
var Role: TRole;
begin

  for Role in Self do begin

    if Role.Name = RoleName then begin

      Result := Role;
      Exit;

    end;

  end;

  Result := nil;

end;

function TRoleList.IsRoleExists(Role: TRole): Boolean;
begin

  Result := GetRoleByName(Role.Name) <> nil;
  
end;

procedure TRoleList.SetRoleByIndex(Index: Integer; Role: TRole);
begin

  SetDomainObjectByIndex(Index, Role);

end;

end.
