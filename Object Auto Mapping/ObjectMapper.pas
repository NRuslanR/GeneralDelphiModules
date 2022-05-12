unit ObjectMapper;

interface

uses

  SysUtils,
  Classes;

type

  IObjectMapper = interface

    function Map(MappeableObject: TObject): TObject;
    
  end;

implementation

end.
