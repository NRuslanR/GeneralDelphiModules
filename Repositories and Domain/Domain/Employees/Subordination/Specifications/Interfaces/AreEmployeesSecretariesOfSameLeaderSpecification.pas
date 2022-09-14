unit AreEmployeesSecretariesOfSameLeaderSpecification;

interface

uses

  Employee;

type

  IAreEmployeesSecretariesOfSameLeaderSpecification = interface
    ['{3D25E801-650B-47BC-B87D-789F1985034A}']
    
    function AreEmployeesSecretariesOfSameLeader(
      FirstEmployee: TEmployee;
      SecondEmployee: TEmployee
    ): Boolean;

  end;
  
implementation

end.
