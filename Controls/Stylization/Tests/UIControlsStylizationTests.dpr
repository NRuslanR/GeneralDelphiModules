program UIControlsStylizationTests;

uses
  Forms,
  unUIControlsStylizationTestForm in 'unUIControlsStylizationTestForm.pas' {UIControlsStylizationTestForm},
  UIAdditionalControlStyle in '..\UIAdditionalControlStyle.pas',
  UIControlsTrackingStylist in '..\UIControlsTrackingStylist.pas',
  UIControlStyle in '..\UIControlStyle.pas',
  UIStandardControlStyle in '..\UIStandardControlStyle.pas',
  UIWin32ControlStyle in '..\UIWin32ControlStyle.pas',
  AbstractObjectRegistry in '..\..\..\Registries\AbstractObjectRegistry.pas',
  InMemoryObjectRegistry in '..\..\..\Registries\InMemoryObjectRegistry.pas',
  TypeObjectRegistry in '..\..\..\Registries\TypeObjectRegistry.pas',
  UIControlTypeStyleRegistry in '..\UIControlTypeStyleRegistry.pas',
  unTestFormA in 'unTestFormA.pas' {TestFormA},
  unTestFormB in 'unTestFormB.pas' {TestFormB};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TUIControlsStylizationTestForm, UIControlsStylizationTestForm);
  Application.CreateForm(TTestFormA, TestFormA);
  Application.CreateForm(TTestFormB, TestFormB);
  Application.Run;
end.
