unit MVPPresenter;

interface

uses

  MVPView,
  VariantListUnit,
  IGetSelfUnit,
  SysUtils,
  InterfaceObjectList,
  Classes;

type

  TOnViewFilledEventHandler =
    procedure (Sender: TObject; View: IMVPView) of object;

  TOnViewAcceptedEventHandler =
    procedure (Sender: TObject; View: IMVPView) of object;

  TOnViewRejectedEventHandler =
    procedure (Sender: TObject; View: IMVPView) of object;
    
  IMVPPresenter = interface (IGetSelf)
    ['{AE264F4F-C50D-4A1D-98D3-4D71D32FC37F}']
    
    procedure OnFill(View: IMVPView);
    procedure OnAccept(View: IMVPView);
    procedure OnReject(View: IMVPView);

    procedure AddView(View: IMVPView);
    procedure RemoveView(View: IMVPView);

    function GetOnViewFilledEventHandler: TOnViewFilledEventHandler;
    procedure SetOnViewFilledEventHandler(Value: TOnViewFilledEventHandler);

    function GetOnViewAcceptedEventHandler: TOnViewAcceptedEventHandler;
    procedure SetOnViewAcceptedEventHandler(Value: TOnViewAcceptedEventHandler);

    function GetOnViewRejectedEventHandler: TOnViewRejectedEventHandler;
    procedure SetOnViewRejectedEventHandler(Value: TOnViewRejectedEventHandler);
    
    function GetCloseViewOnAccept: Boolean;
    procedure SetCloseViewOnAccept(const Value: Boolean);

    function GetCloseViewOnReject: Boolean;
    procedure SetCloseViewOnReject(const Value: Boolean);

    property OnViewFilledEventHandler: TOnViewFilledEventHandler
    read GetOnViewFilledEventHandler write SetOnViewFilledEventHandler;

    property OnViewAcceptedEventHandler: TOnViewAcceptedEventHandler
    read GetOnViewAcceptedEventHandler write SetOnViewAcceptedEventHandler;

    property OnViewRejectedEventHandler: TOnViewRejectedEventHandler
    read GetOnViewRejectedEventHandler write SetOnViewRejectedEventHandler;

    property CloseViewOnAccept: Boolean
    read GetCloseViewOnAccept write SetCloseViewOnAccept;

    property CloseViewOnReject: Boolean
    read GetCloseViewOnReject write SetCloseViewOnReject;

  end;

  TViewHandler = procedure (View: IMVPView) of object;

  TAbstractMVPPresenter = class abstract (TInterfacedObject, IMVPPresenter)

    private

      FCloseViewOnAccept: Boolean;
      FCloseViewOnReject: Boolean;

    private

      FViews: TVariantList;

    private

      FOnViewFilledEventHandler: TOnViewFilledEventHandler;
      FOnViewAcceptedEventHandler: TOnViewAcceptedEventHandler;
      FOnViewRejectedEventHandler: TOnViewRejectedEventHandler;
      
    protected

      procedure ValidateViewOnAccept(View: IMVPView); virtual;
      procedure ValidateViewOnReject(View: IMVPView); virtual;

      procedure FillView(View: IMVPView); virtual;
      procedure DoFillView(View: IMVPView); virtual;

      procedure AcceptView(View: IMVPView); virtual;
      procedure DoAcceptView(View: IMVPView); virtual;

      procedure RejectView(View: IMVPView); virtual;
      procedure DoRejectView(View: IMVPView); virtual;

      procedure ForEachView(Handler: TViewHandler);

      procedure CloseViewAsRejected(View: IMVPView);
      procedure CloseViewAsAccepted(View: IMVPView);
      
    public

      procedure OnFill(View: IMVPView);
      procedure OnAccept(View: IMVPView);
      procedure OnReject(View: IMVPView);

    public

      destructor Destroy; override;
      constructor Create;

      function GetSelf: TObject;

      procedure AddView(View: IMVPView);
      procedure RemoveView(View: IMVPView);

    public

      function GetOnViewFilledEventHandler: TOnViewFilledEventHandler;
      procedure SetOnViewFilledEventHandler(Value: TOnViewFilledEventHandler);

      function GetOnViewAcceptedEventHandler: TOnViewAcceptedEventHandler;
      procedure SetOnViewAcceptedEventHandler(Value: TOnViewAcceptedEventHandler);

      function GetOnViewRejectedEventHandler: TOnViewRejectedEventHandler;
      procedure SetOnViewRejectedEventHandler(Value: TOnViewRejectedEventHandler);

      procedure RaiseOnViewFilledEventHandler(View: IMVPView);
      procedure RaiseOnViewAcceptedEventHandler(View: IMVPView);
      procedure RaiseOnViewAcceptedEventHandlerAndCloseView(View: IMVPView);
      procedure RaiseOnViewRejectedEventHandler(View: IMVPView);
      procedure RaiseOnViewRejectedEventHandlerAndCloseView(View: IMVPView);

    public

      function GetCloseViewOnAccept: Boolean;
      procedure SetCloseViewOnAccept(const Value: Boolean);

      function GetCloseViewOnReject: Boolean;
      procedure SetCloseViewOnReject(const Value: Boolean);

    public

      property OnViewFilledEventHandler: TOnViewFilledEventHandler
      read GetOnViewFilledEventHandler write SetOnViewFilledEventHandler;

      property OnViewAcceptedEventHandler: TOnViewAcceptedEventHandler
      read GetOnViewAcceptedEventHandler write SetOnViewAcceptedEventHandler;

      property OnViewRejectedEventHandler: TOnViewRejectedEventHandler
      read GetOnViewRejectedEventHandler write SetOnViewRejectedEventHandler;

    public

      property CloseViewOnAccept: Boolean
      read GetCloseViewOnAccept write SetCloseViewOnAccept;

      property CloseViewOnReject: Boolean
      read GetCloseViewOnReject write SetCloseViewOnReject;

  end;

