unit unEmployeeSelectionCardFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  dxSkinsCore, dxSkinsDefaultPainters, StdCtrls, cxButtons, ValidateEditUnit,
  RegExprValidateEditUnit, ExtCtrls, ViewFieldOptions, VCLViewFieldOptionsResolvers;

type

  TEmployeeSelectionKind = (skStandard, skNoSelection);
  
  TEmployeeSelectionCardFrame = class(TFrame)
    ButtonsPanel: TPanel;
    EmployeeInfoPanel: TPanel;
    ChooseButton: TcxButton;
    NameLabel: TLabel;
    PersonnelNumberLabel: TLabel;
    SpecialityLabel: TLabel;
    TelephoneLabel: TLabel;
    NameEdit: TRegExprValidateEdit;
    PersonnelNumberEdit: TRegExprValidateEdit;
    SpecialityEdit: TRegExprValidateEdit;
    TelephoneEdit: TRegExprValidateEdit;

    private
    
      function GetSelectionKind: TEmployeeSelectionKind;
      procedure SetSelectionKind(const Value: TEmployeeSelectionKind);

      function GetSelectionToolOptions: IViewFieldOptions;
      procedure SetSelectionToolOptions(const Value: IViewFieldOptions);

    public

      function ValidateInput: Boolean; virtual;

    public

      constructor Create(
        Owner: TComponent;
        const SelectionKind: TEmployeeSelectionKind = skStandard
      );

      property SelectionToolOptions: IViewFieldOptions
      read GetSelectionToolOptions write SetSelectionToolOptions;

      property SelectionKind: TEmployeeSelectionKind
      read GetSelectionKind write SetSelectionKind;

  end;

implementation

{$R *.dfm}

{ TEmployeeSelectionCardFrame }

constructor TEmployeeSelectionCardFrame.Create(Owner: TComponent;
  const SelectionKind: TEmployeeSelectionKind);
begin

  inherited Create(Owner);

  Self.SelectionKind := SelectionKind;
  
end;

function TEmployeeSelectionCardFrame.GetSelectionKind: TEmployeeSelectionKind;
begin

  if ButtonsPanel.Visible then
    Result := skStandard

  else Result := skNoSelection;

end;

function TEmployeeSelectionCardFrame.GetSelectionToolOptions: IViewFieldOptions;
begin

  Result :=
    TViewFieldOptions
      .Create
        .InvalidHint(NameEdit.InvalidHint)
        .ViewOnly(True);

end;

procedure TEmployeeSelectionCardFrame.SetSelectionKind(
  const Value: TEmployeeSelectionKind);
begin

  ButtonsPanel.Visible := Value = skStandard;
  
end;

procedure TEmployeeSelectionCardFrame.SetSelectionToolOptions(
  const Value: IViewFieldOptions);
begin

  NameEdit.InvalidHint := Value.InvalidHint;
  PersonnelNumberEdit.InvalidHint := Value.InvalidHint;
  SpecialityEdit.InvalidHint := Value.InvalidHint;
  TelephoneEdit.InvalidHint := Value.InvalidHint;

end;

function TEmployeeSelectionCardFrame.ValidateInput: Boolean;
var
    IsNameValid, IsPersonnelNumberValid, IsSpecialityValid, IsTelephoneValid: Boolean;
begin

  IsNameValid := NameEdit.IsValid;
  IsPersonnelNumberValid := PersonnelNumberEdit.IsValid;
  IsSpecialityValid := SpecialityEdit.IsValid;
  IsTelephoneValid := TelephoneEdit.IsValid;

  Result :=
    IsNameValid
    and IsPersonnelNumberValid
    and IsSpecialityValid
    and IsTelephoneValid;

end;

end.
