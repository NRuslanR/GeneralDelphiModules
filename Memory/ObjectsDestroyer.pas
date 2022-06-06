unit ObjectsDestroyer;

interface

uses

  SysUtils,
  ArrayTypes,
  Classes;

type

  IObjectsDestroyer = interface

  end;

  TObjectsDestroyer = class (TInterfacedObject, IObjectsDestroyer)

    private

      FObjects: array of TObject;
      
    public

      destructor Destroy; override;
      
      constructor Create(const Objects: array of TObject);
      
  end;

implementation

{ TObjectsDestroyer }

constructor TObjectsDestroyer.Create(const Objects: array of TObject);
var
    I: Integer;
begin

  inherited Create;

  SetLength(FObjects, Length(Objects));

  for I := Low(Objects) to High(Objects) do
    FObjects[I] := Objects[I];

end;

destructor TObjectsDestroyer.Destroy;
var
    Obj: TObject;
begin

  for Obj in FObjects do
    Obj.Free;
    
  inherited;

end;

end.
