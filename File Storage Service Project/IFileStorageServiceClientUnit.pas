unit IFileStorageServiceClientUnit;

interface

uses

  PathBuilder,
  SysUtils,
  Classes;

type

  TFileStorageServiceException = class (Exception)

    private

      FErrorCode: Cardinal;
      
    public

      constructor Create(
        const ErrorCode: Cardinal;
        const Msg: String
      );

      property ErrorCode: Cardinal read FErrorCode;
      
  end;

  TFileNotFoundException = class (TFileStorageServiceException)

    private

      FFileName: String;
      FFilePath: String;

    public

      constructor Create(
        const ErrorCode: Cardinal;
        const FileName, FilePath: String
      );

      property FileName: String read FFileName;
      property FilePath: String read FFilePath;
      
  end;

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

{ TFileNotFoundException }

constructor TFileNotFoundException.Create(
  const ErrorCode: Cardinal;
  const FileName, FilePath: String
);
begin

  inherited Create(
    ErrorCode,
    Format(
      'Файл "%s" по пути "%s" отсутствует"',
      [FileName, FilePath]
    )
  );
  
end;

{ TFileStorageServiceException }

constructor TFileStorageServiceException.Create(
  const ErrorCode: Cardinal;
  const Msg: String
);
begin

  inherited Create(Msg);

  FErrorCode := ErrorCode;
  
end;

end.
