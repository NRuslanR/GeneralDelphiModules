unit Pipe;

interface

uses

  SysUtils;

type

  TPipeReceivingDataResult = (

    rdSuccess,
    rdFail,
    rdEof

  );
  
  IPipe = interface

    procedure Run;
    procedure Stop;
    procedure Send(Data: Pointer; Size: Integer; Count: Integer);
    procedure BackPressure(const UnitCount: Integer);
    function Receive(Data: Pointer; Size: Integer; Count: Integer): TPipeReceivingDataResult;

  end;

implementation

end.
