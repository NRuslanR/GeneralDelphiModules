unit AuxWindowsFunctionsUnit;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ExtCtrls, StdCtrls, ActnList, Math;

const

  CHECKBOX_QUAD_APPROXIMATE_WIDTH = 20;

type

  TActionListHandler = procedure (Action: TAction) of object;
  
  TAnchorsArray = array of TAnchors;
  TAncestorSearchOption = (soUseTypeEquality, soUseTypeInheritance);

  TInflationParentDimension = (psParentDimensionAsInflatedControl, psParentOwnDimension);
  TInflationParentOwning = (poParentAsOwner, poNoChangeOwner);

  TInflationParentSize = record

    ParentWidth: TInflationParentDimension;
    ParentHeight: TInflationParentDimension;

    constructor Create(
      const ParentWidth: TInflationParentDimension;
      const ParentHeight: TInflationParentDimension
    );

  end;

  TInflationInfo = record

    InflatedControl: TControl;
    Parent: TWinControl;
    ParentSize: TInflationParentSize;
    ParentOwning: TInflationParentOwning;

    constructor Create(
      InflatedControl: TControl;
      Parent: TWinControl
    ); overload;

    constructor Create(
      InflatedControl: TControl;
      Parent: TWinControl;
      const ParentSize: TInflationParentSize;
      const ParentOwning: TInflationParentOwning = poParentAsOwner
    ); overload;

  end;

function CreateLabel(
  Parent: TWinControl;
  const Caption: String = '';
  const Anchors: TAnchors = [akLeft, akTop]
): TLabel;
procedure CenterChildControlsOfParentControlByVertically(
  ParentControl: TWinControl
);
procedure CenterWindowRelativeByHorz(CenteredCtrl, RelativeCtrl: TControl);
procedure CenterWindowRelativeByVert(CenteredCtrl, RelativeCtrl: TControl);
procedure CenterWindowRelative(CenteredCtrl, RelativeCtrl: TControl);
procedure SetEnabledControls(Enabled: boolean; Ctrls: array of TControl);
procedure SetVisibleControls(Visible: boolean; Ctrls: array of TControl);
procedure SetCheckedCheckBoxes(Checked: boolean; CheckBoxes: array of TCheckBox);
procedure SetEnabledActions(Enabled: boolean; Actions: array of TAction);
procedure SetVisibleActions(const Visible: Boolean; Actions: array of TAction);
procedure SetEnabledChildControls(const Enabled: Boolean; ParentControl: TWinControl);
procedure SetVisibleChildControls(const Visible: Boolean; ParentControl: TWinControl);
procedure SetProgressBarMinMax(ProgressBar: TProgressBar; const Min, Max: integer);
procedure SetEnabledMenuItems(const Enabled: boolean; MenuItems: array of TMenuItem);
procedure SetVisibleMenuItems(const Visible: boolean; MenuItems: array of TMenuItem);
procedure SetAnchorsToControls(const Anchors: TAnchors; Controls: array of TControl);
procedure ShowErrorMessage(hWindow: HWND; const Msg, Title: string);
procedure ShowWarningMessage(hWindow: HWND; const Msg, Title: string);

procedure AdjustControlBounds(
  const DeltaLeft, DeltaTop, DeltaWidth, DeltaHeight: Integer;
  Controls: array of TControl
); overload;

procedure AdjustControlBounds(
  const DeltaBounds: TRect;
  Controls: array of TControl
); overload;

procedure ShowInfoMessage(hWindow: HWND; const Msg, Title: string);
function ShowQuestionMessage(hWindow: HWND; const Msg, Title: string;
  MsgBoxButtons: Cardinal = MB_YESNO): Integer;
procedure AdjustCheckBoxSize(CheckBox: TCheckBox);
procedure GetAdjustedCheckBoxSize(CheckBox: TCheckBox; var Width, Height: Integer);

procedure AdjustControlSizeByContent(
  Control: TControl;
  ControlCanvas: TCanvas;
  const Padding: TRect
); overload;

procedure AdjustControlSizeByContentIfClipped(
  Control: TControl;
  ControlCanvas: TCanvas;
  const Padding: TRect
);

function DisableAnchorsFor(Control: TControl): TAnchorsArray;
procedure EnableAnchorsFor(Control: TControl; RestoringAnchors: TAnchorsArray);

