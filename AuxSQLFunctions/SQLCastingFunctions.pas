unit SQLCastingFunctions;

interface

uses

  ArrayTypes,
  VariantListUnit,
  SysUtils,
  Classes;


function AsSQLString(Value: Variant): String;

function CreateSQLValueListString(const Values: TStringArray; const Delimiter: String = ','): String; overload;
function CreateSQLValueListString(const Values: TStrings; const Delimiter: String = ','): String; overload;
function CreateSQLValueListString(const Values: array of Variant; const Delimiter: String = ','): String; overload;
function CreateSQLValueListString(const ValueList: TVariantList; const Delimiter: String = ','): String; overload;

implementation

uses

  StrUtils,
  ArrayFunctions,
  Variants;
  
function AsSQLString(Value: Variant): String;
begin

  Result := VarToStr(Value);

  case VarType(Value) of

    varString, varOleStr, varDate: Result := QuotedStr(Result);
    
  end;

end;

function CreateSQLValueListString(
  const Values: TStringArray; 
  const Delimiter: String = ','
): String; overload;
begin

  Result := CreateSQLValueListString(StringArrayToArray(Values), Delimiter);

end;

function CreateSQLValueListString(
  const Values: TStrings; 
  const Delimiter: String = ','
): String; overload;
begin

  Result := CreateSQLValueListString(StringsToArray(Values), Delimiter);
  
end;

function CreateSQLValueListString(
  const Values: array of Variant; 
  const Delimiter: String
): String;
var
    ValueList: TVariantList;

begin

  ValueList := TVariantList.CreateFrom(Values);

  try

    Result := CreateSQLValueListString(ValueList, Delimiter);

  finally

    FreeAndNil(ValueList);
    
  end;

end;

function CreateSQLValueListString(
  const ValueList: TVariantList; 
  const Delimiter: String
): String;
var
    Value: Variant;
begin

  for Value in ValueList do 
    Result := Result + IfThen(Result = '', AsSQLString(Value), ',' + AsSQLString(Value));
  
end;

end.
