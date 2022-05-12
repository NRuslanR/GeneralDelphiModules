program InterfaceIntegration;

uses
  Forms,
  Unit4 in 'Unit4.pas' {Form4},
  Render in 'Render.pas',
  PDFViewFormUnit in 'PDFViewFormUnit.pas' {PDFViewForm},
  PDFViewingModuleInterface in 'PDFViewingModuleInterface.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
