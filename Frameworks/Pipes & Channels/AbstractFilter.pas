unit AbstractFilter;

interface

uses

  Filter,
  Pipe,
  SysUtils;

type

  TAbstractFilter = class (TInterfacedObject, IFilter)

    public

      procedure Connect(Pipe: IPipe); virtual; abstract;

  end;
    
implementation

end.
