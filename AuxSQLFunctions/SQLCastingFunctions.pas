unit SQLCastingFunctions;

interface

uses

  VariantListUnit,
  SysUtils,
  Classes;


function AsSQLString(Value: Variant): String;
function CreateSQLValueListString(const Values: array of Variant; const Delimiter: String = ','): String; overload;
function CreateSQLValueListString(const ValueList: TVariantList; const Delimiter: String = ','): String; overload;

implementation

uses

  StrUtils,
  Variants;
  
function AsSQLString(Value: Variant): String;
begin

  Result := VarToStr(Value);

  if VarIsStr(Value) then Result := QuotedStr(Result);

end;

function CreateSQLValueListString(const Values: array of Variant; const Delimiter: String): String;
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

function CreateSQLValueListString(const ValueList: TVariantList; const Delimiter: String): String;
var
    Value: Variant;
begin

  for Value in ValueList do Result := Result + IfThen(Result = '', AsSQLString(Value), ',' + AsSQLString(Value));
  
end;

end.
