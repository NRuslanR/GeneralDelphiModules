unit unEmployeesReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBDataTableFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxCheckBox, cxLocalization, ActnList, ImgList,
  PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, ComCtrls, ExtCtrls,
  StdCtrls, cxButtons, ToolWin;

type
  TEmployeesReferenceForm = class(TDBDataTableForm)
    IdColumn: TcxGridDBColumn;
    NameColumn: TcxGridDBColumn;
    SurnameColumn: TcxGridDBColumn;
    PatronymicColumn: TcxGridDBColumn;
    SpecialityColumn: TcxGridDBColumn;
    PersonnelNumberColumn: TcxGridDBColumn;
    DepartmentCodeColumn: TcxGridDBColumn;
    DepartmentShortNameColumn: TcxGridDBColumn;
    DepartmentFullNameColumn: TcxGridDBColumn;
    TelephoneColumn: TcxGridDBColumn;
  private

  public

  end;

implementation

{$R *.dfm}

end.
