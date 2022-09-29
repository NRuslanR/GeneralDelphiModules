unit NameValue;

interface

uses

  SysUtils,
  Classes,
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
    
  end;

implementation

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

end.
