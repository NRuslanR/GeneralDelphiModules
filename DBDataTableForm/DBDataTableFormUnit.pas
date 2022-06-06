unit DBDataTableFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ImgList, PngImageList, ActnList, StdCtrls,
  ExtCtrls, DBCtrls, dxCore, cxGridStrs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, pngimage, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, Menus,
  ZAbstractDataset, DataSetOperationThreadUnit, cxButtons, TableViewFilterFormUnit,
  ZIBEventAlerter, ZSequence, ZSqlMonitor, ZSqlProcessor, ZSqlMetadata,
  ZStoredProcedure, ZSqlUpdate, ZAbstractTable, ZDataset,
  ZAbstractRODataset, ZConnection, cxExport, cxExportPivotGridLink,
  cxGridExportLink, Clipbrd, StrUtils, DeletableOnCloseFormUnit, Math,
  StackedControlUnit, VariantListUnit, cxLocalization, dxSkinscxPCPainter,
  CancellationThreadUnit, cxCheckBox, Hashes, cxNavigator;

const


  DEFAULT_INDEX_FIELD_NAME = 'id';
  DEFAULT_SELECTED_RECORD_COLOR = $007dc68c;
  DEFAULT_FOCUSED_CELL_COLOR = clSkyBlue;
  TOTAL_RECORD_PANEL_INDEX = 0;
  USER_NAME_PANEL_INDEX = 1;
  DATABASE_NAME_PANEL_INDEX = 2;
  PANEL_CONTENT_MARGIN_RIGHT = 125;
  NO_SELECTED_SEARCH_COLUMN_CAPTION = 'выберите столбец';
  DEFAULT_DATA_LOADING_CAPTION = 'Пожалуйста подождите, идёт загрузка данных...';
  DEFAULT_DATA_LOADING_CANCELLED_CAPTION = 'Загрузка данных была отменена';

  SEARCH_BY_COLUMN_PANEL_PADDING_TOP = 5;
  SEARCH_BY_COLUMN_PANEL_PADDING_LEFT = 17;
  SEARCH_BY_COLUMN_PANEL_PADDING_RIGHT = 17;
  HORIZONTAL_OFFSET_BETWEEN_SEARCH_BY_ENTER_BUTTON_AND_SEARCH_COLUMN_VALUE_EDIT = 20;
  HORIZONTAL_OFFSET_BETWEEN_SEARCH_BY_ENTER_BUTTON_AND_PREVIOUS_RECORD_SEARCH_BUTTON = 10;
  HORIZONTAL_OFFSET_BETWEEN_PREVIOUS_AND_NEXT_RECORD_SEARCH_BUTTONS = 7;
  HORIZONTAL_OFFSET_BETWEEN_NEXT_RECORD_SEARCH_BUTTON_AND_CHOOSE_COLUMN_LABEL = 15;
  HORIZONTAL_OFFSET_BETWEEN_CHOOSE_COLUMN_LABEL_AND_COLUMN_NAME_LABEL = 5;
  HORIZONTAL_OFFSET_BETWEEN_SEARCH_COLUMN_NAME_AND_SEARCH_COLUMN_VALUE_EDIT = 10;
  
