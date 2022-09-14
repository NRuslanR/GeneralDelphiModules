unit StandardAreEmployeesSecretariesOfSameLeaderSpecification;

interface

uses

  AreEmployeesSecretariesOfSameLeaderSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardAreEmployeesSecretariesOfSameLeaderSpecification =
    class (
      TInterfacedObject,
      IAreEmployeesSecretariesOfSameLeaderSpecification
    )

      public

        function AreEmployeesSecretariesOfSameLeader(
          FirstEmployee: TEmployee;
          SecondEmployee: TEmployee
        ): Boolean; virtual;
      
    end;
    
implementation

{ TStandardAreEmployeesSecretariesOfSameLeaderSpecification }

function TStandardAreEmployeesSecretariesOfSameLeaderSpecification.
  AreEmployeesSecretariesOfSameLeader(
    FirstEmployee, SecondEmployee: TEmployee
  ): Boolean;
begin

  Result :=
    Assigned(FirstEmployee.TopLevelEmployee)
    and Assigned(SecondEmployee.TopLevelEmployee)
    and FirstEmployee.TopLevelEmployee.IsSameAs(SecondEmployee.TopLevelEmployee)
    and FirstEmployee.IsSecretaryForTopLevelEmployee
    and SecondEmployee.IsSecretaryForTopLevelEmployee;
    
end;

end.
