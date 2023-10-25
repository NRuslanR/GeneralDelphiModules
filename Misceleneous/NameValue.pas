unit NameValue;

interface

uses

  SysUtils,
  Classes,
  Disposable,
  VariantListUnit;

type

  TNameValue = record

    Name: String;
    Value: Variant;

    constructor Create(
      const Name: String;
      const Value: Variant
    );

    class procedure Deconstruct(
      NameValueArr: array of TNameValue;
      var FieldNames: TStrings;
      var FieldValues: TVariantList
    ); static;

    class function Empty: TNameValue; static;
    
    class function FindByName(List: array of TNameValue; const Name: String): TNameValue; static;
    
  end;

  TCNameValue = class (TInterfacedObject, IDisposable)

    private

      FInternal: TNameValue;

      function GetName: String;
      function GetValue: Variant;
      
      procedure SetName(const Value: String);
      procedure SetValue(const Value: Variant);

    public

      constructor Create(
        const Name: String;
        const Value: Variant
      );

      class procedure Deconstruct(
        NameValueArr: array of TNameValue;
        var FieldNames: TStrings;
        var FieldValues: TVariantList
      ); static;

      property Name: String read GetName write SetName;
      property Value: Variant read GetValue write SetValue;
      
  end;

implementation

uses

  Variants;

{ TNameValue }

constructor TNameValue.Create(const Name: String; const Value: Variant);
begin

  Self.Name := Name;
  Self.Value := Value;
  
end;

class procedure TNameValue.Deconstruct(
  NameValueArr: array of TNameValue;
  var FieldNames: TStrings;
  var FieldValues: TVariantList
);
var
    I: Integer;
begin

  if Length(NameValueArr) = 0 then begin

    FieldNames := nil;
    FieldValues := nil;

    Exit;

  end;

  FieldNames := TStringList.Create;
  FieldValues := TVariantList.Create;

  try

    for I := Low(NameValueArr) to High(NameValueArr) do begin

      FieldNames.Add(NameValueArr[I].Name);
      FieldValues.Add(NameValueArr[I].Value);
      
    end;

  except

    FreeAndNil(FieldNames);
    FreeAndNil(FieldValues);

    Raise;

  end;

end;

class function TNameValue.Empty: TNameValue;
begin

  Result.Name := '';
  Result.Value := Null;
  
end;

class function TNameValue.FindByName(List: array of TNameValue;
  const Name: String): TNameValue;
var
    NameValue: TNameValue;
begin

  for NameValue in List do begin

    if NameValue.Name = Name then begin

      Result := NameValue;
      Exit;

    end;

  end;

  Result := Empty;
  
end;

{ TCNameValue }

constructor TCNameValue.Create(const Name: String; const Value: Variant);
begin

  inherited Create;

  FInternal := TNameValue.Create(Name, Value);

end;

class procedure TCNameValue.Deconstruct(
  NameValueArr: array of TNameValue;
  var FieldNames: TStrings;
  var FieldValues: TVariantList
);
begin

  TNameValue.Deconstruct(NameValueArr, FieldNames, FieldValues);
  
end;

function TCNameValue.GetName: String;
begin

  Result := FInternal.Name;

end;

function TCNameValue.GetValue: Variant;
begin

  Result := FInternal.Value;

end;

procedure TCNameValue.SetName(const Value: String);
begin

  FInternal.Name := Value;

end;

procedure TCNameValue.SetValue(const Value: Variant);
begin

  FInternal.Value := Value;
  
end;

end.
