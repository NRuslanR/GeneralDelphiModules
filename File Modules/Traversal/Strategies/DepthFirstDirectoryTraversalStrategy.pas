unit DepthFirstDirectoryTraversalStrategy;

interface

uses

  DirectoryTraversalStrategy,
  AbstractDirectoryTraversalStrategy,
  SysUtils,
  Classes;

type

  TDepthFirstDirectoryTraversalStrategy =
    class (TAbstractDirectoryTraversalStrategy)

      protected

        function DoNextFileInfo: Boolean; override;

    end;

implementation

{ TDepthFirstDirectoryTraversalStrategy }

function TDepthFirstDirectoryTraversalStrategy.DoNextFileInfo: Boolean;
begin

end;

end.
