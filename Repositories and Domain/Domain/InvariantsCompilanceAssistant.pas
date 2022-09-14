unit InvariantsCompilanceAssistant;

interface

uses

  DomainException,
  SysUtils,
  Classes;

type

  IInvariantsCompilanceAssistant = interface

    procedure RaiseExceptionIfInvariantsComplianceRequested(
      const Msg: String
    ); overload;

    procedure RaiseExceptionIfInvariantsComplianceRequested(
      ExceptionType: TDomainExceptionClass;
      const Msg: String
    ); overload;

    procedure RaiseExceptionIfInvariantsComplianceRequested(
      const Msg: String;
      const Args: array of const
    ); overload;

    procedure RaiseExceptionIfInvariantsComplianceRequested(
      ExceptionType: TDomainExceptionClass;
      const Msg: String;
      const Args: array of const
    ); overload;

    procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
      const Condition: Boolean;
      const Msg: String
    ); overload;

    procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
      const Condition: Boolean;
      ExceptionType: TDomainExceptionClass;
      const Msg: String
    ); overload;

    procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
      const Condition: Boolean;
      const Msg: String;
      const Args: array of const
    ); overload;

    procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
      const Condition: Boolean;
      ExceptionType: TDomainExceptionClass;
      const Msg: String;
      const Args: array of const
    ); overload;

    function GetInvariantsComplianceRequested: Boolean;
    procedure SetInvariantsComplianceRequested(const Value: Boolean);

    property InvariantsComplianceRequested: Boolean
    read GetInvariantsComplianceRequested
    write SetInvariantsComplianceRequested;

  end;

  TInvariantsCompilanceAssistant =
    class (TInterfacedObject, IInvariantsCompilanceAssistant)

      private

        FInvariantsComplianceRequested: Boolean;

      public

        procedure RaiseExceptionIfInvariantsComplianceRequested(
          const Msg: String
        ); overload;

        procedure RaiseExceptionIfInvariantsComplianceRequested(
          ExceptionType: TDomainExceptionClass;
          const Msg: String
        ); overload;

        procedure RaiseExceptionIfInvariantsComplianceRequested(
          const Msg: String;
          const Args: array of const
        ); overload;

        procedure RaiseExceptionIfInvariantsComplianceRequested(
          ExceptionType: TDomainExceptionClass;
          const Msg: String;
          const Args: array of const
        ); overload;

      public

        procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
          const Condition: Boolean;
          const Msg: String
        ); overload;

        procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
          const Condition: Boolean;
          ExceptionType: TDomainExceptionClass;
          const Msg: String
        ); overload;

        procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
          const Condition: Boolean;
          const Msg: String;
          const Args: array of const
        ); overload;

        procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
          const Condition: Boolean;
          ExceptionType: TDomainExceptionClass;
          const Msg: String;
          const Args: array of const
        ); overload;

      public

        function GetInvariantsComplianceRequested: Boolean;
        procedure SetInvariantsComplianceRequested(const Value: Boolean);
        
      public

        property InvariantsComplianceRequested: Boolean
        read GetInvariantsComplianceRequested
        write SetInvariantsComplianceRequested;

    end;

implementation

procedure TInvariantsCompilanceAssistant.RaiseExceptionIfInvariantsComplianceRequested(
  const Msg: String);
begin

  RaiseExceptionIfInvariantsComplianceRequested(TDomainException, Msg);
  
end;

procedure TInvariantsCompilanceAssistant.RaiseExceptionIfInvariantsComplianceRequested(
  ExceptionType: TDomainExceptionClass;
  const Msg: String
);
begin

  if InvariantsComplianceRequested then
    Raise ExceptionType.Create(Msg);
  
end;

procedure TInvariantsCompilanceAssistant.RaiseExceptionIfInvariantsComplianceRequested(
  const Msg: String;
  const Args: array of const
);
begin

  RaiseExceptionIfInvariantsComplianceRequested(TDomainException, Msg, Args);

end;

procedure TInvariantsCompilanceAssistant.RaiseExceptionIfInvariantsComplianceRequested(
  ExceptionType: TDomainExceptionClass;
  const Msg: String;
  const Args: array of const
);
begin

  Raise ExceptionType.CreateFmt(Msg, Args);
  
end;

procedure TInvariantsCompilanceAssistant.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  const Msg: String
  );
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(Msg);

end;

procedure TInvariantsCompilanceAssistant.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  ExceptionType: TDomainExceptionClass;
  const Msg: String
);
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(ExceptionType, Msg);

end;

procedure TInvariantsCompilanceAssistant.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  const Msg: String;
  const Args: array of const
);
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(Msg, Args);

end;

procedure TInvariantsCompilanceAssistant.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  ExceptionType: TDomainExceptionClass;
  const Msg: String;
  const Args: array of const
);
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(ExceptionType, Msg, Args);

end;

function TInvariantsCompilanceAssistant.GetInvariantsComplianceRequested: Boolean;
begin

  Result := FInvariantsComplianceRequested;

end;

procedure TInvariantsCompilanceAssistant.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  FInvariantsComplianceRequested := Value;
  
end;

end.
