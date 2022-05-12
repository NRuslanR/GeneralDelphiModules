unit frmMVPFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, MVPView, MVPPresenter, CardFormViewModel;

type

  TMVPFrame = class(TFrame, IMVPView)
  
  protected

    FViewModel: TCardFormViewModel;
    FPresenter: IMVPPresenter;

  protected

    FVisible: Boolean;
    FFillOnShow: Boolean;
    FFillOnShowRequested: Boolean;
    
  protected
  
    FViews: IMVPViews;

  protected

    FOnFilledEventHandler: TOnFilledEventHandler;
    FOnAcceptedEventHandler: TOnAcceptedEventHandler;
    FOnRejectedEventHandler: TOnRejectedEventHandler;

    procedure Initialize(Presenter: IMVPPresenter); virtual;

    procedure DoInflateView(View: IMVPView; var InflatingResult: Boolean); virtual;
    function GetInflatingParentForView(View: IMVPView): TWinControl; virtual;
    
    procedure DoVisible; virtual;
    procedure DoUnVisible; virtual;

  protected

    procedure UpdateByViewModel(ViewModel: TCardFormViewModel); virtual;

  protected

    procedure OnViewFilledEventHandler(Sender: TObject; View: IMVPView);
    procedure OnViewAcceptedEventHandler(Sender: TObject; View: IMVPView);
    procedure OnViewRejectedEventHandler(Sender: TObject; View: IMVPView);

  public

    destructor Destroy; override;

    constructor Create(Owner: TComponent; Presenter: IMVPPresenter = nil);

  public

    function GetViewModel: TCardFormViewModel;
    procedure SetViewModel(Value: TCardFormViewModel);

    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    
    function GetOnFilledEventHandler: TOnFilledEventHandler;
    procedure SetOnFilledEventHandler(Value: TOnFilledEventHandler);

    function GetOnAcceptedEventHandler: TOnAcceptedEventHandler;
    procedure SetOnAcceptedEventHandler(Value: TOnAcceptedEventHandler);

    function GetOnRejectedEventHandler: TOnRejectedEventHandler;
    procedure SetOnRejectedEventHandler(Value: TOnRejectedEventHandler);

    function GetFillOnShow: Boolean;
    procedure SetFillOnShow(const Value: Boolean);

  public

    procedure Fill; virtual;
    procedure Accept; virtual;
    procedure Reject; virtual;

  public

    procedure InflateView(View: IMVPView);
    procedure InflateViews(Views: IMVPViews);

    procedure Show; virtual;
    procedure Hide; virtual;
    procedure Close; virtual;

    function ToForm(
      Owner: TComponent = nil;
      const Caption: String = '';
      FormClass: TFormClass = nil
    ): TForm;

    function GetSelf: TObject;
    
    property OnFilledEventHandler: TOnFilledEventHandler
    read GetOnFilledEventHandler write SetOnFilledEventHandler;

    property OnAcceptedEventHandler: TOnAcceptedEventHandler
    read GetOnAcceptedEventHandler write SetOnAcceptedEventHandler;

    property OnRejectedEventHandler: TOnRejectedEventHandler
    read GetOnRejectedEventHandler write SetOnRejectedEventHandler;
    
    property FillOnShow: Boolean
    read GetFillOnShow write SetFillOnShow;

    property Visible: Boolean
    read GetVisible write SetVisible;
    
    property ViewModel: TCardFormViewModel
    read GetViewModel write SetViewModel;
    
  end;

implementation

uses

  StubMVPPresenter,
  AuxWindowsFunctionsUnit;

{$R *.dfm}

{ TMVPFrame }

procedure TMVPFrame.Accept;
begin

  FPresenter.OnAccept(Self);
  
end;

procedure TMVPFrame.Close;
begin

  if Parent is TForm then
    TForm(Parent).Close;

end;

constructor TMVPFrame.Create(Owner: TComponent; Presenter: IMVPPresenter);
begin

  inherited Create(Owner);

  Initialize(Presenter);
  
end;

destructor TMVPFrame.Destroy;
begin

  FreeAndNil(FViewModel);

  inherited;

end;

procedure TMVPFrame.DoInflateView(View: IMVPView; var InflatingResult: Boolean);
var
    InflatingParent: TWinControl;
begin

  InflatingParent := GetInflatingParentForView(View);

  if not Assigned(InflatingParent) then begin

    Raise Exception.CreateFmt(
      'Inflating parent was not found for a view''s type "%s"',
      [
        View.Self.ClassName
      ]
    );

  end;

  InflateControl(TControl(View.Self), InflatingParent);
  
end;

procedure TMVPFrame.DoUnVisible;
begin

end;

procedure TMVPFrame.DoVisible;
var
    View: IMVPView;
begin

  for View in FViews do
    View.Show;

