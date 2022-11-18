unit DepartmentFinder;

interface

uses

  Department;

type

  IDepartmentFinder = interface

    function FindDepartmentByCode(const Code: String): TDepartment;
    function FindDepartment(const DepartmentId: Variant): TDepartment;
    function FindHeadKindredDepartmentForInnerDepartment(const InnerDepartmentId: Variant): TDepartment;

    function FindAllDepartmentsBeginningWith(
      const TargetDepartmentId: Variant
    ): TDepartments;

    function FindAllKindredDepartmentsBeginningWith(
      const TargetDepartmentId: Variant
    ): TDepartments;

    function FindAllNotKindredInnerDepartmentsForDepartment(
      const TargetDepartmentId: Variant
    ): TDepartments;
    
  end;
  
implementation

end.