type

  TDBDataTableSearchRecordOption = (sroCaseInsensitive, sroPartialComparison);
  TShowWaitOrCancellationControls = (ShowWaitControls, ShowCancellationControls);
  TSearchNextFoundOccurrenceDirection = (sdForward, sdBackward);
  TDataRecordMovingDirection = (mdFirst, mdPrior, mdNext, mdLast);

  TExportDBTableDataFormat = class

  end;

  TExportDBTableDataFormatClass = class of TExportDBTableDataFormat;

  TXLSExportDBTableDataFormat = class (TExportDBTableDataFormat)

  end;

  TXMLExportDBTableDataFormat = class (TExportDBTableDataFormat)

  end;

  THTMLExportDBTableDataFormat = class (TExportDBTableDataFormat)

  end;


  TDBDataTableSearchRecordOptions = set of  TDBDataTableSearchRecordOption;


  TDBDataTableRecordField = class

    protected

      FName: String;
      FValue: Variant;

    public

      destructor Destroy; override;

      constructor Create(const AName: String; const AValue: Variant);

      property Name: String read FName;
      property Value: Variant read FValue;

  end;

  TDBDataTableRecordFields = class;

  TDBDataTableRecordFieldsEnumerator = class (TListEnumerator)

    protected

      function GetCurrentDBDataTableRecordField: TDBDataTableRecordField;

      constructor Create(Fields: TDBDataTableRecordFields);

    public

      property Current: TDBDataTableRecordField read GetCurrentDBDataTableRecordField;

  end;

  TDBDataTableRecordFields = class (TList)

    protected

      type TFieldHandler = procedure (
                              Field: TDBDataTableRecordField;
                              const Index: Integer;
                              var ArbitraryData: Variant
                           ) of object;

      function GetDBDataTableRecordFieldByIndex(Index: Integer): TDBDataTableRecordField;
      function GetDBDataTableRecordFieldByName(Name: String): TDBDataTableRecordField;

      function AddField(Field: TDBDataTableRecordField): Integer; overload;
      function AddField(const Name: WideString; const Value: Variant): Integer; overload;

      procedure DeleteByName(const Name: String);

      procedure FindAndHandleField(
        const FieldName: String;
        FieldHandler: TFieldHandler;
        var ArbitraryData: Variant
      );

      procedure DeleteByNameFieldHandler(
        Field: TDBDataTableRecordField;
        const Index: Integer;
        var ArbitraryData: Variant
      );

      procedure GetFieldByNameFieldHandler(
        Field: TDBDataTableRecordField;
        const Index: Integer;
        var ArbitraryData: Variant
      );

      procedure FreeFields;

    public

      destructor Destroy; override;

      procedure Clear; override;
      function GetEnumerator: TDBDataTableRecordFieldsEnumerator;

      property Items[Index: Integer]: TDBDataTableRecordField read GetDBDataTableRecordFieldByIndex; default;
      property Items[Name: String]: TDBDataTableRecordField read GetDBDataTableRecordFieldByName; default;

  end;

  TDBDataTableRecord = class

    protected

      FFields: TDBDataTableRecordFields;

      function GetFieldCount: Integer;
      function GetFieldValueByIndex(Index: Integer): Variant;
      function GetFieldValueByName(Name: String): Variant;

      function AddField(Field: TDBDataTableRecordField): Integer; overload;
      function AddField(const Name: WideString; const Value: Variant): Integer; overload;

      procedure DeleteField(Index: Integer); overload;
      procedure DeleteField(const Name: String); overload;

    public

      destructor Destroy; override;

      constructor Create;

      function GetFieldByIndex(const Index: Integer): TDBDataTableRecordField;

      property FieldCount: Integer read GetFieldCount;
      property FieldValues[Index: Integer]: Variant read GetFieldValueByIndex; default;
      property FieldValues[Name: String]: Variant read GetFieldValueByName; default;
      property Fields: TDBDataTableRecordFields read FFields;

  end;

  TDBDataTableRecordClass = class of TDBDataTableRecord;
  
  TDBDataTableRecords = class;

  TDBDataTableRecordsEnumerator = class (TListEnumerator)

    protected

      FDBDataTableRecords: TDBDataTableRecords;

      function GetCurrentDBDataTableRecord: TDBDataTableRecord;

      constructor Create(DBDataTableRecords: TDBDataTableRecords);

    public

      property Current: TDBDataTableRecord read GetCurrentDBDataTableRecord;

  end;

  TDBDataTableRecords = class (TList)

    protected

      function GetDBDataTableRecordByIndex(Index: Integer): TDBDataTableRecord;

      function AddRecord(DBDataTableRecord: TDBDataTableRecord): Integer;

      procedure FreeRecords;

    public

      destructor Destroy; override;

      function GetEnumerator: TDBDataTableRecordsEnumerator;

      function FetchFieldValues(const FieldName: String): TVariantList;
      
      procedure Clear; override;

      property Items[Index: Integer]: TDBDataTableRecord
      read GetDBDataTableRecordByIndex; default;

  end;

  TDBDataTableRecordsClass = class of TDBDataTableRecords;

  TOnRecordsChoosedEventHandler =
    procedure (
      Sender: TObject;
      SelectedRecords: TDBDataTableRecords
    ) of object;

  TOnRecordsRefreshedEventHandler =
    procedure (Sender: TObject) of object;

  TDataSetOperationCancellationForDestroyingResult =
    (ocNotRequired, ocAlreadyRequested, ocSuccessed);

  TDBDataTableForm = class(TDeletableOnCloseForm)
    imgLstDisabled: TPngImageList;
    imgLstEnabled: TPngImageList;
    DataOperationToolBar: TToolBar;
    AddDataToolButton: TToolButton;
    DataOperationActionList: TActionList;
    actAddData: TAction;
    actChangeData: TAction;
    actDeleteData: TAction;
    actRefreshData: TAction;
    ChangeDataToolButton: TToolButton;
    DeleteDataToolButton: TToolButton;
    RefreshDataToolButton: TToolButton;
    SelectFilterDataToolButton: TToolButton;
    actSelectFilteredData: TAction;
    actExportData: TAction;
    actPrintData: TAction;
    SelectFilteredRecordsSeparator: TToolButton;
    PrintDataToolButton: TToolButton;
    ExportDataToolButton: TToolButton;
    ExportDataSeparator: TToolButton;
    ExitToolButton: TToolButton;
    actExit: TAction;
    StatisticsInfoStatusBar: TStatusBar;
    SearchByColumnPanel: TScrollBox;
    SearchByENTERCheckBox: TCheckBox;
    Label1: TLabel;
    DataRecordGridTableView: TcxGridDBTableView;
    DataRecordGridLevel: TcxGridLevel;
    DataRecordGrid: TcxGrid;
    AnimDataLoading: TAnimate;
    DataLoadingLabel: TLabel;
    imgDataOperationCanceled: TImage;
    WaitDataLoadingPanel: TPanel;
    DataLoadingCanceledPanel: TPanel;
    DataLoadingCanceledLabel: TLabel;
    DataRecordMovingToolBar: TToolBar;
    actPrevDataRecord: TAction;
    actFirstDataRecord: TAction;
    actLastDataRecord: TAction;
    actNextDataRecord: TAction;
    FirstDataRecordToolButton: TToolButton;
    LastDataRecordToolButton: TToolButton;
    PrevDataRecordToolButton: TToolButton;
    NextDataRecordToolButton: TToolButton;
    DataOperationPopupMenu: TPopupMenu;
    AddDataRecordMenuItem: TMenuItem;
    ChangeDataRecordMenuItem: TMenuItem;
    DeleteDataRecordMenuItem: TMenuItem;
    N4: TMenuItem;
    SelectFilteredDataMenuItem: TMenuItem;
    N6: TMenuItem;
    PrintDataMenuItem: TMenuItem;
    ExportDataMenuItem: TMenuItem;
    N1: TMenuItem;
    ExitMenuItem: TMenuItem;
    RefreshDataRecordsMenuItem: TMenuItem;
    FirstDataRecordMenuItem: TMenuItem;
    LastDataRecordMenuItem: TMenuItem;
    N2: TMenuItem;
    actCopySelectedDataRecords: TAction;
    CopySelectedDataRecordsToolButton: TToolButton;
    actCopySelectedDataRecordCell: TAction;
    CopySelectedDataRecordCellMenuItem: TMenuItem;
    N3: TMenuItem;
    CopySelectedDataRecordsMenuItem: TMenuItem;
    TargetDataSource: TDataSource;
    ClientAreaPanel: TPanel;
    btnCancelDataOperation: TcxButton;
    SearchColumnNameLabel: TLabel;
    ExportDataPopupMenu: TPopupMenu;
    actExportDataToXLS: TAction;
    actExportDataToXML: TAction;
    ExcelXLSMenuItem: TMenuItem;
    XMLMenuItem: TMenuItem;
    ExportDataDialog: TSaveDialog;
    actExportDataToHTML: TAction;
    ChooseRecordsToolButton: TToolButton;
    actChooseRecords: TAction;
    ChooseRecordsSeparator: TToolButton;
    ReserveToolButton1: TToolButton;
    ReserveToolButton2: TToolButton;
    actNextFoundOccurrence: TAction;
    actPrevFoundOccurrence: TAction;
    SearchColumnValueEdit: TEdit;
    btnPrevFoundOccurrence: TcxButton;
    btnNextFoundOccurrence: TcxButton;
    Localizer: TcxLocalizer;
    IsSelectedColumn: TcxGridDBColumn;
    procedure actAddDataExecute(Sender: TObject);
    procedure actChangeDataExecute(Sender: TObject);
    procedure actDeleteDataExecute(Sender: TObject);
    procedure actRefreshDataExecute(Sender: TObject);
    procedure actSelectFilteredDataExecute(Sender: TObject);
    procedure actExportDataExecute(Sender: TObject);
    procedure actPrintDataExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actCopySelectedDataRecordsExecute(Sender: TObject);
    procedure actCopySelectedDataRecordCellExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelDataOperationClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataRecordGridTableViewCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure SearchColumnValueEditChange(Sender: TObject);
    procedure SearchColumnValueEditKeyPress(Sender: TObject; var Key: Char);
    procedure actPrevDataRecordExecute(Sender: TObject);
    procedure actFirstDataRecordExecute(Sender: TObject);
    procedure actLastDataRecordExecute(Sender: TObject);
    procedure actNextDataRecordExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actExportDataToXLSExecute(Sender: TObject);
    procedure actExportDataToXMLExecute(Sender: TObject);
    procedure actExportDataToHTMLExecute(Sender: TObject);
    procedure actChooseRecordsExecute(Sender: TObject);
    procedure DataRecordGridTableViewSelectionChanged(
      Sender: TcxCustomGridTableView);
    procedure DataRecordGridTableViewCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure actPrevFoundOccurrenceExecute(Sender: TObject);
    procedure actNextFoundOccurrenceExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DataRecordGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure DataOperationToolBarAdvancedCustomDrawButton(Sender: TToolBar;
      Button: TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage;
      var Flags: TTBCustomDrawFlags; var DefaultDraw: Boolean);
    procedure DataRecordGridTableViewFocusedItemChanged(
      Sender: TcxCustomGridTableView; APrevFocusedItem,
      AFocusedItem: TcxCustomGridTableItem);
    procedure IsSelectedColumnPropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  strict protected

    type

      TDBDataTableFormDataOperation = (opAddRecord, opChangeRecord, opDeleteRecords, opRefreshRecords);
      TStatisticsStatusPanel = (spTotalRecordCountPanel, spDatabaseNamePanel, spUserLoginPanel );

  strict private

    function GetFocusedField: TDBDataTableRecordField;

  private

    function GetFont: TFont; virtual;
    procedure SetFont(const Value: TFont); virtual;

    function GetEnableSelectionColumn: Boolean;
    procedure SetEnableSelectionColumn(const Value: Boolean);
    function GetFocusedRecordId: Variant;
    procedure SetFocusedRecordId(const Value: Variant);
  
  protected

    FViewOnly: Boolean;
    FIsFilterFormLastStateApplyingRequested: Boolean;
    FIsDestroyingRequested: Boolean;
    FLastFocusedRecordKeyValue: Variant;
    FFieldNameOfRequestedColumnForFocus: String;
    FRequestedFocusedRecordKeyValue: Variant;
    FSelectedByColumnRecordIndices: TIntegerHash;
    
    FMustAddRecordToolEnabled: Boolean;
    // Отображается ли форма в первый раз, чтобы
    // не допускать постоянной загрузки данных во
    // врёмя её отображения
    FIsFirstShowing: Boolean;
    FLastOperation: TDBDataTableFormDataOperation;

    // Список выбранных пользователем записей
    // по кнопке "Выбрать"
    FSelectedRecords: TDBDataTableRecords;

    FMovingToAddedRecordAfterAddingEnabled: Boolean;
    FRefreshingAfterDataModificationEnabled: Boolean;

    // Должны ли данные загружаться сразу же
    // после первоначального отображения формы
    FLoadingDataOnFirstShowEnabled: Boolean;

    // Ссылка на поток, который в данный момент
    // выполняет загрузку данных
    FDataSetOperationThread: TDataSetOperationThread;

    FLastSelectedRecordIndexFieldNames: TStringList;
    FLastSelectedRecordIndexFieldValues: TVariantList;
    
    FTableViewFilterForm: TTableViewFilterForm;
    FTableViewFilterFormLastState: TTableViewFilterFormState;
    FMustSaveFilterFormStateBeforeClosing: Boolean;

    FSelectedRecordsColor: TColor;
    FFocusedCellColor: TColor;
    FFocusedCellTextColor: TColor;
    FSelectedRecordsTextColor: TColor;

    FOnRecordsChoosedEventHandler: TOnRecordsChoosedEventHandler;
    FOnRecordsRefreshedEventHandler: TOnRecordsRefreshedEventHandler;

    FDataSetOperationCancellationForDestroyingRequested: Boolean;

    FPreviousDataSetAfterInsert: TDataSetNotifyEvent;
    FPreviousDataSetAfterDelete: TDataSetNotifyEvent;
    FPreviousDataSetAfterPost: TDataSetNotifyEvent;

    function AttachDataSet(ADataSet: TDataSet): TDataSet;

    procedure Init(
      const Caption: String = ''; ADataSet:
      TDataSet = nil
    ); virtual;

    function GetViewOnly: Boolean;
    procedure SetViewOnly(const Value: Boolean); virtual;

    function FreeIfDestroyingRequested: Boolean;

    procedure SetEnabledEditingOptionToGridColumns(Value: Boolean);
    procedure SetEnabledToActionToolsForViewOnly;

    procedure SetEnabledToActionTools(
      Value: Boolean;
      ExceptionalActionTools: array of TAction
    );

    procedure SetEnabledToGrid(Value: Boolean);
    procedure SetEnabledToSearchByColumnPanel(Value: Boolean);

    procedure SaveCurrentSelectedRecordLocation;
    procedure RestorePreviousCurrentSelectedRecordLocation;
    procedure RestorePreviousChangingRecordLocation;

    function CreateAndFillSelectedRecords: TDBDataTableRecords;
    procedure SetRecordSelectedBySelectionColumn(RecordIndex: Integer; const Selected: Boolean);
    procedure SetSelectedRecordsByIds(RecordIds: TVariantList; const Selected: Boolean);

    procedure OnChooseRecords; virtual;
    function OnAddRecord: Boolean; virtual;
    procedure OnCopySelectedDataRecords; virtual;
    function OnChangeRecord: Boolean; virtual;
    function OnDeleteRecords: Integer; virtual;
    function OnDeleteCurrentRecord: Boolean; virtual;
    procedure OnRefreshRecords; virtual;
    procedure OnSelectFilteredDataRecords; virtual;
    procedure OnPrintData; virtual;
    procedure OnDataExport; virtual;
    procedure OnExit; virtual;
    procedure MoveToAddedRecord; virtual;
    procedure MoveToAddedRecordAfterAdding;

    procedure RefreshRecordsInBackground;

    procedure RememberRecordKeyValue(GridRecord: TcxCustomGridRecord);

    function CreateTableRecordViewModelFor(
      const RowIndex: Integer
    ): TDBDataTableRecord;

    function CreateFocusedFieldViewModelFrom(
      Column: TcxGridDBColumn
    ): TDBDataTableRecordField;

    function CreateTableRecordViewModelForCurrentRow: TDBDataTableRecord;
    
    { Deperecated: delete }
    
    procedure HandleSelectedRow(
      RowIndex: Integer;
      RowInfo: TcxRowInfo
    );

    function GetMessageAboutThatUserAssuredThatWantDeleteSelectedRecords: String; virtual;

  public

    class function GetTableViewFilterFormClass: TTableViewFilterFormClass; virtual;

    class function GetDBDataTableRecordClass: TDBDataTableRecordClass; virtual;
    function CreateDBDataTableRecord: TDBDataTableRecord; virtual;

    class function GetDBDataTableRecordsClass: TDBDataTableRecordsClass; virtual;
    function CreateDBDataTableRecords: TDBDataTableRecords; virtual;

  protected
  
    function GetUserLoginPanelLabel: String; virtual;
    function GetDatabaseNamePanelLabel: String; virtual;
    function GetTotalRecordCountPanelLabel: String; virtual;

    // Handling methods for StatusBar panels
    procedure OnUpdateTotalRecordCountPanel(const TotalRecordCount: Integer); virtual;
    procedure OnUpdateUserPanel(const UserName: String); virtual;
    procedure OnUpdateDatabaseNamePanel(const DatabaseName: String); virtual;

    procedure UpdateChooseRecordsAction;

    procedure CopySelectedDataRecordCell;

    // data set functions
    function GetMovingToAddedRecordAfterAddingEnabled: Boolean;
    procedure SetMovingToAddedRecordAfterAddingEnabled(
      const Enabled: Boolean
    );

    function HasDataSetRecords: Boolean;
    function IsDataSetActive: Boolean;

    procedure SavePreviousDataSetEventHandlers(ADataSet: TDataSet);
    procedure RestorePreviousDataSetEventHandlers(ADataSet: TDataSet);

    procedure SetDataSet(const ADataSet: TDataSet);
    function GetDataSet: TDataSet;
    procedure MoveToDataRecord(const MovingDirection: TDataRecordMovingDirection);
    procedure MoveToDataSetRecord(const MovingDirection: TDataRecordMovingDirection);
    procedure UpdateMovingDataRecordActionsActivity;
    function GetConnection: TZConnection;
    procedure SetConnection(const Connection: TZConnection);

    // table view functions
    procedure BeginUpdateGridTableView;
    procedure EndUpdateGridTableView;

    procedure HideStatisticsStatusPanel(const StatisticsStatusPanel: TStatisticsStatusPanel);
    procedure ShowStatisticsStatusPanel(const StatisticsStatusPanel: TStatisticsStatusPanel);
    procedure DeleteStatusPanelByLabel(const StatusPanelLabel: String);

    procedure SetActivatedDataOperationControls(const Activated: Boolean); virtual;
    procedure UpdateMainUI; virtual;
    procedure UpdateStatusBar; virtual;
    procedure UpdateTotalRecordCountPanel; virtual;
    procedure UpdateUserPanel; virtual;
    procedure UpdateDatabaseNamePanel; virtual;
    procedure UpdateModificationDataActions; virtual;
    procedure UpdateDataOperationControls; virtual;
    procedure UpdateStatusBarPanelWidth(const PanelIndex: Integer);

    function GetDataLoadingCaption: String;
    function GetDataLoadingCancelledCaption: String;
    procedure SetDataLoadingCaption(const ADataLoadingCaption: string);
    procedure SetDataLoadingCancelledCaption(const ADataLoadingCancelledCaption: string);

    // For background open DataSet
    procedure OpenDataSetInBackground(ADataSet: TDataSet);

    procedure UpdateUIAfterSuccessDataLoading;
    procedure UpdateUIAfterFailedDataLoading(const ErrorMessage: String = '');

    // DataSet operation thead functions
    procedure DestroyDataSetOperationThread;

    procedure OnDataSetInsertedRecord(DataSet: TDataSet);
    procedure OnDataSetDeletedRecord(DataSet: TDataSet);

    procedure OnDataLoadingSuccessHandle(Sender: TObject; DataSet: TDataSet; RelatedState: TObject); overload;
    procedure OnDataLoadingCancelledHandle(Sender: TObject); overload;
    procedure OnDataLoadingErrorOccurredHandle(Sender: TObject; DataSet: TDataSet; const Error: Exception; RelatedState: TObject); overload;

    procedure OnDataLoadingSuccessHandle(Sender: TObject; DataSet: TDataSet; RelatedState: TObject; const IsDestroyingRequested: Boolean); overload; virtual;
    procedure OnDataLoadingCancelledHandle(Sender: TObject; const IsDestroyingRequested: Boolean); overload; virtual;
    procedure OnDataLoadingErrorOccurredHandle(Sender: TObject; DataSet: TDataSet; const Error: Exception; RelatedState: TObject; const IsDestroyingRequested: Boolean); overload; virtual;

    procedure ShowDataLoadingWaitOrCancellationControls(const ShowWaitOrCancellationControls: TShowWaitOrCancellationControls);
    procedure ShowWaitingDataLoadingPanel(const Show: Boolean);
    procedure ShowDataLoadingCanceledPanel(const Show: Boolean);

    procedure CancelDBDataLoadingOperation;
    procedure InitAnimateProcessControl;

    procedure LocateRecordBySelectedColumnValue;
    procedure HandleClickOnTableViewColumnCell(const CellViewInfo: TcxGridTableDataCellViewInfo);

    // TableViewFilterForm
    procedure ShowTableViewFilterForm; virtual;
    procedure CustomizeTableViewFilterForm(ATableViewFilterForm: TTableViewFilterForm); virtual;
    procedure CloseTableViewFilterForm;
    procedure OnCloseTableViewFilterFormHandle(Sender: TObject; var Action: TCloseAction);
    procedure OnDataSetFilteringHandle(Sender: TObject; DataSet: TDataSet); virtual;
    procedure OnDataSetFilteredHandle(Sender: TObject; DataSet: TDataSet; Filtered: Boolean); virtual;

    procedure ExportDBTableData(const ExportFormat: TExportDBTableDataFormatClass); virtual;

    function CustomizeDBDataExportDialog(
      Dialog: TSaveDialog;
      ExportFormat: TExportDBTableDataFormatClass
    ): Boolean; virtual;

    function ExportGrid(
      FilePath: String;
      Grid: TcxGrid;
      ExportFormat: TExportDBTableDataFormatClass
    ): Boolean; virtual;

    procedure ExportGridAsXLS(const FilePath: String; Grid: TcxGrid); virtual;
    procedure ExportGridAsXML(const FilePath: String; Grid: TcxGrid); virtual;
    procedure ExportGridAsHTML(const FilePath: String; Grid: TcxGrid); virtual;

    procedure UpdateFocusedCellAndSelectedRecordGraphics(
      AViewCellInfo: TcxGridTableDataCellViewInfo;
      ACanvas: TcxCanvas
    );

    function GetMultiSelectionModeEnabled: Boolean;
    procedure SetMultiSelectionModeEnabled(const Enabled: Boolean);

    function GetEnabledChooseRecordAction: Boolean;
    procedure SetEnabledChooseRecordAction(const Enabled: Boolean);

    function GetEnabledAddRecordAction: Boolean;
    procedure SetEnabledAddRecordAction(const Enabled: Boolean);

    function GetEnabledChangeRecordAction: Boolean;
    procedure SetEnabledChangeRecordAction(const Enabled: Boolean);

    function GetEnabledRemoveRecordsAction: Boolean;
    procedure SetEnabledRemoveRecordsAction(const Enabled: Boolean);

    function GetEnabledSelectFilteredRecordAction: Boolean;
    procedure SetEnabledSelectFilteredRecordAction(const Enabled: Boolean);

    function GetEnabledExportDataAction: Boolean;
    procedure SetEnabledExportDataAction(const Enabled: Boolean);

    function GetEnabledPrintDataAction: Boolean;
    procedure SetEnabledPrintDataAction(const Enabled: Boolean);

    function GetChooseRecordActionVisible: Boolean;
    procedure SetChooseRecordActionVisible(const Enabled: Boolean);

    function GetAddRecordActionVisible: Boolean;
    procedure SetAddRecordActionVisible(const Enabled: Boolean);

    function GetChangeRecordActionVisible: Boolean;
    procedure SetChangeRecordActionVisible(const Enabled: Boolean);

    function GetRemoveRecordsActionVisible: Boolean;
    procedure SetRemoveRecordsActionVisible(const Enabled: Boolean);

    function GetSelectFilteredRecordActionVisible: Boolean;
    procedure SetSelectFilteredRecordActionVisible(const Enabled: Boolean);

    function GetExportDataActionVisible: Boolean;
    procedure SetExportDataActionVisible(const Enabled: Boolean);

    function GetPrintDataActionVisible: Boolean;
    procedure SetPrintDataActionVisible(const Enabled: Boolean);

    function GetSelectedRecordCount: Integer;
    function GetConfirmedSelectedRecordCount: Integer;

    function GetFocusedRecord: TDBDataTableRecord;
    
    // single record search functions
    procedure GoToNextFoundOccurrenceBySelectedColumn(
      const ASearchDirection: TSearchNextFoundOccurrenceDirection
    );
    function GetFieldNameBySelectedColumn: String;
    procedure SetEnabledSearchNextOccurrenceTools(const AEnabled: Boolean);
    procedure UpdateSearchNextOccurrenceToolsActivity;

    property SelectedRecordCount: Integer read GetSelectedRecordCount;

    procedure SetSearchColumnNameLabelText(const Text: String);
    procedure ArrangeSearchByColumnPanelControls;
    procedure AdjustSearchByColumnPanel; virtual;

    procedure CorrectBoundsOfFormByCurrentFontSettings;
      procedure CorrectBoundsOfSearchByColumnPanelControls;
      procedure CorrectBoundsOfWaitDataLoadingPanelControls;
      procedure CorrectBoundsOFDataLoadingCanceledPanelControls;

    function GetUserLoginPanelVisible: Boolean;
    procedure SetUserLoginPanelVisible(const Visible: Boolean);

    function GetDatabaseNamePanelVisible: Boolean;
    procedure SetDatabaseNamePanelVisible(const Visible: Boolean);

    function GetTotalRecordCountPanelVisible: Boolean;
    procedure SetTotalRecordCountPanelVisible(
      const Visible: Boolean
    );

    function GetEnableRecordGroupingByColumnsOption: Boolean;
    procedure SetEnableRecordGroupingByColumnsOption(const Value: Boolean);

    function GetRecordCount: Integer;
    function AreRecordKeyValuesEqual(
      const FirstRecordKeyValue, SecondRecordKeyValue: Variant
    ): Boolean;
    function GetRecordKeyValue(GridRecord: TcxCustomGridRecord): Variant;

    procedure SelectDataRecord(const KeyFieldNames: String; const KeyFieldValues: Variant);

    procedure ApplyCurrentFilterFormState;

    procedure SetFilterFormLastState(const Value: TTableViewFilterFormState);

    function RequestDataSetOperationCancellationForDestroying: TDataSetOperationCancellationForDestroyingResult; virtual;

    procedure OnDataLoadingSuccessForDestroyingEventHandler(Sender: TObject; DataSet: TDataSet; RelatedState: TObject);
    procedure OnDataLoadingErrorOccurredForDestroyingEventHandler(Sender: TObject; DataSet: TDataSet; const Error: Exception; RelatedState: TObject);
    procedure OnDataSetCancellationForDestroyingEventHandler(Sender: TObject);

  public
    { Public declarations }

    destructor Destroy; override;
    procedure SafeDestroy;

    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(const Caption: String; AOwner: TComponent); overload;
    constructor Create(AOwner: TComponent; const Caption: String; const EnableSelectionColumn: Boolean); overload;
    constructor Create(ADataSet: TDataSet; AOwner: TComponent); overload;
    constructor Create(ADataSet: TDataset; const Caption: String; AOwner: TComponent); overload;
    constructor Create(AConnection: TZConnection; AOwner: TComponent); overload;

    procedure BeginUpdate;
    procedure EndUpdate;

    property DataSet: TDataSet read GetDataSet write SetDataSet;

    property Connection: TZConnection read GetConnection write SetConnection;

    procedure SetFocusedColumnByFieldName(const FieldName: String);

    function LocateRecord(
      const FieldNames: string;
      const FieldValues: Variant;
      const SearchOptions: TDBDataTableSearchRecordOptions = []
    ): Boolean;

    function LocateRecordById(const RecordId: Variant): Boolean;

    procedure SetRequestedFocusedRecord(const RecordKeyValue: Variant);

    property SelectedRecords: TDBDataTableRecords read FSelectedRecords;

    function CurrentSelectedRecords: TDBDataTableRecords;

    property ConfirmedSelectedRecordCount: Integer
    read GetConfirmedSelectedRecordCount;
    
    procedure Refresh;
    procedure UpdateLayout;
    
    property RecordCount: Integer read GetRecordCount;

    procedure SelectRecordsByIds(RecordIds: TVariantList);
    procedure DeSelectRecordsByIds(RecordIds: TVariantList);

    procedure SelectCurrentDataRecord;
    procedure SelectCurrentDataRecordAsTopRow;

    procedure FreeWhenItWillBePossible;
    function IsDestroyingAllowable: Boolean; virtual;

    property FilterFormLastState: TTableViewFilterFormState 
    read FTableViewFilterFormLastState write SetFilterFormLastState;

    function GetRecordCellValueByFieldName(const GridRecord: TcxCustomGridRecord; const FieldName: String): Variant;
    function GetRecordCellValue(const GridRecord: TcxCustomGridRecord; const ColumnIndex: Integer): Variant;
    function GetFocusedRecordColumnValue(const FieldName: String): Variant; overload;
    function GetFocusedRecordColumnValue(const ColumnIndex: Integer): Variant; overload;
    function GetColumnByFieldName(const FieldName: String): TcxGridDBColumn;
    function GetCurrentRecordKeyValue: Variant;

  published

    property FocusedRecordId: Variant
    read GetFocusedRecordId write SetFocusedRecordId;

    property Font: TFont
    read GetFont write SetFont;

    property DataLoadingCancelledCaption: string
    read GetDataLoadingCancelledCaption write SetDataLoadingCancelledCaption;

    property DataLoadingCaption: string
    read GetDataLoadingCaption write SetDataLoadingCaption;

    property EnableLoadingDataOnFirstShow: Boolean
    read FLoadingDataOnFirstShowEnabled write FLoadingDataOnFirstShowEnabled;

    property RefreshingAfterDataModificationEnabled: Boolean
    read FRefreshingAfterDataModificationEnabled
    write FRefreshingAfterDataModificationEnabled;

    property EnableMultiSelectionMode: Boolean
    read GetMultiSelectionModeEnabled write SetMultiSelectionModeEnabled;

    property EnableChooseRecordAction: Boolean
    read GetEnabledChooseRecordAction write SetEnabledChooseRecordAction;

    property EnableAddRecordAction: Boolean
    read GetEnabledAddRecordAction write SetEnabledAddRecordAction;

    property EnableChangeRecordAction: Boolean
    read GetEnabledChangeRecordAction write SetEnabledChangeRecordAction;

    property EnableRemoveRecordsAction: Boolean
    read GetEnabledRemoveRecordsAction write SetEnabledRemoveRecordsAction;

    property EnableSelectFilteredRecordAction: Boolean
    read GetEnabledSelectFilteredRecordAction
    write SetEnabledSelectFilteredRecordAction;

    property EnableExportDataAction: Boolean
    read GetEnabledExportDataAction write SetEnabledExportDataAction;

    property EnablePrintDataAction: Boolean
    read GetEnabledPrintDataAction write SetEnabledPrintDataAction;

    property ChooseRecordActionVisible: Boolean
    read GetChooseRecordActionVisible write SetChooseRecordActionVisible;

    property AddRecordActionVisible: Boolean
    read GetAddRecordActionVisible write SetAddRecordActionVisible;

    property ChangeRecordActionVisible: Boolean
    read GetChangeRecordActionVisible write SetChangeRecordActionVisible;

    property RemoveRecordsActionVisible: Boolean
    read GetRemoveRecordsActionVisible write SetRemoveRecordsActionVisible;

    property SelectFilteredRecordActionVisible: Boolean
    read GetSelectFilteredRecordActionVisible
    write SetSelectFilteredRecordActionVisible;

    property ExportDataActionVisible: Boolean
    read GetExportDataActionVisible write SetExportDataActionVisible;

    property PrintDataActionVisible: Boolean
    read GetPrintDataActionVisible write SetPrintDataActionVisible;

    property MovingToAddedRecordAfterAddingEnabled: Boolean
    read FMovingToAddedRecordAfterAddingEnabled write
    FMovingToAddedRecordAfterAddingEnabled;

    property MustSaveFilterFormStateBeforeClosing: Boolean
    read FMustSaveFilterFormStateBeforeClosing
    write FMustSaveFilterFormStateBeforeClosing;

    property SelectedRecordsColor: TColor
    read FSelectedRecordsColor write FSelectedRecordsColor;

    property FocusedCellColor: TColor
    read FFocusedCellColor write FFocusedCellColor;

    property SelectedRecordsTextColor: TColor
    read FSelectedRecordsTextColor write FSelectedRecordsTextColor;

    property FocusedCellTextColor: TColor
    read FFocusedCellTextColor write FFocusedCellTextColor;

    property UserLoginPanelVisible: Boolean
    read GetUserLoginPanelVisible write SetUserLoginPanelVisible;

    property DatabaseNamePanelVisible: Boolean
    read GetDatabaseNamePanelVisible write SetDatabaseNamePanelVisible;

    property TotalRecordCountPanelVisible: Boolean
    read GetTotalRecordCountPanelVisible write SetTotalRecordCountPanelVisible;

    property ViewOnly: Boolean read GetViewOnly write SetViewOnly;

  published

    property OnRecordsRefreshedEventHandler: TOnRecordsRefreshedEventHandler
    read FOnRecordsRefreshedEventHandler write FOnRecordsRefreshedEventHandler;

    property OnRecordsChoosedEventHandler: TOnRecordsChoosedEventHandler
    read FOnRecordsChoosedEventHandler
    write FOnRecordsChoosedEventHandler;

  published

    property FocusedRecord: TDBDataTableRecord
    read GetFocusedRecord;

    property FocusedField: TDBDataTableRecordField
    read GetFocusedField;
    
    property EnableRecordGroupingByColumnsOption: Boolean
    read GetEnableRecordGroupingByColumnsOption
    write SetEnableRecordGroupingByColumnsOption;

    property EnableSelectionColumn: Boolean
    read GetEnableSelectionColumn write SetEnableSelectionColumn;
    
  end;