end;

procedure TMVPFrame.Fill;
begin

  FPresenter.OnFill(Self);

end;

function TMVPFrame.GetFillOnShow: Boolean;
begin

  Result := FFillOnShow;
  
end;

function TMVPFrame.GetInflatingParentForView(View: IMVPView): TWinControl;
begin

  Result := nil;

end;

function TMVPFrame.GetOnAcceptedEventHandler: TOnAcceptedEventHandler;
begin

  Result := FOnAcceptedEventHandler;

end;

function TMVPFrame.GetOnFilledEventHandler: TOnFilledEventHandler;
begin

  Result := FOnFilledEventHandler;

end;

function TMVPFrame.GetOnRejectedEventHandler: TOnRejectedEventHandler;
begin

  Result := FOnRejectedEventHandler;

end;

function TMVPFrame.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TMVPFrame.GetViewModel: TCardFormViewModel;
begin

  Result := FViewModel;
  
end;

function TMVPFrame.GetVisible: Boolean;
begin

  Result := FVisible;

end;

procedure TMVPFrame.Hide;
begin

  Visible := False;

end;

procedure TMVPFrame.InflateView(View: IMVPView);
var
    InflatingResult: Boolean;
begin

  if FViews.Contains(View) then Exit;

  InflatingResult := True;

  DoInflateView(View, InflatingResult);

  if InflatingResult then
    FViews.Add(View);

  if Visible then
    View.Show;
    
end;

procedure TMVPFrame.InflateViews(Views: IMVPViews);
var
    View: IMVPView;
begin

  for View in Views do
    InflateView(View);
    
end;

procedure TMVPFrame.Initialize(Presenter: IMVPPresenter);
begin

  FViews := TMVPViews.Create;
  
  if Assigned(Presenter) then
    FPresenter := Presenter

  else FPresenter := TStubMVPPresenter.Create;

  FPresenter.AddView(Self);

  FPresenter.OnViewFilledEventHandler := OnViewFilledEventHandler;
  FPresenter.OnViewAcceptedEventHandler := OnViewAcceptedEventHandler;
  FPresenter.OnViewRejectedEventHandler := OnViewRejectedEventHandler;
  
  FillOnShow := True;
  
end;

procedure TMVPFrame.OnViewAcceptedEventHandler(Sender: TObject; View: IMVPView);
begin

  if Assigned(FOnAcceptedEventHandler) then
    FOnAcceptedEventHandler(Self);

end;

procedure TMVPFrame.OnViewFilledEventHandler(Sender: TObject; View: IMVPView);
begin

  if Assigned(FOnFilledEventHandler) then
    FOnFilledEventHandler(Self);

end;

procedure TMVPFrame.OnViewRejectedEventHandler(Sender: TObject; View: IMVPView);
begin

  if Assigned(FOnRejectedEventHandler) then
    FOnRejectedEventHandler(Self);
    
end;

procedure TMVPFrame.Reject;
begin

  FPresenter.OnReject(Self);
  
end;

procedure TMVPFrame.SetFillOnShow(const Value: Boolean);
begin

  FFillOnShow := Value;

end;

procedure TMVPFrame.SetOnAcceptedEventHandler(Value: TOnAcceptedEventHandler);
begin

  FOnAcceptedEventHandler := Value;

end;

procedure TMVPFrame.SetOnFilledEventHandler(Value: TOnFilledEventHandler);
begin

  FOnFilledEventHandler := Value;
  
end;

procedure TMVPFrame.SetOnRejectedEventHandler(Value: TOnRejectedEventHandler);
begin

  FOnRejectedEventHandler := Value;
  
end;

procedure TMVPFrame.SetViewModel(Value: TCardFormViewModel);
begin

  if FViewModel = Value then Exit;

  FreeAndNil(FViewModel);

  FViewModel := Value;

  UpdateByViewModel(FViewModel);
  
end;

procedure TMVPFrame.SetVisible(const Value: Boolean);
begin

  FVisible := Value;
  
  if Value then begin

    if FillOnShow and not FFillOnShowRequested then begin

      FFillOnShowRequested := True;
      
      Fill;

    end;

    DoVisible;

  end
  
  else DoUnVisible;
    
  inherited Visible := Value;
  
end;

procedure TMVPFrame.Show;
begin

  Visible := True;

end;

function TMVPFrame.ToForm(
  Owner: TComponent;
  const Caption: String;
  FormClass: TFormClass
): TForm;
begin

  if not Assigned(FormClass) then
    FormClass := TForm;

  Result := FormClass.Create(Owner);

  Result.Caption := Caption;
  
  Parent := Result;
  Align := alClient;
  
end;

procedure TMVPFrame.UpdateByViewModel(ViewModel: TCardFormViewModel);
begin

end;

end.
