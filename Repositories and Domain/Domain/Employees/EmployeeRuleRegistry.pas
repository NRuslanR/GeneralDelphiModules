unit EmployeeRuleRegistry;

interface

uses

  EmployeeRelationshipRuleRegistry,
  SysUtils;

type

  TEmployeeRuleRegistry = class

    public

      class procedure Destroy;
      
      class function EmployeeRelationshipRuleRegistry: TEmployeeRelationshipRuleRegistry;

      class procedure RegisterAllStandardEmployeeRules;
      
  end;

  TEmployeeRuleRegistryClass = class of TEmployeeRuleRegistry;
  
implementation

{ TEmployeeRuleRegistry }

class procedure TEmployeeRuleRegistry.Destroy;
begin

  EmployeeRelationshipRuleRegistry.Free;
  
end;

class function TEmployeeRuleRegistry.EmployeeRelationshipRuleRegistry: TEmployeeRelationshipRuleRegistry;
begin

  Result := TEmployeeRelationshipRuleRegistry.Instance;

end;

class procedure TEmployeeRuleRegistry.RegisterAllStandardEmployeeRules;
begin

  EmployeeRelationshipRuleRegistry.RegisterEmployeeRelationshipRules;
  
end;

end.
