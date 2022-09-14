unit EmployeeSubordinationSpecificationRegistry;

interface

uses

  AreEmployeesSecretariesOfSameLeaderSpecification,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  EmployeeIsLeaderForOtherSpecification,
  EmployeeIsSameAsOrDeputySpecification,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  EmployeeIsSecretaryForAnyOfEmployeesSpecification,
  InMemoryObjectRegistry,
  SysUtils;

type

  TEmployeeSubordinationSpecificationRegistry = class

    private

      class var FInstance: TEmployeeSubordinationSpecificationRegistry;

      class function GetInstance: TEmployeeSubordinationSpecificationRegistry; static;

    private

      FInternalRegistry: TInMemoryObjectRegistry;

    public

      procedure RegisterAreEmployeesSecretariesOfSameLeaderSpecification(
        AreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification
      );

      procedure RegisterStandardAreEmployeesSecretariesOfSameLeaderSpecification;

      function GetAreEmployeesSecretariesOfSameLeaderSpecification:
        IAreEmployeesSecretariesOfSameLeaderSpecification;

    public

      procedure RegisterAreEmployeesSubLeadersOfSameLeaderSpecification(
        AreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification
      );

      procedure RegisterStandardAreEmployeesSubLeadersOfSameLeaderSpecification;

      function GetAreEmployeesSubLeadersOfSameLeaderSpecification:
        IAreEmployeesSubLeadersOfSameLeaderSpecification;

    public

      procedure RegisterEmployeeIsLeaderForOtherSpecification(
        EmployeeIsLeaderForOtherSpecification: IEmployeeIsLeaderForOtherSpecification
      );

      procedure RegisterStandardEmployeeIsLeaderForOtherSpecification;

      function GetEmployeeIsLeaderForOtherSpecification: IEmployeeIsLeaderForOtherSpecification;

    public

      procedure RegisterEmployeeIsSameAsOrDeputySpecification(
        EmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification
      );

      procedure RegisterStandardEmployeeIsSameAsOrDeputySpecification;

      function GetEmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification;

    public

      procedure RegisterEmployeeIsSecretaryForAnyOfEmployeesSpecification(
        EmployeeIsSecretaryForAnyOfEmployeesSpecification: IEmployeeIsSecretaryForAnyOfEmployeesSpecification
      );

      procedure RegisterStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification;

      function GetEmployeeIsSecretaryForAnyOfEmployeesSpecification:
        IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

    public

      procedure RegisterEmployeeIsSameAsOrDeputyOfEmployeesSpecification(
        EmployeeIsSameAsOrDeputyOfEmployeesSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification
      );

      procedure RegisterStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification;

      function GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification:
        IEmployeeIsSameAsOrReplacingForOthersSpecification;

    public

      procedure RegisterEmployeeIsSameAsOrReplacingSignerForOthersSpecification(
        EmployeeIsSameAsOrReplacingSignerForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification
      );

      procedure RegisterStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification;
      
      function GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;

    public

      procedure RegisterAllStandardEmployeeSubordinationSpecifications;
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TEmployeeSubordinationSpecificationRegistry
      read GetInstance;
      
  end;

implementation

uses

  TypInfo,
  AbstractObjectRegistry,
  StandardAreEmployeesSecretariesOfSameLeaderSpecification,
  StandardAreEmployeesSubLeadersOfSameLeaderSpecification,
  StandardEmployeeIsLeaderForOtherSpecification,
  StandardEmployeeIsSameAsOrDeputySpecification,
  StandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
  StandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
  StandardEmployeeIsSecretaryForAnyOfEmployeesSpecification,
  EmployeeSubordinationServiceRegistry;

type

  TEmployeeIsSameAsOrDeputyOfEmployeesSpecificationType = class

  end;

  TEmployeeIsSameAsOrReplacingSignerForOthersSpecificationType = class
  
  end;

{ TEmployeeSubordinationSpecificationRegistry }

constructor TEmployeeSubordinationSpecificationRegistry.Create;
begin

  inherited;

  FInternalRegistry := TInMemoryObjectRegistry.Create;
  
