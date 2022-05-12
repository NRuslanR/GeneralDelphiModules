unit UIControlStyle;

interface

uses

  Forms,
  IGetSelfUnit,
  Graphics,
  Controls,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  SysUtils,
  Variants,
  Classes;

type

  IUIControlStyle = interface (IGetSelf)
    ['{BF1DB434-B2B5-44EE-82D5-04994B52BDC7}']
    
    procedure Apply(Control: TWinControl);

    function Align: Variant; overload;
    function Alignment: Variant; overload;
    function AutoSize: Variant; overload;
    function BevelEdges: TBevelEdges; overload;
    function BevelInner: Variant; overload;
    function BevelKind: Variant; overload;
    function BevelOuter: Variant; overload;
    function BevelWidth: Variant; overload;
    function BorderStyle: Variant; overload;
    function BorderWidth: Variant; overload;
    function Caption: Variant; overload;
    function Color: Variant; overload;
    function Cursor: Variant; overload;
    function DragCursor: Variant; overload;
    function Enabled: Variant; overload;
    function Font: Variant; overload;
    function Height: Variant; overload;
    function Width: Variant; overload;
    function Left: Variant; overload;
    function ParentColor: Variant; overload;
    function ParentFont: Variant; overload;
    function Top: Variant; overload;
    function Visible: Variant; overload;

    function Align(Value: TAlign): IUIControlStyle; overload;
    function Alignment(Value: TAlignment): IUIControlStyle; overload;
    function AutoSize(Value: Boolean): IUIControlStyle; overload;
    function BevelEdges(Value: TBevelEdges): IUIControlStyle; overload;
    function BevelInner(Value: TBevelCut): IUIControlStyle; overload;
    function BevelKind(Value: TBevelKind): IUIControlStyle; overload;
    function BevelOuter(Value: TBevelCut): IUIControlStyle; overload;
    function BevelWidth(Value: Integer): IUIControlStyle; overload;
    function BorderStyle(Value: TBorderStyle): IUIControlStyle; overload;
    function BorderWidth(Value: Integer): IUIControlStyle; overload;
    function Caption(Value: String): IUIControlStyle; overload;
    function Color(Value: TColor): IUIControlStyle; overload;
    function Cursor(Value: TCursor): IUIControlStyle; overload;
    function DragCursor(Value: TCursor): IUIControlStyle; overload;
    function Enabled(Value: Boolean): IUIControlStyle; overload;
    function Font(Value: TFont): IUIControlStyle; overload;
    function Height(Value: Integer): IUIControlStyle; overload;
    function Width(Value: Integer): IUIControlStyle; overload;
    function Left(Value: Integer): IUIControlStyle; overload;
    function ParentColor(Value: Boolean): IUIControlStyle; overload;
    function ParentFont(Value: Boolean): IUIControlStyle; overload;
    function Top(Value: Integer): IUIControlStyle; overload;
    function Visible(Value: Boolean): IUIControlStyle; overload;

  end;

  TUIControlStyle = class abstract (TInterfacedObject, IUIControlStyle)

    protected

      FAlign: Variant;
      FAlignment: Variant;
      FAutoSize: Variant;
      FBevelEdges: TBevelEdges;
      FBevelInner: Variant;
      FBevelKind: Variant;
      FBevelOuter: Variant;
      FBevelWidth: Variant;
      FBorderStyle: Variant;
      FBorderWidth: Variant;
      FCaption: Variant;
      FColor: Variant;
      FCursor: Variant;
      FDragCursor: Variant;
      FEnabled: Variant;
      FFont: Variant;
      FHeight: Variant;
      FWidth: Variant;
      FLeft: Variant;
      FParentColor: Variant;
      FParentFont: Variant;
      FTop: Variant;
      FVisible: Variant;

      function TypedFont: TFont;

    public
      
      function Align: Variant; overload;
      function Alignment: Variant; overload;
      function AutoSize: Variant; overload;
      function BevelEdges: TBevelEdges; overload;
      function BevelInner: Variant; overload;
      function BevelKind: Variant; overload;
      function BevelOuter: Variant; overload;
      function BevelWidth: Variant; overload;
      function BorderStyle: Variant; overload;
      function BorderWidth: Variant; overload;
      function Caption: Variant; overload;
      function Color: Variant; overload;
      function Cursor: Variant; overload;
      function DragCursor: Variant; overload;
      function Enabled: Variant; overload;
      function Font: Variant; overload;
      function Height: Variant; overload;
      function Width: Variant; overload;
      function Left: Variant; overload;
      function ParentColor: Variant; overload;
      function ParentFont: Variant; overload;
      function Top: Variant; overload;
      function Visible: Variant; overload;

    public

      function Align(Value: TAlign): IUIControlStyle; overload;
      function Alignment(Value: TAlignment): IUIControlStyle; overload;
      function AutoSize(Value: Boolean): IUIControlStyle; overload;
      function BevelEdges(Value: TBevelEdges): IUIControlStyle; overload;
      function BevelInner(Value: TBevelCut): IUIControlStyle; overload;
      function BevelKind(Value: TBevelKind): IUIControlStyle; overload;
      function BevelOuter(Value: TBevelCut): IUIControlStyle; overload;
      function BevelWidth(Value: Integer): IUIControlStyle; overload;
      function BorderStyle(Value: TBorderStyle): IUIControlStyle; overload;
      function BorderWidth(Value: Integer): IUIControlStyle; overload;
      function Caption(Value: String): IUIControlStyle; overload;
      function Color(Value: TColor): IUIControlStyle; overload;
      function Cursor(Value: TCursor): IUIControlStyle; overload;
      function DragCursor(Value: TCursor): IUIControlStyle; overload;
      function Enabled(Value: Boolean): IUIControlStyle; overload;
      function Font(Value: TFont): IUIControlStyle; overload;
      function Height(Value: Integer): IUIControlStyle; overload;
      function Width(Value: Integer): IUIControlStyle; overload;
      function Left(Value: Integer): IUIControlStyle; overload;
      function ParentColor(Value: Boolean): IUIControlStyle; overload;
      function ParentFont(Value: Boolean): IUIControlStyle; overload;
      function Top(Value: Integer): IUIControlStyle; overload;
      function Visible(Value: Boolean): IUIControlStyle; overload;

    public

      destructor Destroy; override;
      
      constructor Create; virtual;
      
      function GetSelf: TObject;

      procedure Apply(Control: TWinControl); virtual;

  end;

