unit EmployeeDistributionServiceRegistry;

interface

uses

  TypeObjectRegistry,
  DepartmentEmployeeDistributionService,
  WorkGroupEmployeeDistributionService,
  SysUtils;

type

  TEmployeeDistributionServiceRegistry = class

    private

      class var FInstance: TEmployeeDistributionServiceRegistry;

      class function GetInstance: TEmployeeDistributionServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDepartmentEmployeeDistributionService(
        DepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService
      );

      procedure RegisterStandardDepartmentEmployeeDistributionService;

      function GetDepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService;

    public

      procedure RegisterWorkGroupEmployeeDistributionService(
        WorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService
      );

      procedure RegisterStandardWorkGroupEmployeeDistributionService;

      function GetWorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService;

    public

      procedure RegisterAllStandardEmployeeDistributionServices;
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TEmployeeDistributionServiceRegistry
      read GetInstance;

  end;

implementation

uses

  EmployeeSearchServiceRegistry,
  StandardDepartmentEmployeeDistributionService,
  StandardWorkGroupEmployeeDistributionService;

type

  TDepartmentEmployeeDistributionServiceType = class

  end;

  TWorkGroupEmployeeDistributionServiceType = class
  
  end;

{ TEmployeeDistributionServiceRegistry }

constructor TEmployeeDistributionServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TEmployeeDistributionServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);

  inherited;

end;

function TEmployeeDistributionServiceRegistry.
  GetDepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService;
begin

  Result :=
    IDepartmentEmployeeDistributionService(
      FInternalRegistry.GetInterface(
        TDepartmentEmployeeDistributionServiceType
      )
    );

end;

class function TEmployeeDistributionServiceRegistry.
  GetInstance: TEmployeeDistributionServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TEmployeeDistributionServiceRegistry.Create;

  Result := FInstance;

end;

function TEmployeeDistributionServiceRegistry.
  GetWorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService;
begin

  Result :=
    IWorkGroupEmployeeDistributionService(
      FInternalRegistry.GetInterface(TWorkGroupEmployeeDistributionServiceType)
    );
    
end;

procedure TEmployeeDistributionServiceRegistry.
  RegisterDepartmentEmployeeDistributionService(
    DepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService
  );
begin

  FInternalRegistry.RegisterInterface(
    TDepartmentEmployeeDistributionServiceType,
    DepartmentEmployeeDistributionService
  );

end;

procedure TEmployeeDistributionServiceRegistry.
  RegisterStandardDepartmentEmployeeDistributionService;
begin

  RegisterDepartmentEmployeeDistributionService(
    TStandardDepartmentEmployeeDistributionService.Create(
      TEmployeeSearchServiceRegistry.Instance.GetDepartmentFinder
    )
  );
  
end;

procedure TEmployeeDistributionServiceRegistry.RegisterAllStandardEmployeeDistributionServices;
begin

  RegisterStandardDepartmentEmployeeDistributionService;
  RegisterStandardWorkGroupEmployeeDistributionService;
  
end;

procedure TEmployeeDistributionServiceRegistry.
  RegisterStandardWorkGroupEmployeeDistributionService;
begin

  RegisterWorkGroupEmployeeDistributionService(
    TStandardWorkGroupEmployeeDistributionService.Create(
      TEmployeeSearchServiceRegistry.Instance.GetEmployeeFinder,
      TEmployeeSearchServiceRegistry.Instance.GetEmployeesWorkGroupFinder
    )
  );
  
end;

procedure TEmployeeDistributionServiceRegistry.
  RegisterWorkGroupEmployeeDistributionService(
    WorkGroupEmployeeDistributionService: IWorkGroupEmployeeDistributionService
  );
begin

  FInternalRegistry.RegisterInterface(
    TWorkGroupEmployeeDistributionServiceType,
    WorkGroupEmployeeDistributionService
  );
  
end;

end.
