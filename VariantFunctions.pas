unit VariantFunctions;

interface

uses

  SysUtils,
  Variants;

function VarIsNullOrEmpty(Value: Variant): Boolean;
function AnyVarIsNullOrEmpty(Values: array of Variant): Boolean;
function VarOrDefault(Value: Variant; Default: Variant): Variant;
function VarIfThen(const Predicate: Boolean; TrueValue: Variant; FalseValue: Variant): Variant; overload;
function VarIfThen(const Predicate: Boolean; TrueClass: TClass; FalseClass: TClass): TClass; overload;
function VarIfThen(const Predicate: Boolean; TrueObject: TObject; FalseObject: TObject): TObject; overload;
function VarRecToVariant(VarRec: TVarRec): Variant;
function ObjectToVariant(Value: TObject): Variant;
function VariantToObject(Value: Variant): TObject;
function VariantToPointer(Value: Variant): Pointer;
function VariantToClass(Value: Variant): TClass;
function ClassToVariant(ClassType: TClass): Variant;
function InterfaceToVariant(Value: IInterface): Variant;
function VariantToInterface(Value: Variant; const InterfaceGUID: TGUID; out Intf): Boolean;
function IsVariantContainsValue(Arr: Variant; Value: Variant): Boolean;

implementation
  
function VarOrDefault(Value: Variant; Default: Variant): Variant;
begin

  Result := VarIfThen(not VarIsNullOrEmpty(Value), Value, Default);

end;

function VarIfThen(const Predicate: Boolean; TrueValue: Variant; FalseValue: Variant): Variant;
begin

  if Predicate then
    Result := TrueValue

  else Result := FalseValue;

end;

function VarIsNullOrEmpty(Value: Variant): Boolean;
begin

  Result := VarIsNull(Value) or VarIsEmpty(Value);

end;

function VarRecToVariant(VarRec: TVarRec): Variant;
begin

  case VarRec.VType of

    vtInteger: Result := VarRec.VInteger;

    vtBoolean: Result := VarRec.VBoolean;

    vtChar: Result := VarRec.VChar;

    vtWideChar: Result := VarRec.VWideChar;

    vtExtended: Result := VarRec.VExtended^;

    vtString: Result := VarRec.VString^;

    vtPointer, vtPChar, vtObject, vtClass, vtPWideChar, vtInterface:
    begin

      TVarData(Result).VType := varByRef;
                                   
      case VarRec.VType of

        vtPointer: TVarData(Result).VPointer := VarRec.VPointer;
        vtPChar: TVarData(Result).VPointer := VarRec.VPChar;
        vtObject: TVarData(Result).VPointer := VarRec.VObject;
        vtClass: TVarData(Result).VPointer := VarRec.VClass;
        vtPWideChar: TVarData(Result).VPointer := VarRec.VPWideChar;
        vtInterface: TVarData(Result).VPointer := VarRec.VInterface;

      end;
      
    end;

    vtAnsiString, vtWideString:
    begin

      TVarData(Result).VType := varString;

      case VarRec.VType of

        vtAnsiString: TVarData(Result).VString := VarRec.VAnsiString;
        vtWideString: TVarData(Result).VString := VarRec.VWideString;

      end;

    end;

    vtCurrency: Result := VarRec.VCurrency^;

    vtVariant: Result := VarRec.VVariant^;

    vtInt64: Result := VarRec.VInt64^;

    else begin

      TVarData(Result).VType := varNull;

    end;

  end;

end;

function ObjectToVariant(Value: TObject): Variant;
begin

  TVarData(Result).VType := varByRef;
  TVarData(Result).VPointer := Value;

end;

function VariantToObject(Value: Variant): TObject;
begin

  Result := TObject(VariantToPointer(Value));
  
end;

function VariantToPointer(Value: Variant): Pointer;
begin

  if TVarData(Value).VType = varByRef then
    Result := TVarData(Value).VPointer

  else Result := nil;

end;

function VariantToInterface(Value: Variant; const InterfaceGUID: TGUID; out Intf): Boolean;
var
    InterfacePointer: Pointer;
begin

  InterfacePointer := VariantToPointer(Value);

  if Assigned(InterfacePointer) then
    Result := Supports(IInterface(InterfacePointer), InterfaceGUID, Intf)

  else Result := False;

end;

function InterfaceToVariant(Value: IInterface): Variant;
begin

  TVarData(Result).VType := varByRef;
  TVarData(Result).VPointer := Pointer(Value);
  
end;

function AnyVarIsNullOrEmpty(Values: array of Variant): Boolean;
var
    Value: Variant;
begin

  for Value in Values do begin

    if VarIsNullOrEmpty(Value) then begin

      Result := True;
      Exit;

    end;

  end;

  Result := False;

end;

function VariantToClass(Value: Variant): TClass;
begin

  Result := TClass(VariantToPointer(Value));

end;

function ClassToVariant(ClassType: TClass): Variant;
begin

  TVarData(Result).VType := varByRef;
  TVarData(Result).VPointer := ClassType;
  
end;

function VarIfThen(const Predicate: Boolean; TrueClass: TClass; FalseClass: TClass): TClass;
begin

  Result := TClass(VarIfThen(Predicate, TObject(TrueClass), TObject(FalseClass)));

end;

function VarIfThen(const Predicate: Boolean; TrueObject: TObject; FalseObject: TObject): TObject;
begin

  Result :=
    VariantToObject(
      VarIfThen(
        Assigned(ExceptionClass),
        ObjectToVariant(TrueObject),
        ObjectToVariant(FalseObject)
      )
    );
    
end;

function IsVariantContainsValue(Arr: Variant; Value: Variant): Boolean;
var
    I: Integer;
begin

  if not VarIsArray(Arr) then begin

    Result := Arr = Value;
    Exit;

  end;

  for I := VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
  begin

    if Arr[I] = Value then begin

      Result := True;
      Exit;

    end;

  end;

  Result := False;
  
end;

end.
