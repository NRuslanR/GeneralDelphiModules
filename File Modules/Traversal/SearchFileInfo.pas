unit SearchFileInfo;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes;
  
type

  ISearchFileInfo = interface (IGetSelf)
    ['{5236B2D5-4081-4AC2-9CFD-0D04996829E7}']
    
    function GetDirPath: String;
    procedure SetDirPath(const Value: String);

    function GetFilePath: String;
    procedure SetFilePath(const Value: String);

    function GetFileInfo: TSearchRec;
    procedure SetFileInfo(const Value: TSearchRec);

    property DirPath: String read GetDirPath write SetDirPath;
    property FilePath: String read GetFilePath write SetFilePath;
    property FileInfo: TSearchRec read GetFileInfo write SetFileInfo;

    function Clone: ISearchFileInfo;

  end;

  TSearchFileInfo = class (TInterfacedObject, ISearchFileInfo)

    private

      FDirPath: String;
      FFilePath: String;
      FFileInfo: TSearchRec;
      
    public

      destructor Destroy; override;
      
      function GetSelf: TObject;
      
      function GetDirPath: String;
      procedure SetDirPath(const Value: String);

      function GetFilePath: String;
      procedure SetFilePath(const Value: String);

      function GetFileInfo: TSearchRec;
      procedure SetFileInfo(const Value: TSearchRec);

      function Clone: ISearchFileInfo;
      
      property DirPath: String read GetDirPath write SetDirPath;
      property FilePath: String read GetFilePath write SetFilePath;
      property FileInfo: TSearchRec read GetFileInfo write SetFileInfo;

  end;

implementation

{ TSearchFileInfo }

function TSearchFileInfo.Clone: ISearchFileInfo;
begin

  Result := TSearchFileInfo.Create;

  Result.DirPath := DirPath;
  Result.FilePath := FilePath;
  Result.FileInfo := FileInfo;
  
end;

destructor TSearchFileInfo.Destroy;
begin

  inherited;

end;

function TSearchFileInfo.GetDirPath: String;
begin

  Result := FDirPath;

end;

function TSearchFileInfo.GetFileInfo: TSearchRec;
begin

  Result := FFileInfo;

end;

function TSearchFileInfo.GetFilePath: String;
begin

  Result := FFilePath;
  
end;

function TSearchFileInfo.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TSearchFileInfo.SetDirPath(const Value: String);
begin

  FDirPath := Value;
  
end;

procedure TSearchFileInfo.SetFileInfo(const Value: TSearchRec);
begin

  FFileInfo := Value;
  
end;

procedure TSearchFileInfo.SetFilePath(const Value: String);
begin

  FFilePath := Value;
  
end;

end.
