unit RoleRepository;

interface

uses

  Role,
  VariantListUnit,
  Employee,
  SysUtils;

type

  TRoleRepositoryException = class (Exception)

  end;
  
  IRoleRepository = interface

    procedure AddRoleForEmployee(Employee: TEmployee);
    procedure RemoveAllRolesForEmployee(Employee: TEmployee);
    function FindRolesForEmployee(Employee: TEmployee): TRoleList;
    function FindRoleById(const Id: Variant): TRole;
    function FindRolesByIds(const Ids: TVariantList): TRoleList;
    function FindRoleByName(const RoleName: String): TRole;
    function LoadAllRoles: TRoleList;

  end;

implementation

end.