function GetAncestorCanvasFor(Control: TControl): TCanvas;
function GetVerticalScrollBarWidth: Integer;
function GetHorizontalScrollBarHeight: Integer;
function GetAncestorControl(
  Control: TControl;
  const ControlType: TWinControlClass;
  const SearchOption: TAncestorSearchOption = soUseTypeEquality
): TWinControl;

procedure SetControlSizeByOtherControlSize(
  TargetControl: TControl;
  OtherControl: TControl;
  const WidthRatio: Single = 1.0;
  const HeightRatio: Single = 1.0
);

procedure SetControlSizeByRatio(
  TargetControl: TControl;
  const NewWidth, NewHeight: Integer;
  const WidthRatio: Single = 1.0;
  const HeightRatio: Single = 1.0
);

procedure SetControlSizeByScreenSize(
  TargetControl: TControl;
  const WidthRatio: Single = 1.0;
  const HeightRatio: Single = 1.0
);

function GetMemoTextHeight(Memo: TMemo): Integer;
function GetMemoTextWidth(Memo: TMemo): Integer;

function FindChildControlByType(
  ParentControl: TWinControl;
  const ControlType: TControlClass
): TControl;

function FindChildControlsByType(
  ParentControl: TWinControl;
  const ControlType: TControlClass
): TList;

function FindChildControlsByTypes(
  ParentControl: TWinControl;
  ControlTypes: array of TControlClass
): TList;

procedure ApplyHorizontalLayoutToControls(
  Controls: array of TControl;
  const StartLeft: Integer = 0
);

procedure InflateControl(
  InflatedControl: TControl;
  Parent: TWinControl
); overload;

procedure InflateControl(const InflationInfo: TInflationInfo); overload;

procedure InflateControlAndFreePrevious(
  InflatedControl: TControl;
  Parent: TWinControl
); overload;

procedure InflateControlAndFreePrevious(const InflationInfo: TInflationInfo); overload;

procedure InflateControls(InflationInfos: array of TInflationInfo);

function AddTabSheet(PageCtrl: TPageControl; const TabCaption: String = ''): TTabSheet;
function FindTabSheetByCaption(PageCtrl: TPageControl; const TabCaption: String): TTabSheet;

implementation

uses Spin, StrUtils, AuxDebugFunctionsUnit;

procedure AdjustControlWidthByContent(
  Control: TControl;
  ControlContent: String;
  ControlCanvas: TCanvas;
  const Padding: TRect
);
begin

  Control.Width := Padding.Left + ControlCanvas.TextWidth(ControlContent) + Padding.Right;

end;

procedure AdjustControlHeightByContent(
  Control: TControl;
  ControlContent: String;
  ControlCanvas: TCanvas;
  const Padding: TRect
);
begin

  Control.Height := Padding.Top + ControlCanvas.TextHeight(ControlContent) + Padding.Bottom;

end;

procedure AdjustControlSizeByContent(
  Control: TControl;
  ControlContent: String;
  ControlCanvas: TCanvas;
  const Padding: TRect
); overload;
begin

  AdjustControlWidthByContent(Control, ControlContent, ControlCanvas, Padding);
  AdjustControlHeightByContent(Control, ControlContent, ControlCanvas, Padding);

end;

function GetControlContent(Control: TControl; ControlCanvas: TCanvas): Variant;
begin

  if Control is TLabel then
    Result := (Control as TLabel).Caption

  else if Control is TEdit then
    Result := (Control as TEdit).Text

  else if Control is TPanel then
    Result :=  (Control as TPanel).Caption

  else if Control is TCheckBox then begin

    Result :=
      (Control as TCheckBox).Caption +
      DupeString(' ', Integer(Round(CHECKBOX_QUAD_APPROXIMATE_WIDTH / ControlCanvas.TextWidth(' '))));

  end

  else if Control is TSpinEdit then
    Result := (Control as TSpinEdit).Value

  else if Control is TDateTimePicker then
    Result := (Control as TDateTimePicker).DateTime

  else if Control is TButton then
    Result := (Control as TButton).Caption

  else Result := Null;

end;

procedure CenterWindowRelativeByHorz(CenteredCtrl, RelativeCtrl: TControl);
var Left: Integer;
begin

  if CenteredCtrl.Parent = RelativeCtrl then
    Left := 0

  else Left := RelativeCtrl.Left;
  
  CenteredCtrl.Left := Left + (RelativeCtrl.Width - CenteredCtrl.Width) div 2;

end;

procedure CenterWindowRelativeByVert(CenteredCtrl, RelativeCtrl: TControl);
var Top: Integer;
begin

  if CenteredCtrl.Parent = RelativeCtrl then
    Top := 0

  else Top := RelativeCtrl.Top;

  CenteredCtrl.Top := Top + (RelativeCtrl.Height - CenteredCtrl.Height) div 2;