var
  DBDataTableForm: TDBDataTableForm;

implementation

uses

  cxDataUtils,
  VariantFunctions,
  AuxWindowsFunctionsUnit,
  AuxSystemFunctionsUnit,
  AuxDataSetFunctionsUnit,
  AuxiliaryStringFunctions,
  AuxDebugFunctionsUnit;

{$R *.dfm}
{$R TableViewer.res}
{$R DBDataTableFormLocalization.res}

{ TDBDataTableForm }

procedure TDBDataTableForm.actAddDataExecute(Sender: TObject);
begin

  FLastOperation := opAddRecord;
  
  try

    if not OnAddRecord then Exit;

    if FRefreshingAfterDataModificationEnabled then
      RefreshRecordsInBackground;

    if not Assigned(FDataSetOperationThread) then
      MoveToAddedRecordAfterAdding;

  finally

    UpdateMainUI;

  end;

end;

procedure TDBDataTableForm.actChangeDataExecute(Sender: TObject);
begin

  FLastOperation := opChangeRecord;
  
  try

    SaveCurrentSelectedRecordLocation;
    
    if not OnChangeRecord then Exit;

    if FRefreshingAfterDataModificationEnabled then
      RefreshRecordsInBackground;

    if not Assigned(FDataSetOperationThread) then
      RestorePreviousChangingRecordLocation;
    
  finally

    UpdateMainUI;

  end;

end;

procedure TDBDataTableForm.actChooseRecordsExecute(Sender: TObject);
begin

  OnChooseRecords;

end;

procedure TDBDataTableForm.actDeleteDataExecute(Sender: TObject);
begin

  FLastOperation := opDeleteRecords;
  
  try

    CloseTableViewFilterForm;

    if OnDeleteRecords <= 0 then Exit;

    if FRefreshingAfterDataModificationEnabled then
      RefreshRecordsInBackground;

  finally

    UpdateMainUI;

  end;

end;

procedure TDBDataTableForm.actCopySelectedDataRecordCellExecute(
  Sender: TObject);
begin

  Screen.Cursor := crHourGlass;

  try

    CopySelectedDataRecordCell;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDBDataTableForm.actCopySelectedDataRecordsExecute(Sender: TObject);
begin

  Screen.Cursor := crHourGlass;

  try

    OnCopySelectedDataRecords;

  finally

    Screen.Cursor := crDefault;
    
  end;
  
end;

procedure TDBDataTableForm.actExitExecute(Sender: TObject);
begin

  OnExit;

end;

procedure TDBDataTableForm.actExportDataExecute(Sender: TObject);
begin

  OnDataExport;

end;

procedure TDBDataTableForm.actExportDataToHTMLExecute(Sender: TObject);
begin

  ExportDBTableData(THTMLExportDBTableDataFormat);

end;

procedure TDBDataTableForm.actExportDataToXLSExecute(Sender: TObject);
begin

  ExportDBTableData(TXLSExportDBTableDataFormat);

end;

procedure TDBDataTableForm.actExportDataToXMLExecute(Sender: TObject);
begin

  ExportDBTableData(TXMLExportDBTableDataFormat);

end;

procedure TDBDataTableForm.actFirstDataRecordExecute(Sender: TObject);
begin

  MoveToDataRecord(mdFirst);

end;

procedure TDBDataTableForm.actPrevDataRecordExecute(Sender: TObject);
begin

  MoveToDataRecord(mdPrior);

end;

procedure TDBDataTableForm.actLastDataRecordExecute(Sender: TObject);
begin

  MoveToDataRecord(mdLast);
  
end;

procedure TDBDataTableForm.actNextDataRecordExecute(Sender: TObject);
begin

  MoveToDataRecord(mdNext);
  
end;

procedure TDBDataTableForm.actPrevFoundOccurrenceExecute(Sender: TObject);
begin

  GoToNextFoundOccurrenceBySelectedColumn(sdBackward);
  
end;

procedure TDBDataTableForm.actNextFoundOccurrenceExecute(Sender: TObject);
begin

  GoToNextFoundOccurrenceBySelectedColumn(sdForward);
  
end;

procedure TDBDataTableForm.actPrintDataExecute(Sender: TObject);
begin

  OnPrintData;
  
end;

procedure TDBDataTableForm.actRefreshDataExecute(Sender: TObject);
begin

  FLastOperation := opRefreshRecords;

  OnRefreshRecords;

end;

procedure TDBDataTableForm.actSelectFilteredDataExecute(Sender: TObject);
begin

  OnSelectFilteredDataRecords;
  
end;

procedure TDBDataTableForm.AdjustSearchByColumnPanel;
begin

  ArrangeSearchByColumnPanelControls;
  CorrectBoundsOfSearchByColumnPanelControls;
  
end;

procedure TDBDataTableForm.ApplyCurrentFilterFormState;
begin

  TTableViewFilterForm.ApplyFilterFormState(
    GetTableViewFilterFormClass,
    DataRecordGridTableView,
    FTableViewFilterFormLastState,
    OnDataSetFilteredHandle,
    CustomizeTableViewFilterForm
  );

end;

function TDBDataTableForm.AreRecordKeyValuesEqual(const FirstRecordKeyValue,
  SecondRecordKeyValue: Variant): Boolean;
var I: Integer;
    KeyValueElementCount: Integer;
begin

  if VarIsNull(FirstRecordKeyValue) and VarIsNull(SecondRecordKeyValue)
  then Result := True

  else if VarIsNull(FirstRecordKeyValue) or VarIsNull(SecondRecordKeyValue)
  then Result := False

  else begin

    if VarType(FirstRecordKeyValue) <> VarType(SecondRecordKeyValue) then
      Result := False

    else begin

      if not VarIsArray(FirstRecordKeyValue) then
        Result := FirstRecordKeyValue = SecondRecordKeyValue

      else begin

        KeyValueElementCount := VarArrayHighBound(SecondRecordKeyValue, 1);

        for I := 0 to KeyValueElementCount do begin

          if FirstRecordKeyValue[I] <> SecondRecordKeyValue[I] then begin

            Result := False;
            Exit;

          end;

        end;

        Result := True;

      end;

    end;

  end;

end;

procedure TDBDataTableForm.ArrangeSearchByColumnPanelControls;
begin

  SearchColumnNameLabel.Left :=
    Label1.Left +
    Label1.Width +
    HORIZONTAL_OFFSET_BETWEEN_CHOOSE_COLUMN_LABEL_AND_COLUMN_NAME_LABEL;

  SearchColumnValueEdit.Left :=
    SearchColumnNameLabel.Left +
    SearchColumnNameLabel.Width +
    HORIZONTAL_OFFSET_BETWEEN_SEARCH_COLUMN_NAME_AND_SEARCH_COLUMN_VALUE_EDIT;

  btnPrevFoundOccurrence.Left :=
    SearchColumnValueEdit.Left +
    SearchColumnValueEdit.Width +
    HORIZONTAL_OFFSET_BETWEEN_PREVIOUS_AND_NEXT_RECORD_SEARCH_BUTTONS;

  btnNextFoundOccurrence.Left :=
    btnPrevFoundOccurrence.Left +
    btnPrevFoundOccurrence.Width +
    HORIZONTAL_OFFSET_BETWEEN_PREVIOUS_AND_NEXT_RECORD_SEARCH_BUTTONS;

  SearchByENTERCheckBox.Left :=
    btnNextFoundOccurrence.Left +
    btnNextFoundOccurrence.Width +
    20;

  CenterChildControlsOfParentControlByVertically(SearchByColumnPanel);

end;

function TDBDataTableForm.AttachDataSet(ADataSet: TDataSet): TDataSet;
begin

  Screen.Cursor := crHourGlass;

  Result := DataSet;

  if Assigned(ADataSet) then begin

    SetDataSet(ADataSet);
    ADataSet.EnableControls;

  end

  else begin

    DataSet.DisableControls;
    SetDataSet(nil);
    
  end;

  Screen.Cursor := crDefault;

end;

procedure TDBDataTableForm.btnCancelDataOperationClick(Sender: TObject);
begin

  CancelDBDataLoadingOperation;

end;

procedure TDBDataTableForm.CancelDBDataLoadingOperation;
begin

  if Assigned(FDataSetOperationThread) then begin

    ShowWaitingDataLoadingPanel(False);

    Screen.Cursor := crHourGlass;

    FDataSetOperationThread.IsCancelled := True;

  end;

end;

procedure TDBDataTableForm.CopySelectedDataRecordCell;
var FocusedColumn: TcxGridColumn;
begin

  FocusedColumn := DataRecordGridTableView.Controller.FocusedColumn;

  if Assigned(FocusedColumn) then
    Clipboard.AsText := FocusedColumn.EditValue;
  
end;

procedure TDBDataTableForm.CorrectBoundsOFDataLoadingCanceledPanelControls;
begin

  DataLoadingCanceledPanel.Width :=
    DataLoadingCanceledLabel.Left +
    DataLoadingCanceledLabel.Width +
    DataLoadingCanceledLabel.Left;

  DataLoadingCanceledPanel.Height :=
    DataLoadingCanceledLabel.Top +
    DataLoadingCanceledLabel.Height + 5;

  CenterWindowRelativeByHorz(
    imgDataOperationCanceled, DataLoadingCanceledPanel
  );

end;

procedure TDBDataTableForm.CorrectBoundsOfFormByCurrentFontSettings;
begin

  CorrectBoundsOfSearchByColumnPanelControls;
  CorrectBoundsOfWaitDataLoadingPanelControls;
  CorrectBoundsOFDataLoadingCanceledPanelControls;

end;
  
procedure TDBDataTableForm.CorrectBoundsOfSearchByColumnPanelControls;
var NextControlLeft: Integer;
    NextControlTop: Integer;
    MaxControlHeight: Integer;
    SearchByColumnPanelRightBoundForControls: Integer;
begin

end;

procedure TDBDataTableForm.CorrectBoundsOfWaitDataLoadingPanelControls;
begin

  AdjustControlSizeByContent(
    btnCancelDataOperation, Canvas, Rect(5, 5, 5, 5)
  );

  btnCancelDataOperation.Top :=
    DataLoadingLabel.Top + DataLoadingLabel.Height + 14;

  WaitDataLoadingPanel.Width :=
    DataLoadingLabel.Left +  DataLoadingLabel.Width + DataLoadingLabel.Left;

  WaitDataLoadingPanel.Height :=
    btnCancelDataOperation.Top + btnCancelDataOperation.Height + 5;

  CenterWindowRelativeByHorz(
    btnCancelDataOperation, WaitDataLoadingPanel
  );

  CenterWindowRelativeByHorz(
    AnimDataLoading, WaitDataLoadingPanel
  );

end;

constructor TDBDataTableForm.Create(
  ADataSet: TDataSet;
  const Caption: String;
  AOwner: TComponent
);
begin

  inherited Create(AOwner);

  Init;
  
  Self.Caption := Caption;

  DataSet := ADataSet;

end;

constructor TDBDataTableForm.Create(
  AConnection: TZConnection;
  AOwner: TComponent
);
begin

  inherited Create(AOwner);

  Init;

  Connection := AConnection;
  
end;

constructor TDBDataTableForm.Create(AOwner: TComponent; const Caption: String;
  const EnableSelectionColumn: Boolean);
begin

  inherited Create(AOwner);

  Init;

  Self.EnableSelectionColumn := EnableSelectionColumn;
  
end;

function TDBDataTableForm.CreateAndFillSelectedRecords: TDBDataTableRecords;
var
    I: Integer;
begin

  Result := CreateDBDataTableRecords;

  try
  
    with DataRecordGridTableView do begin

      for I := 0 to Controller.SelectedRecordCount - 1 do begin
             {
        if
          EnableSelectionColumn
          and not VarOrDefault(
            DataController.Values[
              Controller.SelectedRecords[I].RecordIndex,
              IsSelectedColumn.Index
            ],
            False
          )

        then Continue;   }

        Result.Add(
          CreateTableRecordViewModelFor(
            DataController.GetRowIndexByRecordIndex(
              Controller.SelectedRecords[I].RecordIndex,
              False
            )
          )
        );
      
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TDBDataTableForm.CreateDBDataTableRecord: TDBDataTableRecord;
begin

  Result := GetDBDataTableRecordClass.Create;

end;

function TDBDataTableForm.CreateDBDataTableRecords: TDBDataTableRecords;
begin

  Result := GetDBDataTableRecordsClass.Create;

end;

function TDBDataTableForm.CreateFocusedFieldViewModelFrom(
  Column: TcxGridDBColumn): TDBDataTableRecordField;
begin

  Result :=
    TDBDataTableRecordField.Create(
      Column.DataBinding.FieldName,
      Column.EditValue
    );
    
end;

function TDBDataTableForm.CreateTableRecordViewModelFor(
  const RowIndex: Integer
): TDBDataTableRecord;
var
    DataSetField: TField;
    GridColumn: TcxGridDBColumn;
    RowInfo: TcxRowInfo;
