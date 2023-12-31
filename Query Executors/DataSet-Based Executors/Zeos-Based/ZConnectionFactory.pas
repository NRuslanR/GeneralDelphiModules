unit ZConnectionFactory;

interface

uses

  ConnectionInfo,
  AbstractConnectionFactory,
  ZConnection,
  SysUtils,
  Classes;

type

  TZConnectionFactory = class (TAbstractConnectionFactory)

    private

      FProtocol: String;
      FClientCodePage: String;
      
    public

      constructor Create(
        const Protocol: String;
        const ClientCodePage: String = ''
      );
      
      function CreateConnection(ConnectionInfo: TConnectionInfo): TObject;
        override;

  end;

implementation

uses

  StrUtils,
  AuxZeosFunctions;

{ TZConnectionFactory }

constructor TZConnectionFactory.Create(const Protocol, ClientCodePage: String);
begin

  inherited Create;

  FProtocol := Protocol;

  FClientCodePage :=
    IfThen(Trim(ClientCodePage) <> '', ClientCodePage, 'WIN1251');

end;

function TZConnectionFactory.CreateConnection(
  ConnectionInfo: TConnectionInfo): TObject;
var ZConnection: TZConnection;
begin

  ZConnection :=
    AuxZeosFunctions.CreateConnection(
      ConnectionInfo.HostName,
      ConnectionInfo.Port,
      ConnectionInfo.DatabaseName,
      ConnectionInfo.UserName,
      ConnectionInfo.Password,
      FProtocol,
      False
    );

  try

    ZConnection.Connect;

    Result := ZConnection;

  except

    on e: Exception do begin

      FreeAndNil(ZConnection);

      raise;
      
    end;

  end;
  
end;

end.
