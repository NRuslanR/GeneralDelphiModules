unit PDFViewFormUnit;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DebenuPDFLibrary1411, StdCtrls, ExtCtrls, ComCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit, cxMaskEdit, cxButtonEdit,
  ShlObj, dxDockControl, dxDockPanel, Buttons, StrUtils, XPMan,
  cxDropDownEdit,
  PDFDocumentRenderingThreadUnit, pngimage,
  PngImageList, ImgList, ActnList,
  StdActns, SyncObjs, Menus, cxButtons, IPDFDocumentProcessorUnit;

type

  TDocumentZoomDirection = (zdIncreasing, zdDecreasing);
  TPDFViewFormMode = (vmNormal, vmFullScreen);
  TDocumentRenderingThreadCancelingResult =
    (RenderingThreadSuccessfullyCanceled,
     RenderingThreadWasCanceledEarlier,
     RenderingThreadWasNotRunYet
    );
  TZoomFactorQuarterPart =
    (_25Percents, _50Percents, _75Percents, _100Percents);
    
const

  DEFAULT_FULL_SCREEN_VIEW_MODE_NAME = 'Полноэкранный режим';
  DEFAULT_NORMAL_VIEW_MODE_NAME = 'Обычный режим';
  DOCUMENT_ZOOM_FACTOR_INCREMENT = 0.05;
  DOCUMENT_MINIMUM_ZOOM_FACTOR = 0.01;
  DOCUMENT_MAXIMUM_ZOOM_FACTOR = 7.00;
  DEFAULT_DOCUMENT_ROTATION_INCREMENT = 90;
  OFFSET_TO_VIEW_MODE_BUTTON = 110;
  IMAGE_INDEX_OF_ENABLED_PREV_DOCUMENT_PAGE_TOOL = 1;
  IMAGE_INDEX_OF_DISABLED_PREV_DOCUMENT_PAGE_TOOL = 7;
  IMAGE_INDEX_OF_ENABLED_NEXT_DOCUMENT_PAGE_TOOL = 0;
  IMAGE_INDEX_OF_DISABLED_NEXT_DOCUMENT_PAGE_TOOL = 6;
  IMAGE_INDEX_OF_ENABLED_FIRST_DOCUMENT_PAGE_TOOL = 5;
  IMAGE_INDEX_OF_DISABLED_FIRST_DOCUMENT_PAGE_TOOL = 11;
  IMAGE_INDEX_OF_ENABLED_LAST_DOCUMENT_PAGE_TOOL = 4;
  IMAGE_INDEX_OF_DISABLED_LAST_DOCUMENT_PAGE_TOOL = 10;

