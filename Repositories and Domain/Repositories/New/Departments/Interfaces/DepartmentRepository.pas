unit DepartmentRepository;

interface

uses

  BaseDepartmentRepository,
  Department;

type

  TDepartmentRepositoryException = class (TBaseDepartmentRepositoryException)

  end;
  
  IDepartmentRepository = interface (IBaseDepartmentRepository)

    function FindAllKindredDepartmentsBeginningWith(
      const TargetDepartmentId: Variant
    ): TDepartments;

    function FindAllNotKindredInnerDepartmentsForDepartment(
      const TargetDepartmentId: Variant
    ): TDepartments;
    
    function FindHeadKindredDepartmentForGivenDepartment(
      const DepartmentId: Variant
    ): TDepartment;

  end;
  
implementation

end.
