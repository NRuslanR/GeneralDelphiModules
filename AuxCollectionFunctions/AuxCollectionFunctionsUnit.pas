unit AuxCollectionFunctionsUnit;

interface

  uses

    Classes,
    SysUtils,
    ArrayFunctions,
    VariantListUnit;

procedure FreeListItems(source: TList);
procedure FreeListWithItems(var source: TList);
function IsNotAssignedOrEmpty(List: TList): Boolean;
function IsAssignedAndNotEmpty(List: TList): Boolean;
function GetDuplicateValues(Strings: TStrings): TStrings;
function ValuesEquals(Values: TVariantList): Boolean;

implementation


procedure FreeListItems(source: TList);
var item: Pointer;
begin

  if not Assigned(source) then Exit;

  for item in source do begin
    try
      TObject(item).Free;
    except
      on e: EInvalidPointer do
        FreeMem(item);
    end;
  end;

  source.Clear;

end;

procedure FreeListWithItems(var source: TList);
begin

  FreeListItems(source);
  FreeAndNil(source);

end;

function IsNotAssignedOrEmpty(List: TList): Boolean;
begin

  Result := not Assigned(List) or (List.Count = 0);
  
end;

function GetDuplicateValues(Strings: TStrings): TStrings;
var
    I, J: Integer;
begin

  Result := TStringList.Create;

  try

    for I := 0 to Strings.Count - 2 do
      for J := I + 1 to Strings.Count - 1 do
        if Strings[I] = Strings[J] then
          if Result.IndexOf(Strings[I]) = -1 then
            Result.Add(Strings[I]);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function IsAssignedAndNotEmpty(List: TList): Boolean;
begin

  Result := not IsNotAssignedOrEmpty(List);

end;

function ValuesEquals(Values: TVariantList): Boolean;
var
   I: Integer;
   Value: Variant;
begin

  Value := Values.First;

  for I := 1 to Values.Count - 1 do
    if Value <> Values[I] then begin

      Result := False;
      Exit;

    end;

  Result := True;

end;

end.
