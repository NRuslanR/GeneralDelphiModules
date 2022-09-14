unit StandardEmployeeChargeIssuingRule;

interface

uses

  EmployeesRelationshipsRule,
  EmployeeChargeIssuingRule,
  EmployeeSubordinationService,
  DepartmentEmployeeDistributionSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeChargeIssuingRule =
    class (
      TInterfacedObject,
      IEmployeeChargeIssuingRule,
      IEmployeesRelationshipsRule
    )

      protected

        FEmployeeSubordinationService: IEmployeeSubordinationService;
        FDepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification;
        
        function AreSubjectAndObjectEmployeesBelongsToSameHeadKindredDepartment(
          SubjectEmployee, ObjectEmployee: TEmployee
        ): Boolean;
        
      public

        function IsEmployeesRelationshipSatisfied(
          SubjectEmployee, ObjectEmployee: TEmployee
        ): Boolean; virtual;

        procedure EnsureThatEmployeesRelationshipSatisfied(
          SubjectEmployee, ObjectEmployee: TEmployee
        ); virtual;

      public

        function IsEmployeeMayIssueChargeToOtherEmployee(
          SubjectEmployee, ObjectEmployee: TEmployee
        ): Boolean; virtual;

        procedure EnsureThatEmployeeMayIssueChargeToOtherEmployee(
          SubjectEmployee, ObjectEmployee: TEmployee
        ); virtual;

      public

        constructor Create(
          EmployeeSubordinationService: IEmployeeSubordinationService;
          DepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification
        );

    end;


implementation

uses

  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TStandardEmployeeChargeIssuingRule }

function TStandardEmployeeChargeIssuingRule.AreSubjectAndObjectEmployeesBelongsToSameHeadKindredDepartment(
  SubjectEmployee, ObjectEmployee: TEmployee): Boolean;
var
    VerifiableEmployees: TEmployees;
    FreeVerifiableEmployees: IDomainObjectBaseList;
begin

  VerifiableEmployees := TEmployees.Create;

  FreeVerifiableEmployees := VerifiableEmployees;

  VerifiableEmployees.Add(SubjectEmployee);
  VerifiableEmployees.Add(ObjectEmployee);

  Result :=
    FDepartmentEmployeeDistributionSpecification
      .AreEmployeesBelongsToSameHeadKindredDepartment(
        VerifiableEmployees
      );

end;

constructor TStandardEmployeeChargeIssuingRule.Create(
  EmployeeSubordinationService: IEmployeeSubordinationService;
  DepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification
);
begin

  inherited Create;

  FEmployeeSubordinationService := EmployeeSubordinationService;
  FDepartmentEmployeeDistributionSpecification := DepartmentEmployeeDistributionSpecification;
  
end;

procedure TStandardEmployeeChargeIssuingRule.
  EnsureThatEmployeeMayIssueChargeToOtherEmployee(
    SubjectEmployee, ObjectEmployee: TEmployee
  );
begin

  EnsureThatEmployeesRelationshipSatisfied(SubjectEmployee, ObjectEmployee);

end;

function TStandardEmployeeChargeIssuingRule.IsEmployeeMayIssueChargeToOtherEmployee(
  SubjectEmployee, ObjectEmployee: TEmployee): Boolean;
begin

  Result := IsEmployeesRelationshipSatisfied(SubjectEmployee, ObjectEmployee);
  
end;

procedure TStandardEmployeeChargeIssuingRule.                                                 
  EnsureThatEmployeesRelationshipSatisfied(
    SubjectEmployee, ObjectEmployee: TEmployee
  );
begin

  if 
    AreSubjectAndObjectEmployeesBelongsToSameHeadKindredDepartment(
      SubjectEmployee, ObjectEmployee
    ) 
  then Exit;

  if SubjectEmployee.IsInAnyOfWorkGroups(ObjectEmployee.WorkGroupIds)
  then Exit;

  if
    not
    FEmployeeSubordinationService.
      IsEmployeeDepartmentSubordinatedToOtherEmployeeDepartment(
        ObjectEmployee, SubjectEmployee
      )
  then begin

    raise TEmployeeChargeIssuingRuleException.CreateFmt(
      'Сотрудник "%s" не может выдать поручение ' +
      'сотруднику "%s", поскольку ' +
      'подразделение последнего не входит в ' +
      'подчинение подразделения первого',
      [
        SubjectEmployee.FullName,
        ObjectEmployee.FullName
      ]
    );

  end;

end;

function TStandardEmployeeChargeIssuingRule.
  IsEmployeesRelationshipSatisfied(
    SubjectEmployee, ObjectEmployee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeesRelationshipSatisfied(SubjectEmployee, ObjectEmployee);

    Result := True;
    
  except

    Result := False;

  end;

end;

end.
