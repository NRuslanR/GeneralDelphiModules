unit unSectionStackedForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, dxSkinsCore,
  dxSkinsDefaultPainters, ExtCtrls, cxInplaceContainer, cxTLData, cxDBTL,
  cxMaskEdit, DB, Hashes, StackedControlUnit,
  SectionRecordViewModel, SectionSetHolder, SectionStackedFormViewModel,
  VariantTypeUnit;

const

  WM_SECTION_CONTROL_REQUESTED_MESSAGE = WM_USER + 5111; { refactor: COMMON USER WND MESSAGES MODULE }
  
type

  TOnSectionControlRequestedEventHandler =
    procedure (
      Sender: TObject;
      SectionRecordViewModel: TSectionRecordViewModel;
      var Control: TControl;
      var Success: Boolean
    ) of object;
    
  TSectionStackedForm = class(TForm)
    SectionsTreeList: TcxDBTreeList;
    SectionListPanel: TPanel;
    Splitter1: TSplitter;
    SectionsDataSource: TDataSource;
    SectionIdColumn: TcxDBTreeListColumn;
    ParentSectionIdColumn: TcxDBTreeListColumn;
    SectionNameColumn: TcxDBTreeListColumn;
    SectionContentPanel: TScrollBox;
    procedure SectionsTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure SectionsTreeListCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);

  private

    FOnSectionControlRequestedEventHandler: TOnSectionControlRequestedEventHandler;

    procedure Initialize;
    
    procedure RaiseOnSectionControlRequestedEventHandler(const SectionId: Variant);

  private

    procedure SetActiveSectionContentControl(const SectionId: Variant);

    procedure QueueSectionControlRequestedMessage(const SectionId: Variant);

    procedure HandleSectionControlRequestedMessage(var Message: TMessage); message WM_SECTION_CONTROL_REQUESTED_MESSAGE;

  private

    FSectionContentStackedControl: TStackedControl;
    FViewModel: TSectionStackedFormViewModel;
    FSectionItemColor: TColor;
    FSectionItemTextColor: TColor;
    
    function CreateSectionContentStackedControl: TStackedControl;

    procedure SetSectionStackedFormViewModel(
      const Value: TSectionStackedFormViewModel
    );

    procedure FillControlsByViewModel(
      ViewModel: TSectionStackedFormViewModel
    ); virtual;

  protected

    procedure SetSectionListColumnLayoutBy(
      SectionSetFieldDefs: TSectionSetFieldDefs
    ); virtual;

  protected

    function GetSectionContentSplitterThickness: TColor;
    procedure SetSectionContentSplitterThickness(const Value: TColor);

    function GetSectionContentSplitterColor: TColor;
    procedure SetSectionContentSplitterColor(const Value: TColor);

  protected

    function SectionSetHolder: TSectionSetHolder;
    
  public

    destructor Destroy; override;
    
    constructor Create(AOwner: TComponent); override;

    procedure AddSection(
      SectionRecordViewModel: TSectionRecordViewModel;
      Control: TControl = nil
    ); virtual;

    procedure ChangeSection(
      SectionRecordViewModel: TSectionRecordViewModel;
      Control: TControl = nil
    ); virtual;

    procedure ChangeControlOfSection(
      const SectionId: Variant;
      Control: TControl
    ); virtual;

    procedure RemoveSection(const SectionId: Variant); virtual;

  published

    property ViewModel: TSectionStackedFormViewModel
    read FViewModel write SetSectionStackedFormViewModel;

  published

    property OnSectionControlRequestedEventHandler: TOnSectionControlRequestedEventHandler
    read FOnSectionControlRequestedEventHandler write FOnSectionControlRequestedEventHandler;

    property SectionItemColor: TColor
    read FSectionItemColor write FSectionItemColor;

    property SectionItemTextColor: TColor
    read FSectionItemTextColor write FSectionItemTextColor;

    property SectionContentSplitterColor: TColor
    read GetSectionContentSplitterColor write SetSectionContentSplitterColor;

    property SectionContentSplitterThickness: TColor
    read GetSectionContentSplitterThickness write SetSectionContentSplitterThickness;
    
  end;

