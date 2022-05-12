unit UIControlTypeStyleRegistry;

interface

uses

  Controls,
  UIControlStyle,
  TypeObjectRegistry,
  SysUtils,
  Classes;

type

  TUIControlTypeStyleRegistrationOption =
    (
      AllowStyleUsingByControlTypeInheritance,
      DisallowStyleUsingByControlTypeInheritance
    );

  TUIControlTypeStyleRegistry = class

    private

      FTypeObjectRegistry: TTypeObjectRegistry;

    public

      destructor Destroy; override;

      constructor Create;

      procedure RegisterOrUpdateUIControlTypeStyle(
        ControlType: TWinControlClass;
        Style: IUIControlStyle;
        Option: TUIControlTypeStyleRegistrationOption = AllowStyleUsingByControlTypeInheritance
      );

      function IsUIControlTypeStyleExists(ControlType: TWinControlClass): Boolean;
      
      function GetUIControlTypeStyle(ControlType: TWinControlClass): IUIControlStyle;

      procedure UnregisterUIControlTypeStyle(ControlType: TWinControlClass);

      procedure Clear;
      
  end;

implementation

uses

  InMemoryObjectRegistry;

{ TUIControlTypeStyleRegistry }

procedure TUIControlTypeStyleRegistry.Clear;
begin

  FTypeObjectRegistry.Clear;
  
end;

constructor TUIControlTypeStyleRegistry.Create;
begin

  inherited;

  FTypeObjectRegistry :=
    TTypeObjectRegistry.Create(TInMemoryObjectRegistry.Create);

  FTypeObjectRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
    
end;

destructor TUIControlTypeStyleRegistry.Destroy;
begin

  FreeAndNil(FTypeObjectRegistry);

  inherited;

end;

function TUIControlTypeStyleRegistry.GetUIControlTypeStyle(
  ControlType: TWinControlClass
): IUIControlStyle;
begin

  Result := IUIControlStyle(FTypeObjectRegistry.GetInterface(ControlType));
  
end;

function TUIControlTypeStyleRegistry.IsUIControlTypeStyleExists(
  ControlType: TWinControlClass): Boolean;
begin

  Result := FTypeObjectRegistry.IsInterfaceExists(ControlType);
  
end;

procedure TUIControlTypeStyleRegistry.RegisterOrUpdateUIControlTypeStyle(
  ControlType: TWinControlClass;
  Style: IUIControlStyle;
  Option: TUIControlTypeStyleRegistrationOption
);
begin

  FTypeObjectRegistry.RegisterInterface(
    ControlType,
    Style,
    TTypeObjectRegistrationOptions.Create.AllowObjectUsingByTypeInheritance(
      Option = AllowStyleUsingByControlTypeInheritance
    )
  );
  
end;

procedure TUIControlTypeStyleRegistry.UnregisterUIControlTypeStyle(
  ControlType: TWinControlClass);
begin

  FTypeObjectRegistry.UnregisterInterface(ControlType);
  
end;

end.
