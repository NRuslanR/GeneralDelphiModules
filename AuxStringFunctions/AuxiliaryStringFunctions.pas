unit AuxiliaryStringFunctions;

interface

uses

  Classes,
  SysUtils,
  StrUtils,
  Windows,
  VariantListUnit;

function CreateStringFromStringList(const Strings: TStrings; const Separator: string = ', '): string;
function CreateStringFromVariantList(const VariantList: TVariantList; const Separator: string = ', '): string;
function CreateStringFromVariantListAndFree(const VariantList: TVariantList; const Separator: string = ', '): string;
function CreateStringFromVariantArray(const Variants: array of Variant; const Separator: string = ', '): string;
function ReplaceStrings(const Target: String; const ReplacedStrings: array of String; const ReplacingStrings: array of String): String;

// unfinished
function TrimBy(const Str, TrimmedLeft, TrimmedRight: string): string;

// Извлекает подстроку, заключенную между двумя
// заданными подстроками
function ExtractString(
  const ATargetString: String;
  const ALeftBound, ARightBound: String
): String;

function SplitStringByDelimiter(
  const TargetString: String;
  const Delimiter: Char
): TStrings;

function LeftByLastDelimiter(const TargetString: String; const Delimiter: String): String;

function EscapeFilePathSpecChars(
  const FilePath: String
): String;

function CreateStringListFrom(StringArray: array of String): TStrings;

procedure SaveToFile(const Str: String; const FilePath: String);

function EscapeString(const Str: String): String;

function GetWindowsLastErrorMessage(const ErrorCode: Integer): String;

implementation

uses

  AuxDebugFunctionsUnit,
  Variants;

function SplitStringByDelimiter(
  const TargetString: String;
  const Delimiter: Char
): TStrings;
begin

  Result := TStringList.Create;

  Result.StrictDelimiter := True;
  Result.Delimiter := Delimiter;
  Result.DelimitedText := TargetString;

end;

function CreateStringFromStringList(const Strings: TStrings; const Separator: string = ', '): string;
var str: string;
begin

  Result := '';

  if not Assigned(Strings) then Exit;

  for str in Strings do
    Result := IfThen(Result = '', str, Result + Separator + str);

end;

// unfinished
function TrimBy(const Str, TrimmedLeft, TrimmedRight: string): string;
var trimmedLen, strLen, idx: integer;
begin

  Result := Str;

  if Pos(TrimmedLeft, Result) = 1 then
    Delete(Result, 1, Length(TrimmedLeft));

  trimmedLen := Length(TrimmedRight);
  idx := Length(Result) - trimmedLen + 1;

  if Pos(TrimmedRight, Result) = idx then
    Delete(Result, idx, trimmedLen);
  
end;

function ExtractString(
  const ATargetString: String;
  const ALeftBound, ARightBound: String
): String;
var LeftBoundLastCharIndex, RightBoundFirstCharIndex: Integer;
    TargetStringLength: Integer;
    TargetWithoutLeftBound: String;
begin

  Result := '';

  LeftBoundLastCharIndex := Pos(ALeftBound, ATargetString);

  if LeftBoundLastCharIndex = 0 then Exit;

  TargetStringLength := Length(ATargetString);

  TargetWithoutLeftBound :=
  
  Copy(ATargetString,
       LeftBoundLastCharIndex + 1,
       TargetStringLength - LeftBoundLastCharIndex
  );

  RightBoundFirstCharIndex := Pos(ARightBound, TargetWithoutLeftBound);

  if RightBoundFirstCharIndex > 0 then
    Result := Copy(TargetWithoutLeftBound,
                   1,
                   RightBoundFirstCharIndex - 1
                  );

end;

function EscapeFilePathSpecChars(
  const FilePath: String
): String;
begin

  Result := ReplaceStr(FilePath, PathDelim, PathDelim + PathDelim);
  
end;

function LeftByLastDelimiter(
  const TargetString: String;
  const Delimiter: String
): String;
var
    LastDelimiterPos: Integer;
begin

  Result := ReverseString(TargetString);

  LastDelimiterPos := Pos(Delimiter, Result);

  if LastDelimiterPos > 0 then
    Result := Copy(TargetString, 1, Length(TargetString) - LastDelimiterPos)
    
  else Result := '';

end;

function CreateStringListFrom(StringArray: array of String): TStrings;
var
    Str: String;
begin

  Result := TStringList.Create;

  try

    for Str in StringArray do
      Result.Add(Str);
      
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function CreateStringFromVariantArray(const Variants: array of Variant; const Separator: string): string;
var
    VariantList: TVariantList;
begin

  VariantList := TVariantList.CreateFrom(Variants);

  try

    Result := CreateStringFromVariantList(VariantList, Separator);

  finally

    FreeAndNil(VariantList);
    
  end;

end;

function CreateStringFromVariantList(
  const VariantList: TVariantList;
  const Separator: string = ', '
): string;
var VariantItem: Variant;
begin

  Result := '';

  if not Assigned(VariantList) then Exit;

  for VariantItem in VariantList do begin

    if Result = '' then
      Result := VarToStr(VariantItem)

    else
      Result := Result + Separator + VarToStr(VariantItem)

  end;

end;

function CreateStringFromVariantListAndFree(const VariantList: TVariantList; const Separator: string): string;
begin

  Result := CreateStringFromVariantList(VariantList, Separator);

  VariantList.Free;

end;

procedure SaveToFile(const Str: String; const FilePath: String);
begin

  with TStringList.Create do begin

    try

      Text := Str;
      SaveToFile(FilePath);
      
    finally

      Free;

    end;

  end;

end;

function EscapeString(const Str: String): String;
begin

  Result := ReplaceStr(Str, '\', '\\');
  
end;

function MAKELANGID(p, s: Word): Word;
begin

  Result := (s shl 10) or p;

end;

function GetWindowsLastErrorMessage(const ErrorCode: Integer): String;
var
    ErrorMsgBuf: PChar;
begin

  FormatMessage(
    FORMAT_MESSAGE_FROM_SYSTEM
    or
    FORMAT_MESSAGE_ALLOCATE_BUFFER
    or
    FORMAT_MESSAGE_IGNORE_INSERTS,
    nil,
    ErrorCode,
    MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
    @ErrorMsgBuf,
    0,
    nil
  );

  Result := String(ErrorMsgBuf);

  LocalFree(Cardinal(ErrorMsgBuf));

end;

function ReplaceStrings(
  const Target: String;
  const ReplacedStrings: array of String;
  const ReplacingStrings: array of String
): String;
var
    I: Integer;
begin

  Result := Target;

  for I := Low(ReplacedStrings) to High(ReplacedStrings) do
    Result := ReplaceStr(Result, ReplacedStrings[I], ReplacingStrings[I]);

end;

end.
