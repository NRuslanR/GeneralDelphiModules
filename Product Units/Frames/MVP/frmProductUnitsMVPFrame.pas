unit frmProductUnitsMVPFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDBTableFormMVPFrame, StdCtrls;

type
  TProductUnitsMVPFrame = class(TDBTableFormMVPFrame)
  private

  protected

    procedure Show; override;
    
  public

  end;

var
  ProductUnitsMVPFrame: TProductUnitsMVPFrame;

implementation

{$R *.dfm}

{ TProductUnitsMVPFrame }

procedure TProductUnitsMVPFrame.Show;
begin

  inherited;

end;

end.
