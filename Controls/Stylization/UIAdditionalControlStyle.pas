unit UIAdditionalControlStyle;

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

  TUIScrollBoxStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;
      
  end;

implementation

{ TUIScrollBoxStyle }

procedure TUIScrollBoxStyle.Apply(Control: TWinControl);
begin

  inherited Apply(Control);

  with Control as TScrollBox do begin

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

    if not VarIsNull(FParentColor) then
      ParentColor := FParentColor;

    if not VarIsNull(FParentFont) then
      ParentFont := FParentFont;

    if FBevelEdges <> [] then
      BevelEdges := FBevelEdges;

  end;
  
end;

end.
