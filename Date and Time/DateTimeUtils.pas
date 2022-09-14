unit DateTimeUtils;

interface

uses

  SysUtils,
  Classes;

type

  TDateTimeUtils = class sealed

    public

      class function IsValidDateTime(const Value: TDateTime): Boolean; static;
      
  end;

implementation

uses

  DateUtils;

{ TDateTimeUtils }

class function TDateTimeUtils.IsValidDateTime(const Value: TDateTime): Boolean;
var
    Year, Month, Day,
    Hour, Minute, Sec, MilliSec: Word;
begin

  DecodeDateTime(Value, Year, Month, Day, Hour, Minute, Sec, MilliSec);

  Result := DateUtils.IsValidDateTime(Year, Month, Day, Hour, Minute, Sec, MilliSec);

end;

end.
