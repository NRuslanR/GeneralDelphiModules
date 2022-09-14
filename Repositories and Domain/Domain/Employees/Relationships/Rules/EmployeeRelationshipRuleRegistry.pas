unit EmployeeRelationshipRuleRegistry;

interface

uses

  EmployeeChargeIssuingRule,
  TypeObjectRegistry,
  SysUtils;

type

  TEmployeeRelationshipRuleRegistry = class

    private

      class var FInstance: TEmployeeRelationshipRuleRegistry;

      class function GetInstance: TEmployeeRelationshipRuleRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterEmployeeChargeIssuingRule(
        EmployeeChargeIssuingRule: IEmployeeChargeIssuingRule
      );

      procedure RegisterStandardEmployeeChargeIssuingRule;

      function GetEmployeeChargeIssuingRule: IEmployeeChargeIssuingRule;

    public

      procedure RegisterEmployeeRelationshipRules;
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TEmployeeRelationshipRuleRegistry
      read GetInstance;
      
  end;


implementation

uses

  StandardEmployeeChargeIssuingRule,
  EmployeeSubordinationServiceRegistry,
  EmployeeDistributionSpecificationRegistry;

type

  TEmployeeChargeIssuingRuleType = class

  end;

{ TEmployeeRelationshipRuleRegistry }

constructor TEmployeeRelationshipRuleRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TEmployeeRelationshipRuleRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TEmployeeRelationshipRuleRegistry.
  GetEmployeeChargeIssuingRule: IEmployeeChargeIssuingRule;
begin

  Result :=
    IEmployeeChargeIssuingRule(
      FInternalRegistry.GetInterface(
        TEmployeeChargeIssuingRuleType)
      );

end;

class function TEmployeeRelationshipRuleRegistry.GetInstance: TEmployeeRelationshipRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TEmployeeRelationshipRuleRegistry.Create;

  Result := FInstance;
  
end;

procedure TEmployeeRelationshipRuleRegistry.RegisterEmployeeChargeIssuingRule(
  EmployeeChargeIssuingRule: IEmployeeChargeIssuingRule);
begin

  FInternalRegistry.RegisterInterface(
    TEmployeeChargeIssuingRuleType,
    EmployeeChargeIssuingRule
  );
  
end;

procedure TEmployeeRelationshipRuleRegistry.RegisterEmployeeRelationshipRules;
begin

  RegisterStandardEmployeeChargeIssuingRule;
  
end;

procedure TEmployeeRelationshipRuleRegistry.
  RegisterStandardEmployeeChargeIssuingRule;
begin

  RegisterEmployeeChargeIssuingRule(
    TStandardEmployeeChargeIssuingRule.Create(
      TEmployeeSubordinationServiceRegistry.Instance.GetEmployeeSubordinationService,
      TEmployeeDistributionSpecificationRegistry.Instance.GetDepartmentEmployeeDistributionSpecification
    )
  );
  
end;

end.
