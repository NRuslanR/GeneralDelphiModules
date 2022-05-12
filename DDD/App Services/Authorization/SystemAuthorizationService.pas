unit SystemAuthorizationService;

interface

uses

  ApplicationService;
  
type

  TSystemAuthorizationServiceException = class (TApplicationServiceException)

  end;
  
  ISystemAuthorizationService = interface (IApplicationService)
    ['{EEDD7C52-563E-4FF6-B994-89FF82ACC2A4}']
    
    function IsRoleAssignedToClient(
      const ClientIdentity: Variant;
      const RoleIdentity: Variant
    ): Boolean;

    procedure EnsureThatRoleAssignedToClient(
      const RoleIdentity: Variant;
      const ClientIdentity: Variant
    );
    
    procedure AssignRoleToClient(
      const RoleIdentity: Variant;
      const ClientIdentity: Variant
    );
    
  end;

implementation

end.