begin

  if DataRecordGridTableView.DataController.RowCount = 0 then begin

    Result := nil;
    Exit;

  end;

  Result := CreateDBDataTableRecord;

  RowInfo := DataRecordGridTableView.DataController.GetRowInfo(RowIndex);

  for DataSetField in DataRecordGridTableView
                      .DataController
                      .DataSource
                      .DataSet
                      .Fields

  do begin

    GridColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        DataSetField.FieldName
      );

    if not Assigned(GridColumn) then Continue;

    Result.AddField(

      DataSetField.FieldName,

      DataRecordGridTableView.DataController.GetRowValue(
        RowInfo,
        GridColumn.Index
      )

    );

  end;

end;

function TDBDataTableForm.CreateTableRecordViewModelForCurrentRow: TDBDataTableRecord;
begin

  Result :=
    CreateTableRecordViewModelFor(
      DataRecordGridTableView.DataController.FocusedRowIndex
    );
    
end;

constructor TDBDataTableForm.Create(
  ADataSet: TDataSet;
  AOwner: TComponent
);
begin

  inherited Create(AOwner);

  Init;
  DataSet := ADataSet;
   
end;

function TDBDataTableForm.CurrentSelectedRecords: TDBDataTableRecords;
begin

  Result := CreateAndFillSelectedRecords;
  
end;

function TDBDataTableForm.CustomizeDBDataExportDialog(
  Dialog: TSaveDialog;
  ExportFormat: TExportDBTableDataFormatClass
): Boolean;
begin

  Result := True;

  if ExportFormat = TXLSExportDBTableDataFormat then begin

    Dialog.Title := 'Экспорт данных в Excel';
    Dialog.Filter := 'Excel (.*xls)|*.xls';
    Dialog.DefaultExt := '.xls';
      
  end

  else if ExportFormat = TXMLExportDBTableDataFormat then begin

    Dialog.Title := 'Экспорт данных в XML';
    Dialog.Filter := 'XML (*.xml)|*.xml';
    Dialog.DefaultExt := '.xml';

  end

  else if ExportFormat = THTMLExportDBTableDataFormat then begin

    Dialog.Title := 'Экспорт данных в HTML';
    Dialog.Filter := 'HTML (*.html)|*.html';
    Dialog.DefaultExt := '.html';

  end

  else Result := False;
  
end;

procedure TDBDataTableForm.CustomizeTableViewFilterForm(
  ATableViewFilterForm: TTableViewFilterForm);
begin
//
end;

constructor TDBDataTableForm.Create(AOwner: TComponent);
begin

  inherited;
  Init;

end;

constructor TDBDataTableForm.Create(const Caption: String; AOwner: TComponent);
begin

  inherited Create(AOwner);
  Init;
      
  Self.Caption := Caption;

end;

procedure TDBDataTableForm.DataOperationToolBarAdvancedCustomDrawButton(
  Sender: TToolBar; Button: TToolButton; State: TCustomDrawState;
  Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags;
  var DefaultDraw: Boolean);
var FilterImage: TPNGObject;
    FilterImageX, FilterImageY: Integer;
    ActiveFilterCaption: String;
    FilterButtonContentHeight: Integer;
    ActiveFilterCaptionWidth, ActiveFilterCaptionHeight: Integer;
    ActiveFilterCaptionX, ActiveFilterCaptionY: Integer;
begin
  
  if (Button <> SelectFilterDataToolButton) or
     (not Assigned(DataSet)) or
     (not DataSet.Active) or
     (not DataSet.Filtered)
  then begin

    DefaultDraw := True;
    inherited;
    Exit;
    
  end;
    
  DefaultDraw := False;

  ActiveFilterCaption := 'Фильтр !';
  ActiveFilterCaptionWidth := Sender.Canvas.TextWidth(ActiveFilterCaption);
  ActiveFilterCaptionHeight := Sender.Canvas.TextHeight(ActiveFilterCaption);

  FilterImage := imgLstEnabled.PngImages.Items[5].PngImage;

  FilterImageX := Button.Left + (Button.Width - FilterImage.Width) div 2;

  FilterButtonContentHeight :=
    FilterImage.Height + 3 + ActiveFilterCaptionHeight;

  FilterImageY :=
    Button.Top + 4;

  ActiveFilterCaptionX :=
    Button.Left + (Button.Width - ActiveFilterCaptionWidth) div 2;

  ActiveFilterCaptionY :=
    FilterImageY + FilterImage.Height;

  if not (cdsHot in State) then
    Sender.Canvas.Brush.Color := $006989ff

  else begin

    Sender.Canvas.Pen.Color := $00d89574;
    Sender.Canvas.Brush.Color := $00efd3c6;

  end;

  Sender.Canvas.Rectangle(Button.BoundsRect);

  Sender.Canvas.Draw(FilterImageX, FilterImageY, FilterImage);
  Sender.Canvas.TextOut(
    ActiveFilterCaptionX, ActiveFilterCaptionY, ActiveFilterCaption
  );

  Sender.Canvas.Pen.Color := clDefault;

end;

procedure TDBDataTableForm.DataRecordGridTableViewCellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin

  UpdateChooseRecordsAction;
  UpdateModificationDataActions;

  AHandled := True;
  
end;

procedure TDBDataTableForm.DataRecordGridTableViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin

  if DataRecordGridTableView.Controller.SelectedRowCount = 0 then
      if Assigned(DataRecordGridTableView.Controller.FocusedRecord) then
        DataRecordGridTableView.Controller.FocusedRecord.Selected := True;

  UpdateFocusedCellAndSelectedRecordGraphics(AViewInfo, ACanvas);

end;

procedure TDBDataTableForm.DataRecordGridTableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
begin

  inherited;

  if Assigned(AFocusedItem) then
    SetSearchColumnNameLabelText(AFocusedItem.Caption);

end;

procedure TDBDataTableForm.DataRecordGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin

  if DataRecordGridTableView.Controller.SelectedRowCount = 0 then
    if Assigned(AFocusedRecord) then
      AFocusedRecord.Selected := True;

  UpdateChooseRecordsAction;
  UpdateModificationDataActions;
  RememberRecordKeyValue(AFocusedRecord);
  
end;

procedure TDBDataTableForm.DeleteStatusPanelByLabel(
  const StatusPanelLabel: String);
var StatusPanelIndex: Integer;
    StatusPanel: TStatusPanel;
begin

  for StatusPanelIndex := 0 to StatisticsInfoStatusBar.Panels.Count - 1 do
  begin

    StatusPanel := StatisticsInfoStatusBar.Panels[StatusPanelIndex];

    if ContainsStr(StatusPanel.Text, StatusPanelLabel)
    then begin

      StatisticsInfoStatusBar.Panels.Delete(StatusPanelIndex);
      Exit;

    end;
    
  end;
    
end;

procedure TDBDataTableForm.DeSelectRecordsByIds(RecordIds: TVariantList);
begin

  SetSelectedRecordsByIds(RecordIds, False);
  
end;

destructor TDBDataTableForm.Destroy;
begin

  DataSet := nil;
  
  FreeAndNil(FTableViewFilterFormLastState);
  FreeAndNil(FSelectedRecords);
  FreeAndNil(FLastSelectedRecordIndexFieldNames);
  FreeAndNil(FLastSelectedRecordIndexFieldValues);
  FreeAndNil(FSelectedByColumnRecordIndices);
  
  inherited;

end;

procedure TDBDataTableForm.DestroyDataSetOperationThread;
begin

  if Assigned(FDataSetOperationThread) then begin

    Screen.Cursor := crHourGlass;

    FDataSetOperationThread.OnCancellationEventHandler := nil;
    FDataSetOperationThread.IsCancelled := True;
    FDataSetOperationThread := nil;

    Screen.Cursor := crDefault;

  end;

end;

function TDBDataTableForm.FreeIfDestroyingRequested: Boolean;
begin

  if FIsDestroyingRequested then begin

    FIsDestroyingRequested := False;

    SafeDestroy;

    Result := True;

  end

  else Result := False;

end;

procedure TDBDataTableForm.FreeWhenItWillBePossible;
begin

  if IsDestroyingAllowable then Free

  else FIsDestroyingRequested := True;

end;

function TDBDataTableForm.IsDestroyingAllowable: Boolean;
begin

  Result := not Assigned(FDataSetOperationThread);

end;

procedure TDBDataTableForm.DataRecordGridTableViewSelectionChanged(
  Sender: TcxCustomGridTableView);
var
    I: Integer;
begin

  if not EnableSelectionColumn then Exit;

  if not Assigned(FSelectedByColumnRecordIndices) then Exit;

  FSelectedByColumnRecordIndices.Restart;

  with DataRecordGridTableView do begin

      while FSelectedByColumnRecordIndices.Next do begin

        ViewData.Records[
          DataController.GetRowIndexByRecordIndex(
            FSelectedByColumnRecordIndices[
              FSelectedByColumnRecordIndices.CurrentKey
            ],
            False
          )
        ].Selected := True;

      end;

  end;

end;

procedure TDBDataTableForm.IsSelectedColumnPropertiesChange(Sender: TObject);
var
    SelectionCheckBox: TcxCheckBox;
begin

  if not EnableSelectionColumn then Exit;

  SelectionCheckBox := Sender as TcxCheckBox;

  SetRecordSelectedBySelectionColumn(
    DataRecordGridTableView.DataController.FocusedRecordIndex,
    SelectionCheckBox.Checked
  );
  
end;

procedure TDBDataTableForm.BeginUpdate;
begin

  DataRecordGridTableView.BeginUpdate;

end;

procedure TDBDataTableForm.BeginUpdateGridTableView;
begin

  Screen.Cursor := crHourGlass;

  DataRecordGridTableView.BeginUpdate;
  DataSet.DisableControls;

  Screen.Cursor := crDefault;

end;

procedure TDBDataTableForm.EndUpdate;
begin

  DataRecordGridTableView.EndUpdate;
  
end;

procedure TDBDataTableForm.EndUpdateGridTableView;
begin

  Screen.Cursor := crHourGlass;

  if FLastOperation = opRefreshRecords then
    {DataSet.Filtered := False};

  DataSet.EnableControls;

  if DataRecordGridTableView.IsUpdateLocked then
    DataRecordGridTableView.EndUpdate;

  Screen.Cursor := crDefault;

end;

procedure TDBDataTableForm.ExportDBTableData(
  const ExportFormat: TExportDBTableDataFormatClass);
begin

  CustomizeDBDataExportDialog(ExportDataDialog, ExportFormat);

  ExportDataDialog.InitialDir := GetCurrentDir;

  if not ExportDataDialog.Execute then Exit;

  Screen.Cursor := crHourGlass;

  try

    ExportGrid(ExportDataDialog.FileName, DataRecordGrid, ExportFormat);

  finally

    Screen.Cursor := crDefault;

  end;

  try

    if
      ShowQuestionMessage(
        Self.Handle,
        'Данные успешно были экспортированы. Показать ' +
        'содержимое соответствующего файла ?',
        'Сообщение'
      ) = IDYES

    then OpenDocument(ExportDataDialog.FileName);

  except

    on e: Exception do begin

      ShowErrorMessage(
        Self.Handle,
        'Не удалось экспортировать данные:'
        + sLineBreak + e.Message,
        'Ошибка'
      );

    end;

  end;

end;

function TDBDataTableForm.ExportGrid(FilePath: String; Grid: TcxGrid;
  ExportFormat: TExportDBTableDataFormatClass): Boolean;
begin

  Result := True;
  
  if ExportFormat = TXLSExportDBTableDataFormat then
    ExportGridAsXLS(ExportDataDialog.FileName, Grid)

  else if ExportFormat = TXMLExportDBTableDataFormat then
    ExportGridAsXML(ExportDataDialog.FileName, Grid)

  else if ExportFormat = THTMLExportDBTableDataFormat then
    ExportGridAsHTML(ExportDataDialog.FileName, Grid)

  else Result := False;

end;

procedure TDBDataTableForm.ExportGridAsHTML(const FilePath: String;
  Grid: TcxGrid);
begin

  ExportGridToHTML(FilePath, Grid);

end;

procedure TDBDataTableForm.ExportGridAsXLS(const FilePath: String;
  Grid: TcxGrid);
begin

  ExportGridToExcel(FilePath, Grid);

end;

procedure TDBDataTableForm.ExportGridAsXML(const FilePath: String;
  Grid: TcxGrid);
begin

  ExportGridToXML(FilePath, Grid);
  
end;

procedure TDBDataTableForm.OpenDataSetInBackground(ADataSet: TDataSet);
begin

  if DataSet is TZAbstractRODataSet then begin

    FDataSetOperationThread := TDataSetOperationThread.Create(
      {A}DataSet as TZAbstractRODataSet,
      opSelectData,
      True
    );

    FDataSetOperationThread.FreeOnTerminate := True;
    FDataSetOperationThread.OnCancellationEventHandler := OnDataLoadingCancelledHandle;
    FDataSetOperationThread.OnDataOperationErrorOccurredEvent := OnDataLoadingErrorOccurredHandle;
    FDataSetOperationThread.OnDataOperationSuccessEvent := OnDataLoadingSuccessHandle;

    FDataSetOperationThread.Resume;

  end

  else begin

    try

      //DataSet.Close;
      DataSet.Open;

      UpdateUIAfterSuccessDataLoading;

    except

      on e: Exception do begin

        UpdateUIAfterFailedDataLoading(e.Message);

      end;

    end;
    
  end;

end;

procedure TDBDataTableForm.Refresh;
begin

  actRefreshData.Execute;

end;

procedure TDBDataTableForm.RefreshRecordsInBackground;
var BackgroundDataSet: TDataSet;
begin

  // Дактивация элементов работы с записями данных
  SetActivatedDataOperationControls(False);

  // Закрытие формы фильтрации записей по полям
  CloseTableViewFilterForm;

  // Отображение элементов управления ожидания или отмены загрузки данных
  ShowDataLoadingWaitOrCancellationControls(ShowWaitControls);

  BeginUpdateGridTableView;
  // Отсоединение набора данных от табличной сетки на время
  // загрузки данных в отдельном потоке
  //BackgroundDataSet := AttachDataSet(nil);
                
  { Выполнение загрузки данных в отдельном потоке,
    со временем заменить на вызов функции ExecuteQueryAsync
    из модуля AuxAsyncZeosFunctions }
  OpenDataSetInBackground(BackgroundDataSet);

end;

procedure TDBDataTableForm.RememberRecordKeyValue(
  GridRecord: TcxCustomGridRecord);
begin

  FLastFocusedRecordKeyValue := GetRecordKeyValue(GridRecord);

end;

function TDBDataTableForm.
  RequestDataSetOperationCancellationForDestroying: TDataSetOperationCancellationForDestroyingResult;
begin

  if Assigned(FDataSetOperationThread) then begin

    FDataSetOperationThread.OnDataOperationSuccessEvent :=
      OnDataLoadingSuccessForDestroyingEventHandler;

    FDataSetOperationThread.OnDataOperationErrorOccurredEvent :=
      OnDataLoadingErrorOccurredForDestroyingEventHandler;
      
    FDataSetOperationThread.OnCancellationEventHandler :=
      OnDataSetCancellationForDestroyingEventHandler;

    FDataSetOperationCancellationForDestroyingRequested := True;

    FDataSetOperationThread.IsCancelled := True;

    FDataSetOperationThread := nil;

    Result := ocSuccessed;

  end

  else if FDataSetOperationCancellationForDestroyingRequested
  then Result := ocAlreadyRequested

  else Result := ocNotRequired

end;

procedure TDBDataTableForm.FormActivate(Sender: TObject);
begin

  { В связи с некорректным отображением
    кнопок тулбара. По всей видимости,
    подобные неурядицы обуславливались
    имманентным свойством дегенератов из Borland
    разрабатывать заведомо некачественное и
    непредсказуемо работающее ПО }
  Width := Width + 1;
  Width := Width - 1;

end;

procedure TDBDataTableForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  CloseTableViewFilterForm;
  DestroyDataSetOperationThread;

  inherited;

end;

procedure TDBDataTableForm.FormCreate(Sender: TObject);
begin

  DataRecordGrid.Realign;

end;

procedure TDBDataTableForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_ESCAPE then
    CancelDBDataLoadingOperation

  else if (Key = $46) and (ssCtrl in Shift)  then
    ShowTableViewFilterForm {
  else if (Key = $72) then
    actNextFoundOccurrence.Execute};

end;

procedure TDBDataTableForm.FormKeyPress(Sender: TObject; var Key: Char);
begin

{  if SearchColumnValueEdit.Focused then Exit;

  if Key <> #8 then
    SearchColumnValueEdit.Text := SearchColumnValueEdit.Text + Key
  else
    SearchColumnValueEdit.Text := Copy(SearchColumnValueEdit.Text, 1, Length(SearchColumnValueEdit.Text)-1);     }
end;

procedure TDBDataTableForm.FormResize(Sender: TObject);
begin

  CorrectBoundsOfFormByCurrentFontSettings;
  
end;

procedure TDBDataTableForm.FormShow(Sender: TObject);
begin

  if not FLoadingDataOnFirstShowEnabled then Exit;

  if not FIsFirstShowing then begin

    FIsFirstShowing := True;
    actRefreshData.Execute;

  end;

end;

function TDBDataTableForm.GetAddRecordActionVisible: Boolean;
begin

  Result := actAddData.Visible;
  
end;

