unit ArrayFunctions;

interface

uses

  SysUtils,
  Classes,
  Variants,
  ArrayTypes,
  VariantFunctions;

function AreValuesIncludedByArray(Values: array of Variant; Arr: array of Variant): Boolean; overload;
function ArraySlice(Arr: array of Variant; StartIndex: Integer; Length: Integer = -1): TVariantArray;
function ArrayRest(Arr: array of Variant): TVariantArray;
function ArrayFirstItem(Arr: array of Variant): Variant;
function ArrayLastItem(Arr: array of Variant): Variant;
function ArrayFirsts(Arr: array of Variant): TVariantArray;
function ArrayIntersect(First, Second: array of Variant): TVariantArray;
function StringsToArray(Strings: TStrings): TVariantArray;
function StringArrayToStrings(Strings: array of String): TStrings;
function StringArrayToArray(Strings: array of String): TVariantArray;
function ArrayDiff(Values: array of Variant; SubValues: array of Variant): TVariantArray;
function AreValuesIncludedByArray(Values: array of Variant; Strings: TStrings): Boolean; overload;
function AreValuesIncludedByArray(Values: TStrings; Arr: array of Variant): Boolean; overload;
function AreArraysSame(First: array of Variant; Second: array of Variant): Boolean;
function IsArrayContains(Arr: array of Variant; const Value: Variant): Boolean; overload;
function IsArrayEmpty(Arr: array of Variant): Boolean;
function IndexOf(const Value: Variant; Arr: array of Variant): Integer;
function AreValuesEqual(Values: array of Variant): Boolean; overload;
function NextArrayItem(Items: array of Variant; var Iterator: Integer; var Item: Variant; const EndPos: Integer = -1): Boolean;

implementation                                                    

function AreValuesIncludedByArray(Values: array of Variant; Arr: array of Variant): Boolean;
var
    Value: Variant;
begin

  for Value in Values do begin

    if not IsArrayContains(Arr, Value) then begin

      Result := False;
      Exit;
      
    end;

  end;

  Result := True;
  
end;

function AreValuesIncludedByArray(Values: array of Variant; Strings: TStrings): Boolean;
var
    Value: Variant;
begin

  for Value in Values do begin

    if Strings.IndexOf(Value) = -1 then begin

      Result := False;
      Exit;
      
    end;

  end;

  Result := True;

end;

function AreValuesIncludedByArray(Values: TStrings; Arr: array of Variant): Boolean;
var
    Str: String;
begin

  for Str in Values do begin

    if not IsArrayContains(Arr, Str) then begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;

end;

function IsArrayContains(Arr: array of Variant; const Value: Variant): Boolean;
begin

  Result := IndexOf(Value, Arr) <> -1;

end;

function IndexOf(const Value: Variant; Arr: array of Variant): Integer;
begin

  for Result := Low(Arr) to High(Arr) do
    if Arr[Result] = Value then
      Exit;

  Result := -1;

end;

function AreValuesEqual(Values: array of Variant): Boolean;
var
    I: Integer;
    CheckValue: Variant;
begin

  CheckValue := Variant(Values[0]);

  for I := Low(Values) + 1 to High(Values) do begin

    if CheckValue <> Values[I] then begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;

end;

function NextArrayItem(Items: array of Variant; var Iterator: Integer; var Item: Variant; const EndPos: Integer): Boolean;
begin

  Result :=
    (Iterator >= Low(Items)) and
    (Iterator <= High(Items)) and
    VarIfThen(EndPos <> -1, Iterator < EndPos, True);

  if not Result then Exit;

  Item := Items[Iterator];

  Inc(Iterator);

end;

function AreArraysSame(First: array of Variant; Second: array of Variant): Boolean;

    function _AreArraysSame(First: array of Variant; Second: array of Variant): Boolean;
    var
        I: Integer;
    begin

      for I := Low(First) to High(First) do begin
      
        if First[I] <> Second[I] then begin

          Result := False;
          Exit;

        end;

      end;

      Result := True;

    end;

begin

  Result := (Length(First) = Length(Second)) and _AreArraysSame(First, Second);

end;

function IsArrayEmpty(Arr: array of Variant): Boolean;
begin

  Result := Length(Arr) = 0;
  
end;

function ArrayDiff(Values: array of Variant; SubValues: array of Variant): TVariantArray;
var
    I: Integer;
    Value: Variant;
    DiffIndex: Integer;
begin

  SetLength(Result, Length(Values));

  I := 0; DiffIndex := 0;

  while NextArrayItem(Values, I, Value) do begin

    if not IsArrayContains(SubValues, Value) then

    Result[DiffIndex] := Value;

    Inc(DiffIndex);

  end;

  SetLength(Result, DiffIndex);
  
end;

function ArrayRest(Arr: array of Variant): TVariantArray;
begin

  Result := ArraySlice(Arr, 1);
  
end;

function ArrayFirsts(Arr: array of Variant): TVariantArray;
begin

  Result := ArraySlice(Arr, Length(Arr) - 2, 1);

end;

function ArrayFirstItem(Arr: array of Variant): Variant;
begin

  Result := Arr[0];

end;

function ArrayLastItem(Arr: array of Variant): Variant;
begin

  Result := Arr[Length(Arr) - 1];

end;

function ArraySlice(Arr: array of Variant; StartIndex: Integer; Length: Integer): TVariantArray;
var
    ArrLen: Integer;
    Value: Variant;
    EndPos: Integer;
    SliceIndex: Integer;
begin
  
  ArrLen := System.Length(Arr);

  if Length < 0 then
    Length := ArrLen - StartIndex;

  EndPos := StartIndex + Length;

  if (Length <= 0) or (StartIndex < 0) or (EndPos > ArrLen) then
  begin

    Result := nil;
    Exit;

  end;

  SetLength(Result, Length);

  SliceIndex := 0;

  while NextArrayItem(Arr, StartIndex, Value, EndPos) do begin

    Result[SliceIndex] := Value;

    Inc(SliceIndex);

  end;
  
end;

function ArrayIntersect(First, Second: array of Variant): TVariantArray;
var
    I: Integer;
    V: Variant;
    IntersectIndex: Integer;
begin

  SetLength(
    Result,
    Integer(
      VarIfThen(
        Length(First) < Length(Second),
        Length(Second),
        Length(First)
      )
    )
  );

  IntersectIndex := 0;

  while NextArrayItem(First, I, V) do begin

    if IsArrayContains(Second, V) then begin

      Result[IntersectIndex] := V;

      Inc(IntersectIndex);

    end;

  end;

  SetLength(Result, IntersectIndex);

end;

function StringsToArray(Strings: TStrings): TVariantArray;
var
    I: Integer;
begin

  SetLength(Result, Strings.Count);

  for I := 0 to High(Result) do
    Result[I] := Strings[I];

end;

function StringArrayToArray(Strings: array of String): TVariantArray;
var
    I: Integer;
begin

  SetLength(Result, Length(Strings));

  for I := 0 to High(Result) do
    Result[I] := Strings[I];

end;

function StringArrayToStrings(Strings: array of String): TStrings;
var
    Str: String;
begin

  Result := TStringList.Create;

  for Str in Strings do
    Result.Add(Str);
  
end;

end.
