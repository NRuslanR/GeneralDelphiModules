unit LocalNetworkFileStorageServiceClientUnit;

interface

uses

  PathBuilder,
  IFileStorageServiceClientUnit,
  AbstractFileStorageServiceClient,
  SysUtils,
  Classes,
  Windows;

type

  TLocalNetworkFileSystemPathBuilder = class (TInterfacedObject, IPathBuilder)

    private

      FPath: String;

    public

      constructor Create;

      function AddPartOfPath(const PartOfPath: String): IPathBuilder;
      function BuildPath: String;
      function ClearPath: IPathBuilder;
      function GetFileName(const FilePath: String): String;
      function GetFileExt(const FileName: String): String;

  end;
  
  TLocalNetworkFileStorageServiceClient = class (TAbstractFileStorageServiceClient)

    private

      type

        TLocalNetworkDeviceConnectionData = class

          LocalNetworkDevicePath: String;
          User: String;
          Password: String;
          IsConnected: Boolean;

        end;

    private

      FCurrentConnectedLocalNetworkDeviceData: TLocalNetworkDeviceConnectionData;

      function ExtractLocalNetworkDeviceConnectionDataFrom(
        const ConnectionString: String
      ): TLocalNetworkDeviceConnectionData;

      procedure DisconnectLocalNetworkDeviceIfExists;

      procedure CreateAdditionalFoldersIfNecessaryForFilePath(
        const FilePath: String
        
      );
      function GetLocalNetworkDevicePath: String;
      procedure SetGetLocalNetworkDevicePath(const Value: String);
      
      function GetUser: String;
      procedure SetUser(const Value: String);

      function GetPassword: String;
      procedure SetPassword(const Value: String);

      procedure CreateLocalNetworkDeviceConnectionDataIfNecessary;

      procedure RaiseExceptionIfNotConnected;

    protected
    
      function CreateFullPathFromPathIfNecessary(
        const Path: String
      ): String; override;

      function InternalGetFile(const RemoteFilePath: String): String; override;
      
    public

      destructor Destroy; override;
      constructor Create; overload;
      constructor Create(
        const LocalNetworkDevicePath: String;
        const User: String = '';
        const Password: String = ''
      ); overload;

      function GetIsConnected: Boolean; override;

      function GetPathBuilder: IPathBuilder; override;

      function GetBaseFileStorePath: String; override;

      procedure Connect(const ConnectionString: String = ''); override;
      procedure Disconnect; override;

      procedure PutFile(
        const LocalFilePath, DestinationRemotePath: String
      ); override;

      procedure RemoveFile(const RemoteFilePath: String); override;

    published

      property LocalNetworkDevicePath: String
      read GetLocalNetworkDevicePath write SetGetLocalNetworkDevicePath;

      property User: String read GetUser write SetUser;
      property Password: String read GetPassword write SetPassword;
      
  end;

implementation

uses

  StrUtils,
  AuxiliaryStringFunctions,
  AuxDebugFunctionsUnit,
  AuxSystemFunctionsUnit,
  ShellAPI;

{ TLocalNetworkFileStorageServiceClient }

procedure TLocalNetworkFileStorageServiceClient.Connect(
  const ConnectionString: String
);
var LocalNetworkDeviceNetResource: NETRESOURCE;
    LocalNetworkDeviceConnectionData: TLocalNetworkDeviceConnectionData;
    AuthorizationResult: Integer;
begin

  DisconnectLocalNetworkDeviceIfExists;
  
  LocalNetworkDeviceConnectionData :=
    ExtractLocalNetworkDeviceConnectionDataFrom(ConnectionString);

  ZeroMemory(
    @LocalNetworkDeviceNetResource,
    SizeOf(LocalNetworkDeviceNetResource)
  );
                                   
  LocalNetworkDeviceNetResource.dwType := RESOURCETYPE_DISK;
  LocalNetworkDeviceNetResource.lpRemoteName :=
    PChar(LocalNetworkDeviceConnectionData.LocalNetworkDevicePath);

  AuthorizationResult :=
    WNetAddConnection2(
      LocalNetworkDeviceNetResource,
      PChar(LocalNetworkDeviceConnectionData.Password),
      PChar(LocalNetworkDeviceConnectionData.User),
      0
    );

  if AuthorizationResult <> NO_ERROR then
    raise Exception.CreateFmt(
            'Во время подключения к ' +
            'удалённому хранилищу возникла ' +
            'ошибка %d',
            [AuthorizationResult]
          );

  FCurrentConnectedLocalNetworkDeviceData.IsConnected := True;
  
end;

constructor TLocalNetworkFileStorageServiceClient.Create;
begin

  inherited;

  CreateLocalNetworkDeviceConnectionDataIfNecessary;
  
end;

constructor TLocalNetworkFileStorageServiceClient.Create(
  const LocalNetworkDevicePath, User, Password: String);
begin

  inherited Create;

  Self.LocalNetworkDevicePath := LocalNetworkDevicePath;
  Self.User := User;
  Self.Password := Password;
  
end;

