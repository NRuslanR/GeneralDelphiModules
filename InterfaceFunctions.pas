unit InterfaceFunctions;

interface

uses

  SysUtils,
  Classes;


  function AsInterface(TargetInterface: IInterface; RequiredInterfaceGUID: TGUID): IInterface;
  function AsInterfaceOrException(TargetInterface: IInterface; RequiredInterfaceGUID: TGUID; ExceptionMessage: String): IInterface;

implementation

function AsInterfaceOrException(
  TargetInterface: IInterface;
  RequiredInterfaceGUID: TGUID;
  ExceptionMessage: String
): IInterface;
begin

  Result := AsInterface(TargetInterface, RequiredInterfaceGUID);

  if not Assigned(Result) then
    Raise Exception.Create(ExceptionMessage);
    
end;

function AsInterface(TargetInterface: IInterface; RequiredInterfaceGUID: TGUID): IInterface;
var
    RequiredInterface: IInterface;
begin

  if Supports(TargetInterface, RequiredInterfaceGUID, RequiredInterface) then
    Result := RequiredInterface

  else Result := nil;

end;

end.
