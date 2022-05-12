unit UIStandardControlStyle;

interface

uses

  UIControlStyle,
  Forms,
  Graphics,
  Controls,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  SysUtils,
  Variants,
  Classes;

type

  TUIEditStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;
      
  end;

  TUIMemoStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;
      
  end;

  TUIButtonStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUICheckBoxtyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUIRadioButtonStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUIListBoxStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUIComboBoxStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUIScrollBarStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUIGroupBoxStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUIPanelStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

  TUIFormStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;
      
  end;

  
implementation

{ TUIEditStyle }

procedure TUIEditStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TEdit do begin

    if not VarIsNull(FAutoSize) then
      AutoSize := FAutoSize;

    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FBevelKind) then
      BevelKind := FBevelKind;

    if not VarIsNull(FBevelInner) then
      BevelInner := FBevelInner;

    if not VarIsNull(FBevelWidth) then
      BevelWidth := FBevelWidth;

    if not VarIsNull(FBevelOuter) then
      BevelOuter := FBevelOuter;

    if not VarIsNull(FBorderStyle) then
      BorderStyle := BorderStyle;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

  end;

end;

{ TUIMemoStyle }

procedure TUIMemoStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TMemo do begin

    if not VarIsNull(FAlignment) then
      Alignment := FAlignment;

    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FBevelKind) then
      BevelKind := FBevelKind;

    if not VarIsNull(FBevelInner) then
      BevelInner := FBevelInner;

    if not VarIsNull(FBevelOuter) then
      BevelOuter := FBevelOuter;

    if not VarIsNull(FBorderStyle) then
      BorderStyle := BorderStyle;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if FBevelEdges <> [] then
      BevelEdges := FBevelEdges;

  end;

end;

procedure TUIButtonStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TButton do begin

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if not VarIsNull(FCaption) then
      Caption := FCaption;

  end;
  
end;

{ TUICheckBoxtyle }

procedure TUICheckBoxtyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TCheckBox do begin

    if not VarIsNull(FAlignment) then
      Alignment := FAlignment;

    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if not VarIsNull(FCaption) then
      Caption := FCaption;
      
  end;

end;

{ TUIRadioButtonStyle }

procedure TUIRadioButtonStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TRadioButton do begin

    if not VarIsNull(FAlignment) then
      Alignment := FAlignment;

    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if not VarIsNull(FCaption) then
      Caption := FCaption;

  end;

end;

{ TUIListBoxStyle }

procedure TUIListBoxStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TListBox do begin

    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FBevelKind) then
      BevelKind := FBevelKind;

    if not VarIsNull(FBevelInner) then
      BevelInner := FBevelInner;

    if not VarIsNull(FBevelOuter) then
      BevelOuter := FBevelOuter;

    if not VarIsNull(FBorderStyle) then
      BorderStyle := BorderStyle;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if FBevelEdges <> [] then
      BevelEdges := FBevelEdges;

  end;

end;

{ TUIComboBoxStyle }

procedure TUIComboBoxStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TComboBox do begin
  
    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FBevelKind) then
      BevelKind := FBevelKind;

    if not VarIsNull(FBevelInner) then
      BevelInner := FBevelInner;

    if not VarIsNull(FBevelOuter) then
      BevelOuter := FBevelOuter;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if FBevelEdges <> [] then
      BevelEdges := FBevelEdges;

  end;

end;

{ TUIScrollBarStyle }

procedure TUIScrollBarStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TScrollBar do begin

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;
      
  end;

end;

{ TUIGroupBoxStyle }

procedure TUIGroupBoxStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TGroupBox do begin
  
    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if not VarIsNull(FCaption) then
      Caption := FCaption;

  end;

end;

{ TUIPanelStyle }

procedure TUIPanelStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TPanel do begin

    if not VarIsNull(FAlignment) then
      Alignment := FAlignment;

    if not VarIsNull(FAutoSize) then
      AutoSize := FAutoSize;

    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FDragCursor) then
      DragCursor := FDragCursor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FBevelKind) then
      BevelKind := FBevelKind;

    if not VarIsNull(FBevelInner) then
      BevelInner := FBevelInner;

    if not VarIsNull(FBevelOuter) then
      BevelOuter := FBevelOuter;

    if not VarIsNull(FBorderStyle) then
      BorderStyle := BorderStyle;

    if not VarIsNull(FBorderWidth) then
      BorderWidth := FBorderWidth;

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if FBevelEdges <> [] then
      BevelEdges := FBevelEdges;

    if not VarIsNull(FCaption) then
      Caption := FCaption;
      
  end;

end;

{ TUIFormStyle }

procedure TUIFormStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TForm do begin

    if not VarIsNull(FAutoSize) then
      AutoSize := FAutoSize;

    if not VarIsNull(FColor) then
      Color := FColor;

    if not VarIsNull(FFont) then
      Font := TypedFont;

    if not VarIsNull(FBorderStyle) then
      BorderStyle := BorderStyle;

    if not VarIsNull(FBorderWidth) then
      BorderWidth := FBorderWidth;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if not VarIsNull(FCaption) then
      Caption := FCaption;

  end;

end;

end.
