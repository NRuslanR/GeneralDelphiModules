unit EmployeeSearchServiceRegistry;

interface

uses

  EmployeeFinder,
  DepartmentFinder,
  EmployeesWorkGroupFinder,
  TypeObjectRegistry,
  SysUtils;

type

  TEmployeeSearchServiceRegistry = class

    private

      class var FInstance: TEmployeeSearchServiceRegistry;

      class function GetInstance: TEmployeeSearchServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      destructor Destroy; override;
      constructor Create;

    public

      procedure RegisterEmployeeFinder(EmployeeFinder: IEmployeeFinder);

      function GetEmployeeFinder: IEmployeeFinder;

    public

      procedure RegisterDepartmentFinder(DepartmentFinder: IDepartmentFinder);

      function GetDepartmentFinder: IDepartmentFinder;

    public

      procedure RegisterEmployeesWorkGroupFinder(
        EmployeesWorkGroupFinder: IEmployeesWorkGroupFinder
      );

      function GetEmployeesWorkGroupFinder: IEmployeesWorkGroupFinder;

    public

      class property Instance: TEmployeeSearchServiceRegistry
      read GetInstance;

  end;

implementation

type

  TEmployeeFinderType = class

  end;

  TDepartmentFinderType = class

  end;

  TEmployeesWorkGroupFinderType = class
  
  end;

{ TEmployeeSearchServiceRegistry }

constructor TEmployeeSearchServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TEmployeeSearchServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TEmployeeSearchServiceRegistry.
  GetDepartmentFinder: IDepartmentFinder;
begin

  Result :=
    IDepartmentFinder(
      FInternalRegistry.GetInterface(TDepartmentFinderType)
    );

end;

function TEmployeeSearchServiceRegistry.
  GetEmployeeFinder: IEmployeeFinder;
begin

  Result :=
    IEmployeeFinder(
      FInternalRegistry.GetInterface(TEmployeeFinderType)
    );

end;

function TEmployeeSearchServiceRegistry.
  GetEmployeesWorkGroupFinder: IEmployeesWorkGroupFinder;
begin

  Result :=
    IEmployeesWorkGroupFinder(
      FInternalRegistry.GetInterface(TEmployeesWorkGroupFinderType)
    );
    
end;

class function TEmployeeSearchServiceRegistry.
  GetInstance: TEmployeeSearchServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TEmployeeSearchServiceRegistry.Create;

  Result := FInstance;

end;

procedure TEmployeeSearchServiceRegistry.RegisterDepartmentFinder(
  DepartmentFinder: IDepartmentFinder);
begin

  FInternalRegistry.RegisterInterface(
    TDepartmentFinderType,
    DepartmentFinder
  );
  
end;

procedure TEmployeeSearchServiceRegistry.RegisterEmployeeFinder(
  EmployeeFinder: IEmployeeFinder);
begin

  FInternalRegistry.RegisterInterface(
    TEmployeeFinderType,
    EmployeeFinder
  );
  
end;

procedure TEmployeeSearchServiceRegistry.RegisterEmployeesWorkGroupFinder(
  EmployeesWorkGroupFinder: IEmployeesWorkGroupFinder);
begin

  FInternalRegistry.RegisterInterface(
    TEmployeesWorkGroupFinderType,
    EmployeesWorkGroupFinder
  );
  
end;

end.