type

  TPDFDocumentStorageMethod = (smSinglePagedStorage, smFullPagedStorage);
  TPDFDocumentRotationType = (rtClockwise, rtCounterClockwise);

  TPDFViewForm = class(TForm)
    ScrollBox1: TScrollBox;
    imgDocument: TImage;
    cxmskdtPageNumDocument: TcxMaskEdit;
    lblDocumentCount: TLabel;
    cbbZoomDocument: TcxComboBox;
    DocumentManipulatingElementsPanel: TScrollBox;
    ActionList1: TActionList;
    actNextDocument: TAction;
    actPrevDocument: TAction;
    DecreaseDocumentScaleButton: TcxButton;
    IncreaseDocumentScaleButton: TcxButton;
    StatusBar: TStatusBar;
    ActivateViewModeButton: TcxButton;
    ImageList1: TImageList;
    btnNextDocument: TcxButton;
    btnPrevDocument: TcxButton;
    ShowLastDocumentPageButton: TcxButton;
    ShowFirstDocumentPageButton: TcxButton;
    ClockwiseRotateDocumentButton: TcxButton;
    CounterClockwiseRotateDocumentButton: TcxButton;
    actRotateClockwiseDocument: TAction;
    actRotateCounterClockwiseDocument: TAction;
    actShowFirstDocumentPage: TAction;
    actShowLastDocumentPage: TAction;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    actZoomAt25Percents: TAction;
    actZoomAt50Percents: TAction;
    actZoomAt75Percents: TAction;
    actZoomAt100Percents: TAction;
    OpenDocumentInAcrobatButton: TcxButton;
    actOpenDocumentInAcrobat: TAction;

    procedure actNextDocumentExecute(Sender: TObject);
    procedure actPrevDocumentExecute(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure imgDocumentMouseEnter(Sender: TObject);

    procedure cxmskdtPageNumDocumentKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IncreaseDocumentScaleButtonClick(Sender: TObject);
    procedure DecreaseDocumentScaleButtonClick(Sender: TObject);
    procedure ActivateViewModeButtonClick(Sender: TObject);
    procedure ScrollBox1MouseEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDocumentDblClick(Sender: TObject);
    procedure actRotateClockwiseDocumentExecute(Sender: TObject);
    procedure actRotateCounterClockwiseDocumentExecute(Sender: TObject);
    procedure actShowFirstDocumentPageExecute(Sender: TObject);
    procedure actShowLastDocumentPageExecute(Sender: TObject);
    procedure actZoomAt25PercentsExecute(Sender: TObject);
    procedure actZoomAt50PercentsExecute(Sender: TObject);
    procedure actZoomAt75PercentsExecute(Sender: TObject);
    procedure actZoomAt100PercentsExecute(Sender: TObject);
    procedure cbbZoomDocumentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actOpenDocumentInAcrobatExecute(Sender: TObject);

  protected
    { Private declarations }

    FPreviousParent: TWinControl;
    FCurrentViewMode: TPDFViewFormMode;
    FCurrentZoomFactor: Single;
    FCurrentRotationAngleDegree: Single;
    FRenderedPDFDocument: TRenderedPDFDocument;
    FIsRequestForCleanupExists: Boolean;
    FDocumentPathForNewShowingRequest: String;
    FPDFDocumentStorageMethod: TPDFDocumentStorageMethod;
    FDocumentRenderingThread: TPDFDocumentRenderingThread;

  protected

    procedure SetHorizontalScrollBarPosition(const Position: Integer);
    procedure SetVerticalScrollBarPosition(const Position: Integer);

  protected

    MaskReplace, FirstPage, OutPath: string;
    procedure RenderDocumentFromFile(const FilePath: string);
    function SelectFile(path : string; filter: string): Variant;
    procedure ShowNextPageOfPDFDocument;
    procedure ShowPreviousPageOfPDFDocument;
    procedure ShowGivenPageOfPDFDocument(PageBitmap: TBitmap);
    procedure ShowGivenPageOfPDFDocumentAndUpdateManipulatingUIElementsOfDocumentPageNavigating(
      PageBitmap: TBitmap
    );
    procedure ZoomDocumentContentAt(
      const QuarterPart: TZoomFactorQuarterPart
    );
    procedure ShowDocumentPageByNumber(const PageNumber: Integer);
    procedure UpdateCurrentDocumentPageNumberLabel(
      const PageNumber: Integer
    );
    procedure UpdateTotalDocumentPageCountLabel(const TotalPageCount: Integer);
    procedure UpdateManipulatingUIElementsOfDocumentPageNavigating;
    function GetCtrlState: Boolean;

    procedure Initialize(
      const ViewMode: TPDFViewFormMode;
      const Width: Integer = 0;
      const Height: Integer = 0
    );

    procedure OnPDFDocumentPageRenderFinishedEventHandle(
      Sender: TObject;
      const CurrentPageNumber: Integer;
      RenderedPageBitmap: TBitmap
    );
    procedure OnPDFDocumentRenderingFinishedEventHandle(
      Sender: TObject;
      RenderedPDFDocument: TRenderedPDFDocument
    );
    procedure OnPDFDocumentRenderingCanceledEventHandle(
      Sender: TObject
    );
    procedure OnPDFDocumentRenderingErrorOccurredEventHandle(
      Sender: TObject;
      Error: Exception
    );

    procedure ScaleDocument(const ZoomDirection: TDocumentZoomDirection);
    procedure UpdateDocumentOrientationAndSize;
    
    procedure SetActivatedDocumentManipulatingControls(const Activated: Boolean);

    procedure BeginBackgroundDocumentRenderingFromFile(
      const FilePath: String
    );
    procedure EndBackgroundDocumentRendering;

    procedure NotifyAboutDocumentRenderingStatus(
      const StatusMessage: String
    );

    procedure RunDocumentRenderingThreadForFile(
      const FilePath: String
    );

    procedure UpdateDocumentZoomButtonsActivity;

    procedure CustomizeLayoutFromViewMode(
      const ViewMode: TPDFViewFormMode
    );

    procedure MinimizeDocument;
    procedure MaximizeDocument;

    procedure SwitchViewMode;
    procedure ActivateViewModeAndUpdateUI(
      const ViewMode: TPDFViewFormMode
    );
    procedure ActivateFullScreenViewMode;
    procedure ActivateNormalViewMode;

    procedure SetViewModeButtonCaption(
      const Caption: String
    );

    procedure UpdateZoomFactorTextField;

    function GetSelectedZoomFactor: Single;

    function IsZoomDocumentMaximumNow: Boolean;
    function IsZoomDocumentMinimumNow: Boolean;
    function ValidateDocumentZoomFactor: Boolean;

    procedure GetSelectedZoomFactorAndUpdateDocumentOrientationAndSize;

    procedure TerminateDocumentRenderingThreadIfItRunning;
    function CancelDocumentRenderingThreadIfItRunning: TDocumentRenderingThreadCancelingResult;
    function IsNewDocumentShowingRequestExists: Boolean;
    function FinishCurrentDocumentRenderingIfItRunningAndQueueNewDocumentShowingRequest(
      const DocumentPath: String
    ): Boolean;

    function CleanupIfWasRequestedEarlier: Boolean;

    procedure RotateDocumentByGivenDegrees(
      const Degrees: Integer;
      const RotationType: TPDFDocumentRotationType
    );

    procedure AssignPDFDocumentPageBitmapToViewArea(
      PageBitmap: TBitmap
    );

    procedure ApplyAcceptableScaleFactorToDocument;

    procedure ClearPDFDocumentPageViewArea;
    
    function GetButtonsColor: TColor;
    procedure SetButtonsColor(const Value: TColor);
    
  public
    { Public declarations }

    destructor Destroy; override;

    constructor Create(Owner: TComponent); overload; override;

    constructor Create(
      Owner: TComponent;
      const FileName: String;
      const ViewMode: TPDFViewFormMode = vmNormal;
      const Width: Integer = 0;
      const Height: Integer = 0
    ); overload;

    property PDFDocumentStorageMethod: TPDFDocumentStorageMethod
    read FPDFDocumentStorageMethod write FPDFDocumentStorageMethod;
    
    procedure LoadAndShowDocument(const DocumentPath: String);

    function CurrentDocumentFilePath: String;
    
    procedure ClearDocument;

    function IsDocumentLoaded: Boolean;
    
    property ButtonsColor: TColor
    read GetButtonsColor write SetButtonsColor;

  end;

var
    PDFViewForm: TPDFViewForm;
    
implementation

uses

  AuxDebugFunctionsUnit,
  FoxitPDFDocumentProcessorUnit,
  PDFDocumentExceptionsUnit,
  AuxGraphicFunctions,
  Math, AuxSystemFunctionsUnit;

function TPDFViewForm.CleanupIfWasRequestedEarlier: Boolean;
begin

  if FIsRequestForCleanupExists then begin

    FIsRequestForCleanupExists := False;

    SetActivatedDocumentManipulatingControls(False);
    NotifyAboutDocumentRenderingStatus('');
    ClearPDFDocumentPageViewArea;
    FreeAndNil(FRenderedPDFDocument);

    Result := True;

  end

  else Result := False;

end;

procedure TPDFViewForm.ClearDocument;
begin

  FIsRequestForCleanupExists := True;
  
  if CancelDocumentRenderingThreadIfItRunning =
      RenderingThreadWasNotRunYet
      
  then CleanupIfWasRequestedEarlier;
  
end;

procedure TPDFViewForm.ClearPDFDocumentPageViewArea;
begin

  imgDocument.Picture.Assign(nil);
  
end;

constructor TPDFViewForm.Create(
  Owner: TComponent;
  const FileName: String;
  const ViewMode: TPDFViewFormMode;
  const Width, Height: Integer
);
begin

  inherited Create(Owner);

  Initialize(ViewMode, Width, Height);

  RenderDocumentFromFile(FileName);

end;

constructor TPDFViewForm.Create(Owner: TComponent);
begin

  inherited;

  Initialize(vmNormal);

end;

function TPDFViewForm.CurrentDocumentFilePath: String;
begin

  if Assigned(FRenderedPDFDocument) then
    Result := FRenderedPDFDocument.DocumentFilePath

  else Result := '';
  
end;

procedure TPDFViewForm.CustomizeLayoutFromViewMode(
  const ViewMode: TPDFViewFormMode);
begin

  ActivateViewModeAndUpdateUI(ViewMode);
  
end;

{$R *.dfm}

procedure TPDFViewForm.DecreaseDocumentScaleButtonClick(Sender: TObject);
begin

  ScaleDocument(zdDecreasing);
               
end;

destructor TPDFViewForm.Destroy;
begin

  TerminateDocumentRenderingThreadIfItRunning;
  FreeAndNil(FRenderedPDFDocument);
  inherited;

end;

function TPDFViewForm.FinishCurrentDocumentRenderingIfItRunningAndQueueNewDocumentShowingRequest(
  const DocumentPath: String): Boolean;
begin

  ClearPDFDocumentPageViewArea;

  if CancelDocumentRenderingThreadIfItRunning <>
        RenderingThreadWasNotRunYet
  then begin

      FDocumentPathForNewShowingRequest := DocumentPath;

      Result := True;

  end

  else Result := False;

end;

procedure TPDFViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Action := caFree;
  
end;

procedure TPDFViewForm.ScaleDocument(
  const ZoomDirection: TDocumentZoomDirection
);
begin

  if ZoomDirection = zdIncreasing then begin

    FCurrentZoomFactor := FCurrentZoomFactor + DOCUMENT_ZOOM_FACTOR_INCREMENT;

  end

  else begin

    FCurrentZoomFactor := FCurrentZoomFactor - DOCUMENT_ZOOM_FACTOR_INCREMENT;

  end;

  UpdateDocumentOrientationAndSize;

end;

procedure TPDFViewForm.ScrollBox1MouseEnter(Sender: TObject);
begin

  ScrollBox1.SetFocus;
  
end;

procedure TPDFViewForm.ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin

  ScrollBox1.SetFocus;

end;

procedure TPDFViewForm.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var ZoomDirection: TDocumentZoomDirection;
begin

  if not IsDocumentLoaded then  Exit;

  if WheelDelta > 0 then
    ZoomDirection := zdIncreasing

  else ZoomDirection := zdDecreasing;
  
  if GetCtrlState then
    ScaleDocument(ZoomDirection)

  else
    ScrollBox1.VertScrollBar.Position :=
            ScrollBox1.VertScrollBar.Position - WheelDelta;

  Handled := True;

end;

procedure TPDFViewForm.imgDocumentDblClick(Sender: TObject);
begin
  SwitchViewMode;
end;

procedure TPDFViewForm.imgDocumentMouseEnter(Sender: TObject);
begin
  ScrollBox1.SetFocus;
end;

procedure TPDFViewForm.IncreaseDocumentScaleButtonClick(Sender: TObject);
begin

  ScaleDocument(zdIncreasing);
  
end;

procedure TPDFViewForm.Initialize(const ViewMode: TPDFViewFormMode; const Width,
  Height: Integer);
begin

  CustomizeLayoutFromViewMode(ViewMode);

  if ViewMode = vmNormal then
    if Width > 0 then begin

      Self.Width := Width;
      Self.Height := Width;

    end;

  FCurrentViewMode := ViewMode;
  FPDFDocumentStorageMethod := smSinglePagedStorage;

end;

function TPDFViewForm.IsDocumentLoaded: Boolean;
begin

  Result := Assigned(FRenderedPDFDocument);

end;

function TPDFViewForm.IsNewDocumentShowingRequestExists: Boolean;
begin

  Result := FDocumentPathForNewShowingRequest <> '';
  
end;

procedure TPDFViewForm.MaximizeDocument;
begin

  cbbZoomDocument.ItemIndex := cbbZoomDocument.Properties.Items.Count - 1;

  GetSelectedZoomFactorAndUpdateDocumentOrientationAndSize;
  
end;

procedure TPDFViewForm.MinimizeDocument;
begin

  cbbZoomDocument.ItemIndex := 0;

  GetSelectedZoomFactorAndUpdateDocumentOrientationAndSize;

end;

procedure TPDFViewForm.NotifyAboutDocumentRenderingStatus(
  const StatusMessage: String);
begin

  StatusBar.Panels[0].Text := StatusMessage;

  StatusBar.Visible := StatusMessage <> '';

end;

procedure TPDFViewForm.RenderDocumentFromFile(const FilePath: string);
begin

  try

    BeginBackgroundDocumentRenderingFromFile(FilePath);

    DocumentManipulatingElementsPanel.Show;

  except

    on e: Exception do begin

      if e is TPDFDocumentLoadingFailedException then
        DocumentManipulatingElementsPanel.Hide;

      raise;

    end;

  end;

end;

// refactor
procedure TPDFViewForm.RotateDocumentByGivenDegrees(
  const Degrees: Integer;
  const RotationType: TPDFDocumentRotationType);
var RotationSign: Integer;
begin

  if RotationType = rtClockwise then
      RotationSign := 1

  else RotationSign := -1;

  FCurrentRotationAngleDegree :=
      FCurrentRotationAngleDegree +
        DEFAULT_DOCUMENT_ROTATION_INCREMENT * RotationSign;

  UpdateDocumentOrientationAndSize;

end;

procedure TPDFViewForm.BeginBackgroundDocumentRenderingFromFile(
  const FilePath: String
);
begin

  FreeAndNil(FRenderedPDFDocument);
  
  SetActivatedDocumentManipulatingControls(False);

  NotifyAboutDocumentRenderingStatus(
    'Выполняется загрузка документа...'
  );

  RunDocumentRenderingThreadForFile(FilePath)

end;

procedure TPDFViewForm.EndBackgroundDocumentRendering;
begin

  SetActivatedDocumentManipulatingControls(True);

  UpdateDocumentZoomButtonsActivity;

  NotifyAboutDocumentRenderingStatus('');

  MinimizeDocument;
  MaximizeDocument;
  
  UpdateManipulatingUIElementsOfDocumentPageNavigating;
  
end;

procedure TPDFViewForm.cbbZoomDocumentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key <> VK_RETURN then Exit;

  GetSelectedZoomFactorAndUpdateDocumentOrientationAndSize;
  
end;

function TPDFViewForm.SelectFile(path: string; filter: string): Variant;
var dlgOpen: TOpenDialog;
begin
  try
    dlgOpen := TOpenDialog.Create(Application);

    dlgOpen.Title := 'Выберите файл';
    dlgOpen.InitialDir := ExtractFileDir(path);
    dlgOpen.Filter := filter;

    if dlgOpen.Execute then
      Result := VarArrayOf([dlgOpen.FileName, dlgOpen.FilterIndex])
    else
      Result := VarArrayOf([Copy(path, 0, LastDelimiter('.', path) - 1), 2]);
  finally
    FreeAndNil(dlgOpen);
  end;
end;

procedure TPDFViewForm.SetActivatedDocumentManipulatingControls(
  const Activated: Boolean);
var I: Integer;
begin

  for I := 0 to DocumentManipulatingElementsPanel.ControlCount - 1 do begin

    DocumentManipulatingElementsPanel.Controls[I].Enabled := Activated;
    
  end;

end;

procedure TPDFViewForm.SetButtonsColor(const Value: TColor);
var I: Integer;
    Button: TcxButton;
    Control: TControl;
begin

  for I := 0 to DocumentManipulatingElementsPanel.ControlCount - 1 do
  begin

    Control := DocumentManipulatingElementsPanel.Controls[I];

    if not (Control is TcxButton) then
      Continue;

    Button := Control as TcxButton;

    Button.Colors.Default := Value;
    
  end;

end;

procedure TPDFViewForm.SetHorizontalScrollBarPosition(
  const Position: Integer
);
begin

  ScrollBox1.HorzScrollBar.Position := Position;

end;

procedure TPDFViewForm.SetVerticalScrollBarPosition(
  const Position: Integer
);
begin

  ScrollBox1.VertScrollBar.Position := Position;
  
end;

procedure TPDFViewForm.SetViewModeButtonCaption(const Caption: String);
var ButtonWidth: Integer;
begin

  ButtonWidth :=
    ActivateViewModeButton.Spacing * 2 +
     Canvas.TextWidth(Caption) +
    ActivateViewModeButton.Spacing * 2;

  if fsBold in ActivateViewModeButton.Font.Style then
    ButtonWidth := ButtonWidth + 20;
  
  ActivateViewModeButton.Caption := Caption;
  ActivateViewModeButton.Width := ButtonWidth;

  OpenDocumentInAcrobatButton.Left :=
    ActivateViewModeButton.Left + ActivateViewModeButton.Width + 5;
    
end;

procedure TPDFViewForm.SwitchViewMode;
begin

  if FCurrentViewMode = vmNormal then begin

    ActivateViewModeAndUpdateUI(vmFullScreen);

  end

  else begin

    ActivateViewModeAndUpdateUI(vmNormal);

  end;

end;

procedure TPDFViewForm.TerminateDocumentRenderingThreadIfItRunning;
begin

  if Assigned(FDocumentRenderingThread) then begin

    FDocumentRenderingThread.Terminate;
    FDocumentRenderingThread := nil;

  end;

end;

function TPDFViewForm.CancelDocumentRenderingThreadIfItRunning: TDocumentRenderingThreadCancelingResult;
begin

  if Assigned(FDocumentRenderingThread) then begin

    FDocumentRenderingThread.IsCancelled := True;

    Result := RenderingThreadSuccessfullyCanceled

  end

  else Result := RenderingThreadWasNotRunYet;

end;

procedure TPDFViewForm.UpdateCurrentDocumentPageNumberLabel(
  const PageNumber: Integer);
begin

  cxmskdtPageNumDocument.Text := IntToStr(PageNumber);

end;

procedure TPDFViewForm.UpdateDocumentOrientationAndSize;
begin

  ValidateDocumentZoomFactor;

  Screen.Cursor := crHourGlass;

  try

    FRenderedPDFDocument.ScaleFactor := FCurrentZoomFactor;
    FRenderedPDFDocument.RotationAngleDegree := FCurrentRotationAngleDegree;

    AssignPDFDocumentPageBitmapToViewArea(
      FRenderedPDFDocument.CurrentPageBitmap
    );                          

    UpdateDocumentZoomButtonsActivity;
    UpdateZoomFactorTextField;
    
  finally

    Screen.Cursor := crDefault;

  end;

end;

function TPDFViewForm.IsZoomDocumentMaximumNow: Boolean;
begin

  Result := FCurrentZoomFactor >= DOCUMENT_MAXIMUM_ZOOM_FACTOR;

end;

function TPDFViewForm.IsZoomDocumentMinimumNow: Boolean;
begin

  Result := FCurrentZoomFactor <= DOCUMENT_MINIMUM_ZOOM_FACTOR;

end;

procedure TPDFViewForm.LoadAndShowDocument(const DocumentPath: String);
begin

  if FinishCurrentDocumentRenderingIfItRunningAndQueueNewDocumentShowingRequest(
        DocumentPath
     )
  then Exit;

  RenderDocumentFromFile(DocumentPath);

  Show;
  
end;

procedure TPDFViewForm.UpdateDocumentZoomButtonsActivity;
begin

  IncreaseDocumentScaleButton.Enabled := not IsZoomDocumentMaximumNow;
  DecreaseDocumentScaleButton.Enabled := not IsZoomDocumentMinimumNow;

end;

procedure TPDFViewForm.UpdateManipulatingUIElementsOfDocumentPageNavigating;
begin

  cxmskdtPageNumDocument.Text := IntToStr(FRenderedPDFDocument.CurrentPageBitmapNumber);
  lblDocumentCount.Caption := '\' + IntToStr(FRenderedPDFDocument.PageCount);
  
  actPrevDocument.Enabled := FRenderedPDFDocument.IsPreviousPageExists;
  actNextDocument.Enabled := FRenderedPDFDocument.IsNextPageExists;

  actShowFirstDocumentPage.Enabled := actPrevDocument.Enabled;
  actShowLastDocumentPage.Enabled := actNextDocument.Enabled;

  btnPrevDocument.Enabled := actPrevDocument.Enabled;
  btnNextDocument.Enabled := actNextDocument.Enabled;

  ShowFirstDocumentPageButton.Enabled := actShowFirstDocumentPage.Enabled;
  ShowLastDocumentPageButton.Enabled := actShowLastDocumentPage.Enabled;
  
end;

procedure TPDFViewForm.UpdateTotalDocumentPageCountLabel(
  const TotalPageCount: Integer
);
begin

  lblDocumentCount.Caption := '\' + IntToStr(TotalPageCount);
  
end;

procedure TPDFViewForm.UpdateZoomFactorTextField;
var ZoomFactorString: String;
begin

  ZoomFactorString := FloatToStr(Round(FCurrentZoomFactor * 100)) + '%';

  cbbZoomDocument.Text := ZoomFactorString;
    
end;

function TPDFViewForm.ValidateDocumentZoomFactor: Boolean;
begin

  if (FCurrentZoomFactor < DOCUMENT_MINIMUM_ZOOM_FACTOR) or
      (FCurrentZoomFactor > DOCUMENT_MAXIMUM_ZOOM_FACTOR)
  then begin

    if FCurrentZoomFactor < DOCUMENT_MINIMUM_ZOOM_FACTOR then
      FCurrentZoomFactor := DOCUMENT_MINIMUM_ZOOM_FACTOR

    else FCurrentZoomFactor := DOCUMENT_MAXIMUM_ZOOM_FACTOR;


    Result := False;

  end

  else Result := True;

end;

procedure TPDFViewForm.ZoomDocumentContentAt(
  const QuarterPart: TZoomFactorQuarterPart);
begin

  case QuarterPart of

    _25Percents: cbbZoomDocument.ItemIndex := 0;
    _50Percents: cbbZoomDocument.ItemIndex := 1;
    _75Percents: cbbZoomDocument.ItemIndex := 2;
    _100Percents: cbbZoomDocument.ItemIndex := 3;

  end;

  GetSelectedZoomFactorAndUpdateDocumentOrientationAndSize;

end;

procedure TPDFViewForm.OnPDFDocumentPageRenderFinishedEventHandle(
  Sender: TObject;
  const CurrentPageNumber: Integer;
  RenderedPageBitmap: TBitmap
);
begin

  if (CurrentPageNumber = 1) and
     (FPDFDocumentStorageMethod = smFullPagedStorage)   
  then begin

    ShowGivenPageOfPDFDocument(RenderedPageBitmap);
    UpdateCurrentDocumentPageNumberLabel(CurrentPageNumber);

  end;

  UpdateTotalDocumentPageCountLabel(CurrentPageNumber);

end;

procedure TPDFViewForm.OnPDFDocumentRenderingCanceledEventHandle(
  Sender: TObject
);
begin

  FDocumentRenderingThread := nil;

  if CleanupIfWasRequestedEarlier then Exit;
  
  if IsNewDocumentShowingRequestExists then begin

    LoadAndShowDocument(FDocumentPathForNewShowingRequest);

    FDocumentPathForNewShowingRequest := '';
    
  end;

end;

procedure TPDFViewForm.OnPDFDocumentRenderingErrorOccurredEventHandle(
  Sender: TObject; Error: Exception);
begin

  FDocumentRenderingThread := nil;

  if CleanupIfWasRequestedEarlier then Exit;
  
  ClearPDFDocumentPageViewArea;

  NotifyAboutDocumentRenderingStatus(
    'Возникла ошибка:' + Error.Message
  );

end;

procedure TPDFViewForm.OnPDFDocumentRenderingFinishedEventHandle(
  Sender: TObject;
  RenderedPDFDocument: TRenderedPDFDocument
);
begin

  FDocumentRenderingThread := nil;

  if CleanupIfWasRequestedEarlier then begin

    FreeAndNil(RenderedPDFDocument);
    Exit;
    
  end;

  FRenderedPDFDocument := RenderedPDFDocument;

  EndBackgroundDocumentRendering;

end;

procedure TPDFViewForm.RunDocumentRenderingThreadForFile(
const FilePath: String
);
var OutputPDFDocumentView: TOutputPDFDocumentView;
begin

  if FPDFDocumentStorageMethod = smSinglePagedStorage then
    OutputPDFDocumentView := dvSinglePagedPDFDocument

  else OutputPDFDocumentView := dvFullPagedPDFDocument;

  FDocumentRenderingThread :=

    TPDFDocumentRenderingThread.Create(
      FilePath,
      TFoxitPDFDocumentProcessor.Create,
      OutputPDFDocumentView
    );

  with FDocumentRenderingThread do begin

    FreeOnTerminate := True;

    OnPDFDocumentPageRenderFinishedEventHandler :=
      OnPDFDocumentPageRenderFinishedEventHandle;

    OnPDFDocumentRenderingFinishedEventHandler :=
      OnPDFDocumentRenderingFinishedEventHandle;

    OnCancellationEventHandler :=
      OnPDFDocumentRenderingCanceledEventHandle;

    OnPDFDocumentRenderingErrorOccurredEventHandler :=
      OnPDFDocumentRenderingErrorOccurredEventHandle;

    Resume;

  end;

end;

procedure TPDFViewForm.ShowDocumentPageByNumber(const PageNumber: Integer);
begin

    Screen.Cursor := crHourGlass;

    FRenderedPDFDocument.CurrentPageBitmapNumber := PageNumber;

    ShowGivenPageOfPDFDocumentAndUpdateManipulatingUIElementsOfDocumentPageNavigating(FRenderedPDFDocument.CurrentPageBitmap);

    Screen.Cursor := crDefault;

end;

procedure TPDFViewForm.ShowGivenPageOfPDFDocument(PageBitmap: TBitmap);
begin

  AssignPDFDocumentPageBitmapToViewArea(PageBitmap);

end;

procedure TPDFViewForm.ShowGivenPageOfPDFDocumentAndUpdateManipulatingUIElementsOfDocumentPageNavigating(
  PageBitmap: TBitmap);
begin

  ShowGivenPageOfPDFDocument(PageBitmap);
  UpdateManipulatingUIElementsOfDocumentPageNavigating;
  
end;

procedure TPDFViewForm.ShowNextPageOfPDFDocument;
var NextPageBitmap: TBitmap;
begin

  Screen.Cursor := crHourGlass;

  ShowGivenPageOfPDFDocumentAndUpdateManipulatingUIElementsOfDocumentPageNavigating(
    FRenderedPDFDocument.GoToNextPageBitmap
  );

  Screen.Cursor := crDefault;

end;

procedure TPDFViewForm.ShowPreviousPageOfPDFDocument;
begin

  Screen.Cursor := crHourGlass;

  ShowGivenPageOfPDFDocumentAndUpdateManipulatingUIElementsOfDocumentPageNavigating(
    FRenderedPDFDocument.GoToPreviousPageBitmap
  );

  Screen.Cursor := crDefault;
  
end;

procedure TPDFViewForm.ActivateFullScreenViewMode;
begin

  FPreviousParent := Parent;

  Parent := nil;

  BorderStyle := bsNone;
  WindowState := wsMaximized;

  FCurrentViewMode := vmFullScreen;

end;

procedure TPDFViewForm.ActivateNormalViewMode;
begin

  Parent := FPreviousParent;

  WindowState := wsNormal;
  //BorderStyle := bsSizeable;
  
  FCurrentViewMode := vmNormal;
  
end;

procedure TPDFViewForm.actNextDocumentExecute(Sender: TObject);
begin

  ShowNextPageOfPDFDocument;

  DebugOutput(btnNextDocument.Width);

end;


procedure TPDFViewForm.actOpenDocumentInAcrobatExecute(Sender: TObject);
begin

  OpenDocument(FRenderedPDFDocument.DocumentFilePath);
  
end;

procedure TPDFViewForm.actPrevDocumentExecute(Sender: TObject);
begin

  ShowPreviousPageOfPDFDocument;

end;

procedure TPDFViewForm.actRotateClockwiseDocumentExecute(Sender: TObject);
begin

  DebugOutput(ClockwiseRotateDocumentButton.Width);
  
  RotateDocumentByGivenDegrees(
    DEFAULT_DOCUMENT_ROTATION_INCREMENT,
    rtClockwise
  );

end;

procedure TPDFViewForm.actRotateCounterClockwiseDocumentExecute(
  Sender: TObject);
begin

  RotateDocumentByGivenDegrees(
    DEFAULT_DOCUMENT_ROTATION_INCREMENT,
    rtCounterClockwise
  );
  
end;

procedure TPDFViewForm.actShowFirstDocumentPageExecute(Sender: TObject);
begin

  ShowDocumentPageByNumber(1);
  
end;

procedure TPDFViewForm.actShowLastDocumentPageExecute(Sender: TObject);
begin

  ShowDocumentPageByNumber(FRenderedPDFDocument.PageCount);
  
end;

procedure TPDFViewForm.actZoomAt100PercentsExecute(Sender: TObject);
begin

  ZoomDocumentContentAt(_100Percents);
  
end;

procedure TPDFViewForm.actZoomAt25PercentsExecute(Sender: TObject);
begin

  ZoomDocumentContentAt(_25Percents);
  
end;

procedure TPDFViewForm.actZoomAt50PercentsExecute(Sender: TObject);
begin

  ZoomDocumentContentAt(_50Percents);
  
end;

procedure TPDFViewForm.actZoomAt75PercentsExecute(Sender: TObject);
begin

  ZoomDocumentContentAt(_75Percents);
  
end;

procedure TPDFViewForm.ApplyAcceptableScaleFactorToDocument;
var AcceptableScaleFactorIndex: Integer;
    ScaleFactorStr: String;
    ScaleFactor: Single;
begin

  for AcceptableScaleFactorIndex :=
    cbbZoomDocument.Properties.Items.Count - 1 downto 0 do begin

    ScaleFactorStr :=
      cbbZoomDocument.Properties.Items[AcceptableScaleFactorIndex];
    ScaleFactor :=
      StrToFloat(Copy(ScaleFactorStr, 1, Length(ScaleFactorStr) - 1)) * 0.01;

    if FRenderedPDFDocument.CurrentPageBitmap.Width * ScaleFactor <=
      ScrollBox1.Width then Break;
    
  end;

  cbbZoomDocument.ItemIndex := Max(AcceptableScaleFactorIndex, 0);
  
  GetSelectedZoomFactorAndUpdateDocumentOrientationAndSize;

end;

procedure TPDFViewForm.AssignPDFDocumentPageBitmapToViewArea(
  PageBitmap: TBitmap);
begin

  if not Assigned(PageBitmap) then Exit;

  imgDocument.AutoSize := False;
  imgDocument.Width := PageBitmap.Width;
  imgDocument.Height := PageBitmap.Height;
  imgDocument.Picture.Assign(PageBitmap);
  
end;

function TPDFViewForm.GetButtonsColor: TColor;
begin

  Result := ActivateViewModeButton.Colors.Default;
  
end;

function TPDFViewForm.GetCtrlState: Boolean;
var State: TKeyboardState;
begin

  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);