function TDBDataTableForm.GetChangeRecordActionVisible: Boolean;
begin

  Result := actChangeData.Visible;
  
end;

function TDBDataTableForm.GetChooseRecordActionVisible: Boolean;
begin

  Result := actChooseRecords.Visible;
  
end;

function TDBDataTableForm.GetColumnByFieldName(
  const FieldName: String
): TcxGridDBColumn;
begin

  Result := DataRecordGridTableView.GetColumnByFieldName(FieldName);
  
end;

function TDBDataTableForm.GetConfirmedSelectedRecordCount: Integer;
begin

  if not Assigned(FSelectedRecords) then
    Result := 0

  else Result := FSelectedRecords.Count;
  
end;

function TDBDataTableForm.GetConnection: TZConnection;
begin

  if DataSet is TZAbstractRODataSet then
    Result := (DataSet as TZAbstractRODataSet).Connection as TZConnection

  else Result := nil;

end;

function TDBDataTableForm.GetCurrentRecordKeyValue: Variant;
begin

  Result := GetRecordKeyValue(DataRecordGridTableView.Controller.FocusedRecord);

end;

function TDBDataTableForm.GetDatabaseNamePanelLabel: String;
begin

  Result := 'БД: ';
  
end;

function TDBDataTableForm.GetDatabaseNamePanelVisible: Boolean;
begin

  Result := True;

end;

function TDBDataTableForm.GetDataLoadingCancelledCaption: String;
begin

  Result := DataLoadingCanceledLabel.Caption;

end;

function TDBDataTableForm.GetDataLoadingCaption: String;
begin

  Result := DataLoadingLabel.Caption;

end;

function TDBDataTableForm.GetDataSet: TDataSet;
begin

  Result := DataRecordGridTableView.DataController.DataSource.DataSet;

end;

class function TDBDataTableForm.GetDBDataTableRecordClass: TDBDataTableRecordClass;
begin

  Result := TDBDataTableRecord;

end;

class function TDBDataTableForm.GetDBDataTableRecordsClass: TDBDataTableRecordsClass;
begin

  Result := TDBDataTableRecords;
  
end;

function TDBDataTableForm.GetEnabledAddRecordAction: Boolean;
begin

  Result := actAddData.Enabled;

end;

function TDBDataTableForm.GetEnabledChangeRecordAction: Boolean;
begin

  Result := actChangeData.Enabled;

end;

function TDBDataTableForm.GetEnabledChooseRecordAction: Boolean;
begin

  Result := actChooseRecords.Enabled;
  
end;

function TDBDataTableForm.GetEnabledExportDataAction: Boolean;
begin

  Result := actExportData.Enabled;
  
end;

function TDBDataTableForm.GetEnabledPrintDataAction: Boolean;
begin

  Result := actPrintData.Enabled;
  
end;

function TDBDataTableForm.GetEnabledRemoveRecordsAction: Boolean;
begin

  Result := actDeleteData.Enabled;
  
end;

function TDBDataTableForm.GetEnabledSelectFilteredRecordAction: Boolean;
begin

  Result := actSelectFilteredData.Enabled;
  
end;

function TDBDataTableForm.GetEnableRecordGroupingByColumnsOption: Boolean;
begin

  Result :=
    DataRecordGridTableView.OptionsCustomize.ColumnGrouping;
    
end;

function TDBDataTableForm.GetEnableSelectionColumn: Boolean;
begin

  Result :=
    IsSelectedColumn.Visible
    and (IsSelectedColumn.DataBinding.FieldName = '')
    and DataRecordGridTableView.DataController.DataModeController.SmartRefresh
    and DataRecordGridTableView.OptionsSelection.MultiSelect;

end;

function TDBDataTableForm.GetExportDataActionVisible: Boolean;
begin

  Result := actExportData.Visible;
  
end;

function TDBDataTableForm.GetFieldNameBySelectedColumn: String;
begin

  Result :=
    TcxGridDBColumn(
      DataRecordGridTableView.Controller.FocusedColumn).
        DataBinding.FieldName;
        
end;

function TDBDataTableForm.GetFocusedRecordColumnValue(
  const FieldName: String
): Variant;
var GridColumn: TcxGridDBColumn;
begin

  Result :=
    GetRecordCellValueByFieldName(
      DataRecordGridTableView.Controller.FocusedRecord,
      FieldName
    );
    
end;

function TDBDataTableForm.GetFocusedRecord: TDBDataTableRecord;
begin

  Result := CreateTableRecordViewModelForCurrentRow;
  
end;

function TDBDataTableForm.GetFocusedField: TDBDataTableRecordField;
begin

  if Assigned(DataRecordGridTableView.Controller.FocusedColumn) then begin

    Result :=
      CreateFocusedFieldViewModelFrom(
        TcxGridDBColumn(
          DataRecordGridTableView.Controller.FocusedColumn
        )
      );

  end

  else Result := nil;

end;

function TDBDataTableForm.GetFocusedRecordColumnValue(
  const ColumnIndex: Integer): Variant;
begin

  Result :=
    GetRecordCellValue(
      DataRecordGridTableView.Controller.FocusedRecord,
      ColumnIndex
    );
    
end;

function TDBDataTableForm.GetFocusedRecordId: Variant;
var
    IdColumn: TcxGridDBColumn;
begin

  with DataRecordGridTableView.DataController do begin

    IdColumn := GetColumnByFieldName(KeyFieldNames);

    if Assigned(IdColumn) then
      Result := Values[FocusedRecordIndex, IdColumn.Index]

    else Result := Null;

  end;

end;

function TDBDataTableForm.GetFont: TFont;
begin

  Result := inherited Font;

end;

function TDBDataTableForm.GetMessageAboutThatUserAssuredThatWantDeleteSelectedRecords: String;
begin

  Result := 'Вы уверены, что хотите удалить выбранные записи ?';
  
end;

function TDBDataTableForm.GetMovingToAddedRecordAfterAddingEnabled: Boolean;
begin

  Result := FMovingToAddedRecordAfterAddingEnabled;

end;

procedure TDBDataTableForm.SetMovingToAddedRecordAfterAddingEnabled(
  const Enabled: Boolean);
begin

  FMovingToAddedRecordAfterAddingEnabled := Enabled;
  
end;

function TDBDataTableForm.GetMultiSelectionModeEnabled: Boolean;
begin

  Result := DataRecordGridTableView.OptionsSelection.MultiSelect;

end;

function TDBDataTableForm.GetPrintDataActionVisible: Boolean;
begin

  Result := actPrintData.Visible;
  
end;

function TDBDataTableForm.GetRecordCellValue(
  const GridRecord: TcxCustomGridRecord;
  const ColumnIndex: Integer
): Variant;
begin

  if Assigned(GridRecord) then begin

    Result :=
      DataRecordGridTableView
        .DataController
          .Values[GridRecord.RecordIndex, ColumnIndex];

  end

  else Result := Null;

end;

function TDBDataTableForm.GetRecordCellValueByFieldName(
  const GridRecord: TcxCustomGridRecord;
  const FieldName: String
): Variant;
var Column: TcxGridDBColumn;
begin

  if not Assigned(GridRecord) then begin

    Result := Null;
    Exit;
    
  end;

  Column := GetColumnByFieldName(FieldName);

  if Assigned(Column) then
    Result := GetRecordCellValue(GridRecord, Column.Index)

  else Result := Null;

end;

function TDBDataTableForm.GetRecordCount: Integer;
begin

  if IsDataSetActive then
    Result := DataSet.RecordCount

  else Result := 0;

end;

function TDBDataTableForm.GetRecordKeyValue(
  GridRecord: TcxCustomGridRecord): Variant;
var KeyFieldNameList: TStrings;
    KeyFieldName: String;
    KeyGridColumn: TcxGridDBColumn;
    KeyFieldValue: Variant;
    I: Integer;
begin

  if not Assigned(GridRecord) then
  begin

    Result := Null;
    Exit;
    
  end;
  
  try

    KeyFieldNameList :=
      SplitStringByDelimiter(
        DataRecordGridTableView.DataController.KeyFieldNames,
        ';'
      );

    if KeyFieldNameList.Count = 0 then begin

      Result := Unassigned;
      Exit;

    end;

    if KeyFieldNameList.Count = 1 then begin

      KeyGridColumn :=
          DataRecordGridTableView.GetColumnByFieldName(KeyFieldNameList[0]);

      Result := GetRecordCellValue(GridRecord, KeyGridColumn.Index);

    end

    else begin

      Result := VarArrayCreate([0, KeyFieldNameList.Count - 1], varVariant);

      for I := 0 to KeyFieldNameList.Count - 1 do begin

        KeyGridColumn :=
          DataRecordGridTableView.GetColumnByFieldName(KeyFieldNameList[I]);

        if not Assigned(KeyGridColumn) then begin

          Result := Null;
          Exit;

        end;

        KeyFieldValue := GetRecordCellValue(GridRecord, KeyGridColumn.Index);

        Result[I] := KeyFieldValue;

      end;

    end;

  finally

    FreeAndNil(KeyFieldNameList);

  end;

end;

function TDBDataTableForm.GetRemoveRecordsActionVisible: Boolean;
begin

  Result := actDeleteData.Visible;
  
end;

function TDBDataTableForm.GetSelectedRecordCount: Integer;
begin

  Result := DataRecordGridTableView.Controller.SelectedRecordCount;
  
end;

function TDBDataTableForm.GetSelectFilteredRecordActionVisible: Boolean;
begin

  Result := actSelectFilteredData.Visible;
  
end;

class function TDBDataTableForm.GetTableViewFilterFormClass: TTableViewFilterFormClass;
begin

  Result := TTableViewFilterForm;
  
end;

function TDBDataTableForm.GetTotalRecordCountPanelLabel: String;
begin

  Result := 'Количество записей: ';
  
end;

function TDBDataTableForm.GetTotalRecordCountPanelVisible: Boolean;
begin

end;

function TDBDataTableForm.GetUserLoginPanelLabel: String;
begin

  Result := 'Пользователь: ';
  
end;

function TDBDataTableForm.GetUserLoginPanelVisible: Boolean;
begin

end;

function TDBDataTableForm.GetViewOnly: Boolean;
begin

  Result := FViewOnly;

end;

procedure TDBDataTableForm.GoToNextFoundOccurrenceBySelectedColumn(
  const ASearchDirection: TSearchNextFoundOccurrenceDirection
);

{function IsDataSetPosAtEnd(
  const ASearchDirection: TSearchNextFoundOccurrenceDirection
): Boolean;
begin

  if ASearchDirection = sdForward then
    Result := DataSet.Eof

  else Result := DataSet.Bof;

end;

procedure GoToNextDataSetRecordForOccurrenceSearch(
  const ASearchDirection: TSearchNextFoundOccurrenceDirection
);
begin

  if ASearchDirection = sdForward then
    DataSet.Next

  else DataSet.Prior;
  
end;

var SelectedFieldName: String;
    SearchColumnValue: String;
    Bookmark: Pointer;
begin

  Bookmark := nil;

  try

    SelectedFieldName := GetFieldNameBySelectedColumn;

    Screen.Cursor := crHourGlass;

    DataSet.DisableControls;

    Bookmark := DataSet.GetBookmark;

    SearchColumnValue := SearchColumnValueEdit.Text;

    if StartsText(SearchColumnValue,
           DataSet.FieldByName(SelectedFieldName).AsString
       )

    then begin

      GoToNextDataSetRecordForOccurrenceSearch(ASearchDirection);

    end;
    
    while not IsDataSetPosAtEnd(ASearchDirection) do begin

      if StartsText(SearchColumnValue,
             DataSet.FieldByName(SelectedFieldName).AsString
         )

      then begin

        Break;

      end;

      GoToNextDataSetRecordForOccurrenceSearch(ASearchDirection);

    end;

    UpdateSearchNextOccurrenceToolsActivity;

    if IsDataSetPosAtEnd(ASearchDirection) then
      DataSet.GotoBookmark(Bookmark);

    DataSet.EnableControls;

    SelectCurrentDataRecord;

  finally

    Screen.Cursor := crDefault;

    if Assigned(Bookmark) then
      DataSet.FreeBookmark(Bookmark);

  end;    }
var SelectedColumn: TcxGridColumn;
  SelectedRecordIndex, recIndex: Integer;
begin

  try
    SelectedColumn :=
      DataRecordGridTableView.Controller.FocusedColumn;

    SelectedRecordIndex := DataRecordGridTableView.Controller.FocusedRecordIndex;

    if ASearchDirection = sdForward then
    begin
      recIndex := DataRecordGridTableView.DataController.FindRecordIndexByText(
        SelectedRecordIndex +1,
        TcxGridDBColumn(
        DataRecordGridTableView.Controller.FocusedColumn).Index,
        SearchColumnValueEdit.Text,
        True,
        False,
        True
      );

      actNextFoundOccurrence.Enabled := recIndex <> -1;
      actPrevFoundOccurrence.Enabled := True;

    end
    else begin
      recIndex := DataRecordGridTableView.DataController.FindRecordIndexByText(
        SelectedRecordIndex - 1,
        DataRecordGridTableView.Controller.FocusedColumn.Index,
        SearchColumnValueEdit.Text,
        True,
        False,
        False
      );

      actPrevFoundOccurrence.Enabled := recIndex <> -1;
      actNextFoundOccurrence.Enabled := True;

    end;

    if recIndex <> -1 then begin

      DataRecordGridTableView.DataController.FocusedRecordIndex := recIndex;
//      DataRecordGridTableView.DataController.FocusedRowIndex := recIndex;
//        DataRecordGridTableView.Controller.FocusedRecord.recIndex
    end;

//    UpdateSearchNextOccurrenceToolsActivity;
    SelectCurrentDataRecord;
  finally
    Screen.Cursor := crDefault;
  end;
  
end;

procedure TDBDataTableForm.HandleClickOnTableViewColumnCell(
  const CellViewInfo: TcxGridTableDataCellViewInfo);
begin

  SetSearchColumnNameLabelText(CellViewInfo.Item.VisibleCaption);
  
end;

procedure TDBDataTableForm.Init(const Caption: String; ADataSet: TDataSet);
var
    LocalizationFilePath: String;
begin

  SetVisibleControls(False, [DataLoadingCanceledPanel, WaitDataLoadingPanel]);

  FLoadingDataOnFirstShowEnabled := True;
  FRefreshingAfterDataModificationEnabled := False;
  FMovingToAddedRecordAfterAddingEnabled := True;
  FIsFirstShowing := False;
  FTableViewFilterForm := nil;

  InitAnimateProcessControl;

  FSelectedRecordsColor := DEFAULT_SELECTED_RECORD_COLOR;
  FFocusedCellColor := DEFAULT_FOCUSED_CELL_COLOR;
  
  FSelectedRecordsTextColor := clDefault;
  FFocusedCellTextColor := clDefault;
  
  FLastSelectedRecordIndexFieldNames := TStringList.Create;
  FLastSelectedRecordIndexFieldNames.Delimiter := ',';
  
  FLastSelectedRecordIndexFieldValues := TVariantList.Create;

  FLastFocusedRecordKeyValue := Null;
  FRequestedFocusedRecordKeyValue := Null;

  FSelectedByColumnRecordIndices := TIntegerHash.Create;
  
  LocalizationFilePath :=
    ExtractFileDir(Application.ExeName) + PathDelim + 'Localization.ini';

  if FileExists(LocalizationFilePath) and not Localizer.Active then begin

    Localizer.FileName := LocalizationFilePath;
    Localizer.StorageType := lstIni;
    Localizer.Locale := 1049;
    Localizer.Active := True;

  end;

end;

procedure TDBDataTableForm.InitAnimateProcessControl;
begin

  AnimDataLoading.ResName := 'AVI_CIRCLE';
  AnimDataLoading.ResHandle := hInstance;
  AnimDataLoading.Active := False;

end;

function TDBDataTableForm.IsDataSetActive: Boolean;
begin

  Result := Assigned(DataSet) and DataSet.Active;

end;

function TDBDataTableForm.HasDataSetRecords: Boolean;
begin

  Result := IsDataSetActive and (not DataSet.IsEmpty);
  
end;

procedure TDBDataTableForm.HideStatisticsStatusPanel(
  const StatisticsStatusPanel: TStatisticsStatusPanel);
var StatusPanelLabel: String;
begin

  case StatisticsStatusPanel of

    spTotalRecordCountPanel:

      StatusPanelLabel := GetTotalRecordCountPanelLabel;

    spDatabaseNamePanel:

      StatusPanelLabel := GetDatabaseNamePanelLabel;

    spUserLoginPanel:

      StatusPanelLabel := GetUserLoginPanelLabel;

    else  raise Exception.CreateFmt(
                  'Incorrect Status Panel Id [%d]',
                  [Integer(StatisticsStatusPanel)]
                );
  end;

  DeleteStatusPanelByLabel(StatusPanelLabel);

end;

function TDBDataTableForm.LocateRecord(const FieldNames: string;
  const FieldValues: Variant;
  const SearchOptions: TDBDataTableSearchRecordOptions): Boolean;
