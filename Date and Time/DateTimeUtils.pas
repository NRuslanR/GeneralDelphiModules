unit DateTimeUtils;

interface

uses

  SysUtils,
  Classes;

type

  TDateTimeUtils = class sealed

    public

      class function IsValidDateTime(const Value: TDateTime): Boolean; static;
      class function ISO_8601_Format: String; static;
      
  end;

implementation

uses

  DateUtils;

{ TDateTimeUtils }

class function TDateTimeUtils.ISO_8601_Format: String;
begin

  Result := 'yyyy-MM-dd hh:mm:ss';
  
end;

class function TDateTimeUtils.IsValidDateTime(const Value: TDateTime): Boolean;
var
    Year, Month, Day,
    Hour, Minute, Sec, MilliSec: Word;
begin

  DecodeDateTime(Value, Year, Month, Day, Hour, Minute, Sec, MilliSec);

  Result := DateUtils.IsValidDateTime(Year, Month, Day, Hour, Minute, Sec, MilliSec);

end;

end.