implementation

{ TUIControlStyle }

constructor TUIControlStyle.Create;
begin

  FAlign := Null;
  FAlignment := Null;
  FAutoSize := Null;
  FBevelEdges := [];
  FBevelInner := Null;
  FBevelKind := Null;
  FBevelOuter := Null;
  FBevelWidth := Null;
  FBorderStyle := Null;
  FBorderWidth := Null;
  FCaption := Null;
  FColor := Null;
  FCursor := Null;
  FDragCursor := Null;
  FEnabled := Null;
  FFont := Null;
  FHeight := Null;
  FWidth := Null;
  FLeft := Null;
  FParentColor := Null;
  FParentFont := Null;
  FTop := Null;
  FVisible := Null;    

end;

function TUIControlStyle.Align(Value: TAlign): IUIControlStyle;
begin

  FAlign := Value;

  Result := Self;

end;

function TUIControlStyle.Align: Variant;
begin

  Result := FAlign;
  
end;

function TUIControlStyle.Alignment(Value: TAlignment): IUIControlStyle;
begin

  FAlignment := Value;

  Result := Self;
  
end;

function TUIControlStyle.Alignment: Variant;
begin

  Result := FAlignment;

end;

function TUIControlStyle.AutoSize(Value: Boolean): IUIControlStyle;
begin

  FAutoSize := Value;

  Result := Self;
  
end;

function TUIControlStyle.AutoSize: Variant;
begin

  Result := FAutoSize;

end;

function TUIControlStyle.BevelEdges(Value: TBevelEdges): IUIControlStyle;
begin

  FBevelEdges := Value;

  Result := Self;
  
end;

function TUIControlStyle.BevelEdges: TBevelEdges;
begin

  Result := FBevelEdges;
  
end;

function TUIControlStyle.BevelInner(Value: TBevelCut): IUIControlStyle;
begin

  FBevelInner := Value;

  Result := Self;
  
end;

function TUIControlStyle.BevelInner: Variant;
begin

  Result := FBevelInner;

end;

function TUIControlStyle.BevelKind(Value: TBevelKind): IUIControlStyle;
begin

  FBevelKind := Value;

  Result := Self;
    
end;

function TUIControlStyle.BevelKind: Variant;
begin

  Result := FBevelKind;

end;

function TUIControlStyle.BevelOuter(Value: TBevelCut): IUIControlStyle;
begin

  FBevelOuter := Value;

  Result := Self;
  
end;

function TUIControlStyle.BevelOuter: Variant;
begin

  Result := FBevelOuter;

end;

function TUIControlStyle.BevelWidth(Value: Integer): IUIControlStyle;
begin

  FBevelWidth := Value;

  Result := Self;
  
end;

function TUIControlStyle.BevelWidth: Variant;
begin

  Result := FBevelWidth;
  
