unit EmployeesDomainRegistries;

interface

uses

  EmployeeRuleRegistry,
  EmployeeServiceRegistry,
  EmployeeSpecificationRegistry;

type

  TEmployeesDomainRegistries = class

    public

      class procedure Destroy;
      
      class function RuleRegistry: TEmployeeRuleRegistryClass;
      class function ServiceRegistry: TEmployeeServiceRegistryClass;
      class function SpecificationRegistry: TEmployeeSpecificationRegistryClass;
      
  end;

  TEmployeesDomainRegistriesClass = class of TEmployeesDomainRegistries;
  
implementation

{ TEmployeesDomainRegistries }

class procedure TEmployeesDomainRegistries.Destroy;
begin

  RuleRegistry.Destroy;
  ServiceRegistry.Destroy;
  SpecificationRegistry.Destroy;
  
end;

class function TEmployeesDomainRegistries.RuleRegistry: TEmployeeRuleRegistryClass;
begin

  Result := TEmployeeRuleRegistry;
  
end;

class function TEmployeesDomainRegistries.ServiceRegistry: TEmployeeServiceRegistryClass;
begin

  Result := TEmployeeServiceRegistry;
  
end;

class function TEmployeesDomainRegistries.SpecificationRegistry: TEmployeeSpecificationRegistryClass;
begin

  Result := TEmployeeSpecificationRegistry;

end;

end.
