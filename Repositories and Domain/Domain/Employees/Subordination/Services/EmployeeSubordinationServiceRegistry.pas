unit EmployeeSubordinationServiceRegistry;

interface

uses

  TypeObjectRegistry,
  EmployeeSubordinationService,
  SysUtils;

type

  TEmployeeSubordinationServiceRegistry = class

    private

      class var FInstance: TEmployeeSubordinationServiceRegistry;

      class function GetInstance: TEmployeeSubordinationServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterEmployeeSubordinationService(
        EmployeeSubordinationService: IEmployeeSubordinationService
      );

      procedure RegisterStandardEmployeeSubordinationService;

      function GetEmployeeSubordinationService: IEmployeeSubordinationService;

    public

      procedure RegisterAllStandardEmployeeSubordinationServices;
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TEmployeeSubordinationServiceRegistry
      read GetInstance;
      
  end;

implementation

uses

  EmployeeSearchServiceRegistry,
  EmployeeDistributionServiceRegistry,
  StandardEmployeeSubordinationService;
  
type

  TEmployeeSubordinationServiceType = class

  end;
  
{ TEmployeeSubordinationServiceRegistry }

constructor TEmployeeSubordinationServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TEmployeeSubordinationServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TEmployeeSubordinationServiceRegistry.
  GetEmployeeSubordinationService: IEmployeeSubordinationService;
begin

  Result :=
    IEmployeeSubordinationService(
      FInternalRegistry.GetInterface(TEmployeeSubordinationServiceType)
    );
    
end;

class function TEmployeeSubordinationServiceRegistry.
  GetInstance: TEmployeeSubordinationServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TEmployeeSubordinationServiceRegistry.Create;

  Result := FInstance;
  
end;

procedure TEmployeeSubordinationServiceRegistry.
  RegisterEmployeeSubordinationService(
    EmployeeSubordinationService: IEmployeeSubordinationService
  );
begin

  FInternalRegistry.RegisterInterface(
    TEmployeeSubordinationServiceType,
    EmployeeSubordinationService
  );
  
end;

procedure TEmployeeSubordinationServiceRegistry.
  RegisterStandardEmployeeSubordinationService;
begin

  RegisterEmployeeSubordinationService(
    TStandardEmployeeSubordinationService.Create(
      TEmployeeSearchServiceRegistry.Instance.GetEmployeeFinder,
      TEmployeeSearchServiceRegistry.Instance.GetDepartmentFinder,
      TEmployeeDistributionServiceRegistry.Instance.GetWorkGroupEmployeeDistributionService
    )
  );

end;

procedure TEmployeeSubordinationServiceRegistry.
  RegisterAllStandardEmployeeSubordinationServices;
begin

  RegisterStandardEmployeeSubordinationService;

end;

end.
