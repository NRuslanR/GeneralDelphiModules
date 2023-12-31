unit AbstractCardFormControllerEvents;

interface

uses

  CardFormViewModel,
  Disposable,
  Event,
  SysUtils,
  Classes;
  
type

  TCardStateChangedEvent = class (TEvent)

    private

      FViewModel: TCardFormViewModel;
      FFreeViewModel: IDisposable;

      procedure SetViewModel(const Value: TCardFormViewModel);

    public

      constructor Create(
        ViewModel: TCardFormViewModel
      );

      property CardFormViewModel: TCardFormViewModel
      read FViewModel write SetViewModel;

  end;

  TCardStateChangedEventClass = class of TCardStateChangedEvent;

  TCardCreatedEvent = class (TCardStateChangedEvent)

  end;

  TCardCreatedEventClass = class of TCardCreatedEvent;
  
  TCardModifiedEvent = class (TCardStateChangedEvent)

  end;

  TCardModifiedEventClass = class of TCardModifiedEvent;
  
  TCardRemovedEvent = class (TCardStateChangedEvent)

  end;

  TCardRemovedEventClass = class of TCardRemovedEvent;
  
implementation

{ TCardStateChangedEvent }

constructor TCardStateChangedEvent.Create(ViewModel: TCardFormViewModel);
begin

  inherited Create;

  CardFormViewModel := ViewModel;

end;

procedure TCardStateChangedEvent.SetViewModel(const Value: TCardFormViewModel);
begin

  if FViewModel = Value then
    Exit;

  FViewModel := Value;
  FFreeViewModel := FViewModel;
  
end;

end.
