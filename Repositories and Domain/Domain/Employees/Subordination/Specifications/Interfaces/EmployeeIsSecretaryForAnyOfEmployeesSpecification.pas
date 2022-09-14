unit EmployeeIsSecretaryForAnyOfEmployeesSpecification;

interface

uses

  Employee,
  SysUtils,
  Classes;

type

  TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult = class

    private

      FIsSatisfied: Boolean;
      FEmployees: TEmployees;

    public

      destructor Destroy; override;
      constructor Create(
        const IsSatisfied: Boolean;
        Employees: TEmployees
      );

    published

      property IsSatisfied: Boolean read FIsSatisfied;
      property Employees: TEmployees read FEmployees;
      
  end;

  IEmployeeIsSecretaryForAnyOfEmployeesSpecification = interface
    ['{24C6FB08-7472-47C9-A4C9-3DCB0DE8855A}']
    
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

{ TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult }

constructor TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult.Create(
  const IsSatisfied: Boolean; Employees: TEmployees);
begin

  inherited Create;

  FIsSatisfied := IsSatisfied;
  FEmployees := Employees;
  
end;

destructor TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult.Destroy;
begin

  FreeAndNil(FEmployees);
  
  inherited;

end;

end.
