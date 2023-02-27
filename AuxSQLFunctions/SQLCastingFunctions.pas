unit SQLCastingFunctions;

interface

uses

  ArrayTypes,
  VariantListUnit,
  SysUtils,
  Classes;

function AsSQLString(Value: Variant): String;
function AsSQLDateTime(const DateTime: TDateTime): String;
function AsSQLFloat(const Float: Single): String;

function CreateSQLValueListString(const Values: TStringArray; const Delimiter: String = ','): String; overload;
function CreateSQLValueListString(const Values: TStrings; const Delimiter: String = ','): String; overload;
function CreateSQLValueListString(const Values: array of Variant; const Delimiter: String = ','): String; overload;
function CreateSQLValueListString(const ValueList: TVariantList; const Delimiter: String = ','): String; overload;

implementation

uses

  StrUtils,
  Windows,
  DateUtils,
  AuxDebugFunctionsUnit,
  ArrayFunctions,
  Variants;
  
function AsSQLString(Value: Variant): String;
begin
                                  
  case VarType(Value) of

    varString, varOleStr: Result := QuotedStr(VarToStr(Value));
    varDate: Result := AsSQLDateTime(Value);
    varSingle, varDouble, varCurrency: Result := AsSQLFloat(Value);
    varNull: Result := 'NULL';

    else Result := VarToStr(Value);

  end;

end;

function AsSQLDateTime(const DateTime: TDateTime): String;
begin

  Result :=
    QuotedStr(
      FormatDateTime(
        IfThen(
          TimeOf(DateTime) <> 0,
          'yyyy-MM-dd hh:mm:ss',
          'yyyy-MM-dd'
        ),
        DateTime
      )
    );

end;

function AsSQLFloat(const Float: Single): String;
var
    FormatSettings: TFormatSettings;
begin

  GetLocaleFormatSettings(GetThreadLocale, FormatSettings);

  FormatSettings.DecimalSeparator := '.';

  Result := Format('%g', [Float], FormatSettings);
  
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
