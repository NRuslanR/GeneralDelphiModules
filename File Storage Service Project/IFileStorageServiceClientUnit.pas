unit IFileStorageServiceClientUnit;

interface

uses

  FileStorageServiceErrors,
  PathBuilder,
  SysUtils,
  Classes;

type
  
  IFileStorageServiceClient = interface
    ['{D681B866-39C8-4F06-A3CD-D63450D7A03D}']

    function GetBaseFileStorePath: String;

    function GetPathBuilder: IPathBuilder;

    function GetIsConnected: Boolean;

    procedure Connect(const ConnectionString: String = '');
    procedure Disconnect;

    procedure PutFile(const LocalFilePath, DestinationRemotePath: String);

    procedure RemoveFile(const RemoteFilePath: String);

    function GetFile(const RemoteFilePath: String): String; overload;
    function GetFile(const RemoteFilePath: String; const NewName: string): String; overload;

    procedure Cleanup;
    
    property PathBuilder: IPathBuilder read GetPathBuilder;

    property IsConnected: Boolean read GetIsConnected;

    property BaseFileStorePath: String read GetBaseFileStorePath;

  end;
  
implementation

end.
