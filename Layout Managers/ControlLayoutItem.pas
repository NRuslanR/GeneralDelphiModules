unit ControlLayoutItem;

interface

uses

  Windows,
  LayoutItem,
  Controls,
  StdCtrls,
  SysUtils,
  Classes;

type

  TControlLayoutItem = class (TLayoutItem)

    protected

      FControl: TControl;

      function GetId: Variant; override;
      function GetHeight: Integer; override;
      function GetWidth: Integer; override;

      procedure SetHeight(const Value: Integer); override;
      procedure SetWidth(const Value: Integer); override;

      procedure AdjustControlSizeIfItIsCheckBox;
      
    public

      constructor Create; overload;
      constructor Create(Control: TControl); overload;

      procedure Execute; override;
      
    published

      property Control: TControl read FControl write FControl;
      
  end;

implementation

uses

  Variants,
  AuxWindowsFunctionsUnit;
  
{ TControlLayoutItem }

procedure TControlLayoutItem.AdjustControlSizeIfItIsCheckBox;
begin

  if not (FControl is TCheckBox) then Exit;

  AdjustCheckBoxSize(FControl as TCheckBox);
  
end;

procedure TControlLayoutItem.Execute;
begin

  Control.Left := Left;
  Control.Top := Top;

end;

constructor TControlLayoutItem.Create(Control: TControl);
begin

  inherited Create;

  Self.Control := Control;
  
end;

constructor TControlLayoutItem.Create;
begin

  inherited;

end;

function TControlLayoutItem.GetHeight: Integer;
begin

  AdjustControlSizeIfItIsCheckBox;
  
  Result := Control.Height;
  
end;

function TControlLayoutItem.GetId: Variant;
begin

  if Assigned(FControl) then
    Result := FControl.Name

  else Result := Null;
  
end;

function TControlLayoutItem.GetWidth: Integer;
begin

  AdjustControlSizeIfItIsCheckBox;
  
  Result := Control.Width;
  
end;


procedure TControlLayoutItem.SetHeight(const Value: Integer);
begin

  Control.Height := Value;

end;

procedure TControlLayoutItem.SetWidth(const Value: Integer);
begin

  Control.Width := Value;

end;

end.
