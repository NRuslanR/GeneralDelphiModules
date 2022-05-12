program PDFFileViewFormProject;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  TestFormUnit in 'TestFormUnit.pas' {Form5},
  FoxitPDFDocumentProcessorUnit in '..\PDF Viewing Module\FoxitPDFDocumentProcessorUnit.pas',
  IPDFDocumentProcessorUnit in '..\PDF Viewing Module\IPDFDocumentProcessorUnit.pas',
  PDFDocumentExceptionsUnit in '..\PDF Viewing Module\PDFDocumentExceptionsUnit.pas',
  PDFDocumentRenderingThreadUnit in '..\PDF Viewing Module\PDFDocumentRenderingThreadUnit.pas',
  PDFViewFormUnit in '..\PDF Viewing Module\PDFViewFormUnit.pas' {PDFViewForm},
  PDFViewingModuleInterface in '..\PDF Viewing Module\PDFViewingModuleInterface.pas',
  ExceptionWithInnerExceptionUnit in 'D:\Common Delphi Libs\u_59968 Delphi Modules\Exception Classes\ExceptionWithInnerExceptionUnit.pas',
  AuxiliaryFunctionsForExceptionHandlingUnit in 'D:\Common Delphi Libs\u_59968 Delphi Modules\Exception Classes And Functions\AuxiliaryFunctionsForExceptionHandlingUnit.pas',
  AuxSystemFunctionsUnit in 'D:\Common Delphi Libs\u_59968 Delphi Modules\AuxSystemFunctions\AuxSystemFunctionsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
