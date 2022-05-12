program DBTableReplicatorProject;

uses
  Forms,
  unDBTableReplicatorTestForm in 'unDBTableReplicatorTestForm.pas' {DBTableReplicatorTestForm},
  DBTableReplicationOptions in 'DBTableReplicationOptions.pas',
  DBTableReplicationRequest in 'DBTableReplicationRequest.pas',
  DBTableReplicationRequestHandler in 'DBTableReplicationRequestHandler.pas',
  DBTableReplicator in 'DBTableReplicator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDBTableReplicatorTestForm, DBTableReplicatorTestForm);
  Application.Run;
end.
