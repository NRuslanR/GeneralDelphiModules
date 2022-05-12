unit AbstractPipe;

interface

uses

  Pipe,
  SysUtils;

type

  TAbstractPipe = class (TInterfacedObject, IPipe)

    public

      procedure Run; virtual; abstract;
      procedure Stop; virtual; abstract;
      procedure Send(Data: Pointer; Size: Integer; Count: Integer); virtual; abstract;
      procedure BackPressure(const UnitCount: Integer); virtual; abstract;
      function Receive(Data: Pointer; Size: Integer; Count: Integer): TPipeReceivingDataResult; virtual; abstract;

  end;

implementation

{ TAbstractPipe }

end.