var LocateOptions: TLocateOptions;
begin

  if (sroCaseInsensitive in SearchOptions) and
      (sroPartialComparison in SearchOptions) then
    LocateOptions := [loCaseInsensitive, loPartialKey]

  else if sroCaseInsensitive in SearchOptions then
    LocateOptions := [loCaseInsensitive]

  else if sroPartialComparison in SearchOptions then
    LocateOptions := [loPartialKey]

  else LocateOptions := [];

  if Assigned(DataSet) then
    Result := DataSet.Locate(FieldNames, FieldValues, LocateOptions)

  else Result := False;

end;

function TDBDataTableForm.LocateRecordById(const RecordId: Variant): Boolean;
begin

  Result :=
    LocateRecord(
      DataRecordGridTableView.DataController.KeyFieldNames,
      RecordId
    );

end;

procedure TDBDataTableForm.LocateRecordBySelectedColumnValue;
var FilteredDBColumnName: String;
  recIndex: Integer;
begin

  FilteredDBColumnName := GetFieldNameBySelectedColumn;

  Screen.Cursor := crHourGlass;


  recIndex := DataRecordGridTableView.DataController.FindRecordIndexByText(
    0,
    TcxGridDBColumn(
      DataRecordGridTableView.Controller.FocusedColumn).Index,
      SearchColumnValueEdit.Text,
      True,
      False,
      True
  );

  if recIndex <> -1 then begin

    DataRecordGridTableView.DataController.FocusedRecordIndex := recIndex;


{  if DataSet.Locate(
        FilteredDBColumnName,
        SearchColumnValueEdit.Text,
        [loPartialKey, loCaseInsensitive]
     )
  then begin   }

    SearchColumnValueEdit.Color := clWindow;
    UpdateSearchNextOccurrenceToolsActivity;
    SelectCurrentDataRecord;

  end

  else begin

    SearchColumnValueEdit.Color := $00A087FF;
    SetEnabledSearchNextOccurrenceTools(False);

  end;

  Screen.Cursor := crDefault;

end;

procedure TDBDataTableForm.MoveToAddedRecord;
begin

  {actLastDataRecordExecute(Self);}
  SelectCurrentDataRecordAsTopRow;

end;

procedure TDBDataTableForm.MoveToAddedRecordAfterAdding;
begin

  if (FLastOperation = opAddRecord) and
      FMovingToAddedRecordAfterAddingEnabled
  then MoveToAddedRecord;
  
end;

procedure TDBDataTableForm.MoveToDataRecord(
  const MovingDirection: TDataRecordMovingDirection);
begin

  try

    Screen.Cursor := crHourGlass;
    
    case MovingDirection of

      mdFirst:

        DataRecordGridTableView.DataController.FocusedRowIndex := 0;

      mdPrior:

        DataRecordGridTableView.DataController.FocusedRowIndex :=
          DataRecordGridTableView.DataController.FocusedRowIndex - 1;

      mdNext:

        DataRecordGridTableView.DataController.FocusedRowIndex :=
          DataRecordGridTableView.DataController.FocusedRowIndex + 1;


      mdLast:

        DataRecordGridTableView.DataController.FocusedRowIndex :=
          DataRecordGridTableView.DataController.RecordCount - 1;

    end;

    UpdateMovingDataRecordActionsActivity;
    SelectCurrentDataRecordAsTopRow;
    
  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDBDataTableForm.MoveToDataSetRecord(
  const MovingDirection: TDataRecordMovingDirection);
begin

  try

    Screen.Cursor := crHourGlass;

    case MovingDirection of

      mdFirst: DataSet.First;
      mdPrior: DataSet.Prior;
      mdNext: DataSet.Next;
      mdLast: DataSet.Last;

    end;

    UpdateMovingDataRecordActionsActivity;
    SelectCurrentDataRecordAsTopRow;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDBDataTableForm.SetDatabaseNamePanelVisible(const Visible: Boolean);
begin

  if not Visible then
    StatisticsInfoStatusBar.Panels.Delete(1);

end;

procedure TDBDataTableForm.SetDataLoadingCancelledCaption(
  const ADataLoadingCancelledCaption: string);
begin

  DataLoadingCanceledLabel.Caption := ADataLoadingCancelledCaption;

end;

procedure TDBDataTableForm.SetDataLoadingCaption(
  const ADataLoadingCaption: string);
begin

  DataLoadingLabel.Caption := ADataLoadingCaption;

end;

procedure TDBDataTableForm.SetDataSet(const ADataSet: TDataSet);
begin

  if Assigned(DataSet) then
    RestorePreviousDataSetEventHandlers(DataSet);
  
  DataRecordGridTableView.DataController.DataSource.DataSet := ADataSet;

  if Assigned(ADataSet) then begin

    SavePreviousDataSetEventHandlers(ADataSet);

    ADataSet.AfterInsert := OnDataSetInsertedRecord;
    ADataSet.AfterDelete := OnDataSetDeletedRecord;
    ADataSet.AfterPost := OnDataSetInsertedRecord;

  end;

  FSelectedByColumnRecordIndices.Clear;

end;

procedure TDBDataTableForm.SetEnabledAddRecordAction(const Enabled: Boolean);
begin

  if not ViewOnly then
    actAddData.Enabled := Enabled;
  
end;

procedure TDBDataTableForm.SetEnabledChangeRecordAction(const Enabled: Boolean);
begin

  if not ViewOnly then
    actChangeData.Enabled := Enabled;
  
end;

procedure TDBDataTableForm.SetEnabledChooseRecordAction(const Enabled: Boolean);
begin

  actChooseRecords.Enabled := Enabled;
  
end;

procedure TDBDataTableForm.SetEnabledExportDataAction(const Enabled: Boolean);
begin

  actExportData.Enabled := Enabled;
  
end;

procedure TDBDataTableForm.SetEnabledPrintDataAction(const Enabled: Boolean);
begin

  actPrintData.Enabled := Enabled;
  
end;

procedure TDBDataTableForm.SetEnabledRemoveRecordsAction(
  const Enabled: Boolean);
begin

  if not ViewOnly then
    actDeleteData.Enabled := Enabled;
  
end;

procedure TDBDataTableForm.SetEnabledSearchNextOccurrenceTools(
  const AEnabled: Boolean);
begin

  SetEnabledActions(
    AEnabled,
    [actPrevFoundOccurrence, actNextFoundOccurrence]
  );
  
end;

procedure TDBDataTableForm.SetEnabledSelectFilteredRecordAction(
  const Enabled: Boolean);
begin

  actSelectFilteredData.Enabled := Enabled;
  
end;

procedure TDBDataTableForm.SetEnabledToActionTools(
  Value: Boolean;
  ExceptionalActionTools: array of TAction
);
var Component: TComponent;
    TraversalAction: TAction;
    ExceptionalActionTool: TAction;
    I: Integer;
begin

  for I := 0 to ComponentCount - 1 do begin

    Component := Components[I];
    
    if not (Component is TAction) then
      Continue;

    TraversalAction := Component as TAction;

    for ExceptionalActionTool in ExceptionalActionTools do
      if ExceptionalActionTool = TraversalAction then
        Break;

    if ExceptionalActionTool = TraversalAction then
      Continue;

    TraversalAction.Enabled := Value;
  
  end;

end;

procedure TDBDataTableForm.SetEnabledToActionToolsForViewOnly;
begin

  SetVisibleActions(
    False,
    [actAddData, actChangeData, actDeleteData]
  );
  
end;

procedure TDBDataTableForm.SetEnabledToGrid(Value: Boolean);
begin

  DataRecordGrid.Enabled := Value;
  
end;

procedure TDBDataTableForm.SetEnabledEditingOptionToGridColumns(Value: Boolean);
var GridColumn: TcxGridDBColumn;
    I: Integer;
begin

  for I := 0 to DataRecordGridTableView.ColumnCount - 1 do begin

    GridColumn := DataRecordGridTableView.Columns[I];
    
    GridColumn.Options.Editing := Value;
    
  end;

end;

procedure TDBDataTableForm.SetEnabledToSearchByColumnPanel(Value: Boolean);
begin

  SearchByColumnPanel.Enabled := Value;
  
end;

procedure TDBDataTableForm.SetEnableRecordGroupingByColumnsOption(
  const Value: Boolean);
var I: Integer;
    GroupedColumnIndices: TVariantList;
begin

  DataRecordGridTableView.OptionsCustomize.ColumnGrouping := Value;
  DataRecordGridTableView.OptionsView.GroupByBox := Value;

  if not Value then begin

    GroupedColumnIndices := TVariantList.Create;

    try

      for I := 0 to DataRecordGridTableView.ColumnCount - 1 do begin

        if DataRecordGridTableView.Columns[I].GroupIndex >= 0 then begin

          GroupedColumnIndices.Add(
            DataRecordGridTableView.Columns[I].Index
          );

        end;

        DataRecordGridTableView.Columns[I].GroupIndex := -1;

      end;

      if GroupedColumnIndices.IsEmpty then Exit;

      for I := 0 to DataRecordGridTableView.ColumnCount - 1 do begin

        if not
           GroupedColumnIndices.Contains(
              DataRecordGridTableView.Columns[I].Index
           )
        then Continue;
        
        if DataRecordGridTableView.Columns[i].VisibleForCustomization and
           (DataRecordGridTableView.Columns[I].DataBinding.FieldName <> '')

        then DataRecordGridTableView.Columns[I].Visible := True

        else DataRecordGridTableView.Columns[I].Visible := False;

      end;

    finally

      FreeAndNil(GroupedColumnIndices);

    end;

  end;

end;

procedure TDBDataTableForm.SetEnableSelectionColumn(const Value: Boolean);
begin

  IsSelectedColumn.Visible := Value;

  with DataRecordGridTableView do begin

    OptionsSelection.MultiSelect := Value;
    DataController.DataModeController.SmartRefresh := Value;
    IsSelectedColumn.DataBinding.FieldName := '';
    
    if Value then begin

      Controller.ClearSelection;

      if Assigned(FSelectedRecords) then
        FSelectedRecords.Clear;

      if not OptionsData.Editing then begin

        OptionsData.Editing := True;

        SetEnabledEditingOptionToGridColumns(False);

        IsSelectedColumn.Options.Editing := True;

      end;

    end;

  end;

end;

procedure TDBDataTableForm.SetExportDataActionVisible(const Enabled: Boolean);
begin

  actExportData.Visible := Enabled;

  ExportDataSeparator.Visible :=
    actExportData.Visible or actPrintData.Visible;

  SelectFilteredRecordsSeparator.Visible :=
    ExportDataSeparator.Visible or actExit.Visible;

end;

procedure TDBDataTableForm.SetFilterFormLastState(
  const Value: TTableViewFilterFormState);
begin

  FreeAndNil(FTableViewFilterFormLastState);
  
  FTableViewFilterFormLastState := Value;

  if Assigned(DataSet) and DataSet.Active then
    ApplyCurrentFilterFormState

  else FIsFilterFormLastStateApplyingRequested := True;

end;

procedure TDBDataTableForm.SetFocusedColumnByFieldName(
  const FieldName: String
);
var Column: TcxGridDBColumn;
begin

  if Assigned(DataSet) and DataSet.Active then begin

    Column := DataRecordGridTableView.GetColumnByFieldName(FieldName);

    if Assigned(Column) then begin

      SetSearchColumnNameLabelText(Column.Caption);

      Column.Focused := True;
      
    end;

  end

  else FFieldNameOfRequestedColumnForFocus := FieldName;

end;

procedure TDBDataTableForm.SetFocusedRecordId(const Value: Variant);
begin

  with DataRecordGridTableView.DataController do begin

    ClearSelection;

    FocusedRecordIndex := FindRecordIndexByKey(Value);

  end;

end;

procedure TDBDataTableForm.SetFont(const Value: TFont);
begin

  inherited Font := Value;

  {
  DataRecordGrid.Font := Value;
  DataOperationToolBar.Font := Value;
  DataLoadingCanceledPanel.Font := Value;
  WaitDataLoadingPanel.Font := Value;
  DataRecordMovingToolBar.Font := Value;
  SearchByColumnPanel.Font := Value;
  StatisticsInfoStatusBar.Font := Value;
  ClientAreaPanel.Font := Value;
   }
end;

procedure TDBDataTableForm.SetMultiSelectionModeEnabled(const Enabled: Boolean);
begin

  DataRecordGridTableView.OptionsSelection.MultiSelect := Enabled;
  
end;

procedure TDBDataTableForm.SetPrintDataActionVisible(const Enabled: Boolean);
begin

  actPrintData.Visible := Enabled;
  
end;

procedure TDBDataTableForm.SetRecordSelectedBySelectionColumn(
  RecordIndex: Integer;
  const Selected: Boolean
);
var
    SelectedRecordIndexKey: String;
begin

  if not EnableSelectionColumn then Exit;

  with DataRecordGridTableView.DataController do begin

    ChangeRowSelection(
      GetRowIndexByRecordIndex(RecordIndex, False),
      Selected
    );

    SelectedRecordIndexKey := IntToStr(RecordIndex);

    if not DataRecordGridTableView.OptionsSelection.MultiSelect then begin

      FSelectedByColumnRecordIndices.Restart;

      while FSelectedByColumnRecordIndices.Next do begin

        Values[
          FSelectedByColumnRecordIndices[
            FSelectedByColumnRecordIndices.CurrentKey
          ],
          IsSelectedColumn.Index
        ] := False

      end;

      
      FSelectedByColumnRecordIndices.Clear;

    end;

    if Selected then begin

      FSelectedByColumnRecordIndices[SelectedRecordIndexKey] :=
        RecordIndex;

    end

    else if FSelectedByColumnRecordIndices.Exists(SelectedRecordIndexKey)
    then FSelectedByColumnRecordIndices.Delete(SelectedRecordIndexKey);

  end;

end;

procedure TDBDataTableForm.SetRemoveRecordsActionVisible(
  const Enabled: Boolean);
begin

  if not ViewOnly then
    actDeleteData.Visible := Enabled;
  
end;

procedure TDBDataTableForm.SetRequestedFocusedRecord(
  const RecordKeyValue: Variant);
begin

  if
      (not Assigned(FDataSetOperationThread)) and
      (IsDataSetActive)

  then
    LocateRecord(
      DataRecordGridTableView.DataController.KeyFieldNames,
      RecordKeyValue
    )

  else
    FRequestedFocusedRecordKeyValue := RecordKeyValue;
  
end;

procedure TDBDataTableForm.SetSearchColumnNameLabelText(const Text: String);
begin

  SearchColumnNameLabel.Caption := Text;

  if SearchColumnNameLabel.Caption <> '' then begin

    if SearchColumnNameLabel.Caption = NO_SELECTED_SEARCH_COLUMN_CAPTION
    then begin

      SearchColumnNameLabel.Font.Color := clRed;

      SearchColumnValueEdit.Enabled := False;

    end

    else begin

      SearchColumnNameLabel.Font.Color := Font.Color;
      
      SearchColumnValueEdit.Enabled := True;

    end;

  end

  else SearchColumnValueEdit.Enabled := False;

  AdjustSearchByColumnPanel;

end;

procedure TDBDataTableForm.SetSelectedRecordsByIds(RecordIds: TVariantList;
  const Selected: Boolean);
var
    FocusedRecordIndex, RecordIndex: Integer;
    RowIndex: Integer;
    RecordId: Variant;
begin

  if not Assigned(RecordIds) or RecordIds.IsEmpty then Exit;
  
  with DataRecordGridTableView do begin

    FocusedRecordIndex := DataController.FocusedRecordIndex;

    try

      DataController.BeginUpdate;

      for RecordId in RecordIds do begin

        RecordIndex := DataController.FindRecordIndexByKey(RecordId);

        if RecordIndex < 0 then Continue;

        if EnableSelectionColumn then begin

          DataController.Values[RecordIndex, IsSelectedColumn.Index] := Selected;

          SetRecordSelectedBySelectionColumn(RecordIndex, Selected);

        end

        else begin

          ViewData.Records[RowIndex].Selected := Selected;

        end;

      end;

    finally

      DataController.EndUpdate;

    end;

  end;

end;

procedure TDBDataTableForm.SetSelectFilteredRecordActionVisible(
  const Enabled: Boolean);
begin

  actSelectFilteredData.Visible := Enabled;
  
end;

procedure TDBDataTableForm.SetTotalRecordCountPanelVisible(
  const Visible: Boolean);
begin

end;

procedure TDBDataTableForm.SetUserLoginPanelVisible(const Visible: Boolean);
begin

  if not Visible then
    StatisticsInfoStatusBar.Panels.Delete(1);
  
end;

procedure TDBDataTableForm.SetViewOnly(const Value: Boolean);
var ExceptionalActionTools: array of TAction;
begin

  FViewOnly := Value;

  if FViewOnly then
    SetEnabledToActionToolsForViewOnly

  else UpdateModificationDataActions;

  SetEnabledEditingOptionToGridColumns(not FViewOnly);

end;

