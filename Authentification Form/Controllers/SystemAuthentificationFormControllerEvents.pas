unit SystemAuthentificationFormControllerEvents;

interface

uses

  ServiceInfo,
  ClientAccount,
  AuthentificationData,
  Event;
  
type

  TLogOnRequestedEvent = class (TEvent)

  end;

  TClientAuthentificatedEvent = class (TEvent)

    private

      FClientAccount: TClientAccount;
      FClientServiceAuthentificationData: TClientServiceAuthentificationData;

    public

      constructor Create(
        ClientAccount: TClientAccount;
        ClientServiceAuthentificationData: TClientServiceAuthentificationData
      );

      property ClientAccount: TClientAccount read FClientAccount;
      property ClientServiceAuthentificationData:
        TClientServiceAuthentificationData
      read FClientServiceAuthentificationData
      write FClientServiceAuthentificationData;

  end;
  
implementation

{ TClientAuthentificatedEvent }

constructor TClientAuthentificatedEvent.Create(
  ClientAccount: TClientAccount;
  ClientServiceAuthentificationData: TClientServiceAuthentificationData
);
begin

  inherited Create;

  FClientAccount := ClientAccount;
  FClientServiceAuthentificationData := ClientServiceAuthentificationData;
  
end;

end.