procedure TLocalNetworkFileStorageServiceClient.CreateAdditionalFoldersIfNecessaryForFilePath(
  const FilePath: String);
var FilePathParts: TStrings;
    FolderPartIndex: Integer;
    FileFolderPath: String;
begin

  FileFolderPath := ExtractFileDir(FilePath);
  
  if not ForceDirectories(FileFolderPath) then
    raise Exception.Create(
            'Не удалось создать дополнительные ' +
            'каталоги для размещения файла'
          );

end;

function TLocalNetworkFileStorageServiceClient.
  CreateFullPathFromPathIfNecessary(
    const Path: String
  ): String;
var PathBuilder: IPathBuilder;
begin

  if Pos(
        FCurrentConnectedLocalNetworkDeviceData.LocalNetworkDevicePath,
        Path
     ) = 0

  then begin

    PathBuilder := GetPathBuilder;

    Result :=
      PathBuilder.
        AddPartOfPath(
          FCurrentConnectedLocalNetworkDeviceData.LocalNetworkDevicePath
        ).
        AddPartOfPath(Path)
        .BuildPath;

  end

  else Result := Path;

end;

procedure TLocalNetworkFileStorageServiceClient.CreateLocalNetworkDeviceConnectionDataIfNecessary;
begin

  if not Assigned(FCurrentConnectedLocalNetworkDeviceData) then
    FCurrentConnectedLocalNetworkDeviceData :=
      TLocalNetworkDeviceConnectionData.Create;
  
end;

function TLocalNetworkFileStorageServiceClient.
  ExtractLocalNetworkDeviceConnectionDataFrom(
    const ConnectionString: String
  ): TLocalNetworkDeviceConnectionData;
var
    AuthorizationParts: TStrings;
    LocalNetworkDeviceName: String;
    User, Password: String;
begin

  Result := FCurrentConnectedLocalNetworkDeviceData;
  
  if ConnectionString = '' then
    Exit;
  
  AuthorizationParts := SplitStringByDelimiter(ConnectionString, ';');
  
  Result.LocalNetworkDevicePath := AuthorizationParts[0];
  Result.User := AuthorizationParts[1];
  Result.Password := AuthorizationParts[2];

  AuthorizationParts.Free;
  
end;

procedure TLocalNetworkFileStorageServiceClient.RaiseExceptionIfNotConnected;
begin

  if not FCurrentConnectedLocalNetworkDeviceData.IsConnected then
    raise TFileStorageServiceException.Create(
            GetLastError,
            'Невозможно выполнить операцию, ' +
            'поскольку ранее не было выполнено ' +
            'подключение к службе хранения файлов'
          );
  
end;

procedure TLocalNetworkFileStorageServiceClient.RemoveFile(
  const RemoteFilePath: String
);
var FileDeleted: Boolean;
    LastError: Cardinal;
begin

  FileDeleted :=
    DeleteFile(
      PChar(
        CreateFullPathFromPathIfNecessary(
          RemoteFilePath
        )
      )
    );

  if not FileDeleted then  begin

    LastError := GetLastError;
    
    case LastError of

      ERROR_FILE_NOT_FOUND, ERROR_FILE_INVALID:

        raise TFileNotFoundException.Create(
                LastError,
                ExtractFileName(RemoteFilePath),
                RemoteFilePath
              );

      else
        raise TFileStorageServiceException.Create(
                LastError,
                Format(
                  'Не удалось удалить файл. '+
                  'Возникла ошибка %d',
                  [LastError]
                )
              );

    end;

  end;

end;

procedure TLocalNetworkFileStorageServiceClient.SetGetLocalNetworkDevicePath(
  const Value: String);
begin

  CreateLocalNetworkDeviceConnectionDataIfNecessary;

  FCurrentConnectedLocalNetworkDeviceData.LocalNetworkDevicePath := Value;
  
end;

procedure TLocalNetworkFileStorageServiceClient.SetPassword(
  const Value: String);
begin

  CreateLocalNetworkDeviceConnectionDataIfNecessary;

  FCurrentConnectedLocalNetworkDeviceData.Password := Value;
  
end;

procedure TLocalNetworkFileStorageServiceClient.SetUser(const Value: String);
begin

  CreateLocalNetworkDeviceConnectionDataIfNecessary;

  FCurrentConnectedLocalNetworkDeviceData.User := Value;
  
end;

destructor TLocalNetworkFileStorageServiceClient.Destroy;
begin

  try

    DisconnectLocalNetworkDeviceIfExists;

  finally

    FreeAndNil(FCurrentConnectedLocalNetworkDeviceData);

    inherited;
    
  end;

end;

procedure TLocalNetworkFileStorageServiceClient.Disconnect;
begin

  DisconnectLocalNetworkDeviceIfExists;
  
end;

