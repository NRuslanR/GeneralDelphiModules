unit InterfaceObjectList;

interface

uses

  SysUtils,
  Classes;

type

  IInterfaceObjectList = interface (IInterfaceList)

    function FindByInterfaceType(InterfaceType: TGUID): IInterface;
    
  end;

  TInterfaceObjectList = class (TInterfaceList, IInterfaceObjectList)

    public

      constructor From(Interfaces: array of IInterface);

      function FindByInterfaceType(InterfaceType: TGUID): IInterface;

  end;
  
implementation

uses

  VariantFunctions;

{ TInterfaceObjectList }

function TInterfaceObjectList.FindByInterfaceType(
  InterfaceType: TGUID): IInterface;
var
    I: IInterface;
begin

  for I in Self do
    if Supports(I, InterfaceType, Result) then
      Exit;

  Result := nil;
  
end;

constructor TInterfaceObjectList.From(Interfaces: array of IInterface);
var
    I: IInterface;
begin

  inherited Create;

  for I in Interfaces do
    Add(I);
    
end;

end.
