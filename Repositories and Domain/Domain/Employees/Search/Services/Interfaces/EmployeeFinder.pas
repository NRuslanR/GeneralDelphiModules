unit EmployeeFinder;

interface

uses

  Employee,
  IGetSelfUnit,
  VariantListUnit;

type

  IEmployeeFinder = interface

    function FindLeaderByDepartmentId(const DepartmentId: Variant): TEmployee;
    function FindLeaderByDepartmentCode(const DepartmentCode: String): TEmployee;
    function FindEmployee(const EmployeeId: Variant): TEmployee;
    function FindEmployees(const Identities: TVariantList): TEmployees;

    function FindAllTopLevelEmployeesForEmployee(const EmployeeId: Variant): TEmployees;

    function FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
      const EmployeeId: Variant
    ): TEmployees;

  end;
  
implementation

end.
