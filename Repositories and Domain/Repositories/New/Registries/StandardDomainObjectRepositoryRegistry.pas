unit StandardDomainObjectRepositoryRegistry;

interface

uses

  DomainObjectRepositoryRegistry,
  TypeObjectRegistry,
  DomainObjectUnit,
  DomainObjectRepository,
  Session,
  PostgresTransaction,
  SysUtils;

type

  TStandardDomainObjectRepositoryRegistry =
    class (TInterfacedObject, IDomainObjectRepositoryRegistry)

      private

        FInternalRegistry: TTypeObjectRegistry;
        
      public

        constructor Create;
        destructor Destroy; override;

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

type

  TSessionType = class

  end;

{ TStandardDomainObjectRepositoryRegistry }

constructor TStandardDomainObjectRepositoryRegistry.Create;
begin

  inherited Create;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

end;

destructor TStandardDomainObjectRepositoryRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);

  inherited Destroy;

end;


procedure TStandardDomainObjectRepositoryRegistry.Clear;
begin

  FInternalRegistry.Clear;

end;

function TStandardDomainObjectRepositoryRegistry.GetDomainObjectRepository(
  DomainObjectClass: TDomainObjectClass): IDomainObjectRepository;
begin

  Result :=
    IDomainObjectRepository(FInternalRegistry.GetInterface(DomainObjectClass));

end;

function TStandardDomainObjectRepositoryRegistry.GetSessionManager: ISession;
begin

  Result := ISession(FInternalRegistry.GetInterface(TSessionType));

end;

procedure TStandardDomainObjectRepositoryRegistry.RegisterDomainObjectRepository(
  DomainObjectClass: TDomainObjectClass;
  DomainObjectRepository: IDomainObjectRepository);
begin

  FInternalRegistry.RegisterInterface(DomainObjectClass, DomainObjectRepository);

end;

procedure TStandardDomainObjectRepositoryRegistry.RegisterSessionManager(
  Session: ISession);
begin

  FInternalRegistry.RegisterInterface(TSessionType, Session);
  
end;

end.
