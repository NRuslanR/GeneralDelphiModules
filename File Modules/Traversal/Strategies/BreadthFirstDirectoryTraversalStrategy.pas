unit BreadthFirstDirectoryTraversalStrategy;

interface

uses

  DirectoryTraversalStrategy,
  AbstractDirectoryTraversalStrategy,
  SearchFileInfo,
  VariantListUnit,
  SysUtils;

type

  TBreadthFirstDirectoryTraversalStrategy =
    class (TAbstractDirectoryTraversalStrategy)

      protected

        function DoNextFileInfo: Boolean; override;

    end;

implementation

{ TBreadthFirstDirectoryTraversalStrategy }

function TBreadthFirstDirectoryTraversalStrategy.DoNextFileInfo: Boolean;
var
    DirectoryInfo: ISearchFileInfo;
begin

  EnqueueCurrentFileInfoIfDirectory;

  Result := ToNextFile;

  if Result then Exit;

  DirectoryInfo := DequeueDirectoryInfo;

  Result := Assigned(DirectoryInfo);

  if Result then ToDir(DirectoryInfo.FilePath);

end;

end.
