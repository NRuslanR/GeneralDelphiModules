unit ReadChannel;

interface

uses

  SysUtils;

type


  TReadChannelReceivingResult = (

    rcSuccess,
    rcFail,
    rcEof

  );

  IReadChannel = interface

    procedure OnReceive(const Data; const DataType; Result: TReadChannelReceivingResult);
    procedure BackPressure(const UnitCount: Integer);
    
  end;

implementation

end.
