unit StandardAreEmployeesSubLeadersOfSameLeaderSpecification;

interface

uses

  AreEmployeesSubLeadersOfSameLeaderSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardAreEmployeesSubLeadersOfSameLeaderSpecification =
    class (
      TInterfacedObject,
      IAreEmployeesSubLeadersOfSameLeaderSpecification
    )

      public

        function AreEmployeesSubLeadersOfSameLeader(
          FirstEmployee: TEmployee;
          SecondEmployee: TEmployee
        ): Boolean; virtual;

    end;


implementation

{ TStandardAreEmployeesSubLeadersOfSameLeaderSpecification }

function TStandardAreEmployeesSubLeadersOfSameLeaderSpecification.
  AreEmployeesSubLeadersOfSameLeader(
    FirstEmployee, SecondEmployee: TEmployee
  ): Boolean;
begin


  Result :=
    Assigned(FirstEmployee.TopLevelEmployee)
    and Assigned(SecondEmployee.TopLevelEmployee)
    and FirstEmployee.TopLevelEmployee.IsSameAs(SecondEmployee.TopLevelEmployee)
    and FirstEmployee.IsSubLeaderForTopLevelEmployee
    and SecondEmployee.IsSubLeaderForTopLevelEmployee;

end;

end.