end;

procedure CenterWindowRelative(CenteredCtrl, RelativeCtrl: TControl);
begin

  CenterWindowRelativeByHorz(CenteredCtrl, RelativeCtrl);
  CenterWindowRelativeByVert(CenteredCtrl, RelativeCtrl);
  
end;

procedure SetEnabledControls(Enabled: boolean; Ctrls: array of TControl);
var ctrl: TControl;
begin

  for ctrl in Ctrls do begin
    if ctrl = nil then continue;
    ctrl.Enabled := Enabled;
  end;

end;

procedure SetVisibleControls(Visible: boolean; Ctrls: array of TControl);
var ctrl: TControl;
begin

  for ctrl in Ctrls do begin
    if ctrl = nil then continue;
    ctrl.Visible := Visible;
  end;

end;

procedure SetCheckedCheckBoxes(Checked: boolean; CheckBoxes: array of TCheckBox);
var cb: TCheckBox;
begin

  for cb in CheckBoxes do begin
    if cb = nil then continue;
    cb.Checked := Checked;
  end;

end;

procedure SetEnabledActions(Enabled: boolean; Actions: array of TAction);
var act: TAction;
begin

  for act in Actions do begin
    if act = nil then continue;
    act.Enabled := Enabled;
  end;
    
end;

procedure SetProgressBarMinMax(ProgressBar: TProgressBar; const Min, Max: integer);
begin
  ProgressBar.Min := Min;
  ProgressBar.Max := Max;
end;

procedure SetVisibleActions(const Visible: Boolean; Actions: array of TAction);
var act: TAction;
begin

  for act in Actions do begin
    if act = nil then Continue;
    act.Visible := Visible;
  end;

end;

procedure SetVisibleMenuItems(const Visible: Boolean; MenuItems: array of TMenuItem);
var MenuItem: TMenuItem;
begin

  for MenuItem in MenuItems do begin
    if MenuItem = nil then Continue;
    MenuItem.Visible := Visible;
  end;

end;

procedure SetEnabledMenuItems(const Enabled: Boolean; MenuItems: array of TMenuItem);
var MenuItem: TMenuItem;
begin

  for MenuItem in MenuItems do begin
    if MenuItem = nil then Continue;
    MenuItem.Enabled := Enabled;
  end;

end;

procedure ShowErrorMessage(hWindow: HWND; const Msg, Title: string);
begin
  MessageBox(hWindow, PChar(Msg), PChar(Title), MB_OK or MB_ICONERROR);
end;

procedure ShowWarningMessage(hWindow: HWND; const Msg, Title: string);
begin
  MessageBox(hWindow, PChar(Msg), PChar(Title), MB_OK or MB_ICONWARNING );
end;

procedure ShowInfoMessage(hWindow: HWND; const Msg, Title: string);
begin
  MessageBox(hWindow, PChar(Msg), PChar(Title), MB_OK or MB_ICONINFORMATION);
end;

function ShowQuestionMessage(hWindow: HWND; const Msg, Title: string;
  MsgBoxButtons: Cardinal = MB_YESNO): Integer;
begin
  Result := MessageBox(hWindow, PChar(Msg), PChar(Title), MsgBoxButtons or MB_ICONQUESTION);
end;

procedure SetEnabledChildControls(const Enabled: Boolean; ParentControl: TWinControl);
var I: Integer;
begin

  for I := 0 to ParentControl.ControlCount - 1 do
    ParentControl.Controls[I].Enabled := Enabled;
    
end;

procedure SetVisibleChildControls(const Visible: Boolean; ParentControl: TWinControl);
var
    I: Integer;
begin

  for I := 0 to ParentControl.ControlCount - 1 do
    ParentControl.Controls[I].Visible := Visible;
    
end;

procedure AdjustCheckBoxSize(CheckBox: TCheckBox);
var AdjustedWidth, AdjustedHeight: Integer;
begin

  GetAdjustedCheckBoxSize(CheckBox, AdjustedWidth, AdjustedHeight);

  CheckBox.Width := AdjustedWidth;
  CheckBox.Height := AdjustedHeight;

end;

procedure GetAdjustedCheckBoxSize(CheckBox: TCheckBox; var Width, Height: Integer);
var Canvas: TCanvas;
    Dummy: TForm;
