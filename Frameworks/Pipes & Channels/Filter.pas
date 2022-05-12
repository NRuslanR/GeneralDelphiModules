unit Filter;

interface

uses

  Pipe,
  SysUtils;

type

  IFilter = interface

    procedure Connect(Pipe: IPipe);
    
  end;

implementation

end.