implementation

uses

    VariantFunctions;

{ TAbstractMVPPresenter }

procedure TAbstractMVPPresenter.AcceptView(View: IMVPView);
begin

  DoAcceptView(View);

  RaiseOnViewAcceptedEventHandlerAndCloseView(View);
  
end;

procedure TAbstractMVPPresenter.AddView(View: IMVPView);
begin

  FViews.AddInterface(View);

end;

procedure TAbstractMVPPresenter.CloseViewAsAccepted(View: IMVPView);
begin

  if CloseViewOnAccept then
    View.Close;

end;

procedure TAbstractMVPPresenter.CloseViewAsRejected(View: IMVPView);
begin

  if CloseViewOnReject then
    View.Close;
    
end;

constructor TAbstractMVPPresenter.Create;
begin

  inherited;

  FViews := TVariantList.Create;
  
end;

destructor TAbstractMVPPresenter.Destroy;
begin

  FreeAndNil(FViews);

  inherited;

end;

procedure TAbstractMVPPresenter.DoAcceptView(View: IMVPView);
begin

end;

procedure TAbstractMVPPresenter.DoFillView(View: IMVPView);
begin

end;

procedure TAbstractMVPPresenter.DoRejectView(View: IMVPView);
begin

end;

procedure TAbstractMVPPresenter.FillView(View: IMVPView);
begin

  DoFillView(View);

  RaiseOnViewFilledEventHandler(View);

end;

procedure TAbstractMVPPresenter.ForEachView(Handler: TViewHandler);
var
    ViewVariant: Variant;
    View: IMVPView;
begin

  for ViewVariant in FViews do begin

    if not VariantToInterface(ViewVariant, IMVPView, View) then begin

      Raise Exception.Create('Failed to cast Variant to View interface');

    end;

    Handler(View);

  end;

end;

