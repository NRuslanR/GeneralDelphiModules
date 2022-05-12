unit DBDataTableFormStyle;

interface

uses

  UIControlStyle,
  UIStandardControlStyle,
  Graphics,
  Controls,
  SysUtils,
  Variants,
  Classes;

type

  TDBDataTableFormStyle = class (TUIFormStyle)

    protected

      FRecordGridSkinName: Variant;
      FRecordMovingToolBarVisible: Variant;
      FFocusedRecordColor: Variant;
      FSelectedRecordColor: Variant;
      FFocusedRecordTextColor: Variant;
      FSelectedRecordTextColor: Variant;

    public

      function RecordGridSkinName: Variant; overload;
      function RecordMovingToolBarVisible: Variant; overload;
      function FocusedRecordColor: Variant; overload;
      function SelectedRecordColor: Variant; overload;
      function FocusedRecordTextColor: Variant; overload;
      function SelectedRecordTextColor: Variant; overload;

    public

      function RecordGridSkinName(Value: String): TDBDataTableFormStyle; overload;
      function RecordMovingToolBarVisible(Value: Boolean): TDBDataTableFormStyle; overload;
      function FocusedRecordColor(Value: TColor): TDBDataTableFormStyle; overload;
      function SelectedRecordColor(Value: TColor): TDBDataTableFormStyle; overload;
      function FocusedRecordTextColor(Value: TColor): TDBDataTableFormStyle; overload;
      function SelectedRecordTextColor(Value: TColor): TDBDataTableFormStyle; overload;
      
    public

      constructor Create; override;

      procedure Apply(Control: TWinControl); override;

  end;


implementation

uses

  DBDataTableFormUnit;

{ TDBDataTableFormStyle }

procedure TDBDataTableFormStyle.Apply(Control: TWinControl);
begin

  inherited;

  with Control as TDBDataTableForm do begin

    if not VarIsNull(FRecordGridSkinName) then
      DataRecordGrid.LookAndFeel.SkinName := FRecordGridSkinName;

    if not VarIsNull(FRecordMovingToolBarVisible) then
      DataRecordMovingToolBar.Visible := FRecordMovingToolBarVisible;

    if not VarIsNull(FFocusedRecordColor) then
      FocusedCellColor := FFocusedRecordColor;

    if not VarIsNull(FSelectedRecordColor) then
      SelectedRecordsColor := FSelectedRecordColor;

    if not VarIsNull(FFocusedRecordTextColor) then
      FocusedCellTextColor := FFocusedRecordTextColor;

    if not VarIsNull(FSelectedRecordTextColor) then
      SelectedRecordsTextColor := FSelectedRecordTextColor;

  end;

end;

function TDBDataTableFormStyle.FocusedRecordColor: Variant;
begin

  Result := FFocusedRecordColor;

end;

constructor TDBDataTableFormStyle.Create;
begin

  inherited Create;

  FRecordGridSkinName := Null;
  FRecordMovingToolBarVisible := Null;
  FFocusedRecordColor := Null;
  FSelectedRecordColor := Null;
  FFocusedRecordTextColor := Null;
  FSelectedRecordTextColor := Null;
  
end;

function TDBDataTableFormStyle.FocusedRecordColor(
  Value: TColor): TDBDataTableFormStyle;
begin

  FFocusedRecordColor := Value;

  Result := Self;
  
end;

function TDBDataTableFormStyle.FocusedRecordTextColor: Variant;
begin

  Result := FFocusedRecordTextColor;

end;

function TDBDataTableFormStyle.FocusedRecordTextColor(
  Value: TColor): TDBDataTableFormStyle;
begin

  FFocusedRecordTextColor := Value;

  Result := Self;
  
end;

function TDBDataTableFormStyle.RecordGridSkinName(
  Value: String): TDBDataTableFormStyle;
begin

  FRecordGridSkinName := Value;

  Result := Self;
  
end;

function TDBDataTableFormStyle.RecordGridSkinName: Variant;
begin

  Result := FRecordGridSkinName;
  
end;

function TDBDataTableFormStyle.RecordMovingToolBarVisible: Variant;
begin

  Result := FRecordMovingToolBarVisible;
  
end;

function TDBDataTableFormStyle.RecordMovingToolBarVisible(
  Value: Boolean): TDBDataTableFormStyle;
begin

  FRecordMovingToolBarVisible := Value;

  Result := Self;
  
end;

function TDBDataTableFormStyle.SelectedRecordColor(
  Value: TColor): TDBDataTableFormStyle;
begin

  FSelectedRecordColor := Value;

  Result := Self;
  
end;

function TDBDataTableFormStyle.SelectedRecordColor: Variant;
begin

  Result := FSelectedRecordColor;
  
end;

function TDBDataTableFormStyle.SelectedRecordTextColor(
  Value: TColor): TDBDataTableFormStyle;
begin

  FSelectedRecordTextColor := Value;

  Result := Self;
  
end;

function TDBDataTableFormStyle.SelectedRecordTextColor: Variant;
begin

  Result := FSelectedRecordTextColor;
  
end;

end.
