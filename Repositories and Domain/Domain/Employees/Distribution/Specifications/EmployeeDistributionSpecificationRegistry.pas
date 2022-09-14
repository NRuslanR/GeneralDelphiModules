unit EmployeeDistributionSpecificationRegistry;

interface

uses

  DepartmentEmployeeDistributionSpecification,
  EmployeesWorkGroupMembershipSpecification,
  WorkspaceEmployeeDistributionSpecification,
  TypeObjectRegistry,
  SysUtils;

type

  TEmployeeDistributionSpecificationRegistry = class

    private

      class var FInstance: TEmployeeDistributionSpecificationRegistry;

      class function GetInstance: TEmployeeDistributionSpecificationRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDepartmentEmployeeDistributionSpecification(
        DepartmentEmployeeDistributionSpecification:
          IDepartmentEmployeeDistributionSpecification
      );

      procedure RegisterStandardDepartmentEmployeeDistributionSpecification;

      function GetDepartmentEmployeeDistributionSpecification:
        IDepartmentEmployeeDistributionSpecification;

    public

      procedure RegisterEmployeesWorkGroupMembershipSpecification(
        EmployeesWorkGroupMembershipSpecification:
          IEmployeesWorkGroupMembershipSpecification
      );

      procedure RegisterStandardEmployeesWorkGroupMembershipSpecification;

      function GetEmployeesWorkGroupMembershipSpecification:
        IEmployeesWorkGroupMembershipSpecification;

    public

      procedure RegisterWorkspaceEmployeeDistributionSpecification(
        WorkspaceEmployeeDistributionSpecification:
          IWorkspaceEmployeeDistributionSpecification
      );

      procedure RegisterStandardWorkspaceEmployeeDistributionSpecification;

      function GetWorkspaceEmployeeDistributionSpecification:
        IWorkspaceEmployeeDistributionSpecification;

    public

      procedure RegisterAllStandardEmployeeDistributionSpecifications;

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TEmployeeDistributionSpecificationRegistry
      read GetInstance;
        
  end;

implementation

uses

  EmployeeSearchServiceRegistry,
  EmployeeDistributionServiceRegistry,
  StandardDepartmentEmployeeDistributionSpecification,
  StandardEmployeesWorkGroupMembershipSpecification,
  StandardWorkspaceEmployeeDistributionSpecification;

type

  TDepartmentEmployeeDistributionSpecificationType = class

  end;

  TEmployeesWorkGroupMembershipSpecificationType = class

  end;

  TWorkspaceEmployeeDistributionSpecificationType = class

  end;
  
{ TEmployeeDistributionSpecificationRegistry }

constructor TEmployeeDistributionSpecificationRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TEmployeeDistributionSpecificationRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TEmployeeDistributionSpecificationRegistry.
  GetDepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification;
begin

  Result :=
    IDepartmentEmployeeDistributionSpecification(
      FInternalRegistry.GetInterface(
        TDepartmentEmployeeDistributionSpecificationType
      )
    );

end;

function TEmployeeDistributionSpecificationRegistry.
  GetEmployeesWorkGroupMembershipSpecification: IEmployeesWorkGroupMembershipSpecification;
begin

  Result :=
    IEmployeesWorkGroupMembershipSpecification(
      FInternalRegistry.GetInterface(
        TEmployeesWorkGroupMembershipSpecificationType
      )
    );
    
end;

class function TEmployeeDistributionSpecificationRegistry.
  GetInstance: TEmployeeDistributionSpecificationRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TEmployeeDistributionSpecificationRegistry.Create;

  Result := FInstance;
  
end;

function TEmployeeDistributionSpecificationRegistry.
  GetWorkspaceEmployeeDistributionSpecification: IWorkspaceEmployeeDistributionSpecification;
begin

  Result :=
    IWorkspaceEmployeeDistributionSpecification(
      FInternalRegistry.GetInterface(
        TWorkspaceEmployeeDistributionSpecificationType
      )
    );

end;

procedure TEmployeeDistributionSpecificationRegistry.
  RegisterAllStandardEmployeeDistributionSpecifications;
begin

  RegisterStandardDepartmentEmployeeDistributionSpecification;
  RegisterStandardWorkspaceEmployeeDistributionSpecification;
  RegisterStandardEmployeesWorkGroupMembershipSpecification;

end;

procedure TEmployeeDistributionSpecificationRegistry.
  RegisterDepartmentEmployeeDistributionSpecification(
    DepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification
  );
begin

  FInternalRegistry.RegisterInterface(
    TDepartmentEmployeeDistributionSpecificationType,
    DepartmentEmployeeDistributionSpecification
  );
  
end;

procedure TEmployeeDistributionSpecificationRegistry.
  RegisterEmployeesWorkGroupMembershipSpecification(
    EmployeesWorkGroupMembershipSpecification: IEmployeesWorkGroupMembershipSpecification
  );
begin

  FInternalRegistry.RegisterInterface(
    TEmployeesWorkGroupMembershipSpecificationType,
    EmployeesWorkGroupMembershipSpecification
  );

end;

procedure TEmployeeDistributionSpecificationRegistry.
  RegisterStandardDepartmentEmployeeDistributionSpecification;
begin

  RegisterDepartmentEmployeeDistributionSpecification(
    TStandardDepartmentEmployeeDistributionSpecification.Create(
      TEmployeeSearchServiceRegistry.Instance.GetDepartmentFinder
    )
  );
  
end;

procedure TEmployeeDistributionSpecificationRegistry.
  RegisterStandardEmployeesWorkGroupMembershipSpecification;
begin

  RegisterEmployeesWorkGroupMembershipSpecification(
    TStandardEmployeesWorkGroupMembershipSpecification.Create(
      TEmployeeDistributionServiceRegistry.Instance.GetWorkGroupEmployeeDistributionService
    )
  );
  
end;

procedure TEmployeeDistributionSpecificationRegistry.
  RegisterStandardWorkspaceEmployeeDistributionSpecification;
begin

  RegisterWorkspaceEmployeeDistributionSpecification(
    TStandardWorkspaceEmployeeDistributionSpecification.Create(
      TEmployeeSearchServiceRegistry.Instance.GetEmployeeFinder
    )
  );
  
end;

procedure TEmployeeDistributionSpecificationRegistry.
  RegisterWorkspaceEmployeeDistributionSpecification(
    WorkspaceEmployeeDistributionSpecification: IWorkspaceEmployeeDistributionSpecification
  );
begin

  FInternalRegistry.RegisterInterface(
    TWorkspaceEmployeeDistributionSpecificationType,
    WorkspaceEmployeeDistributionSpecification
  );

end;

end.