begin

  Dummy := nil;
  
  try

    Canvas := GetAncestorCanvasFor(CheckBox);

    if not Assigned(Canvas) then begin

      Dummy := TForm.Create(nil);

      Canvas := Dummy.Canvas;
      
    end;

    Width := CHECKBOX_QUAD_APPROXIMATE_WIDTH + Canvas.TextWidth(CheckBox.Caption);
    Height := Canvas.TextHeight(CheckBox.Caption);
    
  finally

    FreeAndNil(Dummy);

  end;

end;

procedure SetAnchorsToControls(
  const Anchors: TAnchors;
  Controls: array of TControl
);
var Control: TControl;
begin

  for Control in Controls do
    Control.Anchors := Anchors;

end;

procedure AdjustControlBounds(
  const DeltaLeft, DeltaTop, DeltaWidth, DeltaHeight: Integer;
  Controls: array of TControl
);
var Control: TControl;
begin

  AdjustControlBounds(Rect(DeltaLeft, DeltaTop, DeltaWidth, DeltaHeight), Controls);

end;

procedure AdjustControlBounds(
  const DeltaBounds: TRect;
  Controls: array of TControl
);
var Control: TControl;

begin

  for Control in Controls do begin

    Control.Left := Control.Left + DeltaBounds.Left;
    Control.Top := Control.Top + DeltaBounds.Top;
    Control.Width := Control.Width + DeltaBounds.Right;
    Control.Height := Control.Height + DeltaBounds.Bottom;
    
  end;
    
end;

function CreateLabel(
  Parent: TWinControl;
  const Caption: String = '';
  const Anchors: TAnchors = [akLeft, akTop]
): TLabel;
begin

  Result := TLabel.Create(Parent);
  Result.Parent := Parent;
  Result.Caption := Caption;
  Result.Anchors := Anchors;

end;

procedure AdjustControlSizeByContentIfClipped(
  Control: TControl;
  ControlCanvas: TCanvas;
  const Padding: TRect
);
var
    ControlContentStr: String;
begin

  ControlContentStr := VarToStr(GetControlContent(Control, ControlCanvas));

  if (Padding.Left + ControlCanvas.TextWidth(ControlContentStr) + Padding.Right) > Control.Width then
    AdjustControlWidthByContent(Control, ControlContentStr, ControlCanvas, Padding);

  if (Padding.Top + ControlCanvas.TextHeight(ControlContentStr) + Padding.Bottom) > Control.Height then
    AdjustControlHeightByContent(Control, ControlContentStr, ControlCanvas, Padding);

end;

procedure AdjustControlSizeByContent(
  Control: TControl;
  ControlCanvas: TCanvas;
  const Padding: TRect
);
var ContentStr: String;
begin

  ContentStr := VarToStr(GetControlContent(Control, ControlCanvas));

  AdjustControlSizeByContent(Control, ContentStr, ControlCanvas, Padding);

end;

procedure CenterChildControlsOfParentControlByVertically(
  ParentControl: TWinControl
);
var ChildControl: TControl;
    I: Integer;
begin

  for I := 0 to ParentControl.ControlCount - 1 do begin

    CenterWindowRelativeByVert(ParentControl.Controls[I], ParentControl);

  end;

end;

function GetVerticalScrollBarWidth: Integer;
begin

  Result := GetSystemMetrics(SM_CXVSCROLL);

end;

function GetHorizontalScrollBarHeight: Integer;
begin

  Result := GetSystemMetrics(SM_CYHSCROLL);

end;

function GetAncestorCanvasFor(Control: TControl): TCanvas;
var
    ParentForm: TCustomForm;
begin

  ParentForm := GetParentForm(Control);

  if Assigned(ParentForm) then
    Result := ParentForm.Canvas

  else if Assigned(Application.MainForm) then
    Result := Application.MainForm.Canvas

  else Result := nil;

end;

function DisableAnchorsFor(Control: TControl): TAnchorsArray;
var I: Integer;
begin

  if Control is TWinControl then begin

    with Control as TWinControl do begin

      SetLength(Result, ControlCount);

      for I := 0 to ControlCount - 1 do begin

        Result[I] := Controls[I].Anchors;

        Controls[I].Anchors := [akLeft, akTop];
        
      end;

    end;

  end

  else begin

    SetLength(Result, 1);

    Result[0] := Control.Anchors;
    
  end;

end;

