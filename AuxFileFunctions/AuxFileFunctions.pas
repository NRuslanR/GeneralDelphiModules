unit AuxFileFunctions;

interface

uses

  SysUtils,
  Classes,
  Windows;

function IsDirectory(SearchRec: TSearchRec): Boolean;
function IsCurrentDirectory(SearchRec: TSearchRec): Boolean;
function IsParentDirectory(SearchRec: TSearchRec): Boolean;
function IsCurrentOrParentDirectory(SearchRec: TSearchRec): Boolean;

function IsFileOpen(const FilePath: String): Boolean;
function ReadFileToString(const FilePath: String): String;
function GetFirstFolderByAnyFileTypes(const StartDir: String; const FileTypes: array of String): String; overload;
function GetFirstFolderByAnyFileTypes(const StartDir: String; const FileTypes: TStrings): String; overload;
function SearchFile(const FileName: String; const StartDir: String = '.'): String;

implementation

uses

  DirectoryTraversarImpl,
  DirectoryTraverseEventHandlers,
  DirectoryTraverser,
  AuxDebugFunctionsUnit,
  StrUtils,
  SearchFileInfo;

function IsFileOpen(const FilePath: String): Boolean;

  function IsOpenFileHandleCreated(const FilePath: String): Boolean;
  var
      FileHandle: THandle;
  begin

    FileHandle :=
      CreateFile(
        PChar(FilePath),
        GENERIC_READ,
        0,
        nil,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        0
      );

    if FileHandle = INVALID_HANDLE_VALUE then
      Result := True

    else begin

      Result := False;

      CloseHandle(FileHandle);
      
    end;

  end;

begin

  Result := IsOpenFileHandleCreated(FilePath);

end;

function ReadFileToString(const FilePath: String): String;
var
    Lines: TStrings;
begin

  Lines := TStringList.Create;

  try

    Lines.LoadFromFile(FilePath);

    Result := Lines.Text;
    
  finally

    FreeAndNil(Lines);

  end;

end;

function GetFirstFolderByAnyFileTypes(const StartDir: String; const FileTypes: array of String): String;
var
    FileTypeList: TStrings;
    FileType: String;
begin

  FileTypeList := TStringList.Create;

  try

    for FileType in FileTypes do
      FileTypeList.Add(FileType);

    Result := GetFirstFolderByAnyFileTypes(StartDir, FileTypeList);
    
  finally

    FreeAndNil(FileTypeList);
    
  end;

end;

function GetFirstFolderByAnyFileTypes(const StartDir: String; const FileTypes: TStrings): String;
begin

  
end;

function IsDirectory(SearchRec: TSearchRec): Boolean;
begin

  Result := (SearchRec.Attr and faDirectory) = faDirectory;

end;

function IsCurrentDirectory(SearchRec: TSearchRec): Boolean;
begin

  Result := IsDirectory(SearchRec) and (SearchRec.Name = '.');

end;

function IsParentDirectory(SearchRec: TSearchRec): Boolean;
begin

  Result := IsDirectory(SearchRec) and (SearchRec.Name = '..');

end;

function IsCurrentOrParentDirectory(SearchRec: TSearchRec): Boolean;
begin

  Result := IsCurrentDirectory(SearchRec) or IsParentDirectory(SearchRec);

end;

function SearchFile(const FileName: String; const StartDir: String = '.'): String;
var
    DirectoryTraverser: IDirectoryTraverser;
    SearchFileEventHandler: IDirectoryTraverseEventHandler;
begin

  DirectoryTraverser := TDirectoryTraverser.Create;

  DirectoryTraverser.Options.AllowedFileExtensions([ExtractFileExt(FileName)]);

  SearchFileEventHandler := TSearchFileEventHandler.Create(FileName);

  DirectoryTraverser.EventHandler := SearchFileEventHandler;

  DirectoryTraverser.Traverse(StartDir);

  with TSearchFileEventHandler(SearchFileEventHandler.Self) do begin

    if Assigned(FoundFileInfo) then
      Result := FoundFileInfo.FilePath

    else Result := '';
    
  end;

end;

end.
