program DirectoryTraverserProject;

uses
  Forms,
  DirectoryTraverser in 'Interfaces\DirectoryTraverser.pas',
  DirectoryTraversalStrategy in 'Strategies\Interfaces\DirectoryTraversalStrategy.pas',
  DepthFirstDirectoryTraversalStrategy in 'Strategies\DepthFirstDirectoryTraversalStrategy.pas',
  DirectoryTraversarImpl in 'DirectoryTraversarImpl.pas',
  BreadthFirstDirectoryTraversalStrategy in 'Strategies\BreadthFirstDirectoryTraversalStrategy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Run;
end.
