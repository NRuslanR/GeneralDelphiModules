unit SystemAdministrationPrivileges;

interface

uses

  SysUtils,
  Classes;

type

  TSystemAdministrationPrivilege = class

    public

      Identity: Variant;
      TopLevelPrivilegeIdentity: Variant;
      Name: String;
      HasServices: Boolean;

      constructor Create; overload;
      constructor Create(
        const Identity: Variant;
        const TopLevelPrivilegeIdentity: Variant;
        const Name: String;
        const HasServices: Boolean
      ); overload;

      
  end;

  TSystemAdministrationPrivileges = class;

  TSystemAdministrationPrivilegesEnumerator = class (TListEnumerator)

    protected

      function GetCurrentSystemAdministrationPrivilege: TSystemAdministrationPrivilege;

    public

      constructor Create(SystemAdministrationPrivileges: TSystemAdministrationPrivileges);

      property Current: TSystemAdministrationPrivilege
      read GetCurrentSystemAdministrationPrivilege;
      
  end;

  TSystemAdministrationPrivileges = class (TList)

    protected

      function GetSystemAdministrationPrivilegeByIndex(
        Index: Integer): TSystemAdministrationPrivilege;

      procedure SetSystemAdministrationPrivilegeByIndex(Index: Integer;
        const Value: TSystemAdministrationPrivilege);

      function GetSystemAdministrationPrivilegeById(
        const PrivilegeId: Variant
      ): TSystemAdministrationPrivilege;

      function IsSystemAdministrationPrivilegeExists(
        const PrivilegeId: Variant
      ): Boolean;
      
    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(Privilege: TSystemAdministrationPrivilege): Integer;

      function FindPrivilegeById(const PrivilegeId: Variant): TSystemAdministrationPrivilege;
      
      function IsEmtpy: Boolean;
      
      function GetEnumerator: TSystemAdministrationPrivilegesEnumerator;

      property Items[Index: Integer]: TSystemAdministrationPrivilege
      read GetSystemAdministrationPrivilegeByIndex
      write SetSystemAdministrationPrivilegeByIndex;
      
  end;
  
implementation

uses

  Variants;
  
{ TSystemAdministrationPrivilege }

constructor TSystemAdministrationPrivilege.Create;
begin

  inherited;

  Identity := Null;
  TopLevelPrivilegeIdentity := Null;

end;

constructor TSystemAdministrationPrivilege.Create(
  const Identity, TopLevelPrivilegeIdentity: Variant;
  const Name: String;
  const HasServices: Boolean
);
begin

  inherited Create;

  Self.Identity := Identity;
  Self.TopLevelPrivilegeIdentity := TopLevelPrivilegeIdentity;
  Self.Name := Name;
  Self.HasServices := HasServices;
  
end;

{ TSystemAdministrationPrivileges }

function TSystemAdministrationPrivileges.Add(
  Privilege: TSystemAdministrationPrivilege): Integer;
begin

  if IsSystemAdministrationPrivilegeExists(Privilege.Identity)
  then begin

    raise Exception.CreateFmt(
      'Administration privilege with id "%s" ' +
      'is already exists',
      [VarToStr(Privilege.Identity)]
    );
    
  end;


  Result := inherited Add(Privilege);

end;

function TSystemAdministrationPrivileges.FindPrivilegeById(
  const PrivilegeId: Variant
): TSystemAdministrationPrivilege;
begin

  for Result in Self do
    if Result.Identity = PrivilegeId then
      Exit;

  Result := nil;
    
end;

function TSystemAdministrationPrivileges.GetEnumerator: TSystemAdministrationPrivilegesEnumerator;
begin

  Result := TSystemAdministrationPrivilegesEnumerator.Create(Self);

end;

function TSystemAdministrationPrivileges.GetSystemAdministrationPrivilegeById(
  const PrivilegeId: Variant): TSystemAdministrationPrivilege;
begin

  for Result in Self do
    if Result.Identity = PrivilegeId then
      Exit;

  Result := nil;
    
end;

function TSystemAdministrationPrivileges.GetSystemAdministrationPrivilegeByIndex(
  Index: Integer): TSystemAdministrationPrivilege;
begin

  Result := TSystemAdministrationPrivilege(Get(Index));
  
end;

function TSystemAdministrationPrivileges.IsEmtpy: Boolean;
begin

  Result := Count = 0;
  
end;

function TSystemAdministrationPrivileges.IsSystemAdministrationPrivilegeExists(
  const PrivilegeId: Variant): Boolean;
begin

  Result := Assigned(GetSystemAdministrationPrivilegeById(PrivilegeId));
  
end;

procedure TSystemAdministrationPrivileges.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  inherited;

  if Action = lnDeleted then
    TSystemAdministrationPrivilege(Ptr).Free;
    
end;

procedure TSystemAdministrationPrivileges.SetSystemAdministrationPrivilegeByIndex(
  Index: Integer; const Value: TSystemAdministrationPrivilege);
begin

  Put(Index, Value);
  
end;

{ TSystemAdministrationPrivilegesEnumerator }

constructor TSystemAdministrationPrivilegesEnumerator.Create(
  SystemAdministrationPrivileges: TSystemAdministrationPrivileges);
begin

  inherited Create(SystemAdministrationPrivileges);
  
end;

function TSystemAdministrationPrivilegesEnumerator.GetCurrentSystemAdministrationPrivilege: TSystemAdministrationPrivilege;
begin

  Result := TSystemAdministrationPrivilege(GetCurrent);
  
end;

end.
