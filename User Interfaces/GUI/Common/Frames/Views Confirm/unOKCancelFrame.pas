unit unOKCancelFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  dxSkinsCore, dxSkinsDefaultPainters, StdCtrls, cxButtons;

type

  TOKCancelFrame = class(TFrame)

    OKButton: TcxButton;
    CancelButton: TcxButton;
    procedure CancelButtonClick(Sender: TObject);
    private

    protected

      procedure OnOk; virtual;
      procedure OnCancel; virtual;

    protected


    public

  end;

implementation

{$R *.dfm}

procedure TOKCancelFrame.CancelButtonClick(Sender: TObject);
begin
                 
  OnCancel;

end;

procedure TOKCancelFrame.OnCancel;
begin

end;

procedure TOKCancelFrame.OnOk;
begin

end;

end.