implementation

uses

  AuxWindowsFunctionsUnit,
  AuxDebugFunctionsUnit;
  
{$R *.dfm}

procedure TSectionStackedForm.AddSection(
  SectionRecordViewModel: TSectionRecordViewModel;
  Control: TControl
);
begin

  FViewModel.AddSection(SectionRecordViewModel, Control);

  FSectionContentStackedControl.AddControl(Control);
  FSectionContentStackedControl.SetActiveControl(
    Control, csmUseStackedControlSize
  );
  
end;

procedure TSectionStackedForm.ChangeControlOfSection(const SectionId: Variant;
  Control: TControl);
var PreviousControl: TControl;
begin

  PreviousControl := FViewModel.Controls[SectionId];

  FViewModel.ChangeControlOfSection(SectionId, Control);

  if Assigned(PreviousControl) then
    FSectionContentStackedControl.RemoveControl(PreviousControl);

  if Assigned(Control) then begin

    FSectionContentStackedControl.AddControl(Control);

    if SectionSetHolder.SectionIdFieldValue = SectionId then begin

      FSectionContentStackedControl.SetActiveControl(
        Control, csmUseStackedControlSize
      );

    end;

  end;

end;

procedure TSectionStackedForm.ChangeSection(
  SectionRecordViewModel: TSectionRecordViewModel; Control: TControl);
begin

  ChangeControlOfSection(SectionRecordViewModel.Id, Control);

  FViewModel.ChangeSection(SectionRecordViewModel, Control);
  
end;

constructor TSectionStackedForm.Create(AOwner: TComponent);
begin

  inherited;

  Initialize;

end;

procedure TSectionStackedForm.Initialize;
begin

  FSectionContentStackedControl := CreateSectionContentStackedControl;
  FSectionItemColor := clDefault;

end;

function TSectionStackedForm.CreateSectionContentStackedControl: TStackedControl;
begin

  Result := TStackedControl.Create(SectionContentPanel);

  Result.Parent := SectionContentPanel;
  Result.Left := 0;
  Result.Top := SectionsTreeList.Top;
  Result.Width := SectionContentPanel.ClientWidth;
  Result.Height := SectionsTreeList.Height;
  Result.Anchors := [akLeft, akTop, akRight, akBottom];

  Result.Show;
  
end;

destructor TSectionStackedForm.Destroy;
begin

  FreeAndNil(FViewModel);
  
  inherited;

end;

procedure TSectionStackedForm.FillControlsByViewModel(
  ViewModel: TSectionStackedFormViewModel);
var SectionContentControl: TControl;
begin

  ViewModel.SectionSetHolder.First;

  while not ViewModel.SectionSetHolder.Eof do begin

    SectionContentControl :=
      ViewModel.Controls[ViewModel.SectionSetHolder.SectionIdFieldValue];

    if Assigned(SectionContentControl) then
      FSectionContentStackedControl.AddControl(SectionContentControl);
    
    ViewModel.SectionSetHolder.Next;

  end;

  ViewModel.SectionSetHolder.First;

  SectionsDataSource.DataSet := ViewModel.SectionSetHolder.DataSet;
  
end;

function TSectionStackedForm.GetSectionContentSplitterColor: TColor;
begin

  Result := Splitter1.Color;

end;

function TSectionStackedForm.GetSectionContentSplitterThickness: TColor;
begin

  if Splitter1.Align in [alLeft, alRight] then
    Result := Splitter1.Width

  else Result := Splitter1.Height;
  
end;

procedure TSectionStackedForm.HandleSectionControlRequestedMessage(
  var Message: TMessage
);
var
    SectionIdHolder: TVariant;
begin

  SectionIdHolder := TVariant(Message.LParam);

  try

    RaiseOnSectionControlRequestedEventHandler(SectionIdHolder.Value);
    
  finally

    FreeAndNil(SectionIdHolder);
    
  end;
  
end;

procedure TSectionStackedForm.QueueSectionControlRequestedMessage(
  const SectionId: Variant
);
begin

  PostMessage(
    Self.Handle,
    WM_SECTION_CONTROL_REQUESTED_MESSAGE,
    0,
    Integer(TVariant.Create(SectionId))
  );
  
