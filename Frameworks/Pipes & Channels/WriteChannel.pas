unit WriteChannel;

interface

uses

  SysUtils;

type

  IWriteChannel = interface

    procedure OnWrite(const Data; const DataType);
    procedure BackPressure(const UnitCount: Integer);
    
  end;

implementation

end.
