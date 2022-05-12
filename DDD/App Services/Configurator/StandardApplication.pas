unit StandardApplication;

interface

uses

  Application,
  AbstractApplication,
  ApplicationServiceRegistries,
  ClientAccount,
  SysUtils,
  Classes;

type

  TStandardApplication = class (TAbstractApplication)

    private

      FClientAccount: TClientAccount;
      FServiceRegistries: IApplicationServiceRegistries;

    public

      constructor Create(ServiceRegistries: IApplicationServiceRegistries); overload;

      constructor Create(
        ClientAccount: TClientAccount;
        ServiceRegistries: IApplicationServiceRegistries
      ); overload;
      
      function GetApplicationServiceRegistries: IApplicationServiceRegistries; override;

      procedure SetApplicationServiceRegistries(
        Value: IApplicationServiceRegistries
      ); override;

      function GetClientAccount: TClientAccount; override;

      procedure SetClientAccount(ClientAccount: TClientAccount); override;

  end;

implementation

{ TStandardApplication }

constructor TStandardApplication.Create(
  ServiceRegistries: IApplicationServiceRegistries);
begin

  inherited Create;

  Self.ServiceRegistries := ServiceRegistries;
  
end;

constructor TStandardApplication.Create(ClientAccount: TClientAccount;
  ServiceRegistries: IApplicationServiceRegistries);
begin

  Create(ServiceRegistries);

  Self.ClientAccount := ClientAccount;
  
end;

function TStandardApplication.GetApplicationServiceRegistries: IApplicationServiceRegistries;
begin

  Result := FServiceRegistries;
  
end;

function TStandardApplication.GetClientAccount: TClientAccount;
begin

  Result := FClientAccount;
  
end;

procedure TStandardApplication.SetApplicationServiceRegistries(
  Value: IApplicationServiceRegistries);
begin

  FServiceRegistries := Value;

end;

procedure TStandardApplication.SetClientAccount(ClientAccount: TClientAccount);
begin

  if FClientAccount = ClientAccount then Exit;

  FreeAndNil(FClientAccount);

  FClientAccount := ClientAccount;
  
end;

end.
