unit EmployeeChargeIssuingRule;

interface

uses

  EmployeesRelationshipsRule,
  Employee;

type

  TEmployeeChargeIssuingRuleException = class (TEmployeesRelationshipsRuleException)
  
  end;

  IEmployeeChargeIssuingRule = interface (IEmployeesRelationshipsRule)

    function IsEmployeeMayIssueChargeToOtherEmployee(
      SubjectEmployee, ObjectEmployee: TEmployee
    ): Boolean;
    
    procedure EnsureThatEmployeeMayIssueChargeToOtherEmployee(
      SubjectEmployee, ObjectEmployee: TEmployee
    );
    
  end;

implementation

end.
