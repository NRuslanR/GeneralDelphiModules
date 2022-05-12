unit IGetSelfUnit;

interface

uses

  Disposable;

type

  IGetSelf = interface (IDisposable)
    ['{49D7F3A3-49C0-4813-A480-7E371F219629}']

    function GetSelf: TObject;

    property Self: TObject read GetSelf;
    
  end;
  
implementation

end.
