unit TestFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PDFViewFormUnit, StdCtrls;

type
  TForm5 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
var PDFViewForm: TPDFViewForm;
begin

  PDFViewForm := TPDFViewForm.Create(Self);

  try

    PDFViewForm.LoadAndShowDocument(
      'C:\Documents and Settings\59968\Рабочий стол\gost_34_602_89.pdf'
    );
    
  finally

    //FreeAndNil(PDFViewForm);
    
  end;

end;

end.
