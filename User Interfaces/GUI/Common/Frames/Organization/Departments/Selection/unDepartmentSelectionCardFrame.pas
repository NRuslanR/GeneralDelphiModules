unit unDepartmentSelectionCardFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  dxSkinsCore, dxSkinsDefaultPainters, StdCtrls, cxButtons, ValidateEditUnit,
  RegExprValidateEditUnit, ExtCtrls;

type

  TDepartmentSelectionKind = (skStandard, skNoSelection);
   
  TDepartmentSelectionCardFrame = class(TFrame)
    ButtonsPanel: TPanel;
    DepartmentInfoPanel: TPanel;
    ChooseButton: TcxButton;
    CodeLabel: TLabel;
    FullNameLabel: TLabel;
    ShortNameLabel: TLabel;
    CodeEdit: TRegExprValidateEdit;
    FullNameEdit: TRegExprValidateEdit;
    ShortNameEdit: TRegExprValidateEdit;

    private

      function GetSelectionKind: TDepartmentSelectionKind;
      procedure SetSelectionKind(const Value: TDepartmentSelectionKind);

    public

      constructor Create(
        Owner: TComponent;
        const SelectionKind: TDepartmentSelectionKind = skStandard
      );

      property SelectionKind: TDepartmentSelectionKind
      read GetSelectionKind write SetSelectionKind;

  end;

implementation

{$R *.dfm}

{ TDepartmentSelectionCardFrame }

constructor TDepartmentSelectionCardFrame.Create(Owner: TComponent;
  const SelectionKind: TDepartmentSelectionKind);
begin

  inherited Create(Owner);

  Self.SelectionKind := SelectionKind;
  
end;

function TDepartmentSelectionCardFrame.GetSelectionKind: TDepartmentSelectionKind;
begin

  if ButtonsPanel.Visible then
    Result := skStandard

  else Result := skNoSelection;

end;

procedure TDepartmentSelectionCardFrame.SetSelectionKind(
  const Value: TDepartmentSelectionKind);
begin

  ButtonsPanel.Visible := Value = skStandard;

end;

end.
