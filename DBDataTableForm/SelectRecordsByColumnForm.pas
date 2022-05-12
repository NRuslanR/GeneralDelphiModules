unit SelectRecordsByColumnForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Hashes, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxCheckBox, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, dxmdaset, DBClient, cxGridLevel, cxClasses,
  cxGridCustomView, cxGrid, DBDataTableFormUnit, Menus, cxLocalization,
  ActnList, ImgList, PngImageList, ComCtrls, ExtCtrls, StdCtrls, cxButtons,
  ToolWin;

type
  TForm1 = class(TDBDataTableForm)
    ClientDataSet1: TClientDataSet;
    ClientDataSet1Value: TStringField;
    ValueColumn: TcxGridDBColumn;

  private

  protected

    procedure Init(
      const Caption: String = ''; ADataSet:
      TDataSet = nil
    ); override;
    
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


{ TForm1 }


procedure TForm1.Init(const Caption: String; ADataSet: TDataSet);
begin

  inherited;

  EnableSelectionColumn := True;

end;

end.
