unit AbstractFileStorageServiceClient;

interface

uses

  PathBuilder,
  IFileStorageServiceClientUnit,
  SysUtils,
  Windows;

type

  TAbstractFileStorageServiceClient =
    class (TInterfacedObject, IFileStorageServiceClient)

      protected

        function CreateFullPathFromPathIfNecessary(const Path: String): String; virtual; abstract;
        function InternalGetFile(const RemoteFilePath: String): String; virtual; abstract;
        function ChangeFileName(const CurrentFilePath: String; const NewFileName: String): String; virtual;
        
      public

        function GetBaseFileStorePath: String; virtual; abstract;

        function GetPathBuilder: IPathBuilder; virtual; abstract;

        function GetIsConnected: Boolean; virtual; abstract;

        procedure Connect(const ConnectionString: String = ''); virtual; abstract;
        procedure Disconnect; virtual; abstract;

        procedure PutFile(const LocalFilePath, DestinationRemotePath: String); virtual; abstract;

        procedure RemoveFile(const RemoteFilePath: String); virtual; abstract;

        function GetFile(const RemoteFilePath: String): String; overload; virtual;
        function GetFile(const RemoteFilePath: String; const NewName: string): String; overload; virtual;

        procedure Cleanup; virtual;

        property PathBuilder: IPathBuilder read GetPathBuilder;

        property IsConnected: Boolean read GetIsConnected;

        property BaseFileStorePath: String read GetBaseFileStorePath;

    end;

implementation

uses

  StrUtils;
  
{ TAbstractFileStorageServiceClient }

function TAbstractFileStorageServiceClient.GetFile(
  const RemoteFilePath: String): String;
var
    FullRemoteFilePath: String;
begin

  FullRemoteFilePath := CreateFullPathFromPathIfNecessary(RemoteFilePath);

  Result := InternalGetFile(FullRemoteFilePath);
  
end;

function TAbstractFileStorageServiceClient.GetFile(
  const RemoteFilePath, NewName: string
): String;
begin

  Result := GetFile(RemoteFilePath);

  Result := ChangeFileName(Result, NewName);

end;

function TAbstractFileStorageServiceClient.ChangeFileName(
  const CurrentFilePath, NewFileName: String
): String;
var
    TargetFileName: String;
    FileCopySuccess: Boolean;
    LastError: Cardinal;
begin

  TargetFileName :=
    IfThen(
      ExtractFileExt(NewFileName) = '', 
      NewFileName + PathBuilder.GetFileExt(CurrentFilePath), 
      NewFileName
    );

  Result := ExtractFileDir(CurrentFilePath) + PathDelim + TargetFileName;

  FileCopySuccess :=
      CopyFile(PChar(CurrentFilePath), PChar(Result), False);

  if not FileCopySuccess then begin

    LastError := GetLastError;

    raise TFileStorageServiceException.Create(
            LastError,
            Format(
              'Не удалось переименовать файл. ' +
              'Возникла ошибка %d',
              [LastError]
            )
          );

  end;                                  

  if not DeleteFile(PChar(CurrentFilePath)) then begin
  
    LastError := GetLastError;

    raise TFileStorageServiceException.Create(
            LastError,
            Format(
              'Не удалось переименовать файл. ' +
              'Возникла ошибка %d',
              [LastError]
            )
          );
  end; 
  
end;

procedure TAbstractFileStorageServiceClient.Cleanup;
begin


end;

end.
