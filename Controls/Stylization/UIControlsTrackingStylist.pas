unit UIControlsTrackingStylist;

interface

uses

  UIControlTypeStyleRegistry,
  UIControlStyle,
  AppEvnts,
  Forms,
  Windows,
  Controls,
  SysUtils,
  Classes;

type

  TUIControlTypeStyleTrackingOption =
    (
      UseNearestAncestorControlTypeStyleIfTargetControlTypeNotFound,
      NotUseNearestAncestorControlTypeStyleIfTargetControlTypeNotFound
    );

  TUIControlsTrackingStylist = class

    private

      FApplicationEvents: TApplicationEvents;
      FDefaultApplicationMessageHandler: TMessageEvent;
      
    private

      FUIControlTypeStyleRegistry: TUIControlTypeStyleRegistry;

      procedure OnApplicationMessageHandler(var Msg: TMsg; var Handled: Boolean);

    public

      constructor Create;

      destructor Destroy; override;

      function IsUIControlTypeTracking(ControlType: TWinControlClass): Boolean;

      procedure TrackUIControlTypeForStylization(
        ControlType: TWinControlClass;
        Style: IUIControlStyle;
        TrackingOption: TUIControlTypeStyleTrackingOption = UseNearestAncestorControlTypeStyleIfTargetControlTypeNotFound
      );

      procedure RunTracking;
      procedure StopTracking;

      procedure UntrackAllControlTypes;
      
  end;

implementation

uses

  Messages,
  AuxDebugFunctionsUnit,
  EquipmentReferenceTableFormUnit,
  EquipmentTypesReferenceTableFormUnit,
  EquipmentsWithIPAdressesReferenceTableFormUnit;

{ TUIControlsTrackingStylist }

constructor TUIControlsTrackingStylist.Create;
begin

  inherited;

  FUIControlTypeStyleRegistry := TUIControlTypeStyleRegistry.Create;
  FApplicationEvents := TApplicationEvents.Create(nil);
  
  FDefaultApplicationMessageHandler := FApplicationEvents.OnMessage;
  
end;

destructor TUIControlsTrackingStylist.Destroy;
begin

  FreeAndNil(FApplicationEvents);
  FreeAndNil(FUIControlTypeStyleRegistry);
  
  inherited;

end;

function TUIControlsTrackingStylist.IsUIControlTypeTracking(
  ControlType: TWinControlClass
): Boolean;
begin

  Result :=
    FUIControlTypeStyleRegistry.IsUIControlTypeStyleExists(ControlType);

end;

procedure TUIControlsTrackingStylist.OnApplicationMessageHandler(
  var Msg: TMsg;
  var Handled: Boolean
);
var Control: TWinControl;
    ControlTypeStyle: IUIControlStyle;
begin

  { WM_ACTIVATE, WM_SHOWWINDOW
    по каким-то причинам не доставляются из очереди сообщений }

  if
    (Msg.message <> WM_PAINT) and
    (Msg.message <> WM_ACTIVATE) and
    (Msg.message <> WM_SHOWWINDOW)
  then Exit;

  Control := FindControl(Msg.hwnd);

  if not Assigned(Control) then Exit;

  ControlTypeStyle :=
    FUIControlTypeStyleRegistry.GetUIControlTypeStyle(
      TWinControlClass(Control.ClassType)
    );

  if Assigned(ControlTypeStyle) then
    ControlTypeStyle.Apply(Control);

end;

procedure TUIControlsTrackingStylist.RunTracking;
begin

  FApplicationEvents.OnMessage := OnApplicationMessageHandler;
  
  FApplicationEvents.Activate;

end;


procedure TUIControlsTrackingStylist.StopTracking;
begin

  FApplicationEvents.OnMessage := FDefaultApplicationMessageHandler;
  
end;

procedure TUIControlsTrackingStylist.TrackUIControlTypeForStylization(
  ControlType: TWinControlClass;
  Style: IUIControlStyle;
  TrackingOption: TUIControlTypeStyleTrackingOption
);
var RegistryOption: TUIControlTypeStyleRegistrationOption;
begin

  if TrackingOption = UseNearestAncestorControlTypeStyleIfTargetControlTypeNotFound
  then RegistryOption := AllowStyleUsingByControlTypeInheritance

  else RegistryOption := DisallowStyleUsingByControlTypeInheritance;
  
  FUIControlTypeStyleRegistry.RegisterOrUpdateUIControlTypeStyle(
    ControlType, Style, RegistryOption
  );

end;

procedure TUIControlsTrackingStylist.UntrackAllControlTypes;
begin

  FUIControlTypeStyleRegistry.Clear;

end;

end.

