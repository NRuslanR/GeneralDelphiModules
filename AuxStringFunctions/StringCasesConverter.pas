unit StringCasesConverter;

interface

uses

  SysUtils,
  StrUtils,
  Classes;

type

  TStringCasesConverter = class sealed

    public

      class function PascalCaseStringToSnakeCase(const TargetString: String): String; static;
      
  end;

implementation

{ TStringCasesConverter }

class function TStringCasesConverter.PascalCaseStringToSnakeCase(
  const TargetString: String
): String;
var
    ch: Char;
begin
                  
  for ch in TargetString do ;
    

end;

end.
