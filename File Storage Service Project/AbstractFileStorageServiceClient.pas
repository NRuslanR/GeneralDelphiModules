unit AbstractFileStorageServiceClient;

interface

uses

  PathBuilder,
  FileStorageServiceErrorProcessor,
  IFileStorageServiceClientUnit,
  SysUtils,
  Windows;

type

  TAbstractFileStorageServiceClient =
    class (TInterfacedObject, IFileStorageServiceClient)

      protected

        FErrorProcessor: IFileStorageServiceErrorProcessor;

      protected

        function CreateFullPathFromPathIfNecessary(const Path: String): String; virtual; abstract;
        function InternalGetFile(const RemoteFilePath: String): String; virtual; abstract;
        function ChangeLocalFileName(const CurrentFilePath: String; const NewFileName: String): String; virtual;
        
        function InternalChangeLocalFileName(
          const CurrentFilePath, NewFileNamePath, NewFileName: String
        ): String; virtual;
        
      public

        constructor Create(FileStorageServiceErrorProcessor: IFileStorageServiceErrorProcessor);
        
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

  StrUtils,
  WindowsFileStorageServiceErrorProcessor;
  
{ TAbstractFileStorageServiceClient }

function TAbstractFileStorageServiceClient.GetFile(
  const RemoteFilePath: String): String;
var
    FullRemoteFilePath: String;
    Success: Boolean;
begin

  FullRemoteFilePath := CreateFullPathFromPathIfNecessary(RemoteFilePath);

  Result := InternalGetFile(FullRemoteFilePath);

end;

function TAbstractFileStorageServiceClient.GetFile(
  const RemoteFilePath, NewName: string
): String;
begin

  Result := GetFile(RemoteFilePath);

  if Result <> '' then
    Result := ChangeLocalFileName(Result, NewName);

end;

function TAbstractFileStorageServiceClient.ChangeLocalFileName(
  const CurrentFilePath, NewFileName: String
): String;
var
    TargetFileName: String;
begin

  TargetFileName :=
    IfThen(
      ExtractFileExt(NewFileName) = '', 
      NewFileName + PathBuilder.GetFileExt(CurrentFilePath), 
      NewFileName
    );

  Result := ExtractFileDir(CurrentFilePath) + PathDelim + TargetFileName;

  Result := InternalChangeLocalFileName(CurrentFilePath, Result, NewFileName);

end;

function TAbstractFileStorageServiceClient.InternalChangeLocalFileName(
  const CurrentFilePath, NewFileNamePath, NewFileName: String): String;
var
    FileCopySuccess: Boolean;
begin

  FileCopySuccess :=
      CopyFile(PChar(CurrentFilePath), PChar(NewFileNamePath), False);

  if not FileCopySuccess then begin

    FErrorProcessor.RaiseExceptionByErrorData(
      TFileStorageServiceErrorData.Create(
        GetLastError,
        NewFileName,
        NewFileNamePath
      )
    );

  end;

  if not DeleteFile(PChar(CurrentFilePath)) then begin

    FErrorProcessor.RaiseExceptionByErrorData(
      TFileStorageServiceErrorData.Create(
        GetLastError,
        ExtractFileName(CurrentFilePath),
        CurrentFilePath
      )
    );

  end;

  Result := NewFileNamePath;

end;

procedure TAbstractFileStorageServiceClient.Cleanup;
begin


end;

constructor TAbstractFileStorageServiceClient.Create(
  FileStorageServiceErrorProcessor: IFileStorageServiceErrorProcessor);
begin

  inherited Create;

  if Assigned(FileStorageServiceErrorProcessor) then
    FErrorProcessor := FileStorageServiceErrorProcessor

  else FErrorProcessor := TWindowsFileStorageServiceErrorProcessor.Create;
  
end;

end.
