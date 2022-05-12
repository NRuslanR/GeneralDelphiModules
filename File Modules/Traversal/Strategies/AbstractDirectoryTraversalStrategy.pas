unit AbstractDirectoryTraversalStrategy;

interface

uses

  DirectoryTraversalStrategy,
  AuxiliaryStringFunctions,
  SearchFileInfo,
  VariantListUnit,
  Windows,
  Classes,
  SysUtils;

type

  TAbstractDirectoryTraversalStrategy =
    class abstract (TInterfacedObject, IDirectoryTraversalStrategy)

      private

        FStartDirPath: String;
        FCurrentFileInfo: ISearchFileInfo;
        FOptions: IDirectoryTraversalStrategyOptions;
        FDirectoryInfoQueue: TVariantList;

      protected

        procedure CreateDefaultOptions;
        
        procedure ToStartDir;
        function ToStartDirIfNecessary: Boolean;
        procedure ToDir(const DirPath: String);
        function ToNextFile: Boolean;
        procedure FinishCurrentTraverse;

        procedure Clean; virtual;
        procedure DoStart(const DirPath: String); virtual;
        function DoNextFileInfo: Boolean; virtual; abstract;

        procedure EnqueueFileInfoIfDirectory(FileInfo: ISearchFileInfo);
        procedure EnqueueCurrentFileInfoIfDirectory;
        function DequeueDirectoryInfo: ISearchFileInfo;

        function CanPutFileInfoToQueue(FileInfo: TSearchRec): Boolean;

        procedure PushFileInfoIfDirectory(FileInfo: ISearchFileInfo);
        procedure PushCurrentFileInfoIfDirectory;
        function PopDirectoryInfo: ISearchFileInfo;

        procedure Initialize;
        
      public

        destructor Destroy; override;
        
        constructor Create;
        
        procedure Start(const DirPath: String); virtual;
        procedure Done; virtual;
        
        function NextFileInfo: Boolean; virtual;

        function CurrentFileInfo: ISearchFileInfo; virtual;

        function GetOptions: IDirectoryTraversalStrategyOptions;
        procedure SetOptions(Options: IDirectoryTraversalStrategyOptions);

        property Options: IDirectoryTraversalStrategyOptions
        read GetOptions write SetOptions;

    end;

implementation

uses

  Variants,
  VariantFunctions,
  AuxFileFunctions;
  
{ TAbstractDirectoryTraversalStrategy }

function TAbstractDirectoryTraversalStrategy.CanPutFileInfoToQueue(
  FileInfo: TSearchRec): Boolean;
begin

  Result :=
    Options.Recursive
    and IsDirectory(FileInfo)
    and not IsCurrentOrParentDirectory(FileInfo);

end;

procedure TAbstractDirectoryTraversalStrategy.Clean;
begin

  FinishCurrentTraverse;

  FreeAndNil(FDirectoryInfoQueue);
  
end;

constructor TAbstractDirectoryTraversalStrategy.Create;
begin

  inherited;

  Initialize;
  
end;

procedure TAbstractDirectoryTraversalStrategy.CreateDefaultOptions;
begin

  FOptions :=
    TDirectoryTraversalStrategyOptions
      .Create
      .Recursive(True);
      
end;

function TAbstractDirectoryTraversalStrategy.CurrentFileInfo: ISearchFileInfo;
begin

  Result := FCurrentFileInfo;

end;

function TAbstractDirectoryTraversalStrategy.DequeueDirectoryInfo: ISearchFileInfo;
begin

  if not FDirectoryInfoQueue.IsEmpty then begin

    VariantToInterface(FDirectoryInfoQueue.First, ISearchFileInfo, Result);

    FDirectoryInfoQueue.Delete(0);

  end

  else Result := nil;
  
end;

destructor TAbstractDirectoryTraversalStrategy.Destroy;
begin

  FreeAndNil(FDirectoryInfoQueue);

  inherited;

end;

procedure TAbstractDirectoryTraversalStrategy.Done;
begin

  Clean;
  
end;

procedure TAbstractDirectoryTraversalStrategy.DoStart(const DirPath: String);
begin

  FStartDirPath := DirPath;
  FDirectoryInfoQueue := TVariantList.Create;

end;

procedure TAbstractDirectoryTraversalStrategy.EnqueueCurrentFileInfoIfDirectory;
begin

  EnqueueFileInfoIfDirectory(CurrentFileInfo);

end;

procedure TAbstractDirectoryTraversalStrategy.EnqueueFileInfoIfDirectory(
  FileInfo: ISearchFileInfo);