procedure TDBDataTableForm.ShowTableViewFilterForm;
begin

  if not Assigned(FTableViewFilterForm) then begin

      Screen.Cursor := crHourGlass;

      FTableViewFilterForm :=

        TTableViewFilterForm.CreateTableViewFilterForm(
          GetTableViewFilterFormClass,
          nil,
          Self,
          CustomizeTableViewFilterForm
        );
      
      CustomizeTableViewFilterForm(FTableViewFilterForm);

      FTableViewFilterForm.DataSetTableView := DataRecordGridTableView;

      if FMustSaveFilterFormStateBeforeClosing then begin

        FTableViewFilterForm.MustSaveStateBeforeClosing := True;
        FTableViewFilterForm.LastState := FTableViewFilterFormLastState;

      end;

      FTableViewFilterForm.Show;

      Screen.Cursor := crDefault;
      
      FTableViewFilterForm.OnClose := OnCloseTableViewFilterFormHandle;
      FTableViewFilterForm.OnDataSetFiltering := OnDataSetFilteringHandle;
      FTableViewFilterForm.OnDataSetFiltered := OnDataSetFilteredHandle;

  end

  else begin

    if FTableViewFilterForm.WindowState = wsMinimized then
      FTableViewFilterForm.WindowState := wsNormal;

    FTableViewFilterForm.SetFocus;

  end;

end;

procedure TDBDataTableForm.CloseTableViewFilterForm;
begin

  if Assigned(FTableViewFilterForm) then begin

    FTableViewFilterForm.Close;

  end;

end;

procedure TDBDataTableForm.UpdateDataOperationControls;
var
    FocusedColumn: TcxGridDBColumn;
begin

  if not HasDataSetRecords then begin

    SearchColumnValueEdit.Text := '';

    SetSearchColumnNameLabelText('');

  end

  else begin

    if FFieldNameOfRequestedColumnForFocus <> '' then begin

      SetFocusedColumnByFieldName(FFieldNameOfRequestedColumnForFocus);

      FFieldNameOfRequestedColumnForFocus := '';

    end

    else begin

      FocusedColumn :=
        TcxGridDBColumn(DataRecordGridTableView.Controller.FocusedColumn);

      if not Assigned(FocusedColumn) then
        SetSearchColumnNameLabelText(NO_SELECTED_SEARCH_COLUMN_CAPTION)

      else SetSearchColumnNameLabelText(FocusedColumn.Caption);

    end;
    
  end;

  SetEnabledActions(True, [actRefreshData]);

  SetEnabledActions(
    HasDataSetRecords,
    [
      actCopySelectedDataRecords,
      actExportData,
      actPrintData,
      actFirstDataRecord,
      actNextDataRecord,
      actPrevDataRecord,
      actLastDataRecord
    ]
  );

  SetEnabledControls(
    (SearchColumnNameLabel.Caption <> NO_SELECTED_SEARCH_COLUMN_CAPTION)
    and
    (SearchColumnNameLabel.Caption <> ''),
    [SearchColumnValueEdit]
  );

  SetEnabledActions(
    IsDataSetActive,
    [actSelectFilteredData]
  );

  UpdateMovingDataRecordActionsActivity;

  if FViewOnly then
    SetEnabledToActionToolsForViewOnly

  else begin

    SetEnabledActions(IsDataSetActive, [actAddData]);

  end;

  if HasDataSetRecords then
    UpdateChooseRecordsAction;
                       
end;

procedure TDBDataTableForm.UpdateFocusedCellAndSelectedRecordGraphics(
  AViewCellInfo: TcxGridTableDataCellViewInfo; ACanvas: TcxCanvas);
begin

  if AViewCellInfo.GridRecord.Selected then begin

    ACanvas.Brush.Color := FSelectedRecordsColor;
    ACanvas.Font.Color := FSelectedRecordsTextColor;
    
  end

  else if AViewCellInfo.Focused then begin

    ACanvas.Brush.Color := FFocusedCellColor;
    ACanvas.Font.Color := FFocusedCellTextColor;

  end;
  
end;

procedure TDBDataTableForm.UpdateLayout;
begin

  DataRecordGridTableView.LayoutChanged;
  
end;

procedure TDBDataTableForm.UpdateSearchNextOccurrenceToolsActivity;
begin                      

//  actPrevFoundOccurrence.Enabled := not IsDataSetAtFirstRecord(DataSet);
//  actNextFoundOccurrence.Enabled := not IsDataSetAtLastRecord(DataSet);

  actPrevFoundOccurrence.Enabled := not DataRecordGridTableView.DataController.IsBOF;
  actNextFoundOccurrence.Enabled := not DataRecordGridTableView.DataController.IsEOF;

end;

procedure TDBDataTableForm.UpdateStatusBar;
var
    TotalRecordCount: Integer;
    UserName, DatabaseName: String;
begin

  if not IsDataSetActive then  begin

    TotalRecordCount := 0;
    UserName := '';
    DatabaseName := '';

  end

  else begin

    TotalRecordCount := DataSet.RecordCount;

    if DataSet is TZAbstractRODataSet then
      with TZAbstractRODataSet(DataSet) do begin
    
        UserName := Connection.User;
        DatabaseName := Connection.Database;

      end;

  end;

  UpdateTotalRecordCountPanel;
  UpdateUserPanel;
  UpdateDatabaseNamePanel;

end;

procedure TDBDataTableForm.UpdateStatusBarPanelWidth(const PanelIndex: Integer);
var StatusPanel: TStatusPanel;
begin

  StatusPanel := StatisticsInfoStatusBar.Panels[PanelIndex];
  StatusPanel.Width := StatisticsInfoStatusBar.Canvas.TextWidth(StatusPanel.Text) +
    PANEL_CONTENT_MARGIN_RIGHT;

end;

procedure TDBDataTableForm.UpdateTotalRecordCountPanel;
var TotalRecordCount: Integer;
begin

  if not IsDataSetActive then
    TotalRecordCount := 0

  else TotalRecordCount := DataSet.RecordCount;

  OnUpdateTotalRecordCountPanel(TotalRecordCount);

end;

procedure TDBDataTableForm.UpdateUIAfterFailedDataLoading(
  const ErrorMessage: String
);
begin

  ShowWaitingDataLoadingPanel(False);

  EndUpdateGridTableView;
  
  UpdateMainUI;

  if ErrorMessage <> '' then
    ShowErrorMessage(Self.Handle, ErrorMessage, 'Ошибка');
  
end;

procedure TDBDataTableForm.UpdateUIAfterSuccessDataLoading;
var CurrentFocusedRecordKeyValue: Variant;
begin

  ShowWaitingDataLoadingPanel(False);

  if DataRecordGridTableView.ColumnCount = 0 then
    DataRecordGridTableView.DataController.CreateAllItems;

  if FIsFilterFormLastStateApplyingRequested then begin

    ApplyCurrentFilterFormState;
    
    FIsFilterFormLastStateApplyingRequested := False;

  end;
  
  if FLastOperation = opRefreshRecords then begin

    if not VarIsNull(FRequestedFocusedRecordKeyValue) then begin

      CurrentFocusedRecordKeyValue := FRequestedFocusedRecordKeyValue;
      FRequestedFocusedRecordKeyValue := Null;

    end

    else if not VarIsNull(FLastFocusedRecordKeyValue) then
      CurrentFocusedRecordKeyValue := FLastFocusedRecordKeyValue;

    if not VarIsEmpty(CurrentFocusedRecordKeyValue) then begin

      LocateRecord(
        DataRecordGridTableView.DataController.KeyFieldNames,
        CurrentFocusedRecordKeyValue
      );

    end;

  end;

  FSelectedByColumnRecordIndices.Clear;

  MoveToAddedRecordAfterAdding;
  RestorePreviousChangingRecordLocation;

  EndUpdateGridTableView;

  SelectCurrentDataRecordAsTopRow;

  UpdateMainUI;

end;

procedure TDBDataTableForm.UpdateUserPanel;
var UserName: String;
begin

  if not IsDataSetActive then
    UserName := ''

  else if DataSet is TZAbstractRODataSet then
    UserName := (DataSet as TZAbstractRODataSet).Connection.User;

  OnUpdateUserPanel(UserName);

end;

procedure TDBDataTableForm.UpdateChooseRecordsAction;
begin

  actChooseRecords.Enabled := SelectedRecordCount > 0;

end;

procedure TDBDataTableForm.UpdateDatabaseNamePanel;
var DatabaseName: String;
begin

  if not IsDataSetActive then
    DatabaseName := ''

  else if DataSet is TZAbstractDataset then
   DatabaseName := (DataSet as TZAbstractDataset).Connection.Database;

  OnUpdateDatabaseNamePanel(DatabaseName);

end;

procedure TDBDataTableForm.UpdateMainUI;
begin

  UpdateDataOperationControls;
  UpdateStatusBar;

  if not DataRecordGrid.Visible then
    DataRecordGrid.Show;

  Screen.Cursor := crDefault;

end;

procedure TDBDataTableForm.UpdateModificationDataActions;
begin

  SetEnabledActions(not FViewOnly, [actAddData]);
  
  SetEnabledActions(
    ((SelectedRecordCount > 0) or Assigned(DataRecordGridTableView.Controller.FocusedRecord)) and not FViewOnly,
    [actDeleteData, actChangeData]
  );

end;

procedure TDBDataTableForm.UpdateMovingDataRecordActionsActivity;
begin

  SetEnabledActions(
    DataRecordGridTableView.DataController.FocusedRowIndex > 0,
    [actPrevDataRecord, actFirstDataRecord]
  );

  SetEnabledActions(
    DataRecordGridTableView.DataController.FocusedRowIndex <
    (DataRecordGridTableView.DataController.RecordCount - 1),
    [actNextDataRecord, actLastDataRecord]
  );

end;

function TDBDataTableForm.OnAddRecord: Boolean;
begin

  Result := False;
  
  try

    Screen.Cursor := crHourGlass;

    DataSet.Append;

    Result := True;

  finally

    Screen.Cursor := crDefault;

  end;

end;

function TDBDataTableForm.OnChangeRecord: Boolean;
begin

  Result := False;

  try

    Screen.Cursor := crHourGlass;

    DataSet.Edit;
    DataSet.Post;

    Result := True;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDBDataTableForm.HandleSelectedRow(RowIndex: Integer; RowInfo: TcxRowInfo);
var DataSetField: TField;
    InternalSelectedRecord: TDBDataTableRecord;
    GridColumn: TcxGridDBColumn;
begin

  InternalSelectedRecord := CreateTableRecordViewModelFor(RowIndex);

  FSelectedRecords.AddRecord(InternalSelectedRecord);

end;

procedure TDBDataTableForm.OnChooseRecords;
var SelectedRowIndex: Integer;
    DataSetField: TField;
    InternalSelectedRecord: TDBDataTableRecord;
    GridColumn: TcxGridDBColumn;
begin

  try

    with DataRecordGridTableView.Controller do begin

      if SelectedRecordCount <= 0 then begin

        ShowInfoMessage(
          Self.Handle,
          'Ни одна запись не была выбрана. ' +
          'Необходимо, по меньшей мере, выбрать хотя бы одну запись',
          'Сообщение'
        );
        Exit;

      end;

      FSelectedRecords := CreateAndFillSelectedRecords;

    end;

    if Assigned(FOnRecordsChoosedEventHandler) then
      FOnRecordsChoosedEventHandler(Self, FSelectedRecords);

    ModalResult := mrOk;
    CloseModal;

  except

    on e: Exception do begin

      FreeAndNil(FSelectedRecords);
      ShowErrorMessage(Self.Handle, e.Message, 'Ошибка');
      
    end;

  end;

end;

function TDBDataTableForm.OnDeleteCurrentRecord: Boolean;
begin

  Result := False;
  DataSet.Delete;
  Result := True;
  
end;

function TDBDataTableForm.OnDeleteRecords: Integer;
var I: Integer;
begin

  Result := 0;

  if DataRecordGridTableView.Controller.SelectedRecordCount = 0 then
    Exit;

  if ShowQuestionMessage(
        Self.Handle,
        GetMessageAboutThatUserAssuredThatWantDeleteSelectedRecords,
        'Вопрос'
     ) = IDNO

  then Exit;

  try

    Screen.Cursor := crHourGlass;

    for
      I := DataRecordGridTableView.Controller.SelectedRecordCount - 1
      downto 0
    do begin

      DataRecordGridTableView.DataController.FocusedRecordIndex :=
        DataRecordGridTableView.Controller.SelectedRecords[I].RecordIndex;

      try

        if OnDeleteCurrentRecord then Inc(Result);

      except

        on e: Exception do begin

          raise;
          
        end;

      end;

    end;                       
    
    DataRecordGridTableView.Controller.ClearSelection;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDBDataTableForm.OnCloseTableViewFilterFormHandle(Sender: TObject;
  var Action: TCloseAction);
begin

  if FMustSaveFilterFormStateBeforeClosing then begin

    FreeAndNil(FTableViewFilterFormLastState);

    FTableViewFilterFormLastState := FTableViewFilterForm.LastState;

  end;

  Action := caFree;
  FTableViewFilterForm := nil;

end;

procedure TDBDataTableForm.OnCopySelectedDataRecords;
begin

  DataRecordGridTableView.CopyToClipboard(False);

end;

procedure TDBDataTableForm.OnDataExport;
begin

  with ExportDataToolButton, ClientToScreen(Point(0, Height)) do
    ExportDataPopupMenu.Popup(X, Y);

end;

procedure TDBDataTableForm.OnDataLoadingCancelledHandle(Sender: TObject);
begin

  OnDataLoadingCancelledHandle(Sender, FIsDestroyingRequested);

end;

procedure TDBDataTableForm.OnDataLoadingErrorOccurredHandle(
  Sender: TObject;
  DataSet: TDataSet;
  const Error: Exception;
  RelatedState: TObject
);
begin

  OnDataLoadingErrorOccurredHandle(
    Sender, DataSet, Error, RelatedState, FIsDestroyingRequested
  );

end;

procedure TDBDataTableForm.OnDataLoadingSuccessHandle(
  Sender: TObject;
  DataSet: TDataSet;
  RelatedState: TObject
);
begin

  OnDataLoadingSuccessHandle(Sender, DataSet, RelatedState, FIsDestroyingRequested);
  
end;

procedure TDBDataTableForm.OnDataSetInsertedRecord(DataSet: TDataSet);
begin

  UpdateMainUI;
  
end;

procedure TDBDataTableForm.OnDataSetCancellationForDestroyingEventHandler(
  Sender: TObject);
begin

  FDataSetOperationCancellationForDestroyingRequested := False;

  Free;
  
end;

procedure TDBDataTableForm.OnDataSetDeletedRecord(DataSet: TDataSet);
begin

  UpdateMainUI;
  
end;

procedure TDBDataTableForm.OnDataSetFilteredHandle(
  Sender: TObject;
  DataSet: TDataSet;
  Filtered: Boolean
);
begin

  UpdateTotalRecordCountPanel;
  DataOperationToolBar.Repaint;

end;

procedure TDBDataTableForm.OnDataSetFilteringHandle(
  Sender: TObject;
  DataSet: TDataSet
);
begin

  inherited;

end;

procedure TDBDataTableForm.OnExit;
begin

  DestroyDataSetOperationThread;
  Close;

end;

procedure TDBDataTableForm.OnPrintData;
begin

end;

procedure TDBDataTableForm.OnSelectFilteredDataRecords;
var TableViewFilterForm: TTableViewFilterForm;
begin

  ShowTableViewFilterForm;

end;

procedure TDBDataTableForm.OnRefreshRecords;
begin

  if not Assigned(DataSet) then Exit;
  
  RefreshRecordsInBackground;

end;

procedure TDBDataTableForm.SafeDestroy;
begin

  if RequestDataSetOperationCancellationForDestroying = ocNotRequired then
    Destroy;
    
end;

procedure TDBDataTableForm.SaveCurrentSelectedRecordLocation;
var IndexField: TField;
    KeyFieldNames, KeyFieldName: string;
    KeyColumnIndex, FocusedRecordIndex: Integer;
    KeyColumn: TcxGridDBColumn;
begin

  KeyFieldNames := DataRecordGridTableView.DataController.KeyFieldNames;
  
  if KeyFieldNames = '' then Exit;

  FLastSelectedRecordIndexFieldNames.Clear;
  FLastSelectedRecordIndexFieldValues.Clear;
  
  FLastSelectedRecordIndexFieldNames.Text := KeyFieldNames;

  FocusedRecordIndex :=
      DataRecordGridTableView.DataController.FocusedRecordIndex;
      
  for KeyFieldName in FLastSelectedRecordIndexFieldNames do begin

    KeyColumn :=
      DataRecordGridTableView.GetColumnByFieldName(KeyFieldName);

    if not Assigned(KeyColumn) then Exit;

    KeyColumnIndex := KeyColumn.Index;

    FLastSelectedRecordIndexFieldValues.Add(
      DataRecordGridTableView.DataController.Values[FocusedRecordIndex, KeyColumnIndex]
    );
    
  end;

end;

procedure TDBDataTableForm.SavePreviousDataSetEventHandlers(ADataSet: TDataSet);
begin

  with ADataSet do begin

    FPreviousDataSetAfterInsert := AfterInsert;
    FPreviousDataSetAfterDelete := AfterDelete;
    FPreviousDataSetAfterPost := AfterPost;

  end;

