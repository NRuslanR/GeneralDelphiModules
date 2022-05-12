program FileStorageServiceProject;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  TestFormUnit1 in 'TestFormUnit1.pas' {Form5},
  IFileStorageServiceClientUnit in 'IFileStorageServiceClientUnit.pas',
  LocalNetworkFileStorageServiceClientUnit in 'LocalNetworkFileStorageServiceClientUnit.pas',
  AuxiliaryStringFunctions in 'D:\Common Delphi Libs\u_59968 Delphi Modules\AuxStringFunctions\AuxiliaryStringFunctions.pas',
  AuxSystemFunctionsUnit in 'D:\Common Delphi Libs\u_59968 Delphi Modules\AuxSystemFunctions\AuxSystemFunctionsUnit.pas',
  AuxDebugFunctionsUnit in 'D:\Common Delphi Libs\u_59968 Delphi Modules\AuxDebugFunctions\AuxDebugFunctionsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
