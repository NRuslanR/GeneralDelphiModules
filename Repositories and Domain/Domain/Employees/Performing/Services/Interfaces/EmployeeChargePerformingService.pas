unit EmployeeChargePerformingService;

interface

uses

  Employee,
  EmployeeChargePerformingUnit;

type

  IEmployeeChargePerformingService = interface

    function FindChargePerformingUnitForEmployeeLeader(Employee: TEmployee): TEmployeeChargePerformingUnit;
    function FindSubordinateChargePerformingUnitForEmployee(Employee: TEmployee): TEmployeeChargePerformingUnit;

    function FindKindredChargePerformingUnitForEmployeeLeader(Employee: TEmployee): TEmployeeChargePerformingUnit;
    function FindSubordinateKindredChargePerformingUnitForEmployee(Employee: TEmployee): TEmployeeChargePerformingUnit;
    
  end;
  
implementation

end.