begin

  if not CanPutFileInfoToQueue(FileInfo.FileInfo) then Exit;

  FDirectoryInfoQueue.AddInterface(FileInfo.Clone);

end;

procedure TAbstractDirectoryTraversalStrategy.FinishCurrentTraverse;
var
    SearchRec: TSearchRec;
begin

  if Assigned(FCurrentFileInfo) then begin

    SearchRec := FCurrentFileInfo.FileInfo;
    
    FindClose(SearchRec);

  end;

end;

procedure TAbstractDirectoryTraversalStrategy.ToDir(const DirPath: String);
var
    ErrorCode: Integer;
    SearchRec: TSearchRec;
begin

  FinishCurrentTraverse;
  
  ErrorCode :=
    FindFirst(
      IncludeTrailingPathDelimiter(DirPath) + '*',
      faAnyFile,
      SearchRec
    );

  if ErrorCode <> 0 then begin

    Raise TDirectoryTraversalStrategyException.CreateFmt(
      'Во время запуска обхода директории "%s" возникла следующая ошибка:' +
      sLineBreak +
      '%s',
      [
        DirPath,
        GetWindowsLastErrorMessage(ErrorCode)
      ]
    );

  end;

  FCurrentFileInfo.DirPath := DirPath;
  FCurrentFileInfo.FilePath := IncludeTrailingPathDelimiter(DirPath) + SearchRec.Name;
  FCurrentFileInfo.FileInfo := SearchRec;

end;


function TAbstractDirectoryTraversalStrategy.ToNextFile: Boolean;
var
    ErrorCode: Integer;
    SearchRec: TSearchRec;
begin

  SearchRec := FCurrentFileInfo.FileInfo;
  
  ErrorCode := FindNext(SearchRec);

  Result := ErrorCode = 0;

  if Result then begin

    FCurrentFileInfo.FileInfo := SearchRec;
    FCurrentFileInfo.FilePath :=
      IncludeTrailingPathDelimiter(FCurrentFileInfo.DirPath)
      + FCurrentFileInfo.FileInfo.Name;

  end

  else if ErrorCode <> ERROR_NO_MORE_FILES then begin

    Raise TDirectoryTraversalStrategyException.CreateFmt(
      'Во время обхода директории "%s" возникла следующая ошибка:' +
      sLineBreak +
      '%s',
      [
        FCurrentFileInfo.DirPath,
        GetWindowsLastErrorMessage(ErrorCode)
      ]
    );

  end;

end;

procedure TAbstractDirectoryTraversalStrategy.ToStartDir;
begin
  
  ToDir(FStartDirPath);
  
end;

function TAbstractDirectoryTraversalStrategy.GetOptions: IDirectoryTraversalStrategyOptions;
begin

  Result := FOptions;
  
end;

procedure TAbstractDirectoryTraversalStrategy.Initialize;
begin

  Clean;
  
  CreateDefaultOptions;

end;

function TAbstractDirectoryTraversalStrategy.NextFileInfo: Boolean;
begin

  Result := ToStartDirIfNecessary or DoNextFileInfo;
  
end;

function TAbstractDirectoryTraversalStrategy.PopDirectoryInfo: ISearchFileInfo;
begin

  if not FDirectoryInfoQueue.IsEmpty then begin

    VariantToInterface(FDirectoryInfoQueue.Last, ISearchFileInfo, Result);

    FDirectoryInfoQueue.Delete(FDirectoryInfoQueue.Count - 1);

  end

  else Result := nil;

end;

procedure TAbstractDirectoryTraversalStrategy.PushCurrentFileInfoIfDirectory;
begin

  PushFileInfoIfDirectory(CurrentFileInfo);
  
end;

procedure TAbstractDirectoryTraversalStrategy.PushFileInfoIfDirectory(
  FileInfo: ISearchFileInfo);
begin

  if not CanPutFileInfoToQueue(FileInfo.FileInfo) then Exit;

  FDirectoryInfoQueue.AddInterface(FileInfo.Clone);
  
end;

function TAbstractDirectoryTraversalStrategy.ToStartDirIfNecessary: Boolean;
begin

  Result := not Assigned(FCurrentFileInfo);

  if Result then begin

    FCurrentFileInfo := TSearchFileInfo.Create;
    
    ToStartDir;

  end;

end;

procedure TAbstractDirectoryTraversalStrategy.SetOptions(
  Options: IDirectoryTraversalStrategyOptions);
begin

  FOptions := Options;

  if not Assigned(FOptions) then
    CreateDefaultOptions;

end;

procedure TAbstractDirectoryTraversalStrategy.Start(const DirPath: String);
begin

  Clean;

  DoStart(DirPath);

end;

end.
