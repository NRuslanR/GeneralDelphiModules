unit DomainException;

interface

uses

  SysUtils,
  Classes;

type

  TDomainException = class;
  TDomainExceptionClass = class of TDomainException;
  
  {$M+}
  TDomainException = class (Exception)


  end;
  {$M-}

implementation


end.
