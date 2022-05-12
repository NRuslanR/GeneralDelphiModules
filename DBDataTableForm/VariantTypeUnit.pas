unit VariantTypeUnit;

interface

uses

  Variants,
  VariantFunctions,
  Cloneable;

type

  TVariant = class sealed (TCloneable)

    private

      FValue: Variant;
      FFreeValue: IInterface;

      procedure SetValue(const Value: Variant);

    public

      constructor Create; overload;
      constructor Create(Value: IInterface); overload;
      constructor Create(const AValue: Variant); overload;

      property Value: Variant read FValue write SetValue;

      procedure SetValueAsInterface(Value: IInterface);
      
      function Clone: TObject; override;
      
  end;

implementation


{ TVariant }

function TVariant.Clone: TObject;
begin

  Result := TVariant.Create(FValue);
  
end;

constructor TVariant.Create(const AValue: Variant);
begin

  inherited Create;

  Self.Value := AValue;
  
end;

constructor TVariant.Create(Value: IInterface);
begin

  inherited Create;

  SetValueAsInterface(Value);

end;

procedure TVariant.SetValue(const Value: Variant);

begin

  FValue := Value;

end;

procedure TVariant.SetValueAsInterface(Value: IInterface);
begin

  Self.Value := InterfaceToVariant(Value);

  FFreeValue := Value;

end;

constructor TVariant.Create;
begin

  inherited;
  
end;

end.
