unit EventHandlerChains;

interface

uses

  SourcedEventHandlers,
  SysUtils;

type

  TSourcedEventHandlerChain = class

    class function CreateWrapperChain(
      EventHandleMethods: array of TEventHandleMethod
    ): ISourcedEventHandler; static;

  end;

implementation

{ TSourcedEventHandlerChain }

class function TSourcedEventHandlerChain.CreateWrapperChain(
  EventHandleMethods: array of TEventHandleMethod): ISourcedEventHandler;
var
    I: Integer;
    EventHandleMethod: TEventHandleMethod;
begin

  Result := nil;

  for I := High(EventHandleMethods) downto Low(EventHandleMethods) do begin

    EventHandleMethod := EventHandleMethods[I];

    if Assigned(Result) then begin

      Result :=
        TSourcedEventHandlerWrapperDecorator
          .CreateWithInternalEventHandlerAfterCallOrder(
            EventHandleMethod,
            Result
          );

    end

    else Result := TSourcedEventHandlerWrapper.Create(EventHandleMethod);

  end;

end;

end.
