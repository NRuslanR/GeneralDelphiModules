unit FullSuccessedStubSystemAuthorizationService;

interface

uses

  SystemAuthorizationService,
  SysUtils;

type

  TFullSuccessedStubSystemAuthorizationService =
    class (TInterfacedObject, ISystemAuthorizationService)

      public

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

{ TFullSuccessedStubSystemAuthorizationService }

procedure TFullSuccessedStubSystemAuthorizationService.AssignRoleToClient(
  const RoleIdentity, ClientIdentity: Variant);
begin


end;

procedure TFullSuccessedStubSystemAuthorizationService.EnsureThatRoleAssignedToClient(
  const RoleIdentity, ClientIdentity: Variant);
begin

end;

function TFullSuccessedStubSystemAuthorizationService.IsRoleAssignedToClient(
  const ClientIdentity, RoleIdentity: Variant): Boolean;
begin

  Result := True;
  
end;

end.
