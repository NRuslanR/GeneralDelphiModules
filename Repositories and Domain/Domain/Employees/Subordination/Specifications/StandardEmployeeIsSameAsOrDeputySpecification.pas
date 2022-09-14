unit StandardEmployeeIsSameAsOrDeputySpecification;

interface

uses

  Employee,
  EmployeeIsSameAsOrDeputySpecification,
  SysUtils,
  Classes;

type

  TStandardEmployeeIsSameOrDeputySpecification =
    class (TInterfacedObject, IEmployeeIsSameAsOrDeputySpecification)

    public

      function IsEmployeeSameAsOrDeputyForOther(
        TargetEmployee: TEmployee;
        OtherEmployee: TEmployee
      ): Boolean;

      function IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
        TargetEmployee: TEmployee;
        OtherEmployee: TEmployee
      ): Boolean;

  end;

implementation

{ TStandardEmployeeDeputyRule }
function TStandardEmployeeIsSameOrDeputySpecification.
  IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
begin

  Result :=
    IsEmployeeSameAsOrDeputyForOther(TargetEmployee, OtherEmployee)
    or IsEmployeeSameAsOrDeputyForOther(OtherEmployee, TargetEmployee);

end;

function TStandardEmployeeIsSameOrDeputySpecification.
  IsEmployeeSameAsOrDeputyForOther(
    TargetEmployee: TEmployee;
    OtherEmployee: TEmployee
  ): Boolean;
begin

  Result :=
    TargetEmployee.IsSameAs(OtherEmployee) or
    TargetEmployee.IsSubLeaderFor(OtherEmployee) or
    TargetEmployee.IsSubstitutesFor(OtherEmployee) or
    TargetEmployee.IsSecretarySignerFor(OtherEmployee);

end;


end.
