unit PDFViewingModuleInterface;

interface

uses SysUtils, PDFViewFormUnit, Classes, Controls;

procedure ShowPDFViewForm(
  Owner: TComponent;
  const FileName: String;
  const ViewMode: TPDFViewFormMode = vmNormal
);

function CreatePDFViewForm(
  Owner: TComponent;
  const FileName: String;
  const ViewMode: TPDFViewFormMode = vmNormal;
  const Width: Integer = 0;
  const Height: Integer = 0
): TPDFViewForm;

implementation

uses ShellApi, Windows, Forms;

var

  Wow64FsEnableRedirection: LongBool;

procedure ShowPDFViewForm(
  Owner: TComponent;
  const FileName: String;
  const ViewMode: TPDFViewFormMode = vmNormal
);
begin

  with TPDFViewForm.Create(Owner, FileName) do begin

    if ViewMode = vmFullScreen then begin

      BorderStyle := bsNone;
      WindowState := wsMaximized;
      
    end;

    ShowModal;

  end;

end;

function CreatePDFViewForm(
  Owner: TComponent;
  const FileName: String;
  const ViewMode: TPDFViewFormMode = vmNormal;
  const Width: Integer = 0;
  const Height: Integer = 0
): TPDFViewForm;
begin

  Result := TPDFViewForm.Create(Owner, FileName, ViewMode, Width, Height);

end;

end.
