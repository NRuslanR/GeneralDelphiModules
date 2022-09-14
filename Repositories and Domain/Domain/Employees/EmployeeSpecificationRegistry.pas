unit EmployeeSpecificationRegistry;

interface

uses

  EmployeeDistributionSpecificationRegistry,
  EmployeeSubordinationSpecificationRegistry,
  SysUtils;

type

  TEmployeeSpecificationRegistry = class

    public

      class procedure Destroy;
      
      class function EmployeeDistributionSpecificationRegistry:
        TEmployeeDistributionSpecificationRegistry; static;

      class function EmployeeSubordinationSpecificationRegistry:
        TEmployeeSubordinationSpecificationRegistry; static;

      class procedure RegisterAllStandardEmployeeSpecifications;
      
  end;

  TEmployeeSpecificationRegistryClass = class of TEmployeeSpecificationRegistry;
  
implementation

{ TEmployeeSpecificationRegistry }

class procedure TEmployeeSpecificationRegistry.Destroy;
begin

  EmployeeDistributionSpecificationRegistry.Free;
  EmployeeSubordinationSpecificationRegistry.Free;
  
end;

class function TEmployeeSpecificationRegistry.
  EmployeeDistributionSpecificationRegistry: TEmployeeDistributionSpecificationRegistry;
begin

  Result := TEmployeeDistributionSpecificationRegistry.Instance;
  
end;

class function TEmployeeSpecificationRegistry.
  EmployeeSubordinationSpecificationRegistry: TEmployeeSubordinationSpecificationRegistry;
begin

  Result := TEmployeeSubordinationSpecificationRegistry.Instance;
  
end;

class procedure TEmployeeSpecificationRegistry.RegisterAllStandardEmployeeSpecifications;
begin

  EmployeeDistributionSpecificationRegistry.RegisterAllStandardEmployeeDistributionSpecifications;
  EmployeeSubordinationSpecificationRegistry.RegisterAllStandardEmployeeSubordinationSpecifications;
  
end;

end.
