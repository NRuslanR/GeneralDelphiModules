unit unExtendedDatabaseAuthentificationForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDatabaseAuthentificationForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, StdCtrls, cxButtons, ValidateEditUnit,
  RegExprValidateEditUnit, Spin, ExtCtrls, ImgList, pngimage, cxClasses, Buttons,
  ActnList, ExtendedDatabaseAuthentificationFormViewModel,
  ValidateComboBoxDesign, SystemAuthentificationFormViewModel,
  ZAbstractConnection, ZConnection;

type
  TExtendedDatabaseAuthentificationForm = class(TDatabaseAuthentificationForm)
    ServerAddressLabel: TLabel;
    ServerAddressComboBox: TValidateComboBox;
    ServerPortLabel: TLabel;
    ServerPortEdit: TSpinEdit;
  private

    function GetExtendedDatabaseAuthentificationFormViewModel:
      TExtendedDatabaseAuthentificationFormViewModel;

    procedure SetExtendedDatabaseAuthentificationFormViewModel(
      const Value: TExtendedDatabaseAuthentificationFormViewModel
    );

  protected

    procedure FillControlsByViewModel(ViewModel: TSystemAuthentificationFormViewModel); override;
    procedure FillViewModelByControls; override;

  protected

    function InputCredentialsDataFormatValid: Boolean; override;
    
  public

    property ViewModel: TExtendedDatabaseAuthentificationFormViewModel
    read GetExtendedDatabaseAuthentificationFormViewModel
    write SetExtendedDatabaseAuthentificationFormViewModel;
    
  end;

var
  ExtendedDatabaseAuthentificationForm: TExtendedDatabaseAuthentificationForm;

implementation

{$R *.dfm}

{ TExtendedDatabaseAuthentificationForm }

procedure TExtendedDatabaseAuthentificationForm.FillControlsByViewModel(
  ViewModel: TSystemAuthentificationFormViewModel);
begin

  inherited;

  with ViewModel as TExtendedDatabaseAuthentificationFormViewModel do begin

    ServerAddressComboBox.Items := Hosts;
    ServerAddressComboBox.Text := CurrentHost;
    ServerPortEdit.Value := Port;
    
  end;

end;

procedure TExtendedDatabaseAuthentificationForm.FillViewModelByControls;
begin

  inherited;

  if ServerAddressComboBox.ItemIndex = -1 then
    ViewModel.CurrentHost := ServerAddressComboBox.Text

  else begin

    ViewModel.CurrentHost :=
      ServerAddressComboBox.Items[ServerAddressComboBox.ItemIndex];

  end;

  ViewModel.Hosts.Assign(ServerAddressComboBox.Items);

  ViewModel.Port := ServerPortEdit.Value;
  
end;

function TExtendedDatabaseAuthentificationForm.
  GetExtendedDatabaseAuthentificationFormViewModel:
    TExtendedDatabaseAuthentificationFormViewModel;
begin

  Result :=
    TExtendedDatabaseAuthentificationFormViewModel(inherited ViewModel);
  
end;

function TExtendedDatabaseAuthentificationForm.
  InputCredentialsDataFormatValid: Boolean;
var IsServerAddressValid: Boolean;
begin

  IsServerAddressValid := ServerAddressComboBox.Validate;

  Result :=
    inherited InputCredentialsDataFormatValid and
    IsServerAddressValid;
    
end;

procedure TExtendedDatabaseAuthentificationForm.
  SetExtendedDatabaseAuthentificationFormViewModel(
    const Value: TExtendedDatabaseAuthentificationFormViewModel
  );
begin

  SetViewModel(Value);

end;

end.
