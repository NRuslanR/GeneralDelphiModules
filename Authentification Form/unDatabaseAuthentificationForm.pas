unit unDatabaseAuthentificationForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSystemAuthentificationForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, StdCtrls, cxButtons, ValidateEditUnit,
  RegExprValidateEditUnit, ExtCtrls,
  SystemAuthentificationFormViewModel, DatabaseAuthentificationFormViewModel,
  ImgList, pngimage, cxClasses, Buttons, ActnList, ValidateComboBoxDesign;

type
  TDatabaseAuthentificationForm = class(TSystemAuthentificationForm)
    DatabaseSettingsImageList: TImageList;
    DatabaseSettingActions: TActionList;
    actExpandDatabaseSettingsPanel: TAction;
    actCollapseDatabaseSettingsPanel: TAction;
    DatabaseSettingsPanel: TPanel;
    DatabaseLabel: TLabel;
    DatabaseComboBox: TValidateComboBox;
    DatabaseSettingsButton: TcxButton;
    procedure actExpandDatabaseSettingsPanelExecute(Sender: TObject);
    procedure actCollapseDatabaseSettingsPanelExecute(Sender: TObject);

  private

    procedure AdjustHeightBy(const HeightDelta: Integer);

  protected

    procedure Initialize; override;
    
  protected

    procedure ExpandDatabaseSettingsPanel;
    procedure CollapseDatabaseSettingsPanel;
    
  protected

    procedure FillControlsByViewModel(ViewModel: TSystemAuthentificationFormViewModel); override;
    procedure FillViewModelByControls; override;

  protected

    function InputCredentialsDataFormatValid: Boolean; override;

  private

    function GetDatabaseAuthentificationFormViewModel:
      TDatabaseAuthentificationFormViewModel;

    procedure SetDatabaseAuthentificationFormViewModel(
      const Value: TDatabaseAuthentificationFormViewModel
    );
      
  public

    property ViewModel: TDatabaseAuthentificationFormViewModel
    read GetDatabaseAuthentificationFormViewModel
    write SetDatabaseAuthentificationFormViewModel;

  end;

var
  DatabaseAuthentificationForm: TDatabaseAuthentificationForm;

implementation
  
{$R *.dfm}

{ TDatabaseAuthentificationForm }

procedure TDatabaseAuthentificationForm.actCollapseDatabaseSettingsPanelExecute(
  Sender: TObject);
begin

  CollapseDatabaseSettingsPanel;

end;

procedure TDatabaseAuthentificationForm.actExpandDatabaseSettingsPanelExecute(Sender: TObject);
begin

  ExpandDatabaseSettingsPanel;

end;

procedure TDatabaseAuthentificationForm.AdjustHeightBy(const HeightDelta: Integer);
begin

  Constraints.MinHeight := Constraints.MinHeight + HeightDelta;
  Constraints.MaxHeight := Constraints.MinHeight;

end;

procedure TDatabaseAuthentificationForm.CollapseDatabaseSettingsPanel;
begin

  DatabaseSettingsPanel.Hide;

  DatabaseSettingsButton.Action := actExpandDatabaseSettingsPanel;

  AdjustHeightBy(-DatabaseSettingsPanel.Height);
  
end;

procedure TDatabaseAuthentificationForm.ExpandDatabaseSettingsPanel;
begin

  DatabaseSettingsPanel.Show;

  DatabaseSettingsButton.Action := actCollapseDatabaseSettingsPanel;

  AdjustHeightBy(DatabaseSettingsPanel.Height);
  
end;

procedure TDatabaseAuthentificationForm.FillControlsByViewModel(
  ViewModel: TSystemAuthentificationFormViewModel);
begin

  inherited;

  with ViewModel as TDatabaseAuthentificationFormViewModel do begin

    DatabaseComboBox.Items := DatabaseNames;
    DatabaseComboBox.Text := CurrentDatabaseName;
    
  end;

end;

procedure TDatabaseAuthentificationForm.FillViewModelByControls;
begin

  inherited;

  if DatabaseComboBox.ItemIndex = -1 then
    ViewModel.CurrentDatabaseName := DatabaseComboBox.Text

  else begin
  
    ViewModel.CurrentDatabaseName :=
      DatabaseComboBox.Items[DatabaseComboBox.ItemIndex];

  end;

  ViewModel.DatabaseNames.Assign(DatabaseComboBox.Items);
  
end;

function TDatabaseAuthentificationForm.
  GetDatabaseAuthentificationFormViewModel: TDatabaseAuthentificationFormViewModel;
begin

  Result := TDatabaseAuthentificationFormViewModel(inherited ViewModel);
  
end;

procedure TDatabaseAuthentificationForm.Initialize;
begin

  inherited;

  CollapseDatabaseSettingsPanel;
  
end;

function TDatabaseAuthentificationForm.InputCredentialsDataFormatValid: Boolean;
var IsDatabaseNameValid: Boolean;
begin

  IsDatabaseNameValid := DatabaseComboBox.Validate;
  
  Result :=
    inherited InputCredentialsDataFormatValid and
    IsDatabaseNameValid;
    
end;

procedure TDatabaseAuthentificationForm.SetDatabaseAuthentificationFormViewModel(
  const Value: TDatabaseAuthentificationFormViewModel);
begin

  SetViewModel(Value);
  
end;

end.