end;

procedure TSectionStackedForm.RaiseOnSectionControlRequestedEventHandler(const SectionId: Variant);
var SectionRecordViewModel: TSectionRecordViewModel;
    Control: TControl;
    Success: Boolean;
begin

  if not Assigned(FOnSectionControlRequestedEventHandler) then
    Exit;

  SectionRecordViewModel := FViewModel.GetSectionRecordViewModel(SectionId);

  Control := nil;

  Success := True;

  Screen.Cursor := crHourGlass;

  try

    FOnSectionControlRequestedEventHandler(
      Self, SectionRecordViewModel, Control, Success
    );

    if Success then
      ChangeControlOfSection(SectionId, Control);

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TSectionStackedForm.RemoveSection(const SectionId: Variant);
var SectionContentControl: TControl;
begin

  SectionContentControl := FViewModel.Controls[SectionId];

  if Assigned(SectionContentControl) then
    FSectionContentStackedControl.RemoveControl(SectionContentControl);
    
  FViewModel.RemoveSection(SectionId);
  
end;

function TSectionStackedForm.SectionSetHolder: TSectionSetHolder;
begin

  if Assigned(FViewModel) then
    Result := FViewModel.SectionSetHolder

  else Result := nil;
  
end;

procedure TSectionStackedForm.SectionsTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin

  if AViewInfo.Node.Focused then begin

    ACanvas.FillRect(AViewInfo.BoundsRect, FSectionItemColor);
    ACanvas.Font.Color := FSectionItemTextColor;
    
  end;

end;

procedure TSectionStackedForm.SectionsTreeListFocusedNodeChanged(
  Sender: TcxCustomTreeList;
  APrevFocusedNode, AFocusedNode: TcxTreeListNode
);
begin

  if not Assigned(AFocusedNode) or (APrevFocusedNode = AFocusedNode) then Exit;
                                 
  if not FViewModel.IsControlAssignedForSection(SectionSetHolder.SectionIdFieldValue)
  then QueueSectionControlRequestedMessage(SectionSetHolder.SectionIdFieldValue)
  else SetActiveSectionContentControl(SectionSetHolder.SectionIdFieldValue);

end;

procedure TSectionStackedForm.SetActiveSectionContentControl(
  const SectionId: Variant);
var SectionContentControl: TControl;
begin

  SectionContentControl := FViewModel.Controls[SectionId];

  FSectionContentStackedControl.SetActiveControl(
    SectionContentControl, csmUseStackedControlSize
  );

end;

procedure TSectionStackedForm.SetSectionContentSplitterColor(
  const Value: TColor);
begin

  Splitter1.Color := Value;
  
end;

procedure TSectionStackedForm.SetSectionContentSplitterThickness(
  const Value: TColor);
begin

  if Splitter1.Align in [alLeft, alRight] then
    Splitter1.Width := Value

  else Splitter1.Height := Value;

end;

procedure TSectionStackedForm.SetSectionListColumnLayoutBy(
  SectionSetFieldDefs: TSectionSetFieldDefs);
begin

  SectionIdColumn.DataBinding.FieldName := SectionSetFieldDefs.SectionIdFieldName;
  ParentSectionIdColumn.DataBinding.FieldName := SectionSetFieldDefs.ParentIdSectionFieldName;
  SectionNameColumn.DataBinding.FieldName := SectionSetFieldDefs.SectionNameFieldName;

  SectionsTreeList.DataController.KeyField := SectionSetFieldDefs.SectionIdFieldName;
  SectionsTreeList.DataController.ParentField := SectionSetFieldDefs.ParentIdSectionFieldName;

end;

procedure TSectionStackedForm.SetSectionStackedFormViewModel(
  const Value: TSectionStackedFormViewModel);
begin

  if FViewModel = Value then
    Exit;

  FreeAndNil(FViewModel);
  
  FViewModel := Value;

  SetSectionListColumnLayoutBy(FViewModel.SectionSetHolder.FieldDefs);
  
  FillControlsByViewModel(FViewModel);
  
end;

end.