procedure EnableAnchorsFor(Control: TControl; RestoringAnchors: TAnchorsArray);
var I: Integer;
begin

  if Control is TWinControl then begin

    with Control as TWinControl do begin

      for I := 0 to ControlCount - 1 do
        Controls[I].Anchors := RestoringAnchors[I];

    end;

  end

  else Control.Anchors := RestoringAnchors[I];

end;

procedure SetControlSizeByScreenSize(
  TargetControl: TControl;
  const WidthRatio: Single = 1.0;
  const HeightRatio: Single = 1.0
);
begin

  SetControlSizeByRatio(
    TargetControl,
    Screen.Width,
    Screen.Height,
    WidthRatio,
    HeightRatio
  );
  
end;

procedure SetControlSizeByOtherControlSize(
  TargetControl: TControl;
  OtherControl: TControl;
  const WidthRatio: Single = 1.0;
  const HeightRatio: Single = 1.0
);
begin

  SetControlSizeByRatio(
    TargetControl,
    OtherControl.Width,
    OtherControl.Height,
    WidthRatio,
    HeightRatio
  );
  
end;

procedure SetControlSizeByRatio(
  TargetControl: TControl;
  const NewWidth, NewHeight: Integer;
  const WidthRatio: Single = 1.0;
  const HeightRatio: Single = 1.0
);
begin

  TargetControl.Width := Trunc(Min(WidthRatio, 1.0) * NewWidth);
  TargetControl.Height := Trunc(Min(HeightRatio, 1.0) * NewHeight);
  
end;

function GetMemoTextHeight(Memo: TMemo): Integer;
var Canvas: TCanvas;
    CustomForm: TForm;
begin

  Canvas := GetAncestorCanvasFor(Memo);

  if not Assigned(Canvas) then begin

    CustomForm := TForm.Create(nil);

    Canvas := CustomForm.Canvas;

  end

  else CustomForm := nil;
  
  try

    Result := Canvas.TextHeight('Wq') * Memo.Lines.Count;

  finally

    FreeAndNil(CustomForm);

  end;
  
end;

function GetMemoTextWidth(Memo: TMemo): Integer;
var Canvas: TCanvas;
    CustomForm: TForm;
begin

  Canvas := GetAncestorCanvasFor(Memo);

  if not Assigned(Canvas) then begin

    CustomForm := TForm.Create(nil);

    Canvas := CustomForm.Canvas;

  end

  else CustomForm := nil;

  try 

    Result := Canvas.TextWidth(Memo.Text);

  finally

    FreeAndNil(CustomForm);

  end;
  
end;

function FindChildControlByType(
  ParentControl: TWinControl;
  const ControlType: TControlClass
): TControl;
var
    I: Integer;
begin

  with ParentControl do begin

    for I := 0 to ControlCount - 1 do
      if Controls[I].ClassType.InheritsFrom(ControlType) then begin

        Result := Controls[I];

        Exit;

      end;

    Result := nil;

  end;

end;

function FindChildControlsByType(
  ParentControl: TWinControl;
  const ControlType: TControlClass
): TList;

var

    I: Integer;
begin

  Result := nil;

  try

    with ParentControl do begin

      for I := 0 to ControlCount - 1 do begin

        if Controls[I].ClassType.InheritsFrom(ControlType) then begin

          if not Assigned(Result) then
            Result := TList.Create;

          Result.Add(Controls[I]);
          
        end;

      end;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function GetAncestorControl(
  Control: TControl;
  const ControlType: TWinControlClass;
  const SearchOption: TAncestorSearchOption
): TWinControl;
var
    ComparisonResult: Boolean;
begin

  Result := Control.Parent;

  while Assigned(Result) do begin

    if SearchOption = soUseTypeEquality then
      ComparisonResult := TControlClass(Result.ClassType) = ControlType

    else if SearchOption = soUseTypeInheritance then
      ComparisonResult := Result.ClassType.InheritsFrom(ControlType)

    else ComparisonResult := TControlClass(Result.ClassType) = ControlType;

    if ComparisonResult then begin
    
      Result := Result;

      Exit;
      
    end;

    Result := Result.Parent;

  end;
  
end;

procedure ApplyHorizontalLayoutToControls(
  Controls: array of TControl;
  const StartLeft: Integer
);
var
    Control: TControl;
    CurrentHorizontalPos: Integer;
begin

  CurrentHorizontalPos := StartLeft;
  
  for Control in Controls do begin

    if not Control.Visible then
      Continue;

    Control.Left := CurrentHorizontalPos;

    Inc(CurrentHorizontalPos, Control.Width + Control.Margins.Right);

  end;
  
end;

