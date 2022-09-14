unit EmployeePerformingServiceRegistry;

interface

uses

  TypeObjectRegistry,
  EmployeeChargePerformingService,
  SysUtils;

type

  TEmployeePerformingServiceRegistry = class

    private

      class var FInstance: TEmployeePerformingServiceRegistry;

      class function GetInstance: TEmployeePerformingServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterEmployeeChargePerformingService(
        EmployeeChargePerformingService: IEmployeeChargePerformingService
      );

      procedure RegisterStandardEmployeeChargePerformingService;

      function GetEmployeeChargePerformingService: IEmployeeChargePerformingService;

    public

      procedure RegisterAllStandardEmployeePerformingServices;
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instnace: TEmployeePerformingServiceRegistry
      read GetInstance;
      
  end;


implementation

uses

  StandardEmployeeChargePerformingService,
  EmployeeSubordinationServiceRegistry;

type

  TEmployeeChargePerformingServiceType = class

  end;
  
{ TEmployeePerformingServiceRegistry }

constructor TEmployeePerformingServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TEmployeePerformingServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TEmployeePerformingServiceRegistry.
  GetEmployeeChargePerformingService: IEmployeeChargePerformingService;
begin

  Result :=
    IEmployeeChargePerformingService(
      FInternalRegistry.GetInterface(TEmployeeChargePerformingServiceType)
    );
    
end;

class function TEmployeePerformingServiceRegistry.
  GetInstance: TEmployeePerformingServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TEmployeePerformingServiceRegistry.Create;

  Result := FInstance;
  
end;

procedure TEmployeePerformingServiceRegistry.
  RegisterEmployeeChargePerformingService(
    EmployeeChargePerformingService: IEmployeeChargePerformingService
  );
begin

  FInternalRegistry.RegisterInterface(
    TEmployeeChargePerformingServiceType,
    EmployeeChargePerformingService
  );
  
end;

procedure TEmployeePerformingServiceRegistry.
  RegisterStandardEmployeeChargePerformingService;
begin

  RegisterEmployeeChargePerformingService(
    TStandardEmployeeChargePerformingService.Create(
      TEmployeeSubordinationServiceRegistry.Instance.GetEmployeeSubordinationService
    )
  );
  
end;

procedure TEmployeePerformingServiceRegistry.
  RegisterAllStandardEmployeePerformingServices;
begin

  RegisterStandardEmployeeChargePerformingService;
  
end;

end.
