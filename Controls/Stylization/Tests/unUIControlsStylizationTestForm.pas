unit unUIControlsStylizationTestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unTestFormA, unTestFormB, StdCtrls, ExtCtrls, ComCtrls, UIControlsTrackingStylist;

type
  TUIControlsStylizationTestForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

    FUIControlsTrackingStylist: TUIControlsTrackingStylist;

  public

    constructor Create(AOwner: TComponent); override;
    
  end;

var
  UIControlsStylizationTestForm: TUIControlsStylizationTestForm;

implementation

uses

  UIControlStyle,
  UIStandardControlStyle,
  UIWin32ControlStyle;

{$R *.dfm}

procedure TUIControlsStylizationTestForm.Button1Click(Sender: TObject);
begin

  with TTestFormA.Create(Self) do begin

    try

      ShowModal;

    finally

      Free;
      
    end;

  end;
  
end;

procedure TUIControlsStylizationTestForm.Button2Click(Sender: TObject);
const

  Counter: Integer = 0;
begin

  if Counter = 0 then begin

    Inc(Counter);

    FUIControlsTrackingStylist.RunTracking;

  end

  else begin

    Dec(Counter);

    FUIControlsTrackingStylist.StopTracking;
    
  end;
  
end;

constructor TUIControlsStylizationTestForm.Create(AOwner: TComponent);
var Style: IUIControlStyle;
begin

  inherited;

  FUIControlsTrackingStylist := TUIControlsTrackingStylist.Create;

  Style :=
    TUIFormStyle
      .Create
      .Color(clRed)
      .BorderStyle(bsNone);

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(
    TWinControlClass(ClassType), Style
  );

  Style :=
    TUIFormStyle
      .Create
      .Color(clGreen);

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(
    TTestFormA, Style
  );

  Style :=
    TUIFormStyle
      .Create
      .Color(clBlue);

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(
    TTestFormB, Style
  );

  Style :=
    TUIEditStyle
      .Create
      .Color(clLime)
      .Enabled(False);

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(TEdit, Style);

  Style :=
    TUIMemoStyle
      .Create
      .Align(alBottom)
      .Color(clGray);

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(TMemo, Style);

  Style :=
    TUIPanelStyle
      .Create
      .BevelInner(bvNone)
      .BevelOuter(bvNone)
      .BevelKind(bkNone)
      .Color($0023ff44);

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(TPanel, Style);

  Style :=
    TUIButtonStyle
      .Create
      .Caption('STYLIZED BUTTON');

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(TButton, Style);

  Style :=
    TUIDateTimePickerStyle
      .Create
      .Color(clYellow);

  FUIControlsTrackingStylist
    .TrackUIControlTypeForStylization(TDateTimePicker, Style);

end;

end.
