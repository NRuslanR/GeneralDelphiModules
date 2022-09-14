unit EmployeesRelationshipsRule;

interface

uses

  DomainException,
  Employee;

type

  TEmployeesRelationshipsRuleException = class (TDomainException)

  end;
  
  IEmployeesRelationshipsRule = interface

    function IsEmployeesRelationshipSatisfied(
      SubjectEmployee, ObjectEmployee: TEmployee
    ): Boolean;

    procedure EnsureThatEmployeesRelationshipSatisfied(
      SubjectEmployee, ObjectEmployee: TEmployee
    );

  end;

implementation

end.
