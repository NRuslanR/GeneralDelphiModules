unit MVPView;

interface

uses

  CardFormViewModel,
  IGetSelfUnit,
  SysUtils,
  Classes,
  VariantListUnit;

type

  TOnFilledEventHandler =
    procedure (Sender: TObject) of object;

  TOnAcceptedEventHandler =
    procedure (Sender: TObject) of object;

  TOnRejectedEventHandler =
    procedure (Sender: TObject) of object;

  IMVPViews = interface;

  IMVPView = interface (IGetSelf)
    ['{EA5F67B4-612A-455F-B2C1-151CCEC526DA}']

    procedure InflateView(View: IMVPView);
    procedure InflateViews(Views: IMVPViews);
    
    procedure Fill;
    procedure Accept;
    procedure Reject;

    procedure Show;
    procedure Hide;
    procedure Close;

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

  TMVPViews = class;

  TMVPViewsEnumerator = class (TListEnumerator)

    protected

      function GetCurrentView: IMVPView;

    public

      constructor Create(Views: TMVPViews);

      property Current: IMVPView read GetCurrentView;

  end;

  IMVPViews = interface (IGetSelf)
    ['{633B2A48-4D3C-4C3B-AD25-FA477F39E443}']

    function GetCount: Integer;
    
    function GetViewByIndex(Index: Integer): IMVPView;

    function Add(View: IMVPView): Integer; overload;
    function Add(Views: IMVPViews): Integer; overload;
    procedure Remove(View: IMVPView);
    procedure RemoveByIndex(const Index: Integer);

    function IndexOf(View: IMVPView): Integer;
    function Contains(View: IMVPView): Boolean;

    function GetEnumerator: TMVPViewsEnumerator;

    property Count: Integer read GetCount;
    
    property Items[Index: Integer]: IMVPView
    read GetViewByIndex; default;
    
  end;

  TMVPViews = class (TInterfacedObject, IMVPViews)

    protected

      FViewList: TVariantList;

    public

      destructor Destroy; override;
      constructor Create;

      function GetSelf: TObject;

      function GetCount: Integer;
    
      function GetViewByIndex(Index: Integer): IMVPView;

      function Add(View: IMVPView): Integer; overload;
      function Add(Views: IMVPViews): Integer; overload;
      procedure Remove(View: IMVPView);
      procedure RemoveByIndex(const Index: Integer);

      function IndexOf(View: IMVPView): Integer;
      function Contains(View: IMVPView): Boolean;

      function GetEnumerator: TMVPViewsEnumerator;

      property Count: Integer read GetCount;

      property Items[Index: Integer]: IMVPView
      read GetViewByIndex; default;

  end;
  
implementation

uses

  VariantTypeUnit,
  VariantFunctions;

{ TMVPViews }

constructor TMVPViews.Create;
begin

  inherited;

  FViewList := TVariantList.Create;
  
end;

destructor TMVPViews.Destroy;
begin

  FreeAndNil(FViewList);

  inherited;

end;

function TMVPViews.Add(Views: IMVPViews): Integer;
var
    View: IMVPView;
    Index: Integer;
begin

  Result := -1;

  for View in Views do begin

    Index := Add(View);

    if Result = -1 then Result := Index;
    
  end;
end;

function TMVPViews.Add(View: IMVPView): Integer;
begin

  if not Contains(View) then
    Result := FViewList.AddInterface(View)

  else Result := -1;

end;

function TMVPViews.Contains(View: IMVPView): Boolean;
begin

  Result := FViewList.Contains(InterfaceToVariant(View));
  
end;

function TMVPViews.GetCount: Integer;
begin

  Result := FViewList.Count;

end;

function TMVPViews.GetEnumerator: TMVPViewsEnumerator;
begin

  Result := TMVPViewsEnumerator.Create(Self);

end;

function TMVPViews.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TMVPViews.GetViewByIndex(Index: Integer): IMVPView;
begin

  VariantToInterface(FViewList[Index], IMVPView, Result);
  
end;

function TMVPViews.IndexOf(View: IMVPView): Integer;
begin

  Result := FViewList.IndexOf(InterfaceToVariant(View));

end;

procedure TMVPViews.Remove(View: IMVPView);
begin

  FViewList.RemoveInterface(View);

end;

procedure TMVPViews.RemoveByIndex(const Index: Integer);
begin

  FViewList.Delete(Index);

end;

{ TMVPViewsEnumerator }

constructor TMVPViewsEnumerator.Create(Views: TMVPViews);
begin

  inherited Create(Views.FViewList);

end;

function TMVPViewsEnumerator.GetCurrentView: IMVPView;
begin

  VariantToInterface(TVariant(GetCurrent).Value, IMVPView, Result);

end;

end.
