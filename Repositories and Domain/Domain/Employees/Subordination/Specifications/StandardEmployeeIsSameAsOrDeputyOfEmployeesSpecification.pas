unit StandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification;

interface

uses

  AbstractEmployeeIsSameAsOrReplacingForOthersSpecification,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  EmployeeIsSameAsOrDeputySpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification =
    class (TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification)

      protected

        FEmployeeIsSameAsOrDeputySpecification:
          IEmployeeIsSameAsOrDeputySpecification;

        function InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
          TargetEmployee: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean; override;

      public

        constructor Create(
          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification
        );

    end;

implementation

uses

  DocumentSignings,
  AuxDebugFunctionsUnit;

{ TStandardEmployeeIsDocumentSignerOrHisDeputySpecification }

constructor TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification.Create(
  EmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification
);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputySpecification :=
    EmployeeIsSameAsOrDeputySpecification;

end;


function TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification.
  InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
begin

  Result :=
    FEmployeeIsSameAsOrDeputySpecification.IsEmployeeSameAsOrDeputyForOther(
      TargetEmployee, OtherEmployee
    );
    
end;

end.
