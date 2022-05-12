program SelectRecordsByColumnProject;



uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  AuxDebugFunctionsUnit,
  DBDataTableFormUnit in 'DBDataTableFormUnit.pas' {DBDataTableForm},
  SelectRecordsByColumnForm in 'SelectRecordsByColumnForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);


  Application.Run;

  DebugOutput(Form1.SelectedRecords.COunt                   );
end.
