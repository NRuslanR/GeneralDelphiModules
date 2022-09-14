unit EmployeesWorkGroup;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  SysUtils,
  Classes;

type

  TEmployeesWorkGroup = class (TDomainObject)

    private

      FName: String;
      FLeaderIdentity: Variant;
      
      procedure SetLeaderIdentity(const Value: Variant);
      procedure SetName(const Value: String);

    published

      property Name: String read FName write SetName;
      property LeaderIdentity: Variant read FLeaderIdentity write SetLeaderIdentity;
      
  end;

  TEmployeesWorkGroups = class;

  TEmployeesWorkGroupsEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentEmployeesWorkGroup: TEmployeesWorkGroup;

    public

      constructor Create(EmployeesWorkGroups: TEmployeesWorkGroups);

      property Current: TEmployeesWorkGroup
      read GetCurrentEmployeesWorkGroup;
      
  end;

  TEmployeesWorkGroups = class (TDomainObjectList)

    private

      function GetEmployeesWorkGroupByIndex(Index: Integer): TEmployeesWorkGroup;

      procedure SetEmployeesWorkGroupByIndex(Index: Integer;
        const Value: TEmployeesWorkGroup
      );

    public

      procedure Add(EmployeesWorkGroup: TEmployeesWorkGroup);

      function GetEnumerator: TEmployeesWorkGroupsEnumerator;

      property Items[Index: Integer]: TEmployeesWorkGroup
      read GetEmployeesWorkGroupByIndex write SetEmployeesWorkGroupByIndex;
      
  end;
  
  
implementation

{ TEmployeesWorkGroup }

procedure TEmployeesWorkGroup.SetLeaderIdentity(const Value: Variant);
begin

  FLeaderIdentity := Value;

end;

procedure TEmployeesWorkGroup.SetName(const Value: String);
begin

  FName := Value;

end;

{ TEmployeesWorkGroups }

procedure TEmployeesWorkGroups.Add(
  EmployeesWorkGroup: TEmployeesWorkGroup);
begin

  AddDomainObject(EmployeesWorkGroup);
  
end;

function TEmployeesWorkGroups.GetEmployeesWorkGroupByIndex(
  Index: Integer): TEmployeesWorkGroup;
begin

  Result := TEmployeesWorkGroup(GetDomainObjectByIndex(Index));
  
end;

function TEmployeesWorkGroups.GetEnumerator: TEmployeesWorkGroupsEnumerator;
begin

  Result := TEmployeesWorkGroupsEnumerator.Create(Self);
  
end;

procedure TEmployeesWorkGroups.SetEmployeesWorkGroupByIndex(Index: Integer;
  const Value: TEmployeesWorkGroup);
begin

  SetDomainObjectByIndex(Index, Value);
  
end;

{ TEmployeesWorkGroupsEnumerator }

constructor TEmployeesWorkGroupsEnumerator.Create(
  EmployeesWorkGroups: TEmployeesWorkGroups);
begin

  inherited Create(EmployeesWorkGroups);
  
end;

function TEmployeesWorkGroupsEnumerator.GetCurrentEmployeesWorkGroup: TEmployeesWorkGroup;
begin

  Result := TEmployeesWorkGroup(GetCurrentDomainObject);
  
end;

end.
