unit StandardEmployeeIsSecretaryForAnyOfEmployeesSpecification;

interface

uses

  EmployeeIsSecretaryForAnyOfEmployeesSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification =
    class (
      TInterfacedObject,
      IEmployeeIsSecretaryForAnyOfEmployeesSpecification
    )

      protected

        type

          TRelationshipDefiningMethod =
            function (
              TargetEmployee: TEmployee;
              OtherEmployee: TEmployee
            ): Boolean of object;

      protected

        function IsOtherEmployeeSecretaryForTarget(
          OtherEmployee: TEmployee;
          TargetEmployee: TEmployee
        ): Boolean;

        function IsEmployeeHasRelationshipWithOtherEmployees(
          TargetEmployee: TEmployee;
          OtherEmployees: TEmployees;
          RelationshipDefiningMethod: TRelationshipDefiningMethod
        ): TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult;
        
      public

        function IsEmployeeSecretaryForOther(
          TargetEmployee: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean;

        function IsEmployeeSecretaryForAnyOfEmployees(
          TargetEmployee: TEmployee;
          OtherEmployees: TEmployees
        ): TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult;

        function AreAnyOfEmployeesSecretaryForOtherEmployee(
          TargetEmployees: TEmployees;
          OtherEmployee: TEmployee
        ): TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult;

    end;
    
implementation

{ TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification }

function TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification.
  AreAnyOfEmployeesSecretaryForOtherEmployee(
    TargetEmployees: TEmployees;
    OtherEmployee: TEmployee
  ): TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult;
begin

  Result :=
    IsEmployeeHasRelationshipWithOtherEmployees(
      OtherEmployee, TargetEmployees, IsOtherEmployeeSecretaryForTarget
    );

end;

function TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification.
  IsEmployeeHasRelationshipWithOtherEmployees(
    TargetEmployee: TEmployee; OtherEmployees: TEmployees;
    RelationshipDefiningMethod: TRelationshipDefiningMethod
  ): TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult;
var OtherEmployee: TEmployee;
    SatisfyingEmployees: TEmployees;
    IsSatisfied: Boolean;
begin

  IsSatisfied := False;
  SatisfyingEmployees := TEmployees.Create;

  try

    for OtherEmployee in OtherEmployees do begin

      if RelationshipDefiningMethod(TargetEmployee, OtherEmployee)
      then begin

        IsSatisfied := True;

        SatisfyingEmployees.AddDomainObject(OtherEmployee);
        
      end;

    end;

    Result :=
      TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult.Create(
        IsSatisfied, SatisfyingEmployees
      );
      
  except

    on e: Exception do begin

      FreeAndNil(SatisfyingEmployees);
      raise;
      
    end;

  end;

end;

function TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification.
  IsEmployeeSecretaryForAnyOfEmployees(
    TargetEmployee: TEmployee;
    OtherEmployees: TEmployees
  ): TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult;
begin

  Result :=
    IsEmployeeHasRelationshipWithOtherEmployees(
      TargetEmployee, OtherEmployees, IsEmployeeSecretaryForOther
    );

end;

function TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification.
  IsEmployeeSecretaryForOther(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
begin

  Result := TargetEmployee.IsSecretaryFor(OtherEmployee);

end;

function TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification.
  IsOtherEmployeeSecretaryForTarget(
    OtherEmployee, TargetEmployee: TEmployee
  ): Boolean;
begin

  Result := OtherEmployee.IsSecretaryFor(TargetEmployee);
  
end;

end.
