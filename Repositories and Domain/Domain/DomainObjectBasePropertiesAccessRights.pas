unit DomainObjectBasePropertiesAccessRights;

interface

uses

  DomainObjectBaseUnit,
  DomainObjectBaseListUnit,
  SysUtils;

type

  TDomainObjectBasePropertyAccessRights = class (TDomainObjectBase)

    protected

      FName: String;
      FEditable: Boolean;
      FRequired: Boolean;
      FViewable: Boolean;

    published

      property Name: String read FName write FName;
      property Editable: Boolean read FEditable write FEditable;
      property Required: Boolean read FRequired write FRequired;
      property Viewable: Boolean read FViewable write FViewable;

  end;

  TDomainObjectBasePropertiesAccessRights = class;
  
  TDomainObjectBasePropertiesAccessRightsEnumerator = class (TDomainObjectBaseListEnumerator)

    protected

      function GetCurrentPropertyAccessRights: TDomainObjectBasePropertyAccessRights;
      
    public

      constructor Create(PropertiesAccessRights: TDomainObjectBasePropertiesAccessRights);

      property Current: TDomainObjectBasePropertyAccessRights
      read GetCurrentPropertyAccessRights;
      
  end;
  
  TDomainObjectBasePropertiesAccessRights = class (TDomainObjectBaseList)

    protected

      function GetPropertyAccessRightsByName(const PropertyName: String): TDomainObjectBasePropertyAccessRights;
      function ContainsPropertyAccessRights(const PropertyName: String): Boolean;

    public

      function Add: TDomainObjectBasePropertyAccessRights; overload;

      function Add(
        const Name: String;
        const Editable: Boolean = True;
        const Required: Boolean = False;
        const Viewable: Boolean = True
      ): TDomainObjectBasePropertyAccessRights; overload;

      procedure Remove(const PropertyName: String);

      function GetEnumerator: TDomainObjectBasePropertiesAccessRightsEnumerator;
      
      property Items[const PropertyName: String]: TDomainObjectBasePropertyAccessRights
      read GetPropertyAccessRightsByName; default;
      
  end;

implementation

{ TDomainObjectBasePropertiesAccessRights }

function TDomainObjectBasePropertiesAccessRights.Add: TDomainObjectBasePropertyAccessRights;
begin

  Result := Add('');
  
end;

function TDomainObjectBasePropertiesAccessRights.Add(
  const Name: String;
  const Editable, Required,
  Viewable: Boolean
): TDomainObjectBasePropertyAccessRights;
var
    AccessRights: TDomainObjectBasePropertyAccessRights;
begin

  AccessRights := Self[Name];

  if not Assigned(AccessRights) then
    AccessRights := TDomainObjectBasePropertyAccessRights.Create;

  AccessRights.Name := Name;
  AccessRights.Editable := Editable;
  AccessRights.Required := Required;
  AccessRights.Viewable := Viewable;

  AddBaseDomainObject(AccessRights);

  Result := AccessRights;

end;

function TDomainObjectBasePropertiesAccessRights.ContainsPropertyAccessRights(
  const PropertyName: String): Boolean;
begin

  Result := Assigned(Self[PropertyName]);

end;

function TDomainObjectBasePropertiesAccessRights.GetEnumerator: TDomainObjectBasePropertiesAccessRightsEnumerator;
begin

  Result := TDomainObjectBasePropertiesAccessRightsEnumerator.Create(Self);
  
end;

function TDomainObjectBasePropertiesAccessRights.GetPropertyAccessRightsByName(
  const PropertyName: String
): TDomainObjectBasePropertyAccessRights;
begin

  for Result in Self do
    if Result.Name = PropertyName then
      Exit;

  Result := nil;

end;

procedure TDomainObjectBasePropertiesAccessRights.Remove(
  const PropertyName: String);
var
    AccessRights: TDomainObjectBasePropertyAccessRights;
begin

  AccessRights := Self[PropertyName];

  DeleteBaseDomainObject(AccessRights);
  
end;

{ TDomainObjectBasePropertiesAccessRightsEnumerator }

constructor TDomainObjectBasePropertiesAccessRightsEnumerator.Create(
  PropertiesAccessRights: TDomainObjectBasePropertiesAccessRights);
begin

  inherited Create(PropertiesAccessRights);
  
end;

function TDomainObjectBasePropertiesAccessRightsEnumerator.
  GetCurrentPropertyAccessRights: TDomainObjectBasePropertyAccessRights;
begin

  Result := TDomainObjectBasePropertyAccessRights(GetCurrentBaseDomainObject);

end;

end.
