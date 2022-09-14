unit AreEmployeesSubLeadersOfSameLeaderSpecification;

interface

uses

  Employee;

type

  IAreEmployeesSubLeadersOfSameLeaderSpecification = interface
    ['{9CCA79DA-CB3A-43C1-94B7-E3865DCEB5B1}']
    
    function AreEmployeesSubLeadersOfSameLeader(
      FirstEmployee: TEmployee;
      SecondEmployee: TEmployee
    ): Boolean;
    
  end;

implementation

end.