function FindChildControlsByTypes(
  ParentControl: TWinControl;
  ControlTypes: array of TControlClass
): TList;
var
    TypeControlList: TList;
    ControlType: TControlClass;
    ControlPointer: Pointer;
begin


  try

    Result := nil;
    TypeControlList := nil;
    
    try

      for ControlType in ControlTypes do begin

        TypeControlList := FindChildControlsByType(ParentControl, ControlType);

        if not Assigned(TypeControlList) then Continue;

        if not Assigned(Result) then
          Result := TList.Create;
          
        for ControlPointer in TypeControlList do
          Result.Add(ControlPointer);

      end;

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(TypeControlList);

  end;

end;

procedure InflateControl(
  InflatedControl: TControl;
  Parent: TWinControl
);
begin

  InflateControl(TInflationInfo.Create(InflatedControl, Parent));

end;

procedure InflateControl(const InflationInfo: TInflationInfo); overload;
begin

  with InflationInfo do begin

    InflatedControl.Parent := Parent;

    if
      (ParentSize.ParentWidth = psParentOwnDimension)
      and (ParentSize.ParentHeight = psParentOwnDimension)
    then
      InflatedControl.Align := alClient

    else begin

      InflatedControl.Left := 0; InflatedControl.Top := 0;

      if ParentSize.ParentWidth = psParentDimensionAsInflatedControl then
        Parent.Width := InflatedControl.Width

      else InflatedControl.Width := Parent.Width;

      if ParentSize.ParentHeight = psParentDimensionAsInflatedControl then
        Parent.Height := InflatedControl.Height

      else InflatedControl.Height := Parent.Height;
        
    end;

    if InflatedControl is TForm then
      TForm(InflatedControl).BorderStyle := bsNone;

    if ParentOwning = poParentAsOwner then
      Parent.InsertComponent(InflatedControl);

  end;

end;

procedure InflateControls(InflationInfos: array of TInflationInfo);
var
    InflationInfo: TInflationInfo;
begin

  for InflationInfo in InflationInfos do InflateControl(InflationInfo);

end;

function AddTabSheet(PageCtrl: TPageControl; const TabCaption: String = ''): TTabSheet;
begin

  Result := TTabSheet.Create(PageCtrl);

  with Result do begin

    try

      Caption := TabCaption;
      PageControl := PageCtrl;

    except

      Free;

    end;

  end;

end;

function FindTabSheetByCaption(PageCtrl: TPageControl; const TabCaption: String): TTabSheet;
var
    I: Integer;
begin

  for I := 0 to PageCtrl.PageCount - 1 do begin

    Result := PageCtrl.Pages[I];

    if Result.Caption = TabCaption then Exit;

  end;

  Result := nil;
  
end;

procedure InflateControlAndFreePrevious(
  InflatedControl: TControl;
  Parent: TWinControl
);
begin

  InflateControlAndFreePrevious(TInflationInfo.Create(InflatedControl, Parent));
  
end;

procedure InflateControlAndFreePrevious(const InflationInfo: TInflationInfo); overload;
var
    PreviousControl: TControl;
begin

  with InflationInfo do begin

    if Parent.ControlCount > 1 then begin

      raise Exception.Create(
        'Current parent''s control count more than one for inflating'
      );

    end;

    if Parent.ControlCount = 1 then begin

      if Parent.Controls[0] = InflatedControl then Exit;

      PreviousControl := Parent.Controls[0];

    end

    else PreviousControl := nil;

    InflateControl(InflationInfo);

    FreeAndNil(PreviousControl);

  end;

end;

{ TInflatedControl }

constructor TInflationInfo.Create(InflatedControl: TControl;
  Parent: TWinControl);
begin

  Create(
    InflatedControl,
    Parent,
    TInflationParentSize.Create(psParentOwnDimension, psParentOwnDimension),
    poParentAsOwner
  );

end;

constructor TInflationInfo.Create(
  InflatedControl: TControl;
  Parent: TWinControl;
  const ParentSize: TInflationParentSize;
  const ParentOwning: TInflationParentOwning
);
begin

  Self.InflatedControl := InflatedControl;
  Self.Parent := Parent;
  Self.ParentSize := ParentSize;
  Self.ParentOwning := ParentOwning;

end;

{ TInflationParentSize }

constructor TInflationParentSize.Create(const ParentWidth,
  ParentHeight: TInflationParentDimension);
begin

  Self.ParentWidth := ParentWidth;
  Self.ParentHeight := ParentHeight;

end;

end.
