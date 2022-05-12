unit LayoutItem;

interface

uses

  Windows,
  SysUtils,
  Classes;

type

  TLayoutItem = class abstract (TObject)

    protected

      FId: Variant;
      FLeft: Integer;
      FTop: Integer;
      
    protected

      function GetId: Variant; virtual;
      function GetLeft: Integer; virtual;
      function GetTop: Integer; virtual;
      function GetRight: Integer; virtual;
      function GetBottom: Integer; virtual;
      function GetBoundsRect: TRect; virtual;
      function GetHeight: Integer; virtual; abstract;
      function GetWidth: Integer; virtual; abstract;

      procedure SetId(const Value: Variant); virtual;
      procedure SetLeft(const Value: Integer); virtual;
      procedure SetTop(const Value: Integer); virtual;
      procedure SetRight(const Value: Integer); virtual;
      procedure SetBottom(const Value: Integer); virtual;
      procedure SetBoundsRect(const Value: TRect); virtual; 
      procedure SetHeight(const Value: Integer); virtual; abstract;
      procedure SetWidth(const Value: Integer); virtual; abstract;

    public

      destructor Destroy; override;
      constructor Create; overload; virtual;
      constructor Create(const Id: Variant); overload; virtual;

      procedure Execute; virtual; abstract;
      
    published

      property Id: Variant read GetId write SetId;
      property Left: Integer read GetLeft write SetLeft;
      property Top: Integer read GetTop write SetTop;
      property Right: Integer read GetRight write SetRight;
      property Bottom: Integer read GetBottom write SetBottom;
      property Width: Integer read GetWidth write SetWidth;
      property Height: Integer read GetHeight write SetHeight;
      property BoundsRect: TRect read GetBoundsRect write SetBoundsRect;

  end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit,
  ControlLayoutItem;
{ TLayoutItem }

constructor TLayoutItem.Create;
begin

  inherited;
  
end;

constructor TLayoutItem.Create(const Id: Variant);
begin

  inherited Create;

  Self.Id := Id;
  
end;

destructor TLayoutItem.Destroy;
begin

  inherited;

end;

function TLayoutItem.GetBottom: Integer;
begin

  Result := Top + Height;

end;

function TLayoutItem.GetBoundsRect: TRect;
begin

  Result := Rect(Left, Top, Right, Bottom);
  
end;

function TLayoutItem.GetId: Variant;
begin

  Result := FId
  
end;

function TLayoutItem.GetLeft: Integer;
begin

  Result := FLeft;
  
end;

function TLayoutItem.GetRight: Integer;
begin

  Result := Left + Width;

end;

function TLayoutItem.GetTop: Integer;
begin

  Result := FTop;
  
end;

procedure TLayoutItem.SetBottom(const Value: Integer);
begin

  Top := Value - Height;
  
end;

procedure TLayoutItem.SetBoundsRect(const Value: TRect);
begin

  Left := Value.Left;
  Top := Value.Top;
  Width := Value.Right - Value.Left;
  Height := Value.Bottom - Value.Top;

end;

procedure TLayoutItem.SetId(const Value: Variant);
begin

  FId := Value;
  
end;

procedure TLayoutItem.SetLeft(const Value: Integer);
begin

  FLeft := Value;
  
end;

procedure TLayoutItem.SetRight(const Value: Integer);
begin

  Left := Value - Width;
  
end;

procedure TLayoutItem.SetTop(const Value: Integer);
begin

  FTop := Value;

end;

end.
