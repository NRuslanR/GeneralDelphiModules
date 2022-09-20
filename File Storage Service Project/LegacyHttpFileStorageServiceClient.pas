unit LegacyHttpFileStorageServiceClient;

interface

uses

  PathBuilder,
  UnFileWebLoad,
  ZConnection,
  AbstractFileStorageServiceClient,
  LocalNetworkFileStorageServiceClientUnit,
  IFileStorageServiceClientUnit;

type

  TLegacyHttpFileStorageServiceClient = class (TAbstractFileStorageServiceClient)

    private

      FZConnection: TZConnection;
      FPathBuilder: IPathBuilder;

    protected

      function CreateFullPathFromPathIfNecessary(
        const Path: String
      ): String; override;

      function InternalGetFile(const RemoteFilePath: String): String; override;
      
    public

      destructor Destroy; override;
      
      constructor Create(
        ZConnection: TZConnection;
        PathBuilder: IPathBuilder
      );

      function GetBaseFileStorePath: String; override;

      function GetPathBuilder: IPathBuilder; override;

      function GetIsConnected: Boolean; override;

      procedure Connect(const ConnectionString: String = ''); override;
      procedure Disconnect; override;

      procedure PutFile(const LocalFilePath, DestinationRemotePath: String); override;

      procedure RemoveFile(const RemoteFilePath: String); override;

      procedure Cleanup; override;

      property PathBuilder: IPathBuilder read GetPathBuilder;

      property IsConnected: Boolean read GetIsConnected;

      property BaseFileStorePath: String read GetBaseFileStorePath;

  end;


implementation

{ TLegacyHttpFileStorageServiceClient }

procedure TLegacyHttpFileStorageServiceClient.Cleanup;
begin

  { Clear Temp Files Directory }
  DeleteFolder;
  
  inherited;

end;

procedure TLegacyHttpFileStorageServiceClient.Connect(
  const ConnectionString: String);
begin

end;

constructor TLegacyHttpFileStorageServiceClient.Create(
  ZConnection: TZConnection;
  PathBuilder: IPathBuilder
);
begin

  inherited Create(nil);

  FZConnection := ZConnection;
  FPathBuilder := PathBuilder;
    
end;

function TLegacyHttpFileStorageServiceClient.CreateFullPathFromPathIfNecessary(
  const Path: String): String;
begin

  Result := Path;
  
end;

destructor TLegacyHttpFileStorageServiceClient.Destroy;
begin

  Cleanup;

  inherited;

end;

procedure TLegacyHttpFileStorageServiceClient.Disconnect;
begin

end;

function TLegacyHttpFileStorageServiceClient.GetBaseFileStorePath: String;
begin

end;

function TLegacyHttpFileStorageServiceClient.GetIsConnected: Boolean;
begin

  Result := False;

end;

function TLegacyHttpFileStorageServiceClient.GetPathBuilder: IPathBuilder;
begin

  Result := FPathBuilder;

end;

function TLegacyHttpFileStorageServiceClient.InternalGetFile(
  const RemoteFilePath: String): String;
begin

  Result := get_sz_doc_by_http(FZConnection, RemoteFilePath, 'doc'); 

end;

procedure TLegacyHttpFileStorageServiceClient.PutFile(const LocalFilePath,
  DestinationRemotePath: String);
begin

  upload_sz_doc_by_http(FZConnection, LocalFilePath, 'doc', DestinationRemotePath);
  
end;

procedure TLegacyHttpFileStorageServiceClient.RemoveFile(
  const RemoteFilePath: String);
begin

  del_sz_doc_by_http(FZConnection, RemoteFilePath, 'doc');

end;

end.
