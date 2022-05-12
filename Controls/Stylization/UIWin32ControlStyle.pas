unit UIWin32ControlStyle;

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

  TUIDateTimePickerStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override; 
    
  end;

implementation

{ TUIDateTimePickerStyle }

procedure TUIDateTimePickerStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TDateTimePicker do begin

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

end.
