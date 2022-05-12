unit AbstractDomainService;

interface

uses

  DomainService;

type

  TAbstractDomainService = class (TInterfacedObject, IDomainService)

    public

      function GetSelf: TObject;

  end;
  
implementation

{ TAbstractDomainService }

function TAbstractDomainService.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