function TAbstractMVPPresenter.GetCloseViewOnAccept: Boolean;
begin

  Result := FCloseViewOnAccept;

end;

function TAbstractMVPPresenter.GetCloseViewOnReject: Boolean;
begin

  Result := FCloseViewOnReject;
  
end;

function TAbstractMVPPresenter.GetOnViewAcceptedEventHandler: TOnViewAcceptedEventHandler;
begin

  Result := FOnViewAcceptedEventHandler;

end;

function TAbstractMVPPresenter.GetOnViewFilledEventHandler: TOnViewFilledEventHandler;
begin

  Result := FOnViewFilledEventHandler;

end;

function TAbstractMVPPresenter.GetOnViewRejectedEventHandler: TOnViewRejectedEventHandler;
begin

  Result := FOnViewRejectedEventHandler;
  
end;

function TAbstractMVPPresenter.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TAbstractMVPPresenter.OnFill(View: IMVPView);
begin

  FillView(View);

end;

procedure TAbstractMVPPresenter.OnAccept(View: IMVPView);
begin

  ValidateViewOnAccept(View);

  AcceptView(View);

end;

procedure TAbstractMVPPresenter.OnReject(View: IMVPView);
begin

  ValidateViewOnReject(View);
  
  RejectView(View);

end;

procedure TAbstractMVPPresenter.RaiseOnViewAcceptedEventHandler(View: IMVPView);
begin

  if Assigned(FOnViewAcceptedEventHandler) then
    FOnViewAcceptedEventHandler(Self, View);

end;

procedure TAbstractMVPPresenter.RaiseOnViewAcceptedEventHandlerAndCloseView(
  View: IMVPView);
begin

  RaiseOnViewAcceptedEventHandler(View);

  CloseViewAsAccepted(View);

end;

procedure TAbstractMVPPresenter.RaiseOnViewFilledEventHandler(View: IMVPView);
begin

  if Assigned(FOnViewFilledEventHandler) then
    FOnViewFilledEventHandler(Self, View);
    
end;

procedure TAbstractMVPPresenter.RaiseOnViewRejectedEventHandler(View: IMVPView);
begin

  if Assigned(FOnViewRejectedEventHandler) then
    FOnViewRejectedEventHandler(Self, View);

end;

procedure TAbstractMVPPresenter.RaiseOnViewRejectedEventHandlerAndCloseView(
  View: IMVPView);
begin

  RaiseOnViewRejectedEventHandler(View);

  CloseViewAsRejected(View);
  
end;

procedure TAbstractMVPPresenter.RejectView(View: IMVPView);
begin

  DoRejectView(View);

  RaiseOnViewRejectedEventHandlerAndCloseView(View);
  
end;

procedure TAbstractMVPPresenter.RemoveView(View: IMVPView);
begin

  FViews.RemoveInterface(View);

end;

procedure TAbstractMVPPresenter.SetCloseViewOnAccept(const Value: Boolean);
begin

  FCloseViewOnAccept := Value;

end;

procedure TAbstractMVPPresenter.SetCloseViewOnReject(const Value: Boolean);
begin

  FCloseViewOnReject := Value;

end;

procedure TAbstractMVPPresenter.SetOnViewAcceptedEventHandler(
  Value: TOnViewAcceptedEventHandler);
begin

  FOnViewAcceptedEventHandler := Value;

end;

procedure TAbstractMVPPresenter.SetOnViewFilledEventHandler(
  Value: TOnViewFilledEventHandler);
begin

  FOnViewFilledEventHandler := Value;

end;

procedure TAbstractMVPPresenter.SetOnViewRejectedEventHandler(
  Value: TOnViewRejectedEventHandler);
begin

  FOnViewRejectedEventHandler := Value;

end;

procedure TAbstractMVPPresenter.ValidateViewOnAccept(View: IMVPView);
begin

end;

procedure TAbstractMVPPresenter.ValidateViewOnReject(View: IMVPView);
begin

end;

end.
