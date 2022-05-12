unit AbstractApplication;

interface

uses

  Application,
  ApplicationServiceRegistries,
  ClientAccount,
  SysUtils,
  Classes;

type

  TAbstractApplication =
    class abstract (TInterfacedObject, IApplication)

      public

        function GetApplicationServiceRegistries: IApplicationServiceRegistries; virtual; abstract;

        procedure SetApplicationServiceRegistries(
          Value: IApplicationServiceRegistries
        ); virtual; abstract;

        function GetClientAccount: TClientAccount; virtual; abstract;

        procedure SetClientAccount(ClientAccount: TClientAccount); virtual; abstract;
    
        property ServiceRegistries: IApplicationServiceRegistries
        read GetApplicationServiceRegistries
        write SetApplicationServiceRegistries;

        property ClientAccount: TClientAccount
        read GetClientAccount write SetClientAccount;
    
    end;

implementation

end.
