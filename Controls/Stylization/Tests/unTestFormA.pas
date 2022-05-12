unit unTestFormA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ValidateEditUnit, RegExprValidateEditUnit, ExtCtrls, unTestFormB,
  ComCtrls;

type
  TTestFormA = class(TForm)
    Panel1: TPanel;
    RegExprValidateEdit1: TRegExprValidateEdit;
    Memo1: TMemo;
    Button1: TButton;
    DateTimePicker1: TDateTimePicker;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestFormA: TTestFormA;

implementation

{$R *.dfm}

procedure TTestFormA.Button1Click(Sender: TObject);
begin

  with TTestFormB.Create(Self) do begin

    try

      ShowModal;
      
    finally

      Free;

    end;

  end;

end;

end.
