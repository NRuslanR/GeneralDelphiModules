unit StandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification;

interface

uses

  EmployeeIsSameAsOrReplacingForOthersSpecification,
  StandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification =
    class (TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification)

      protected

        function InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
          TargetEmployee: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean; override;

      public

    end;

implementation

{ TStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification }

function TStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification.
  InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
begin

  Result :=
    inherited InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
      TargetEmployee, OtherEmployee
    ) or
    TargetEmployee.IsSecretarySignerFor(OtherEmployee);

end;

end.