procedure TLocalNetworkFileStorageServiceClient.DisconnectLocalNetworkDeviceIfExists;
var DisconnectionResult: Cardinal;
begin

  if not FCurrentConnectedLocalNetworkDeviceData.IsConnected

  then Exit;
  
  DisconnectionResult :=
    WNetCancelConnection2(
      PChar(FCurrentConnectedLocalNetworkDeviceData.LocalNetworkDevicePath),
      0,
      True
    );

  if DisconnectionResult <> NO_ERROR then
    raise TFileStorageServiceException.Create(
            DisconnectionResult,
            Format(
              'Во время попытки отсоединения от ' +
              'удалённого хранилища "%s"' +
              'возникла ошибка %d',
              [
                FCurrentConnectedLocalNetworkDeviceData.LocalNetworkDevicePath,
                DisconnectionResult
              ]
            )
          );

  FCurrentConnectedLocalNetworkDeviceData.IsConnected := False;
          
end;

function TLocalNetworkFileStorageServiceClient.GetBaseFileStorePath: String;
begin

  if Assigned(FCurrentConnectedLocalNetworkDeviceData) then
    Result := FCurrentConnectedLocalNetworkDeviceData.LocalNetworkDevicePath

  else Result := '';

end;

function TLocalNetworkFileStorageServiceClient.GetIsConnected: Boolean;
begin

  Result := FCurrentConnectedLocalNetworkDeviceData.IsConnected;
  
end;

function TLocalNetworkFileStorageServiceClient.GetLocalNetworkDevicePath: String;
begin

  Result := FCurrentConnectedLocalNetworkDeviceData.LocalNetworkDevicePath;

end;

function TLocalNetworkFileStorageServiceClient.GetPassword: String;
begin

  Result := FCurrentConnectedLocalNetworkDeviceData.Password;

end;

function TLocalNetworkFileStorageServiceClient.GetPathBuilder: IPathBuilder;
begin

  Result := TLocalNetworkFileSystemPathBuilder.Create;
  
end;

function TLocalNetworkFileStorageServiceClient.GetUser: String;
begin

  Result := FCurrentConnectedLocalNetworkDeviceData.User;
  
end;

function TLocalNetworkFileStorageServiceClient.InternalGetFile(
  const RemoteFilePath: String): String;
var
    TempFolderPath, TempLocalFilePath: String;
    GettingFileSuccessed: Boolean;
    LastError: Cardinal;
begin

  TempFolderPath := GetUserTemporaryFolderPath;

  TempLocalFilePath := TempFolderPath + PathDelim + PathBuilder.GetFileName(RemoteFilePath);

  if not FileExists(TempLocalFilePath) then
  begin

    GettingFileSuccessed :=
      CopyFile(PChar(RemoteFilePath), PChar(TempLocalFilePath), False);

    if not GettingFileSuccessed then begin

      LastError := GetLastError;

      raise TFileStorageServiceException.Create(
              LastError,
              Format(
                'Не удалось получить файл ' +
                'из удалённого хранилиша. ' +
                'Возникла ошибка %d',
                [LastError]
              )
            );

    end;

  end;

  Result := TempLocalFilePath;

end;

procedure TLocalNetworkFileStorageServiceClient.PutFile(
  const LocalFilePath, DestinationRemotePath: String
);
var
    PutFileSuccessed: Boolean;
    OverwriteFileIfItExisting: Boolean;
    FullDestinationRemotePath: String;
begin

  RaiseExceptionIfNotConnected;

  FullDestinationRemotePath :=
    CreateFullPathFromPathIfNecessary(DestinationRemotePath);

  CreateAdditionalFoldersIfNecessaryForFilePath(FullDestinationRemotePath);

  OverwriteFileIfItExisting := False;

  PutFileSuccessed :=
    CopyFile(
      PChar(LocalFilePath),
      PChar(FullDestinationRemotePath),
      OverwriteFileIfItExisting
    );

  if not PutFileSuccessed then
    raise TFileStorageServiceException.Create(
            GetLastError,
            Format(
              'Не удалось разместить файл "%s" ' +
              'в удалённом хранилище. Возникла ' +
              'ошибка %d',
              [
                LocalFilePath,
                GetLastError
              ]
            )
          );
                  
end;

{ TLocalNetworkFileSystemPathBuilder }

function TLocalNetworkFileSystemPathBuilder.AddPartOfPath(
  const PartOfPath: String
): IPathBuilder;
begin

  FPath := IfThen(FPath = '', PartOfPath, FPath + PathDelim + PartOfPath);

  Result := Self;

end;

function TLocalNetworkFileSystemPathBuilder.BuildPath: String;
begin

  Result := FPath;

  FPath := '';
  
end;

function TLocalNetworkFileSystemPathBuilder.ClearPath: IPathBuilder;
begin

  FPath := '';
  
end;

constructor TLocalNetworkFileSystemPathBuilder.Create;
begin

  inherited;

  ClearPath;
  
end;

function TLocalNetworkFileSystemPathBuilder.GetFileExt(
  const FileName: String): String;
begin

  Result := ExtractFileExt(FileName);
  
end;

function TLocalNetworkFileSystemPathBuilder.GetFileName(
  const FilePath: String): String;
begin

  Result := ExtractFileName(FilePath);
end;

end.