end;

procedure TDBDataTableForm.RestorePreviousCurrentSelectedRecordLocation;
var KeyFieldValueArrayVariant: Variant;
    KeyFieldValueVariant: Variant;
    I: Integer;
begin

  if (FLastSelectedRecordIndexFieldNames.Count = 0) or
     (FLastSelectedRecordIndexFieldValues.Count = 0)
  then Exit;

  KeyFieldValueArrayVariant :=
    VarArrayCreate(
      [0, FLastSelectedRecordIndexFieldValues.Count - 1],
      varVariant
    );

  for I := 0 to FLastSelectedRecordIndexFieldValues.Count - 1 do
    KeyFieldValueArrayVariant[I] := FLastSelectedRecordIndexFieldValues[I];

  DataSet.Locate(
    FLastSelectedRecordIndexFieldNames.Text,
    KeyFieldValueArrayVariant,
    [loPartialKey, loCaseInsensitive]
  );

  SelectCurrentDataRecordAsTopRow;

end;

procedure TDBDataTableForm.RestorePreviousDataSetEventHandlers(
  ADataSet: TDataSet);
begin

  with ADataSet do begin

    AfterInsert := FPreviousDataSetAfterInsert;
    AfterDelete := FPreviousDataSetAfterDelete;
    AfterPost := FPreviousDataSetAfterPost;
    
  end;

end;

procedure TDBDataTableForm.RestorePreviousChangingRecordLocation;
begin

  if FLastOperation = opChangeRecord then
    RestorePreviousCurrentSelectedRecordLocation;

end;

procedure TDBDataTableForm.SearchColumnValueEditChange(Sender: TObject);
begin

  if SearchByENTERCheckBox.Checked then Exit;

  LocateRecordBySelectedColumnValue;

end;

procedure TDBDataTableForm.SearchColumnValueEditKeyPress(Sender: TObject;
  var Key: Char);
begin

  if not SearchByENTERCheckBox.Checked then Exit;

  if Key = #13 then
    LocateRecordBySelectedColumnValue;
  
end;

procedure TDBDataTableForm.SelectCurrentDataRecord;
begin

  if not Assigned(DataRecordGridTableView.Controller.FocusedRecord)
  then Exit;

  DataRecordGridTableView.Controller.ClearSelection;
  DataRecordGridTableView.Controller.FocusedRecord.Selected := True;

end;

procedure TDBDataTableForm.SelectCurrentDataRecordAsTopRow;
begin

  DataRecordGridTableView.Controller.TopRowIndex :=
    DataRecordGridTableView.Controller.FocusedRowIndex;
    
  SelectCurrentDataRecord;

end;

procedure TDBDataTableForm.SelectDataRecord(const KeyFieldNames: String;
  const KeyFieldValues: Variant);
begin

  DataSet.Locate(KeyFieldNames, KeyFieldValues, []);

  SelectCurrentDataRecord;

end;

procedure TDBDataTableForm.SelectRecordsByIds(RecordIds: TVariantList);
begin

  SetSelectedRecordsByIds(RecordIds, True);

end;

procedure TDBDataTableForm.ShowWaitingDataLoadingPanel(
  const Show: Boolean);
begin

  SetVisibleControls(Show, [WaitDataLoadingPanel]);

  AnimDataLoading.Active := Show;

  if Show then
    CenterWindowRelative(WaitDataLoadingPanel, ClientAreaPanel);

end;

procedure TDBDataTableForm.ShowDataLoadingCanceledPanel(
  const Show: Boolean);
begin

  SetVisibleControls(Show, [DataLoadingCanceledPanel]);

  if Show then
    CenterWindowRelative(DataLoadingCanceledPanel, ClientAreaPanel);

end;

procedure TDBDataTableForm.ShowDataLoadingWaitOrCancellationControls(
  const ShowWaitOrCancellationControls: TShowWaitOrCancellationControls
);
begin

  DataRecordGrid.Hide;
  
  ShowWaitingDataLoadingPanel(ShowWaitOrCancellationControls = ShowWaitControls);
  ShowDataLoadingCanceledPanel(not (ShowWaitOrCancellationControls = ShowWaitControls));

end;

procedure TDBDataTableForm.ShowStatisticsStatusPanel(
  const StatisticsStatusPanel: TStatisticsStatusPanel);
var StatusPanelIndex: Integer;
begin

  case StatisticsStatusPanel of

    spTotalRecordCountPanel:

      StatusPanelIndex := TOTAL_RECORD_PANEL_INDEX;

    spDatabaseNamePanel:

      StatusPanelIndex := DATABASE_NAME_PANEL_INDEX;

    spUserLoginPanel:

      StatusPanelIndex := USER_NAME_PANEL_INDEX;

  end;

  StatisticsInfoStatusBar.Panels.Insert(StatusPanelIndex);
  
end;

procedure TDBDataTableForm.SetActivatedDataOperationControls(
  const Activated: Boolean);
begin

  SetEnabledActions(Activated,
    [actAddData, actChooseRecords, actChangeData, actDeleteData, actRefreshData,
     actFirstDataRecord, actCopySelectedDataRecords, actPrevDataRecord, actNextDataRecord,
     actLastDataRecord, actExportData, actPrintData, actSelectFilteredData]);

  SetEnabledControls(Activated, [SearchColumnValueEdit]);

end;

procedure TDBDataTableForm.SetAddRecordActionVisible(const Enabled: Boolean);
begin

  if not ViewOnly then
    actAddData.Visible := Enabled;
  
end;

procedure TDBDataTableForm.SetChangeRecordActionVisible(const Enabled: Boolean);
begin

  if not ViewOnly then
    actChangeData.Visible := Enabled;
  
end;

procedure TDBDataTableForm.SetChooseRecordActionVisible(const Enabled: Boolean);
begin

  actChooseRecords.Visible := Enabled;
  ChooseRecordsSeparator.Visible := Enabled;

end;

procedure TDBDataTableForm.SetConnection(const Connection: TZConnection);
begin

  if DataSet is TZAbstractRODataSet then
    (DataSet as TZAbstractRODataSet).Connection := Connection;

end;

procedure TDBDataTableForm.OnUpdateDatabaseNamePanel(
  const DatabaseName: String);
begin

  if StatisticsInfoStatusBar.Panels.Count <= DATABASE_NAME_PANEL_INDEX
  then Exit;

  StatisticsInfoStatusBar.Panels[DATABASE_NAME_PANEL_INDEX].Text :=
    GetDatabaseNamePanelLabel + DatabaseName;

  UpdateStatusBarPanelWidth(DATABASE_NAME_PANEL_INDEX);

end;

procedure TDBDataTableForm.OnUpdateTotalRecordCountPanel(
  const TotalRecordCount: Integer);
begin

  if StatisticsInfoStatusBar.Panels.Count <= TOTAL_RECORD_PANEL_INDEX
  then Exit;
  
  StatisticsInfoStatusBar.Panels[TOTAL_RECORD_PANEL_INDEX].Text :=
    GetTotalRecordCountPanelLabel + IntToStr(TotalRecordCount);

  UpdateStatusBarPanelWidth(TOTAL_RECORD_PANEL_INDEX);

end;

procedure TDBDataTableForm.OnUpdateUserPanel(const UserName: String);
begin

  if StatisticsInfoStatusBar.Panels.Count <= USER_NAME_PANEL_INDEX
  then Exit;
  
  StatisticsInfoStatusBar.Panels[USER_NAME_PANEL_INDEX].Text :=
    GetUserLoginPanelLabel + UserName;

  UpdateStatusBarPanelWidth(USER_NAME_PANEL_INDEX);

end;

procedure TDBDataTableForm.OnDataLoadingCancelledHandle(Sender: TObject;
  const IsDestroyingRequested: Boolean);
begin

  if not Assigned(FDataSetOperationThread) then Exit;

  FDataSetOperationThread := nil;

  // Отображение элементов управления, сообщающих об отмененной
  // операции загрузки данных
  ShowDataLoadingWaitOrCancellationControls(ShowCancellationControls);

  EndUpdateGridTableView;
  //AttachDataSet(FDataSetOperationThread.DataSet);

  if FreeIfDestroyingRequested then Exit;

  // Обновление интерфейса
  UpdateMainUI;

  FSelectedByColumnRecordIndices.Clear;

end;

procedure TDBDataTableForm.OnDataLoadingErrorOccurredForDestroyingEventHandler(
  Sender: TObject;
  DataSet: TDataSet;
  const Error: Exception;
  RelatedState: TObject
);
begin

  FDataSetOperationCancellationForDestroyingRequested := False;

  Free;

end;

procedure TDBDataTableForm.OnDataLoadingErrorOccurredHandle(Sender: TObject;
  DataSet: TDataSet; const Error: Exception; RelatedState: TObject;
  const IsDestroyingRequested: Boolean);
begin

  if not Assigned(FDataSetOperationThread) then Exit;

  FDataSetOperationThread := nil;

  if FreeIfDestroyingRequested then Exit;

  UpdateUIAfterFailedDataLoading(Error.Message);

  FSelectedByColumnRecordIndices.Clear;

end;

procedure TDBDataTableForm.OnDataLoadingSuccessForDestroyingEventHandler(
  Sender: TObject;
  DataSet: TDataSet;
  RelatedState: TObject
);
begin

  FDataSetOperationCancellationForDestroyingRequested := False;

  Free;

end;

procedure TDBDataTableForm.OnDataLoadingSuccessHandle(
  Sender: TObject;
  DataSet: TDataSet; RelatedState: TObject;
  const IsDestroyingRequested: Boolean
);
begin

  if not Assigned(FDataSetOperationThread) then Exit;

  FDataSetOperationThread := nil;

  if FreeIfDestroyingRequested then Exit;

  UpdateUIAfterSuccessDataLoading;

  if Assigned(FOnRecordsRefreshedEventHandler) then
    FOnRecordsRefreshedEventHandler(Self);

end;

{ TDBDataTableRecordField }

constructor TDBDataTableRecordField.Create(const AName: String;
  const AValue: Variant);
begin

  inherited Create;

  FName := AName;
  FValue := AValue;

end;

destructor TDBDataTableRecordField.Destroy;
begin

  inherited;

end;

{ TDBDataTableRecordFieldsEnumerator }

constructor TDBDataTableRecordFieldsEnumerator.Create(
  Fields: TDBDataTableRecordFields);
begin

  inherited Create(Fields);

end;

function TDBDataTableRecordFieldsEnumerator.GetCurrentDBDataTableRecordField: TDBDataTableRecordField;
begin

  Result := TDBDataTableRecordField(GetCurrent);

end;

{ TDBDataTableRecordFields }

function TDBDataTableRecordFields.AddField(Field: TDBDataTableRecordField): Integer;
begin

  Result := Add(Field);

end;

function TDBDataTableRecordFields.AddField(const Name: WideString;
  const Value: Variant): Integer;
begin

  AddField(TDBDataTableRecordField.Create(Name, Value));
  
end;

procedure TDBDataTableRecordFields.Clear;
var Field: TDBDataTableRecordField;
begin

  FreeFields;
    
  inherited;

end;

procedure TDBDataTableRecordFields.DeleteByName(const Name: String);
var DeletableFieldIndex: Integer;
    Field: TDBDataTableRecordField;
    z: Variant;
begin
                                               z := Null;
  FindAndHandleField(Name, DeleteByNameFieldHandler, z);

end;

procedure TDBDataTableRecordFields.DeleteByNameFieldHandler(
  Field: TDBDataTableRecordField; const Index: Integer;
  var ArbitraryData: Variant);
begin

  Delete(Index);
  Field.Free;

end;

destructor TDBDataTableRecordFields.Destroy;
begin

  inherited;

end;

procedure TDBDataTableRecordFields.FindAndHandleField(
  const FieldName: String;
  FieldHandler: TFieldHandler;
  var ArbitraryData: Variant
);
var FieldIndex: Integer;
    Field: TDBDataTableRecordField;
begin

  for FieldIndex := 0 to Count - 1 do begin

    Field := Self[FieldIndex];

    if Field.Name = FieldName then begin

      FieldHandler(Field, FieldIndex, ArbitraryData);
      Exit;

    end;

  end;

end;

procedure TDBDataTableRecordFields.FreeFields;
var Field: TDBDataTableRecordField;
begin

  for Field in Self do begin

    Field.Free;

  end;

end;

function TDBDataTableRecordFields.GetDBDataTableRecordFieldByIndex(Index: Integer): TDBDataTableRecordField;
begin

  Result := TDBDataTableRecordField(Get(Index));

end;

function TDBDataTableRecordFields.GetDBDataTableRecordFieldByName(
  Name: String
): TDBDataTableRecordField;
var FieldHolderVariant: Variant;
    FieldVarData: TVarData;
begin

  FindAndHandleField(Name, GetFieldByNameFieldHandler, FieldHolderVariant);

  FieldVarData := TVarData(FieldHolderVariant);

  if not Assigned(FieldVarData.VPointer) then
    Result := nil
  
  else Result := TDBDataTableRecordField(TVarData(FieldHolderVariant).VPointer);
  
end;

function TDBDataTableRecordFields.GetEnumerator: TDBDataTableRecordFieldsEnumerator;
begin

  Result := TDBDataTableRecordFieldsEnumerator.Create(Self);

end;

procedure TDBDataTableRecordFields.GetFieldByNameFieldHandler(
  Field: TDBDataTableRecordField; const Index: Integer;
  var ArbitraryData: Variant);
begin

  TVarData(ArbitraryData).VType := varByRef;
  TVarData(ArbitraryData).VPointer := Field;
  
end;

{ TDBDataTableRecord }

function TDBDataTableRecord.AddField(Field: TDBDataTableRecordField): Integer;
begin

  Result := FFields.Add(Field);

end;

function TDBDataTableRecord.AddField(const Name: WideString;
  const Value: Variant): Integer;
begin

  Result := FFields.AddField(Name, Value);
  
end;

constructor TDBDataTableRecord.Create;
begin

  inherited;

  FFields := TDBDataTableRecordFields.Create;

end;

procedure TDBDataTableRecord.DeleteField(Index: Integer);
begin

  FFields.Delete(Index);

end;

procedure TDBDataTableRecord.DeleteField(const Name: String);
begin

  FFields.DeleteByName(Name);

end;

destructor TDBDataTableRecord.Destroy;
begin

  FreeAndNil(FFields);
  inherited;

end;

function TDBDataTableRecord.GetFieldByIndex(
  const Index: Integer): TDBDataTableRecordField;
begin

  Result := FFields[Index];

end;

function TDBDataTableRecord.GetFieldCount: Integer;
begin

  Result := FFields.Count;

end;

function TDBDataTableRecord.GetFieldValueByIndex(Index: Integer): Variant;
begin

  Result := FFields[Index].Value;

end;

function TDBDataTableRecord.GetFieldValueByName(Name: String): Variant;
var Field: TDBDataTableRecordField;
begin

  Field := FFields[Name];

  if not Assigned(Field) then
    Result := Null

  else Result := FFields[Name].Value;

end;

{ TDBDataTableRecordsEnumerator }

constructor TDBDataTableRecordsEnumerator.Create(
  DBDataTableRecords: TDBDataTableRecords);
begin

  inherited Create(DBDataTableRecords);

  FDBDataTableRecords := DBDataTableRecords;
  
end;

function TDBDataTableRecordsEnumerator.GetCurrentDBDataTableRecord: TDBDataTableRecord;
begin

  Result := TDBDataTableRecord(GetCurrent);

end;

{ TDBDataTableRecords }

function TDBDataTableRecords.AddRecord(
  DBDataTableRecord: TDBDataTableRecord): Integer;
begin

  Result := Add(Pointer(DBDataTableRecord));

end;

procedure TDBDataTableRecords.Clear;
begin

  FreeRecords;

  inherited;

end;

destructor TDBDataTableRecords.Destroy;
begin

  inherited;

end;

function TDBDataTableRecords.FetchFieldValues(
  const FieldName: String): TVariantList;
var
   DBRecord: TDBDataTableRecord;
   DBField: TDBDataTableRecordField;
begin

  Result := TVariantList.Create;

  try
  
    for DBRecord in Self do begin
  
      for DBField in DBRecord.Fields do begin
      
        if DBField.Name = FieldName then
          Result.Add(DBField.Value);
        
      end;
      
    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;
  
end;

procedure TDBDataTableRecords.FreeRecords;
var DBDataTableRecord: TDBDataTableRecord;
begin

  for DBDataTableRecord in Self do begin

    DBDataTableRecord.Free;

  end;

end;

function TDBDataTableRecords.GetDBDataTableRecordByIndex(
  Index: Integer): TDBDataTableRecord;
begin

  Result := TDBDataTableRecord(Get(Index));

end;

function TDBDataTableRecords.GetEnumerator: TDBDataTableRecordsEnumerator;
begin

  Result := TDBDataTableRecordsEnumerator.Create(Self);
  
end;

initialization

cxSetResourceString(@scxGridGroupByBoxCaption,
    'Переносите в данную область заголовоки столбцов для группировки ' +
     'записей по ним');

end.
