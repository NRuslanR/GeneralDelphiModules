unit BaseDepartmentRepository;

interface

uses

  DomainObjectRepository,
  Department,
  VariantListUnit,
  SysUtils;

type

  TBaseDepartmentRepositoryException = class (Exception)

  end;

  IBaseDepartmentRepository = interface (IDomainObjectRepository)

    function LoadAllDepartments: TDepartments;
    function FindDepartmentById(const Id: Variant): TDepartment;
    function FindDepartmentsByIds(const Ids: TVariantList): TDepartments;

    function IsDepartmentIncludesOtherDepartment(
      const TargetDepartmentId, OtherDepartmentId: Variant
    ): Boolean;

    function FindDepartmentByCode(const Code: String): TDepartment;

    function FindAllDepartmentsBeginningWith(
      const TargetDepartmentId: Variant
    ): TDepartments;

    function FindHeadDepartmentForGivenDepartment(
      const DepartmentId: Variant
    ): TDepartment;

    procedure AddDepartment(Department: TDepartment);
    procedure UpdateDepartment(Department: TDepartment);
    procedure RemoveDepartment(Department: TDepartment);

  end;
  
implementation

end.
