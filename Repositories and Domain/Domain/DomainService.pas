unit DomainService;

interface

uses

  IGetSelfUnit,
  DomainException;

type

  TDomainServiceException = class (TDomainException)

  end;
  
  IDomainService = interface (IGetSelf)

  end;

  
implementation

end.