end;

destructor TEmployeeSubordinationSpecificationRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TEmployeeSubordinationSpecificationRegistry.
  GetAreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification;
begin

  Result :=
    IAreEmployeesSecretariesOfSameLeaderSpecification(
      FInternalRegistry.GetInterface(
        TObjectRegistryPointerKey.From(
          TypeInfo(IAreEmployeesSecretariesOfSameLeaderSpecification)
        )
      )
    );
    
end;

function TEmployeeSubordinationSpecificationRegistry.
  GetAreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;
begin

  Result :=
    IAreEmployeesSubLeadersOfSameLeaderSpecification(
      FInternalRegistry.GetInterface(
        TObjectRegistryPointerKey.From(
          TypeInfo(IAreEmployeesSubLeadersOfSameLeaderSpecification)
        )
      )
    );

end;

function TEmployeeSubordinationSpecificationRegistry.
  GetEmployeeIsLeaderForOtherSpecification:
    IEmployeeIsLeaderForOtherSpecification;
begin

  Result :=
    IEmployeeIsLeaderForOtherSpecification(
      FInternalRegistry.GetInterface(
        TObjectRegistryPointerKey.From(
          TypeInfo(IEmployeeIsLeaderForOtherSpecification)
        )
      )
    );
    
end;

function TEmployeeSubordinationSpecificationRegistry.
  GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;
begin

  Result :=
    IEmployeeIsSameAsOrReplacingForOthersSpecification(
      FInternalRegistry.GetInterface(
        TObjectRegistryClassKey.From(
          TEmployeeIsSameAsOrDeputyOfEmployeesSpecificationType
        )
      )
    );
    
end;

function TEmployeeSubordinationSpecificationRegistry.
  GetEmployeeIsSameAsOrDeputySpecification:
    IEmployeeIsSameAsOrDeputySpecification;
begin

  Result :=
    IEmployeeIsSameAsOrDeputySpecification(
      FInternalRegistry.GetInterface(
        TObjectRegistryPointerKey.From(
          TypeInfo(IEmployeeIsSameAsOrDeputySpecification)
        )
      )
    );
    
end;

function TEmployeeSubordinationSpecificationRegistry.
  GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;
begin

  Result :=
    IEmployeeIsSameAsOrReplacingForOthersSpecification(
      FInternalRegistry.GetInterface(
        TObjectRegistryClassKey.From(
          TEmployeeIsSameAsOrReplacingSignerForOthersSpecificationType
        )
      )
    );
    
end;

function TEmployeeSubordinationSpecificationRegistry.
  GetEmployeeIsSecretaryForAnyOfEmployeesSpecification:
    IEmployeeIsSecretaryForAnyOfEmployeesSpecification;
begin

  Result :=
    IEmployeeIsSecretaryForAnyOfEmployeesSpecification(
      FInternalRegistry.GetInterface(
        TObjectRegistryPointerKey.From(
          TypeInfo(IEmployeeIsSecretaryForAnyOfEmployeesSpecification)
        )
      )
    );
    
end;

class function TEmployeeSubordinationSpecificationRegistry.
  GetInstance: TEmployeeSubordinationSpecificationRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TEmployeeSubordinationSpecificationRegistry.Create;

  Result := FInstance;
  
end;

procedure TEmployeeSubordinationSpecificationRegistry.
  RegisterAreEmployeesSecretariesOfSameLeaderSpecification(
    AreEmployeesSecretariesOfSameLeaderSpecification: IAreEmployeesSecretariesOfSameLeaderSpecification
  );
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryPointerKey.From(
      TypeInfo(IAreEmployeesSecretariesOfSameLeaderSpecification)
    ),
    AreEmployeesSecretariesOfSameLeaderSpecification
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterAreEmployeesSubLeadersOfSameLeaderSpecification(
  AreEmployeesSubLeadersOfSameLeaderSpecification: IAreEmployeesSubLeadersOfSameLeaderSpecification);
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryPointerKey.From(
      TypeInfo(IAreEmployeesSubLeadersOfSameLeaderSpecification)
    ),
    AreEmployeesSubLeadersOfSameLeaderSpecification
  );
  