end;

function TUIControlStyle.BorderStyle: Variant;
begin

  Result := FBorderStyle;
  
end;

function TUIControlStyle.BorderStyle(Value: TBorderStyle): IUIControlStyle;
begin

  FBorderStyle := Value;

  Result := Self;
  
end;

function TUIControlStyle.BorderWidth: Variant;
begin

  Result := BorderWidth;
  
end;

function TUIControlStyle.BorderWidth(Value: Integer): IUIControlStyle;
begin

  FBorderWidth := Value;

  Result := Self;

end;

function TUIControlStyle.Caption(Value: String): IUIControlStyle;
begin

  FCaption := Value;

  Result := Self;

end;

function TUIControlStyle.Caption: Variant;
begin

  Result := FCaption;

end;

function TUIControlStyle.Color: Variant;
begin

  Result := FColor;

end;

function TUIControlStyle.Color(Value: TColor): IUIControlStyle;
begin

  FColor := Value;

  Result := Self;

end;

function TUIControlStyle.Cursor(Value: TCursor): IUIControlStyle;
begin

  FCursor := Value;

  Result := Self;
  
end;

function TUIControlStyle.Cursor: Variant;
begin

  Result := FCursor;
  
end;

destructor TUIControlStyle.Destroy;
begin

  inherited;

end;

function TUIControlStyle.DragCursor(Value: TCursor): IUIControlStyle;
begin

  FDragCursor := Value;

  Result := Self;
  
end;

function TUIControlStyle.DragCursor: Variant;
begin

  Result := FCursor;
  
end;

function TUIControlStyle.Enabled: Variant;
begin

  Result := FEnabled;

end;

function TUIControlStyle.Enabled(Value: Boolean): IUIControlStyle;
begin

  FEnabled := Value;

  Result := Self;

end;

function TUIControlStyle.Font(Value: TFont): IUIControlStyle;
begin

  TVarData(FFont).VType := varByRef;
  TVarData(FFont).VPointer := Value;

  Result := Self;
  
end;

function TUIControlStyle.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TUIControlStyle.Font: Variant;
begin

  Result := FFont;

end;

function TUIControlStyle.Height(Value: Integer): IUIControlStyle;
begin

  FHeight := Value;

  Result := Self;
  
end;

function TUIControlStyle.Height: Variant;
begin

  Result := FHeight;
  
end;

function TUIControlStyle.Left(Value: Integer): IUIControlStyle;
begin

  FLeft := Value;

  Result := Self;
  
end;

function TUIControlStyle.Left: Variant;
begin

  Result := FLeft;
  
end;

function TUIControlStyle.ParentColor(Value: Boolean): IUIControlStyle;
begin

  FParentColor := Value;

  Result := Self;

end;

function TUIControlStyle.ParentColor: Variant;
begin         

  Result := FParentColor;

end;

function TUIControlStyle.ParentFont: Variant;
begin

  Result := FParentFont;

end;

function TUIControlStyle.ParentFont(Value: Boolean): IUIControlStyle;
begin

  FParentFont := Value;

  Result := Self;
  
end;

function TUIControlStyle.Top(Value: Integer): IUIControlStyle;
begin

  FTop := Value;

  Result := Self;

end;

function TUIControlStyle.TypedFont: TFont;
begin

  if not VarIsNull(FFont) then
    Result := TFont(TVarData(FFont).VPointer)

  else Result := nil;

end;

function TUIControlStyle.Top: Variant;
begin

  Result := FTop;

end;

function TUIControlStyle.Visible(Value: Boolean): IUIControlStyle;
begin

  FVisible := Value;

  Result := Self;
  
end;

function TUIControlStyle.Visible: Variant;
begin

  Result := FVisible;
  
end;

function TUIControlStyle.Width: Variant;
begin

  Result := FWidth;

end;

function TUIControlStyle.Width(Value: Integer): IUIControlStyle;
begin

  FWidth := Value;

  Result := Self;
  
end;

procedure TUIControlStyle.Apply(Control: TWinControl);
begin

  if not VarIsNull(FAlign) then
    Control.Align := FAlign;

  if not VarIsNull(FCursor) then
    Control.Cursor := FCursor;

  if not VarIsNull(FEnabled) then
    Control.Enabled := FEnabled;

  if not VarIsNull(FLeft) then
    Control.Left := FLeft;

  if not VarIsNull(FTop) then
    Control.Top := FTop;

  if not VarIsNull(FWidth) then
    Control.Width := FWidth;

  if not VarIsNull(FHeight) then
    Control.Height := FHeight;

  if not VarIsNull(FVisible) then
    Control.Visible := FVisible;

end;

end.