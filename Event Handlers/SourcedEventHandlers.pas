unit SourcedEventHandlers;

interface

uses

  IGetSelfUnit,
  SysUtils;

type

  TEventHandleMethod = procedure (Sender: TObject) of object;

  ISourcedEventHandler = interface (IGetSelf)

    procedure Handle(Sender: TObject);

  end;

  TAbstractSourcedEventHandler = class abstract (TInterfacedObject, ISourcedEventHandler)

    public

      function GetSelf: TObject;
      
      procedure Handle(Sender: TObject); virtual; abstract;

  end;

  TSourcedEventHandlerWrapper = class (TAbstractSourcedEventHandler)

    private

      FEventHandleMethod: TEventHandleMethod;

    public

      constructor Create(EventHandleMethod: TEventHandleMethod);

      procedure Handle(Sender: TObject); override;

      property EventHandleMethod: TEventHandleMethod read FEventHandleMethod;

  end;

  TInternalEventHandlerCallOrder =
    (
      coCallInternalEventHandlerBefore,
      coCallInternalEventHandlerAfter
    );

  TAbstractSourcedEventHandlerDecorator = class abstract (TAbstractSourcedEventHandler)

    protected

      FEventHandler: ISourcedEventHandler;
      FInternalEventHandlerCallOrder: TInternalEventHandlerCallOrder;
      
      procedure InternalHandle(Sender: TObject); virtual; abstract;

    public

      constructor Create(
        EventHandler: ISourcedEventHandler;
        const InternalEventHandlerCallOder: TInternalEventHandlerCallOrder
      );

      constructor CreateWithInternalEventHandlerBeforeCallOrder(
        EventHandler: ISourcedEventHandler
      );

      constructor CreateWithInternalEventHandlerAfterCallOrder(
        EventHandler: ISourcedEventHandler
      );

      procedure Handle(Sender: TObject); override;

  end;

  TSourcedEventHandlerWrapperDecorator = class (TAbstractSourcedEventHandlerDecorator)

    private

      FTargetEventHandlerWrapper: ISourcedEventHandler;

      procedure CreateTargetEventHandlerWrapper(EventHandleMethod: TEventHandleMethod);

      function GetEventHandleMethod: TEventHandleMethod;

    protected

      procedure InternalHandle(Sender: TObject); override;

    public

      constructor Create(
        EventHandleMethod: TEventHandleMethod;
        InternalEventHandler: ISourcedEventHandler;
        const InternalEventHandlerCallOder: TInternalEventHandlerCallOrder
      );

      constructor CreateWithInternalEventHandlerBeforeCallOrder(
        EventHandleMethod: TEventHandleMethod;
        EventHandler: ISourcedEventHandler
      );

      constructor CreateWithInternalEventHandlerAfterCallOrder(
        EventHandleMethod: TEventHandleMethod;
        EventHandler: ISourcedEventHandler
      );

      property EventHandleMethod: TEventHandleMethod read GetEventHandleMethod;

  end;

implementation

{ TAbstractSourcedEventHandlerDecorator }

constructor TAbstractSourcedEventHandlerDecorator.CreateWithInternalEventHandlerAfterCallOrder(
  EventHandler: ISourcedEventHandler);
begin

  Create(EventHandler, coCallInternalEventHandlerAfter);

end;

constructor TAbstractSourcedEventHandlerDecorator.CreateWithInternalEventHandlerBeforeCallOrder(
  EventHandler: ISourcedEventHandler);
begin

  Create(EventHandler, coCallInternalEventHandlerBefore);
  
end;

constructor TAbstractSourcedEventHandlerDecorator.Create(
  EventHandler: ISourcedEventHandler;
  const InternalEventHandlerCallOder: TInternalEventHandlerCallOrder
);
begin

  inherited Create;

  FEventHandler := EventHandler;
  FInternalEventHandlerCallOrder := InternalEventHandlerCallOder;

end;

procedure TAbstractSourcedEventHandlerDecorator.Handle(Sender: TObject);
begin

  if FInternalEventHandlerCallOrder = coCallInternalEventHandlerBefore
  then FEventHandler.Handle(Sender);

  InternalHandle(Sender);

  if FInternalEventHandlerCallOrder = coCallInternalEventHandlerAfter
  then FEventHandler.Handle(Sender);
  
end;

{ TSourcedEventHandlerWrapper }

constructor TSourcedEventHandlerWrapper.Create(
  EventHandleMethod: TEventHandleMethod);
begin

  inherited Create;

  FEventHandleMethod := EventHandleMethod;

end;

procedure TSourcedEventHandlerWrapper.Handle(Sender: TObject);
begin

  FEventHandleMethod(Sender);

end;

{ TSourcedEventHandlerWrapperDecorator }

constructor TSourcedEventHandlerWrapperDecorator.Create(
  EventHandleMethod: TEventHandleMethod;
  InternalEventHandler: ISourcedEventHandler;
  const InternalEventHandlerCallOder: TInternalEventHandlerCallOrder
);
begin

  inherited Create(InternalEventHandler, InternalEventHandlerCallOder);

  CreateTargetEventHandlerWrapper(EventHandleMethod);

end;

constructor TSourcedEventHandlerWrapperDecorator.CreateWithInternalEventHandlerAfterCallOrder(
  EventHandleMethod: TEventHandleMethod;
  EventHandler: ISourcedEventHandler
);
begin

  inherited CreateWithInternalEventHandlerAfterCallOrder(EventHandler);

  CreateTargetEventHandlerWrapper(EventHandleMethod);

end;

constructor TSourcedEventHandlerWrapperDecorator.CreateWithInternalEventHandlerBeforeCallOrder(
  EventHandleMethod: TEventHandleMethod;
  EventHandler: ISourcedEventHandler
);
begin

  inherited CreateWithInternalEventHandlerBeforeCallOrder(EventHandler);

  CreateTargetEventHandlerWrapper(EventHandleMethod);

end;

procedure TSourcedEventHandlerWrapperDecorator.CreateTargetEventHandlerWrapper(
  EventHandleMethod: TEventHandleMethod);
begin

  FTargetEventHandlerWrapper :=
    TSourcedEventHandlerWrapper.Create(EventHandleMethod);

end;

function TSourcedEventHandlerWrapperDecorator.GetEventHandleMethod: TEventHandleMethod;
begin

  Result :=
    TSourcedEventHandlerWrapper(FTargetEventHandlerWrapper.Self)
      .EventHandleMethod;

end;

procedure TSourcedEventHandlerWrapperDecorator.InternalHandle(Sender: TObject);
begin

  FTargetEventHandlerWrapper.Handle(Sender);

end;

{ TAbstractSourcedEventHandler }

function TAbstractSourcedEventHandler.GetSelf: TObject;
begin

  Result := Self;

end;

end.