end;

function TPDFViewForm.GetSelectedZoomFactor: Single;
var SelectedZoomFactorString: String;
begin

  SelectedZoomFactorString :=
      cbbZoomDocument.Text;

  SelectedZoomFactorString :=
    Copy(SelectedZoomFactorString, 1, Length(SelectedZoomFactorString) - 1);

  Result := StrToFloat(SelectedZoomFactorString) * 0.01;

end;

procedure TPDFViewForm.GetSelectedZoomFactorAndUpdateDocumentOrientationAndSize;
begin

  FCurrentZoomFactor := GetSelectedZoomFactor;

  UpdateDocumentOrientationAndSize;
  
end;

procedure TPDFViewForm.ActivateViewModeAndUpdateUI(
  const ViewMode: TPDFViewFormMode
);
begin

  if ViewMode = vmNormal then begin

    ActivateNormalViewMode;

    SetViewModeButtonCaption(DEFAULT_FULL_SCREEN_VIEW_MODE_NAME);

  end

  else begin

    ActivateFullScreenViewMode;

    SetViewModeButtonCaption(DEFAULT_NORMAL_VIEW_MODE_NAME);
    
  end;

end;

procedure TPDFViewForm.ActivateViewModeButtonClick(Sender: TObject);
begin

  SwitchViewMode;

end;

procedure TPDFViewForm.cxmskdtPageNumDocumentKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var InputPageNumber: Integer;
begin

  if Key <> VK_RETURN then Exit;

  InputPageNumber := StrToInt(cxmskdtPageNumDocument.Text);

  if not FRenderedPDFDocument.IsPageBitmapNumberValid(InputPageNumber) then
  begin

    if FRenderedPDFDocument.PageCount < InputPageNumber then
      InputPageNumber := FRenderedPDFDocument.PageCount

    else InputPageNumber := 1;

    cxmskdtPageNumDocument.Text := IntToStr(InputPageNumber);

    Exit;
    
  end;
  
  ShowDocumentPageByNumber(StrToInt(cxmskdtPageNumDocument.Text));

end;

end.
