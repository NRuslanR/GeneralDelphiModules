unit SystemAdministrationService;

interface

uses

  ApplicationService,
  SystemAdministrationPrivileges,
  SystemAdministrationPrivilegeServices;
  
type

  TSystemAdministrationServiceException = class (TApplicationServiceException)

  end;
  
  ISystemAdministrationService = interface (IApplicationService)
    ['{664477B0-829F-42CF-80F7-EA2AD74D77DA}']
    
    function HasClientSystemAdministrationPrivileges(
      const ClientIdentity: Variant
    ): Boolean;
    
    function GetAllSystemAdministrationPrivileges(
      const ClientIdentity: Variant
    ): TSystemAdministrationPrivileges;

    function GetSystemAdministrationPrivilegeServices(
      const ClientIdentity: Variant;
      const PrivilegeIdentity: Variant
    ): TSystemAdministrationPrivilegeServices;
    
  end;

implementation

end.
