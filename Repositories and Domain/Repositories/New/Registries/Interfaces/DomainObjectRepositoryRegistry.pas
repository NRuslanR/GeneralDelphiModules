unit DomainObjectRepositoryRegistry;

interface

uses

  Session,
  DomainObjectUnit,
  DomainObjectRepository;

type

  IDomainObjectRepositoryRegistry = interface
    ['{85B9160F-0B00-4A21-AD38-27ACE03C8A23}']

    procedure Clear;

    procedure RegisterSessionManager(Session: ISession);

    function GetSessionManager: ISession;
    
    procedure RegisterDomainObjectRepository(
      DomainObjectClass: TDomainObjectClass;
      DomainObjectRepository: IDomainObjectRepository
    );

    function GetDomainObjectRepository(
      DomainObjectClass: TDomainObjectClass
    ): IDomainObjectRepository;
    
  end;
  
implementation

end.