end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterEmployeeIsLeaderForOtherSpecification(
  EmployeeIsLeaderForOtherSpecification: IEmployeeIsLeaderForOtherSpecification);
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryPointerKey.From(
      TypeInfo(IEmployeeIsLeaderForOtherSpecification)
    ),
    EmployeeIsLeaderForOtherSpecification
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterEmployeeIsSameAsOrDeputyOfEmployeesSpecification(
  EmployeeIsSameAsOrDeputyOfEmployeesSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification);
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryClassKey.From(
      TEmployeeIsSameAsOrDeputyOfEmployeesSpecificationType
    ),
    EmployeeIsSameAsOrDeputyOfEmployeesSpecification
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterEmployeeIsSameAsOrDeputySpecification(
  EmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification);
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryPointerKey.From(
      TypeInfo(IEmployeeIsSameAsOrDeputySpecification)
    ),
    EmployeeIsSameAsOrDeputySpecification
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterEmployeeIsSameAsOrReplacingSignerForOthersSpecification(
  EmployeeIsSameAsOrReplacingSignerForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification);
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryClassKey.From(
      TEmployeeIsSameAsOrReplacingSignerForOthersSpecificationType
    ),
    EmployeeIsSameAsOrReplacingSignerForOthersSpecification
  );
  
end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterEmployeeIsSecretaryForAnyOfEmployeesSpecification(
  EmployeeIsSecretaryForAnyOfEmployeesSpecification: IEmployeeIsSecretaryForAnyOfEmployeesSpecification);
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryPointerKey.From(
      TypeInfo(IEmployeeIsSecretaryForAnyOfEmployeesSpecification)
    ),
    EmployeeIsSecretaryForAnyOfEmployeesSpecification
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterStandardAreEmployeesSecretariesOfSameLeaderSpecification;
begin

  RegisterAreEmployeesSecretariesOfSameLeaderSpecification(
    TStandardAreEmployeesSecretariesOfSameLeaderSpecification.Create
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.
  RegisterStandardAreEmployeesSubLeadersOfSameLeaderSpecification;
begin

  RegisterAreEmployeesSubLeadersOfSameLeaderSpecification(
    TStandardAreEmployeesSubLeadersOfSameLeaderSpecification.Create
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterStandardEmployeeIsLeaderForOtherSpecification;
begin

  RegisterEmployeeIsLeaderForOtherSpecification(
    TStandardEmployeeIsLeaderForOtherSpecification.Create(
      TEmployeeSubordinationServiceRegistry.Instance.GetEmployeeSubordinationService
    )
  );
  
end;

procedure TEmployeeSubordinationSpecificationRegistry.
  RegisterStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification;
begin

  RegisterEmployeeIsSameAsOrDeputyOfEmployeesSpecification(
    TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification.Create(
      GetEmployeeIsSameAsOrDeputySpecification
    )
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.
  RegisterStandardEmployeeIsSameAsOrDeputySpecification;
begin

  RegisterEmployeeIsSameAsOrDeputySpecification(
    TStandardEmployeeIsSameOrDeputySpecification.Create
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.
  RegisterStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification;
begin

  RegisterEmployeeIsSameAsOrReplacingSignerForOthersSpecification(
    TStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification
    )
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.
  RegisterStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification;
begin

  RegisterEmployeeIsSecretaryForAnyOfEmployeesSpecification(
    TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification.Create
  );

end;

procedure TEmployeeSubordinationSpecificationRegistry.RegisterAllStandardEmployeeSubordinationSpecifications;
begin

  RegisterStandardEmployeeIsSameAsOrDeputySpecification;
  RegisterStandardEmployeeIsLeaderForOtherSpecification;
  RegisterStandardAreEmployeesSubLeadersOfSameLeaderSpecification;
  RegisterStandardAreEmployeesSecretariesOfSameLeaderSpecification;
  RegisterStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification;
  RegisterStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification;
  RegisterStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification;
  
end;

end.
