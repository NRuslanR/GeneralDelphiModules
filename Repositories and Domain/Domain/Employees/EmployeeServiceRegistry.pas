unit EmployeeServiceRegistry;

interface

uses

  EmployeeSearchServiceRegistry,
  EmployeeDistributionServiceRegistry,
  EmployeePerformingServiceRegistry,
  EmployeeSubordinationServiceRegistry,
  TypeObjectRegistry,
  SysUtils;

type

  TEmployeeServiceRegistry = class

    public

      class procedure Destroy;
      
      class function EmployeeSearchServiceRegistry: TEmployeeSearchServiceRegistry; static;
      class function EmployeeDistributionServiceRegistry: TEmployeeDistributionServiceRegistry; static;
      class function EmployeePerformingServiceRegistry: TEmployeePerformingServiceRegistry; static;
      class function EmployeeSubordinationServiceRegistry: TEmployeeSubordinationServiceRegistry; static;

      class procedure RegisterAllStandardEmployeeServices; static;
      
  end;

  TEmployeeServiceRegistryClass = class of TEmployeeServiceRegistry;

implementation

{ TEmployeeServiceRegistry }

class procedure TEmployeeServiceRegistry.Destroy;
begin

  EmployeeSearchServiceRegistry.Free;
  EmployeeDistributionServiceRegistry.Free;
  EmployeePerformingServiceRegistry.Free;
  EmployeeSubordinationServiceRegistry.Free;
  
end;

class function TEmployeeServiceRegistry.
  EmployeeDistributionServiceRegistry: TEmployeeDistributionServiceRegistry;
begin

  Result := TEmployeeDistributionServiceRegistry.Instance;
  
end;

class function TEmployeeServiceRegistry.
  EmployeePerformingServiceRegistry: TEmployeePerformingServiceRegistry;
begin

  Result := TEmployeePerformingServiceRegistry.Instnace;
  
end;

class function TEmployeeServiceRegistry.
  EmployeeSearchServiceRegistry: TEmployeeSearchServiceRegistry;
begin

  Result := TEmployeeSearchServiceRegistry.Instance;
  
end;

class function TEmployeeServiceRegistry.
  EmployeeSubordinationServiceRegistry: TEmployeeSubordinationServiceRegistry;
begin

  Result := TEmployeeSubordinationServiceRegistry.Instance;
  
end;

class procedure TEmployeeServiceRegistry.RegisterAllStandardEmployeeServices;
begin

  EmployeeDistributionServiceRegistry.RegisterAllStandardEmployeeDistributionServices;
  EmployeeSubordinationServiceRegistry.RegisterAllStandardEmployeeSubordinationServices;
  EmployeePerformingServiceRegistry.RegisterAllStandardEmployeePerformingServices;
  
end;

end.
