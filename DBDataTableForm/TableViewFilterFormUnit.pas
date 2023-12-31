unit TableViewFilterFormUnit;

// Data Set Filtering Form for Dev Express Table View
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, Grids, Calendar, Spin,
  RegExprValidateEditUnit, ValidateEditUnit, ComCtrls, ExtCtrls, Math,
  ZDataset, ZAbstractDataset, ShellAPI, StrUtils, ZMatchPattern,
  StackedControlUnit, SimpleDateRangePanelUnit, Cloneable, Menus, cxButtons,
  RegExprValidateRichEdit, RegExprValidateMemoUnit, VariantListUnit;

const

  TEXT_FIELD_DEFAULT_WIDTH = 200;

  FILTER_SCROLL_BOX_LEFT_MARGIN = 3;
  FILTER_SCROLL_BOX_TOP_MARGIN = 16;
  FILTER_SCROLL_BOX_RIGHT_MARGIN = 3;
  FILTER_SCROLL_BOX_BOTTOM_MARGIN = 3;
  
  FILTER_FIELD_LAYOUT_LEFT_MARGIN = 10;
  FILTER_FIELD_LAYOUT_TOP_MARGIN = 15;
  FILTER_FIELD_LAYOUT_RIGHT_MARGIN = 10;
  FILTER_FIELD_LAYOUT_BOTTOM_MARGIN = 0;

  FILTER_CONTROL_LEFT_MARGIN = 0;
  FILTER_CONTROL_TOP_MARGIN = 0;
  FILTER_CONTROL_RIGHT_MARGIN = 15;
  FILTER_CONTROL_BOTTOM_MARGIN = 0;

  FILTER_CONDITION_COUNT = 9;
  FILTER_CONDITION_COUNT_WITHOUT_DATE_RANGE_CONDITION =
    FILTER_CONDITION_COUNT - 1;

  EQUAL_TO_FILTER_COND_NAME = '�����';
  NOT_EQUAL_TO_FILTER_COND_NAME = '�� �����';
  LESS_THAN_FILTER_COND_NAME = '������';
  LESS_OR_EQUAL_THAN_FILTER_COND_NAME = '������ ��� �����';
  GREATER_THAN_FILTER_COND_NAME = '������';
  GREATER_OR_EQUAL_THAN_FILTER_COND_NAME = '������ ��� �����';
  CONTAINS_FILTER_COND_NAME = '��������';
  NOT_CONTAINS_FILTER_COND_NAME = '�� ��������';
  DATE_RANGE_FILTER_COND_NAME = '�������� ���';

  CONTAINS_FILTER_COND_EXPR = ' like ';
  NOT_CONTAINS_FILTER_COND_EXPR = ' not like ';

  EQUAL_TO_FILTER_COND_IDX = 0;
  NOT_EQUAL_TO_FILTER_COND_IDX = 1;
  LESS_THAN_FILTER_COND_IDX = 2;
  LESS_OR_EQUAL_THAN_FILTER_COND_IDX = 3;
  GREATER_THAN_FILTER_COND_IDX = 4;
  GREATER_OR_EQUAL_THAN_FILTER_COND_IDX = 5;
  CONTAINS_FILTER_COND_IDX = 6;
  NOT_CONTAINS_FILTER_COND_IDX = 7;
  DATE_RANGE_FILTER_COND_IDX = 8;
  DISABLE_ALL_FILTER_CONDITIONS = 9;
  ENABLE_ALL_FILTER_CONDITIONS = 10;

  FILTER_GROUP_BOX_DEFAULT_CAPTION = '��������������';
  DEFAULT_FORM_CAPTION = '����� ������� �� �������� ���������������';

  DATE_FORMAT = 'yyyy-MM-dd';
  DISPLAY_DATE_FORMAT = 'dd.MM.yyyy';

  DATE_TIME_FORMAT = 'yyyy-MM-dd hh:mm:ss';
  DISPLAY_DATE_TIME_FORMAT = 'dd.MM.yyyy hh:mm:ss';

  MONEY_TYPE_REG_EXPR_PATTERN = '^\d{1,16}(\%s\d{1,4})?$';
  MONEY_TYPE_REG_EXPR_FAILED_STR = '��������� �������� ��� ������';

  FLOAT_TYPE_REG_EXPR_PATTERN = '^-?\d{1,16}(\%s\d{1,15})?$';
  FLOAT_TYPE_REG_EXPR_FAILED_STR = '��������� ������������ ��� ������';

type

  TFilterConditionComboBoxItem = record

    ConditionName: String;
    ConditionIndex: Integer;

  end;

  TFilterConditionIndexToExpression = record

    ConditionIndex: Integer;
    ConditionExpression: String;

  end;

  TFilterDataSetData = record

    Filter: String;
    FilterOptions: TFilterOptions;

  end;

  PFilterDataSetData = ^TFilterDataSetData;

  // ������� ��� ����������� ���� � ������� ������,
  // ������������� ���� timestamp
  TDateAndTimePicker = class(TDateTimePicker)

    strict private

      procedure OnChangeHandle(Sender: TObject);

    public
    procedure SetDateTimeFromCaption;

    public

      constructor Create(AOwner: TComponent); override;

  end;

  // Filter Field Control Validators

  // Base
  TFilterFieldValueControlValidator = class

    public

      function IsValid: Boolean; virtual; abstract;

  end;

  // Default, IsValid always return true
  TDefaultFilterFieldValueControlValidator = class(TFilterFieldValueControlValidator)

    public

      function IsValid: Boolean; override;

  end;

  // Validator for Validate Filter Field Controls
  TValidateEditValidator = class(TFilterFieldValueControlValidator)

    strict private

      FValidateEdit: TValidateEdit;

    public

      constructor Create(AValidateEdit: TValidateEdit);

      function IsValid: Boolean; override;

      property ValidateEdit: TValidateEdit
      read FValidateEdit write FValidateEdit;

  end;

  // Filter Field Controls using for creating a filter expression
  TFilterFieldControls = class

    public

      SelectFieldCheckBox: TCheckBox;
      FilterConditionComboBox:  TComboBox;
      FilterFieldValueControl: TControl;
      FilterFieldValueControlValidator: TFilterFieldValueControlValidator;

      constructor Create(
        ASelectFieldCheckBox: TCheckBox;
        AFilterConditionComboBox:  TComboBox;
        AFilterFieldValueControl: TControl;
        AFilterFieldValueControlValidator: TFilterFieldValueControlValidator = nil
      );

      destructor Destroy; override;

  end;

  { ������� ���������� ��� �������� � �����������
    ��� ������������� �������� TDateTimePicker ���
    ������� ���������� "�����", "�� �����", "������", "������" � �.�.,
    ��� � �������� TSimpleDateRangePanel, ���������������
    ����� ����������� ���� ��������� TDateTimePicker,
    ��� �������� ���������� ��� ������� ���������� "�������� ���" }
  TDateTimeStackedControl = class (TStackedControl)

    private

      FDateTimePicker: TDateTimePicker;
      FDateRangePanel: TSimpleDateRangePanel;

    public

      property DateRangePanel: TSimpleDateRangePanel
      read FDateRangePanel write FDateRangePanel;

      property DateTimePicker: TDateTimePicker
      read FDateTimePicker write FDateTimePicker;

      procedure ActivateDateRangePanel;
      procedure ActivateDateTimePicker;

      function IsDateRangePanelActiveControl: Boolean;
      function IsDateTimePickerActiveControl: Boolean;

  end;

  TDateTimeStackedControlComboBox = class (TComboBox)

    private

      FDateTimeStackedControl: TDateTimeStackedControl;

    public

      constructor Create(AOwner: TComponent); overload; override;
      constructor Create(
        DateTimeStackedControl: TDateTimeStackedControl;
        AOwner: TComponent
      ); overload;

      property DateTimeStackedControl: TDateTimeStackedControl
      read FDateTimeStackedControl write FDateTimeStackedControl;

  end;

const

  FilterConditionList: array [0..FILTER_CONDITION_COUNT - 1]
  of TFilterConditionComboBoxItem =

  (
    (ConditionName: EQUAL_TO_FILTER_COND_NAME; ConditionIndex: EQUAL_TO_FILTER_COND_IDX),
    (ConditionName: LESS_THAN_FILTER_COND_NAME; ConditionIndex: LESS_THAN_FILTER_COND_IDX),
    (ConditionName: LESS_OR_EQUAL_THAN_FILTER_COND_NAME; ConditionIndex: LESS_OR_EQUAL_THAN_FILTER_COND_IDX),
    (ConditionName: GREATER_THAN_FILTER_COND_NAME; ConditionIndex: GREATER_THAN_FILTER_COND_IDX),
    (ConditionName: GREATER_OR_EQUAL_THAN_FILTER_COND_NAME; ConditionIndex: GREATER_OR_EQUAL_THAN_FILTER_COND_IDX),
    (ConditionName: CONTAINS_FILTER_COND_NAME; ConditionIndex: CONTAINS_FILTER_COND_IDX),
    (ConditionName: NOT_EQUAL_TO_FILTER_COND_NAME; ConditionIndex: NOT_EQUAL_TO_FILTER_COND_IDX),
    (ConditionName: NOT_CONTAINS_FILTER_COND_NAME; ConditionIndex: NOT_CONTAINS_FILTER_COND_IDX),
    (ConditionName: DATE_RANGE_FILTER_COND_NAME; ConditionIndex: DATE_RANGE_FILTER_COND_IDX)
  );

  FilterConditionIndicesToExpressions:
  array [0..FILTER_CONDITION_COUNT_WITHOUT_DATE_RANGE_CONDITION - 1]
  of TFilterConditionIndexToExpression =

  (
    (ConditionIndex: EQUAL_TO_FILTER_COND_IDX; ConditionExpression: '='),
    (ConditionIndex: LESS_THAN_FILTER_COND_IDX; ConditionExpression: '<'),
    (ConditionIndex: LESS_OR_EQUAL_THAN_FILTER_COND_IDX; ConditionExpression: '<='),
    (ConditionIndex: GREATER_THAN_FILTER_COND_IDX; ConditionExpression : '>'),
    (ConditionIndex: GREATER_OR_EQUAL_THAN_FILTER_COND_IDX; ConditionExpression: '>='),
    (ConditionIndex: CONTAINS_FILTER_COND_IDX; ConditionExpression: CONTAINS_FILTER_COND_EXPR),
    (ConditionIndex: NOT_EQUAL_TO_FILTER_COND_IDX; ConditionExpression: '<>'),
    (ConditionIndex: NOT_CONTAINS_FILTER_COND_IDX; ConditionExpression: NOT_CONTAINS_FILTER_COND_EXPR)
  );

type

  TIntArray = array of Integer;
  TDataSetFieldType =
    (
      FieldHasStringType,
      FieldHasUnknownType,
      FieldHasIntegerType,
      FieldHasRealType,
      FieldHasCurrencyType,
      FieldHasBooleanType,
      FieldHasDateType,
      FieldHasDateTimeType,
      FieldHasTimeType
    );

  TTableViewFilterForm = class;
  TTableViewFilterFormClass = class of TTableViewFilterForm;

  TFilterPanelData = class

    strict private

      FIsFilterFieldSelected: Boolean;
      FIsFilterFieldControlFocused: Boolean;
      FFilterFieldName: String;
      FConditionExpressionIndex: Integer;
      FFilterValue: TCloneable;

    public

      destructor Destroy; override;

      constructor Create; overload;

      constructor Create(
        const AIsFilterFieldControlFocused: Boolean;
        const AIsFilterFieldSelected: Boolean;
        const AFilterFieldName: String;
        const AConditionExpressionIndex: Integer;
        const AFilterValue: TCloneable
      ); overload;

      property IsFilterFieldControlFocused: Boolean
      read FIsFilterFieldControlFocused write FIsFilterFieldControlFocused;

      property IsFilterFieldSelected: Boolean
      read FIsFilterFieldSelected write FIsFilterFieldSelected;
      
      property FilterFieldName: String
      read FFilterFieldName write FFilterFieldName;

      property ConditionExpressionIndex: Integer
      read FConditionExpressionIndex write FConditionExpressionIndex;

      property FilterValue: TCloneable
      read FFilterValue write FFilterValue;

      function Clone: TFilterPanelData;

  end;

  TFilterPanelDataList = class;

  TFilterPanelDataListEnumerator = class (TListEnumerator)

    private

      function GetCurrentFilterPanelData: TFilterPanelData;

    public

      constructor Create(FilterPanelDataList: TFilterPanelDataList);
      
      property Current: TFilterPanelData read GetCurrentFilterPanelData;

  end;

  TFilterPanelDataList = class (TList)

    private

      function GetFilterPanelDataByIndex(Index: Integer): TFilterPanelData;
      procedure SetFilterPanelDataByIndex(Index: Integer; FilterPanelData: TFilterPanelData);

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function GetEnumerator: TFilterPanelDataListEnumerator;

      function Clone: TFilterPanelDataList; virtual;
      
      property Items[Index: Integer]: TFilterPanelData
      read GetFilterPanelDataByIndex write SetFilterPanelDataByIndex; default;
    
  end;

  TTableViewFilterFormState = class

    private

      FFilterPanelDataList: TFilterPanelDataList;
      FUseInsensitiveTextFilter: Boolean;
      FChooseAllFilterFields: Boolean;
      FFilterActivated: Boolean;

      destructor Destroy; override;

    public

      constructor Create;

      procedure AddFilterPanelData(AFilterPanelData: TFilterPanelData);
      function FindFilterPanelData(const AFieldName: String): TFilterPanelData;
      procedure RemoveFilterPanelData(const AFieldName: String);

      property UseInsensitiveTextFilter: Boolean
      read FUseInsensitiveTextFilter write FUseInsensitiveTextFilter;

      property ChooseAllFilterFields: Boolean
      read FChooseAllFilterFields write FChooseAllFilterFields;
      
      property FilterPanelDataList: TFilterPanelDataList
      read FFilterPanelDataList write FFilterPanelDataList;

      property FilterActivated: Boolean
      read FFilterActivated write FFilterActivated;
      
      function ToDataSetFilter: String; virtual;
      function Clone: TTableViewFilterFormState; virtual;

  end;

  TTableViewFilterFormStateClass = class of TTableViewFilterFormState;

  TDataSetEvent = procedure(Sender: TObject; DataSet: TDataSet; Filtered: Boolean) of object;
  TOnDataSetFilteringEvent = procedure(Sender: TObject; DataSet: TDataSet) of object;
  TOnCustomizingEventHandler = procedure (Sender: TTableViewFilterForm) of object;

  TTableViewFilterForm = class(TForm)
    btnApply: TcxButton;
    btnCancel: TcxButton;
    FilterOptionsGroupBox: TGroupBox;
    UseCaseInSensitiveFilter: TCheckBox;
    btnCancelPrevFilter: TcxButton;
    SelectAllFieldsCheckBox: TCheckBox;
    ResetFilterSettingsButton: TcxButton;
    procedure btnCancelPrevFilterClick(Sender: TObject);
    procedure FilterByAllFieldsCheckBoxClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);

    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ResetFilterSettingsButtonClick(Sender: TObject);
    procedure OnFilterFieldValueTextEditChanged(Sender: TObject);

    procedure OnAfterFilterFieldValueFloatEditValidate(
      Sender: TObject;
      const IsValid: Boolean
    );

    procedure OnFilterFieldValueSpinEditChange(Sender: TObject);
    procedure OnFilterFieldValueDateTimePickerChange(Sender: TObject);
    procedure OnFilterComboBoxConditionChanged(Sender: TObject);

  protected

    FDataSetTableView: TcxGridDBTableView;
    FFocusedFilterFieldValueControl: TWinControl;
    FFilterFieldLayoutMargin: TRect;
    FFilterControlMargin: TRect;
    FFilterGroupBox: TGroupBox;
    FFilterGroupBoxDefCaption: String;
    FCalculatedHeight: Integer;
    FMaxHeight: Integer;
    FFilterFieldPanelsParentControl: TWinControl;
    FSelectFilterFieldCount: Integer;
    FFormDefaultMinWidth: Integer;
    FFilterFieldControlsList: TList;
    FMustSaveStateBeforeClosing: Boolean;
    FLastState: TTableViewFilterFormState;

    FOnDataSetFiltered: TDataSetEvent;
    FOnDataSetFiltering: TOnDataSetFilteringEvent;
    //FDefaultFilterFieldValueControlValidator: TFilterFieldValueControlValidator;

    procedure SaveCurrentState; virtual;
    procedure AssignFilterPanelData(
      const ColumnField: TcxGridDBColumn;
      FilterFieldControls: TFilterFieldControls;
      FilterPanelData: TFilterPanelData
    ); virtual;

    function IsFilterFieldValueControlKnown(
      FilterFieldValueControl: TControl
    ): Boolean;

    procedure SetValueForFilterFieldControl(
      const ColumnField: TcxGridDBColumn;
      FilterFieldValueControl: TControl;
      Value: TCloneable
    );
    procedure SetValueForDateTimeStackedControl(
      DateTimeStackedControl: TDateTimeStackedControl;
      Value: TCloneable
    );

    procedure InternalSetLastState(ALastState: TTableViewFilterFormState); virtual;

    procedure SetLastState(ALastState: TTableViewFilterFormState);

    function CreateCurrentFilterPanelDataFor(
      const ColumnField: TcxGridDBColumn;
      FilterFieldControls: TFilterFieldControls
    ): TFilterPanelData; virtual;

  public

    class function GetTableViewFilterFormStateClass: TTableViewFilterFormStateClass; virtual;

  protected
  
    function GetFilterValueOfControl(
      const ColumnField: TcxGridDBColumn;
      FilterFieldValueControl: TControl
    ): TCloneable;

    function GetFilterValueOfDateTimeStackedControl(
      DateTimeStackedControl: TDateTimeStackedControl
    ): TCloneable;

    procedure Init(
      const ACaption: String = '';
      ADataSetTableView: TcxGridDBTableView = nil
    ); virtual;

    procedure CreateFilterFieldsLayout;
    function CanCreateFilterPanelForColumn(Column: TcxGridDBColumn): Boolean; virtual;

    procedure SetDataSetTableView(DataSetTableView: TcxGridDBTableView);

    function CreatePanel(AParentControl: TWinControl; const AAnchors: TAnchors): TPanel;
    function CreateFilterFieldPanel(Parent: TWinControl; const Field: TcxGridDBColumn): TPanel;

    procedure OnBooleanCheckBoxClickHandle(Sender: TObject);
    procedure OnSelectFilterFieldHandle(Sender: TObject); virtual;

    function CreateTextEdit(Parent: TWinControl; const Field: TcxGridDBColumn): TRegExprValidateEdit;
    function CreateFloatEdit(Parent: TWinControl; const Field: TcxGridDBColumn): TRegExprValidateEdit;
    function CreateBooleanCheckBox(Parent: TWinControl; const Field: TcxGridDBColumn): TCheckBox;

    function CreateDateTimePicker(
      Parent: TWinControl;
      const Field: TcxGridDBColumn;
      const DefaultKindIfFieldTypeNotDateTime: TDateTimeKind = dtkDate
    ): TDateTimePicker;

    function CreateDateTimeStackedControl(
      Parent: TWinControl;
      const Field: TcxGridDBColumn;
      const DefaultKindIfFieldTypeNotDateTime: TDateTimeKind = dtkDate
    ): TDateTimeStackedControl;
    procedure OnDateTimeStackedControlComboBoxChanged(
      Sender: TObject
    );

    function CreateDateRangePanel(
      Parent: TWinControl;
      const Field: TcxGridDBColumn;
      const DefaultKindIfFieldTypeNotDateTime: TDateTimeKind = dtkDate
    ): TSimpleDateRangePanel;

    function CreateSpinEdit(Parent: TWinControl; const Field: TcxGridDBColumn): TSpinEdit;

    function CreateFilterSelectFieldCheckBox(Parent: TWinControl; const Field: TcxGridDBColumn): TCheckBox;
    function CreateFilterConditionsComboBox(ParentControl: TWinControl; FilterFieldValueControl: TControl; const Field: TcxGridDBColumn): TComboBox; virtual;
    function CreateDisabledFilterConditionsComboBox(
      Parent: TWinControl;
      FilterFieldValueControl: TControl;
      const DisabledConditionIdxs: array of Integer
    ): TComboBox;
    function CreateFilterFieldValueControl(Parent: TWinControl; const Field: TcxGridDBColumn): TControl; virtual;

    function GetDataSetFieldType(const ColumnField: TcxGridDBColumn): TDataSetFieldType;

    function CreateFilterFieldValueControlValidator(
      FilterFieldValueControl: TControl;
      const Field: TcxGridDBColumn
    ): TFilterFieldValueControlValidator; virtual;

    function CreateFilterPanel(Parent: TWinControl; const Anchors: TAnchors): TPanel;
    procedure AddChildControlToFilterPanel(Panel: TPanel; ChildControl: TControl);
    procedure CenterPanelChildControlsByVert(Panel: TPanel);

    function GetDisableFilterConditionIndicesByField(const ColumnField: TcxGridDBColumn): TIntArray; virtual;

    function GetFilterSubPanel(Panel: TPanel): TPanel;
    function GetFilterValueControlFromSubPanel(SubPanel: TPanel): TControl;
    function SetFilterSubPanel(ParentPanel: TPanel; TargetSubPanel: TPanel): TPanel;
    
    function CreateFilterScrollBox(Parent: TWinControl; const Anchors: TAnchors): TScrollBox;
    procedure AddFilterPanelToScrollBox(ScrollBox: TScrollBox; Panel: TPanel);
    procedure AddScrollBarsSizeToScrollBoxSize(ScrollBox: TScrollBox);

    function CreateFilterGroupBox(const Anchors: TAnchors): TGroupBox;
    procedure AddFitlerScrollBoxToFilterGroupBox(GroupBox: TGroupBox; ScrollBox: TScrollBox);

    procedure AlignFilterFieldSubPanels(ParentControl: TWinControl);
    procedure SetAnchorsToFilterFieldPanels(const Anchors: TAnchors; ParentControl: TWinControl);

    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;

    procedure CancelPreviousFilter;
    function GetDataSet: TDataSet;
    procedure SetActivatedAllFilterFieldPanels(const Activated: Boolean);
    procedure UpdateApplyButtonActivity;
    procedure UpdateResetFilterSettingsButtonActivity;

    // Functions for creating filter expressions
    function ValidateFilterFieldInputValues: Boolean;
    function CreateFilterDataByInputValues: TFilterDataSetData; virtual;
    
    function CreateFilterFieldExpression(
      const ColumnField: TcxGridDBColumn;
      FilterConditionsComboBox: TComboBox;
      FilterFieldValueControl: TControl
    ): string; virtual;

    function CreateExpressionForFilterFieldByOtherWayIfValueControlIsDateRange(
      const ColumnField: TcxGridDBColumn;
      FilterConditionsComboBox: TComboBox;
      FilterFieldValueControl: TControl
    ): String;

    function GetFilterFieldName(const ColumnField: TcxGridDBColumn): String; virtual;

    function GetFilterConditionExpression(
      const ColumnField: TcxGridDBColumn;
      FilterConditionsComboBox: TComboBox;
      FilterFieldValueControl: TControl
    ): string; virtual;

    function GetFilterFieldInputValue(
      const ColumnField: TcxGridDBColumn;
      FilterConditionsComboBox: TComboBox;
      FilterFieldValueControl: TControl
    ): String; virtual;

    function GetCheckBoxFilterValueString(CheckBox: TCheckBox): String; virtual;
    function GetSpinEditFilterValueString(SpinEdit: TSpinEdit): String; virtual;

    function GetEditFilterValueString(
      Edit: TEdit;
      const UseLikeExpression: Boolean;
      const UseCaseSensitivity: Boolean
    ): String; virtual;

    function GetComboBoxFilterValueString(ComboBox: TComboBox; const FilterFieldType: TDataSetFieldType): String; virtual;

    function GetDateTimeFilterFieldInputValue(
	    const ColumnField: TcxGridDBColumn;
      FilterConditionsComboBox: TComboBox;
      FilterFieldValueControl: TDateTimePicker
    ): String;

    function GetFloatControlFilterValueString(Edit: TEdit): String; virtual;
    
    ////////////////////////////////////////

    procedure FilterDataSet(const Filtered: Boolean; const PFilterData: PFilterDataSetData = nil);
    procedure SetDataSetFiltered(const Filtered: Boolean); virtual;

    function GetCurrentFilterConditionIndex(
      FilterConditionsComboBox: TComboBox
    ): Integer;
    function GetCurrentFilterConditionExpression(FilterConditionsComboBox: TComboBox): String;
    function GetFilterConditionExpressionByIndex(const FilterConditionIndex: Integer): String;
    function GetDataSetFieldByColumnIndex(const ColumnIndex: Integer): TcxGridDBColumn;
    function FindItemIndexOfFilterConditionComboBoxByFilterConditionIndex(
      FilterConditionComboBox: TComboBox;
	    const FilterConditionIndex: Integer
    ): Integer;

    procedure DestroyLastState;

  public

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(const ACaption: String; AOwner: TComponent); overload;
    constructor Create(ADataSetTableView: TcxGridDBTableView; AOwner: TComponent); overload;
    constructor Create(ADataSetTableView: TcxGridDBTableView; const ACaption: String; AOwner: TComponent); overload;

    class function ShowTableViewFilterForm(
      ATableViewFilterFormClass: TTableViewFilterFormClass;
      ADataSetTableView: TcxGridDBTableView;
      AOwner: TComponent;
      OnCustomizingEventHandler: TOnCustomizingEventHandler = nil;
      const AModal: Boolean = True;
      const ACaption: String = '';
      const AFilterGroupBoxCaption: String = FILTER_GROUP_BOX_DEFAULT_CAPTION;
      const AFilterFieldPanelMargin: PRect = nil;
      const AFilterControlMargin: PRect = nil
    ): TTableViewFilterForm; static;

    class function CreateTableViewFilterForm(
      ATableViewFilterFormClass: TTableViewFilterFormClass;
      ADataSetTableView: TcxGridDBTableView;
      AOwner: TComponent;
      OnCustomizingEventHandler: TOnCustomizingEventHandler = nil;
      const ACaption: String = '';
      const AFilterGroupBoxCaption: String = FILTER_GROUP_BOX_DEFAULT_CAPTION;
      const AFilterFieldPanelMargin: PRect = nil;
      const AFilterControlMargin: PRect = nil
    ): TTableViewFilterForm; static;

    property DataSetTableView: TcxGridDBTableView
    read FDataSetTableView write SetDataSetTableView;

    property FilterFieldPanelMargin: TRect read FFilterFieldLayoutMargin
    write FFilterFieldLayoutMargin;

    property FilterControlMargin: TRect read FFilterControlMargin
    write FFilterControlMargin;

    property FilterGroupBoxCaption: String read FFilterGroupBoxDefCaption
    write FFilterGroupBoxDefCaption;

    property DataSet: TDataSet read GetDataSet;

    property MustSaveStateBeforeClosing: Boolean
    read FMustSaveStateBeforeClosing write FMustSaveStateBeforeClosing;

    property LastState: TTableViewFilterFormState
    read FLastState write SetLastState;

    class procedure ApplyFilterFormState(
      TableViewFilterFormClass: TTableViewFilterFormClass;
      DataSetTableView: TcxGridDBTableView;
      FilterFormState: TTableViewFilterFormState;
      OnDataSetFilteredEventHandler: TDataSetEvent = nil;
      OnCustomizingEventHandler: TOnCustomizingEventHandler = nil
    ); overload; static;

    procedure ApplyFilterState(
      FilterFormState: TTableViewFilterFormState;
      OnDataSetFilteredEventHandler: TDataSetEvent = nil
    ); overload;

    procedure ApplyContainsFilter(
      const FieldNames: TStrings;
      const FieldValues: TVariantList
    ); overload;

    procedure ApplyContainsFilter(
      const FieldNames: array of String;
      const FieldValues: array of Variant
    ); overload;

  published

    property OnDataSetFiltered: TDataSetEvent read FOnDataSetFiltered
    write FOnDataSetFiltered;

    property OnDataSetFiltering: TOnDataSetFilteringEvent
    read FOnDataSetFiltering write FOnDataSetFiltering;

  end;

var
  TableViewFilterForm: TTableViewFilterForm;

implementation

uses

  AuxWindowsFunctionsUnit,
  AuxCollectionFunctionsUnit,
  VariantTypeUnit,
  AuxiliaryStringFunctions,
  AuxDebugFunctionsUnit;

{$R *.dfm}

  {$IF CompilerVersion >= 21.0}
    {$LEGACYIFEND ON}
  {$IFEND}

{ TDataSetFilterForm }

constructor TTableViewFilterForm.Create(AOwner: TComponent);
begin

  inherited;
  Init;

end;

constructor TTableViewFilterForm.Create(const ACaption: String;
  AOwner: TComponent);
begin

  inherited Create(AOwner);
  Init(ACaption);

end;

constructor TTableViewFilterForm.Create(ADataSetTableView: TcxGridDBTableView; AOwner: TComponent);
begin

  inherited Create(AOwner);
  Init('', ADataSetTableView);

end;

constructor TTableViewFilterForm.Create(ADataSetTableView: TcxGridDBTableView;
  const ACaption: String; AOwner: TComponent);
begin

  inherited Create(AOwner);
  Init(ACaption, ADataSetTableView);

end;

procedure TTableViewFilterForm.AddFilterPanelToScrollBox(ScrollBox: TScrollBox; Panel: TPanel);
var PossibleWidth: Integer;
begin

  Panel.Top := ScrollBox.Height + FFilterFieldLayoutMargin.Top;
  Panel.Left := FFilterFieldLayoutMargin.Left;

  PossibleWidth := Panel.Left + Panel.Width + FFilterFieldLayoutMargin.Right;

  if PossibleWidth > ScrollBox.Width then
    ScrollBox.Width := PossibleWidth;

  ScrollBox.Height := Panel.Top + Panel.Height + FFilterFieldLayoutMargin.Bottom;

end;

function TTableViewFilterForm.CreateFilterGroupBox(const Anchors: TAnchors): TGroupBox;
begin

  Result := TGroupBox.Create(Self);
  Result.Parent := Self;
  Result.Anchors := Anchors;
  Result.Width := 0;
  Result.Height := 0;
  Result.Caption := FFilterGroupBoxDefCaption;

end;

procedure TTableViewFilterForm.AddFitlerScrollBoxToFilterGroupBox(GroupBox: TGroupBox; ScrollBox: TScrollBox);
begin

  ScrollBox.Left := FILTER_SCROLL_BOX_LEFT_MARGIN;
  ScrollBox.Top := FILTER_SCROLL_BOX_TOP_MARGIN;

  GroupBox.Left := FilterOptionsGroupBox.Left;
  GroupBox.Top := FilterOptionsGroupBox.Top;
  GroupBox.Width := ScrollBox.Left + ScrollBox.Width + FILTER_SCROLL_BOX_RIGHT_MARGIN;
  GroupBox.Height := ScrollBox.Top + ScrollBox.Height + FILTER_SCROLL_BOX_BOTTOM_MARGIN;

end;

procedure TTableViewFilterForm.AddScrollBarsSizeToScrollBoxSize(
  ScrollBox: TScrollBox);
begin

  ScrollBox.Width := ScrollBox.Width + GetSystemMetrics(SM_CXHSCROLL);
  ScrollBox.Height := ScrollBox.Height + GetSystemMetrics(SM_CYVSCROLL);

end;

procedure TTableViewFilterForm.CancelPreviousFilter;
begin

  FilterDataSet(False);

end;

function TTableViewFilterForm.CanCreateFilterPanelForColumn(
  Column: TcxGridDBColumn): Boolean;
begin

  Result :=
    (Column.DataBinding.FieldName <> '') and
    (Column.Visible or (Column.GroupIndex >= 0));

end;

procedure TTableViewFilterForm.CenterPanelChildControlsByVert(Panel: TPanel);
var I: Integer;
begin

  for I := 0 to Panel.ControlCount - 1 do begin

     CenterWindowRelativeByVert(Panel.Controls[I], Panel);

  end;

end;

function TTableViewFilterForm.CreateBooleanCheckBox(
  Parent: TWinControl; const Field: TcxGridDBColumn): TCheckBox;
begin

  Result := TCheckBox.Create(Parent);
  Result.Parent := Parent;
  Result.Caption := '���';
  Result.OnClick := OnBooleanCheckBoxClickHandle;
  Result.Tag := -1; // ��� ���������� ������� �������� �� ��������,
  // ������������� ��� ������ ���� ����������
  // (��. SetActivatedFilterFieldPanels)
  
  AdjustCheckBoxSize(Result);

end;

function TTableViewFilterForm.CreateCurrentFilterPanelDataFor(
  const ColumnField: TcxGridDBColumn;
  FilterFieldControls: TFilterFieldControls
): TFilterPanelData;
var FilterVariantValue: TVariant;
begin

  Result := TFilterPanelData.Create;

  Result.IsFilterFieldSelected := FilterFieldControls.SelectFieldCheckBox.Checked;
  Result.FilterFieldName := ColumnField.DataBinding.FieldName;
    //FilterFieldControls.SelectFieldCheckBox.Caption;

  if Assigned(FilterFieldControls.FilterConditionComboBox) then
    Result.ConditionExpressionIndex :=
      GetCurrentFilterConditionIndex(
        FilterFieldControls.FilterConditionComboBox
      ); //FilterFieldControls.FilterConditionComboBox.ItemIndex;

  with FilterFieldControls do begin

    if FilterFieldValueControl is TWinControl then
      Result.IsFilterFieldControlFocused :=
        (FilterFieldValueControl as TWinControl).Focused;

    Result.FilterValue :=
      GetFilterValueOfControl(ColumnField, FilterFieldValueControl);

  end;

end;

function TTableViewFilterForm.GetFilterValueControlFromSubPanel(
  SubPanel: TPanel): TControl;
begin

  if SubPanel.ControlCount = 1 then
    Result := SubPanel.Controls[0]

  else begin

    if (SubPanel.Controls[0] is TComboBox) and (SubPanel.Controls[1] is TComboBox)
    then begin

      if SubPanel.Controls[0].Left > SubPanel.Controls[1].Left then
        Result := SubPanel.Controls[0]

      else Result := SubPanel.Controls[1];

    end

    else if not (SubPanel.Controls[0] is TComboBox) then
      Result := SubPanel.Controls[0]

    else Result := SubPanel.Controls[1];

  end;
  
end;

function TTableViewFilterForm.GetFilterValueOfControl(
  const ColumnField: TcxGridDBColumn;
  FilterFieldValueControl: TControl): TCloneable;
var FilterVariantValue: TVariant;
begin

  if not IsFilterFieldValueControlKnown(FilterFieldValueControl)
  then begin

    Result := nil;
    Exit;

  end;

  FilterVariantValue := TVariant.Create;

  if FilterFieldValueControl is TEdit then
      FilterVariantValue.Value := (FilterFieldValueControl as TEdit).Text

  else if FilterFieldValueControl is TSpinEdit then
      FilterVariantValue.Value := (FilterFieldValueControl as TSpinEdit).Value

  else if FilterFieldValueControl is TCheckBox then
      FilterVariantValue.Value := (FilterFieldValueControl as TCheckBox).Checked

  else if FilterFieldValueControl is TComboBox then
      FilterVariantValue.Value := (FilterFieldValueControl as TComboBox).ItemIndex

  else if FilterFieldValueControl is TDateTimeStackedControl then begin

    Result := GetFilterValueOfDateTimeStackedControl(
                FilterFieldValueControl as TDateTimeStackedControl
              );
    Exit;
    
  end

  else FilterVariantValue.Value := (FilterFieldValueControl as TDateTimePicker).DateTime;

  Result := FilterVariantValue;
  
end;

function TTableViewFilterForm.GetFilterValueOfDateTimeStackedControl(
  DateTimeStackedControl: TDateTimeStackedControl): TCloneable;
begin

  if DateTimeStackedControl.IsDateRangePanelActiveControl then begin

    Result :=
      DateTimeStackedControl.DateRangePanel.GetCurrentDateTimeRange;
      
  end

  else begin

    Result :=
      TVariant.Create(DateTimeStackedControl.DateTimePicker.DateTime);
      
  end;

end;

function TTableViewFilterForm.GetSpinEditFilterValueString(
  SpinEdit: TSpinEdit): String;
begin

  Result := IntToStr(SpinEdit.Value);
  
end;

class function TTableViewFilterForm.GetTableViewFilterFormStateClass: TTableViewFilterFormStateClass;
begin

  Result := TTableViewFilterFormState;

end;

function TTableViewFilterForm.CreateFilterScrollBox(Parent: TWinControl;
  const Anchors: TAnchors): TScrollBox;
begin

  Result := TScrollBox.Create(Parent);
  Result.Parent := Parent;
  Result.Anchors := Anchors;
  Result.BorderStyle := bsNone;
  Result.Width := 0;
  Result.Height := 0;
  Result.AutoScroll := True;

end;

function TTableViewFilterForm.CreateFilterSelectFieldCheckBox(
  Parent: TWinControl; const Field: TcxGridDBColumn): TCheckBox;
begin

  Result := TCheckBox.Create(Parent);
  Result.Parent := Parent;
  Result.Anchors := [akLeft, akTop];
  Result.Caption := //Field.VisibleCaption;
    Copy(Field.VisibleCaption, 0 , 100);

  Result.Tag := Field.Index;
  
  AdjustCheckBoxSize(Result);

end;

{ �������� �� �����������:
  ������� ��������� ��������� TDateRangePanel
}
function TTableViewFilterForm.CreateDateRangePanel(
  Parent: TWinControl;
  const Field: TcxGridDBColumn;
  const DefaultKindIfFieldTypeNotDateTime: TDateTimeKind
): TSimpleDateRangePanel;
var
    LeftDateTimePicker, RightDateTimePicker: TDateTimePicker;
    LeftDateRangeLabel, RightDateRangeLabel: TLabel;
begin

  Result := TSimpleDateRangePanel.Create(Parent);
  Result.Parent := Parent;
  Result.Anchors := [akLeft, akTop];
  Result.BevelOuter := bvNone;

  LeftDateTimePicker :=
    CreateDateTimePicker(Result, Field, DefaultKindIfFieldTypeNotDateTime);
  RightDateTimePicker :=
    CreateDateTimePicker(Result, Field, DefaultKindIfFieldTypeNotDateTime);

  LeftDateRangeLabel := CreateLabel(Result, '��:');
  RightDateRangeLabel := CreateLabel(Result, '��:');

  LeftDateRangeLabel.Left := 0;
  LeftDateRangeLabel.Top := 0;

  LeftDateTimePicker.Left := 0;
  LeftDateTimePicker.Top := LeftDateRangeLabel.Height + 5;

  RightDateRangeLabel.Left := LeftDateTimePicker.Width + 30;
  RightDateRangeLabel.Top := 0;

  RightDateTimePicker.Left := RightDateRangeLabel.Left;
  RightDateTimePicker.Top := RightDateRangeLabel.Height + 5;

  Result.Width := RightDateTimePicker.Left + RightDateTimePicker.Width;
  Result.Height := RightDateTimePicker.Top + RightDateTimePicker.Height;

  Result.LeftDateTimePicker := LeftDateTimePicker;
  Result.RightDateTimePicker := RightDateTimePicker;

end;

function TTableViewFilterForm.CreateDateTimePicker(
  Parent: TWinControl;
  const Field: TcxGridDBColumn;
  const DefaultKindIfFieldTypeNotDateTime: TDateTimeKind
): TDateTimePicker;
var RepresenationFormat: String;
    DateTimePickerKind: TDateTimeKind;
    FieldType: TDataSetFieldType;

function CreateDateTimePickerWithGivenKind(
  ParentControl: TWinControl;
  const GivenKind: TDateTimeKind;
  const RepresentationFormat: String = ''
): TDateTimePicker;
begin

  Result := TDateTimePicker.Create(Parent);
  Result.Parent := ParentControl;

  Result.Kind := GivenKind;

  if RepresentationFormat <> '' then
    Result.Format := RepresentationFormat;

end;

begin

  FieldType := GetDataSetFieldType(Field);
  
  case FieldType of
                  
    FieldHasDateType, FieldHasTimeType:
    begin

      if FieldType = FieldHasDateType then
        Result := CreateDateTimePickerWithGivenKind(
                      Parent,
                      dtkDate,
                      DISPLAY_DATE_FORMAT
                  )

      else Result := CreateDateTimePickerWithGivenKind(Parent, dtkTime);

    end;

    FieldHasDateTimeType:
    begin

      Result := TDateAndTimePicker.Create(Parent);
      Result.Parent := Parent;
      Result.Format := DISPLAY_DATE_TIME_FORMAT;
      Result.DateTime := Now;
      
      (Result as TDateAndTimePicker).SetDateTimeFromCaption;

    end;

    else begin

      if DefaultKindIfFieldTypeNotDateTime = dtkDate then begin

        DateTimePickerKind := dtkDate;
        RepresenationFormat := DISPLAY_DATE_FORMAT;

      end

      else begin

        DateTimePickerKind := dtkTime;
        RepresenationFormat := DISPLAY_DATE_TIME_FORMAT;

      end;

      Result := CreateDateTimePickerWithGivenKind(
                  Parent,
                  DateTimePickerKind,
                  RepresenationFormat
                );

    end;

  end;

  Result.OnChange := OnFilterFieldValueDateTimePickerChange;

end;


function TTableViewFilterForm.CreateDateTimeStackedControl(
  Parent: TWinControl;
  const Field: TcxGridDBColumn;
  const DefaultKindIfFieldTypeNotDateTime: TDateTimeKind
): TDateTimeStackedControl;
var OrdinaryDateTimePicker: TDateTimePicker;
    DateRangePanel: TSimpleDateRangePanel;
begin

  Result := TDateTimeStackedControl.Create(Parent);
  Result.Parent:= Parent;

  OrdinaryDateTimePicker :=
    CreateDateTimePicker(Result, Field, DefaultKindIfFieldTypeNotDateTime);

  DateRangePanel :=
    CreateDateRangePanel(Result, Field, DefaultKindIfFieldTypeNotDateTime);

  Result.DateTimePicker := OrdinaryDateTimePicker;
  Result.DateRangePanel := DateRangePanel;

end;

function TTableViewFilterForm.CreateSpinEdit(
  Parent: TWinControl; const Field: TcxGridDBColumn): TSpinEdit;
var MinValue, MaxValue: Integer;
    FieldType: TFieldType;
begin

  Result := TSpinEdit.Create(Parent);
  Result.Parent := Parent;

  FieldType := DataSet.FieldByName(Field.DataBinding.FieldName).DataType;

  case FieldType of

    ftInteger, ftAutoInc:
    begin

      MinValue := Low(Integer);
      MaxValue := High(Integer);

    end;

    ftWord:
    begin

      MinValue := Low(Word);
      MaxValue := High(Word);

    end;

    ftLargeint:
    begin

      MinValue := Low(LongInt);
      MaxValue := High(LongInt);

    end;

    else begin

      MinValue := Low(SmallInt);
      MaxValue := High(SmallInt);
      
    end;

  end;

  Result.MinValue := MinValue;
  Result.MaxValue := MaxValue;

  Result.OnChange := OnFilterFieldValueSpinEditChange;

end;

function TTableViewFilterForm.CreateTextEdit(
  Parent: TWinControl; const Field: TcxGridDBColumn): TRegExprValidateEdit;
begin

  Result := TRegExprValidateEdit.Create(Parent);
  Result.Parent := Parent;
  Result.Width := TEXT_FIELD_DEFAULT_WIDTH;
  Result.OnChange := OnFilterFieldValueTextEditChanged;

end;

function TTableViewFilterForm.CreateFloatEdit(
  Parent: TWinControl; const Field: TcxGridDBColumn): TRegExprValidateEdit;

//���������� ��� Delphi 10
{$IF CompilerVersion >= 21.0}
var
  FS: TFormatSettings;
{$IFEND}
begin

  Result := TRegExprValidateEdit.Create(Parent);
  Result.Parent := Parent;
  Result.Width := TEXT_FIELD_DEFAULT_WIDTH;

  {$IF CompilerVersion >= 21.0}
    FS := TFormatSettings.Create('RU-ru');
  {$IFEND}

  case GetDataSetFieldType(Field) of

    FieldHasCurrencyType:
    begin

      Result.RegularExpression := Format(MONEY_TYPE_REG_EXPR_PATTERN, [
        {$IF CompilerVersion >= 21.0}
        FS.
        {$IFEND}
        DecimalSeparator
      ]);
      Result.InvalidHint := MONEY_TYPE_REG_EXPR_FAILED_STR;

    end;

    FieldHasRealType:
    begin

      Result.RegularExpression := Format(FLOAT_TYPE_REG_EXPR_PATTERN, [
        {$IF CompilerVersion >= 21.0}
        FS.
        {$IFEND}
        DecimalSeparator
      ]);
      Result.InvalidHint := FLOAT_TYPE_REG_EXPR_FAILED_STR;

    end;

  end;

  Result.OnAfterValidate := OnAfterFilterFieldValueFloatEditValidate;

end;

function TTableViewFilterForm.GetFloatControlFilterValueString(Edit: TEdit): String;
begin

  Result := Edit.Text;
  
end;

function TTableViewFilterForm.CreatePanel(AParentControl: TWinControl;
  const AAnchors: TAnchors): TPanel;
begin

  Result := TPanel.Create(AParentControl);
  Result.Parent := AParentControl;
  Result.Anchors := AAnchors;
  Result.BevelOuter := bvNone;

end;

function TTableViewFilterForm.CreateFilterFieldValueControl(
  Parent: TWinControl; const Field: TcxGridDBColumn): TControl;
var i: Integer;
begin

  case GetDataSetFieldType(Field) of

    FieldHasStringType:
    begin

      Result := CreateTextEdit(Parent, Field);

    end;

    FieldHasRealType:
    begin

      Result := CreateFloatEdit(Parent, Field);

    end;

    FieldHasBooleanType:
    begin

      Result := CreateBooleanCheckBox(Parent, Field);

    end;

    FieldHasIntegerType:
    begin

      Result := CreateSpinEdit(Parent, Field);

    end;

    FieldHasDateType, FieldHasDateTimeType, FieldHasTimeType:
    begin

      Result := CreateDateTimeStackedControl(Parent, Field);

    end;

    else Result := CreateTextEdit(Parent, Field);

  end;

end;

function TTableViewFilterForm.GetDataSetFieldType(
  const ColumnField: TcxGridDBColumn): TDataSetFieldType;
var FieldType: TFieldType;
begin

  FieldType :=
    DataSet.FieldByName(ColumnField.DataBinding.FieldName).DataType;

  //FieldType := ColumnField.DataBinding.Field.DataType;

  case FieldType of

    ftString, ftBytes, ftMemo, ftFmtMemo, ftVarBytes, ftBlob,
    ftGraphic, ftTypedBinary, ftCursor, ftFixedChar, ftWideString,
    ftArray, ftReference, ftDataSet, ftVariant, ftInterface, ftIDispatch,
    ftGuid, ftTimeStamp, ftFMTBcd, ftBCD, ftFixedWideChar, ftWideMemo:
    begin

      Result := FieldHasStringType;

    end;

    ftFloat:
    begin

      Result := FieldHasRealType;

    end;

    ftCurrency:
    begin

      Result := FieldHasCurrencyType;

    end;

    ftBoolean:
    begin

      Result := FieldHasBooleanType;

    end;

    ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint:
    begin

      Result := FieldHasIntegerType;

    end;

    ftDate:
    begin

      Result := FieldHasDateType;

    end;

    ftDateTime:
    begin

      Result := FieldHasDateTimeType;

    end;

    ftTime:
    begin

      Result := FieldHasTimeType;
      
    end

    else Result := FieldHasUnknownType;

  end;

end;

function TTableViewFilterForm.GetDateTimeFilterFieldInputValue(
  const ColumnField: TcxGridDBColumn;
  FilterConditionsComboBox: TComboBox;
  FilterFieldValueControl: TDateTimePicker): String;
begin

  if FilterFieldValueControl.Kind = dtkDate then
    Result := FormatDateTime(DATE_FORMAT, FilterFieldValueControl.DateTime)

  else if FilterFieldValueControl.Format <> DISPLAY_DATE_TIME_FORMAT then
    Result := TimeToStr(FilterFieldValueControl.DateTime)

  else
    Result :=
      FormatDateTime(DATE_TIME_FORMAT, FilterFieldValueControl.DateTime);

  Result := QuotedStr(Result);

end;

// Validator ��� �������� ���������� ���������� �������� ����
// ������� ����� ���� �������������� (override) � ������������
// � ������������ ������������
function TTableViewFilterForm.CreateFilterFieldValueControlValidator(
  FilterFieldValueControl: TControl;
  const Field: TcxGridDBColumn): TFilterFieldValueControlValidator;
begin

  if FilterFieldValueControl is TValidateEdit then
    Result := TValidateEditValidator.Create(FilterFieldValueControl as TValidateEdit)

  else Result := TDefaultFilterFieldValueControlValidator.Create;
  //FDefaultFilterFieldValueControlValidator;
       
end;

//-----------------------------------------------------------------
function TTableViewFilterForm.CreateDisabledFilterConditionsComboBox(
  Parent: TWinControl;
  FilterFieldValueControl: TControl;
  const DisabledConditionIdxs: array of Integer
): TComboBox;
label EndOuterIteration;
var I, DisabledConditionIdx: Integer;
    FilterConditionComboBoxItem: TFilterConditionComboBoxItem;
begin

  if FilterFieldValueControl is TDateTimeStackedControl then begin

    Result := TDateTimeStackedControlComboBox.Create(
                FilterFieldValueControl as TDateTimeStackedControl,
                Parent
              );

    Result.OnChange :=
      OnDateTimeStackedControlComboBoxChanged;

  end

  else begin

    Result := TComboBox.Create(Parent);
    Result.OnChange := OnFilterComboBoxConditionChanged;

  end;
  
  Result.Parent := Parent;
  Result.Anchors := [akLeft, akTop];
  Result.Style := csDropDownList;

  for I := 0 to FILTER_CONDITION_COUNT - 1 do begin

    FilterConditionComboBoxItem := FilterConditionList[I];

    for DisabledConditionIdx in DisabledConditionIdxs do
      if FilterConditionComboBoxItem.ConditionIndex = DisabledConditionIdx then
        goto EndOuterIteration;

    Result.AddItem(
      FilterConditionComboBoxItem.ConditionName,
      TObject(FilterConditionComboBoxItem.ConditionIndex)
    );

    EndOuterIteration:

  end;

end;

function TTableViewFilterForm.
  CreateExpressionForFilterFieldByOtherWayIfValueControlIsDateRange(

    const ColumnField: TcxGridDBColumn;
    FilterConditionsComboBox: TComboBox;
    FilterFieldValueControl: TControl

): String;
var DateTimeStackedControl: TDateTimeStackedControl;
    FieldName, LeftDateTimeString, RightDateTimeString: String;
    FieldType: TDataSetFieldType;
begin

  FieldType := GetDataSetFieldType(ColumnField);

  if not (
            (FilterFieldValueControl is TDateTimeStackedControl) and
            ((FieldType = FieldHasDateType)
              or (FieldType = FieldHasDateTimeType))
         )
  then Exit;

  DateTimeStackedControl :=
    FilterFieldValueControl as TDateTimeStackedControl;

  FieldName := ColumnField.DataBinding.FieldName;
  
  if DateTimeStackedControl.IsDateRangePanelActiveControl then begin

    LeftDateTimeString :=
      DateTimeStackedControl.
        DateRangePanel.GetLeftFormattedDateTimeString(DATE_FORMAT);

    RightDateTimeString :=
      DateTimeStackedControl.DateRangePanel.
        GetRightFormattedDateTimeString(DATE_FORMAT);

    Result :=
      '((' +
          FieldName + ' >= ' +
            QuotedStr(LeftDateTimeString) +
          ') AND (' +
          FieldName + ' <= ' +
            QuotedStr(RightDateTimeString) +
      '))';

  end

  else Result :=
    '(' +
      FieldName + ' ' +

      GetFilterConditionExpression(
        ColumnField, FilterConditionsComboBox, FilterFieldValueControl
      ) + ' ' +

      GetDateTimeFilterFieldInputValue(
        ColumnField,
        FilterConditionsComboBox,
        DateTimeStackedControl.DateTimePicker
      )
      + ')';

end;

/////////////////////////////////////////////////////////
function TTableViewFilterForm.CreateFilterPanel(Parent: TWinControl;
  const Anchors: TAnchors): TPanel;
begin

  Result := CreatePanel(Parent, Anchors);
  Result.Width := 0;
  Result.Height := 0;

end;
 ////////////////////////////////////////////////////////////
procedure TTableViewFilterForm.AddChildControlToFilterPanel(Panel: TPanel;
  ChildControl: TControl);
var PossiblePanelHeight: Integer;
    ControlMargin: TRect;
    I: Integer;
begin

  if ChildControl is TPanel then
    ControlMargin := Rect(0, 0, 0, 0)

  else ControlMargin := FilterControlMargin;
  
  ChildControl.Left := Panel.Width + ControlMargin.Left;

  ChildControl.Top := ControlMargin.Top;

  PossiblePanelHeight := ChildControl.Top + ChildControl.Height + 1 + ControlMargin.Bottom;

  if PossiblePanelHeight > Panel.Height then
    Panel.Height := PossiblePanelHeight;

  Panel.Width := ChildControl.Left + ChildControl.Width + ControlMargin.Right;

end;

//---------------------------------------------------------------------

//////////////////////////////////////////////////////////
function TTableViewFilterForm.CreateFilterFieldPanel(
  Parent: TWinControl;
  const Field: TcxGridDBColumn): TPanel;

var FieldNameCheckBox: TCheckBox;
    FilterConditionsComboBox: TComboBox;
    FilterFieldValueControl: TControl;
    DisabledConditionIdxs: TIntArray;
    FilterFieldPanel, FilterFieldSubPanel: TPanel;
    FilterFieldValueControlValidator: TFilterFieldValueControlValidator;
begin

  // ������� ������ ��� ����, ������� ����� �������� � ���� ������� � ��������� ����
  // (��� ����������� ������ � ����������), �������� ��������� ������ ��� ������
  // ������� ���������� (�������� - ������ ��� ��� �������� ���� ������
  // ���������� ������ ����� ���� ������������) � ������������ ������� ��� ����������
  // �������� ����
  FilterFieldPanel := CreateFilterPanel(Parent, [akLeft, akTop]);

  // ������� ������� � ��������� ����
  FieldNameCheckBox := CreateFilterSelectFieldCheckBox(FilterFieldPanel, Field);

    // ������� ���������, ���������� ���������� ������ � ������� ��� ���������� �������� ����,
  // ��������� ������ ������������ ��� ���������/����������� �������� � �� ���������
  // � ����������� �� ��������� �������� � ��������� ����
  FilterFieldSubPanel := CreateFilterPanel(FilterFieldPanel, [akLeft, akTop]);

  // ������� ������������ ������� ��� ���������� �������� ����
  FilterFieldValueControl := CreateFilterFieldValueControl(FilterFieldSubPanel, Field);

  // �������� ������� � ������
  AddChildControlToFilterPanel(FilterFieldPanel, FieldNameCheckBox);

  // ������� ���������� ������ � ������������ ��������� ����������
  FilterConditionsComboBox := CreateFilterConditionsComboBox(
    FilterFieldSubPanel, FilterFieldValueControl, Field);

  // �������� ������ � ���������, ���� �� ��� ������
  if Assigned(FilterConditionsComboBox) then
    AddChildControlToFilterPanel(FilterFieldSubPanel, FilterConditionsComboBox);

  // �������� ������� ���������� ���������� �������� ���� � ���������
  AddChildControlToFilterPanel(FilterFieldSubPanel, FilterFieldValueControl);

  // �������� ��������� � ������
  AddChildControlToFilterPanel(FilterFieldPanel, FilterFieldSubPanel);

  // ��������� �������� � ������������� �������� ����������
  FilterFieldValueControl.Anchors := [akLeft, akTop, akRight];
  FilterFieldSubPanel.Anchors := [akLeft, akTop, akRight];

  // �������� ����� ���� ���������� �� ���������
  FieldNameCheckBox.Checked := False;

  // ������� ������, ����������� �� ������������ ����������
  // �������� ���������� ���������� �������� ����
  FilterFieldValueControlValidator := CreateFilterFieldValueControlValidator(FilterFieldValueControl, Field);

  FFilterFieldControlsList.Add(

    TFilterFieldControls.Create(
      FieldNameCheckBox,
      FilterConditionsComboBox,
      FilterFieldValueControl,
      FilterFieldValueControlValidator
    )

  );

  SetEnabledChildControls(False, FilterFieldSubPanel);

  FieldNameCheckBox.OnClick := OnSelectFilterFieldHandle;

  // �������������� �������� ���������� ������������
  // ���������� ������ �� ���������
  CenterPanelChildControlsByVert(FilterFieldSubPanel);

  // �������������� �������� ���������� ������������
  // ���������� ������ �� ���������
  CenterPanelChildControlsByVert(FilterFieldPanel);

  Result := FilterFieldPanel;

end;

procedure TTableViewFilterForm.SaveCurrentState;
var I: Integer;
    FilterFieldControls: TFilterFieldControls;
    FilterPanelData: TFilterPanelData;
begin

  if not Assigned(FLastState) then
    FLastState := GetTableViewFilterFormStateClass.Create

  else FLastState.FFilterPanelDataList.Clear;

  for I := 0 to FFilterFieldControlsList.Count - 1 do begin

    FilterFieldControls := TFilterFieldControls(
                              FFilterFieldControlsList[I]
                           );

    FilterPanelData := CreateCurrentFilterPanelDataFor(
                          DataSetTableView.Columns[
                            FilterFieldControls.SelectFieldCheckBox.Tag
                          ],
                          FilterFieldControls
                       );

    FLastState.AddFilterPanelData(FilterPanelData);

  end;

  FLastState.UseInsensitiveTextFilter := UseCaseInSensitiveFilter.Checked;
  FLastState.ChooseAllFilterFields := SelectAllFieldsCheckBox.Checked;
  FLastState.FilterActivated := btnCancelPrevFilter.Enabled;

end;

procedure TTableViewFilterForm.SetActivatedAllFilterFieldPanels(const Activated: Boolean);
var I: Integer;
    FilterFieldControls: TFilterFieldControls;
begin

  for I := 0 to FFilterFieldControlsList.Count - 1 do begin

    FilterFieldControls := TFilterFieldControls(FFilterFieldControlsList[I]);

    FilterFieldControls.SelectFieldCheckBox.Checked := Activated;

  end;

end;
 ////////////////////////////////////////////////////////////////////
procedure TTableViewFilterForm.SetAnchorsToFilterFieldPanels(
  const Anchors: TAnchors; ParentControl: TWinControl);
var I: Integer;
    FilterSubPanel: TPanel;
begin

  for I := 0 to ParentControl.ControlCount - 1 do
  begin

    ParentControl.Controls[I].Anchors := Anchors;

  end;

end;
 ///////////////////////////////////////////////////////////
procedure TTableViewFilterForm.AlignFilterFieldSubPanels(
  ParentControl: TWinControl);
var I: Integer;
    MaxSubPanelLeft, MaxSubPanelWidth: Integer;
    ChildCtrl: TControl;
    NewPossibleParentWidth: Integer;
begin

  if ParentControl.ControlCount = 0 then Exit;
  
  ChildCtrl := GetFilterSubPanel(ParentControl.Controls[0] as TPanel);

  MaxSubPanelLeft := ChildCtrl.Left;
  MaxSubPanelWidth := ChildCtrl.Width;

  for I := 1 to ParentControl.ControlCount - 1 do
  begin

    ChildCtrl := GetFilterSubPanel(ParentControl.Controls[I] as TPanel);

    if ChildCtrl.Left > MaxSubPanelLeft then
      MaxSubPanelLeft := ChildCtrl.Left;

    if ChildCtrl.Width > MaxSubPanelWidth then
      MaxSubPanelWidth := ChildCtrl.Width;

  end;

  NewPossibleParentWidth :=
    FFilterFieldLayoutMargin.Left + MaxSubPanelLeft +
    MaxSubPanelWidth + FFilterFieldLayoutMargin.Right;

  if NewPossibleParentWidth > ParentControl.Width then begin

    ClientWidth := FilterOptionsGroupBox.Left * 2 +
      FILTER_SCROLL_BOX_LEFT_MARGIN + FILTER_SCROLL_BOX_RIGHT_MARGIN
      +  NewPossibleParentWidth;

    FFilterGroupBox.Width := FILTER_SCROLL_BOX_LEFT_MARGIN + FILTER_SCROLL_BOX_RIGHT_MARGIN
      +  NewPossibleParentWidth;

    ParentControl.Width := NewPossibleParentWidth;

  end;

  for I := 0 to ParentControl.ControlCount - 1 do
  begin

    ChildCtrl := GetFilterSubPanel(ParentControl.Controls[I] as TPanel);
    ChildCtrl.Left := MaxSubPanelLeft;

    ChildCtrl.Anchors := [akLeft, akTop];
    ParentControl.Controls[I].Width := MaxSubPanelLeft + MaxSubPanelWidth;
    ChildCtrl.Width := MaxSubPanelWidth;
    ChildCtrl.Anchors := [akLeft, akTop, akRight];

  end;

end;

 procedure TTableViewFilterForm.ApplyFilterState(
  FilterFormState: TTableViewFilterFormState;
  OnDataSetFilteredEventHandler: TDataSetEvent
 );
begin

  MustSaveStateBeforeClosing := True;
  OnDataSetFiltered := OnDataSetFilteredEventHandler;
  LastState := FilterFormState;

end;

procedure TTableViewFilterForm.ApplyContainsFilter(
  const FieldNames: array of String;
  const FieldValues: array of Variant
);
var
    FieldName: String;
    FieldNameList: TStrings;
    FieldValueList: TVariantList;
begin

  FieldNameList := nil;
  FieldValueList := nil;

  try

    FieldNameList := TStringList.Create;

    for FieldName in FieldNames do FieldNameList.Add(FieldName);

    FieldValueList := TVariantList.CreateFrom(FieldValues);

    ApplyContainsFilter(FieldNameList, FieldValueList);
    
  finally

    FreeAndNil(FieldNameList);
    FreeAndNil(FieldValueList);

  end;

end;

procedure TTableViewFilterForm.ApplyContainsFilter(
  const FieldNames: TStrings;
  const FieldValues: TVariantList
);
var
    FilterFormState: TTableViewFilterFormState;
begin

  FilterFormState := GetTableViewFilterFormStateClass.Create;

  try


  finally

    FreeAndNil(FilterFormState);

  end;

end;

class procedure TTableViewFilterForm.ApplyFilterFormState(
  TableViewFilterFormClass: TTableViewFilterFormClass;
  DataSetTableView: TcxGridDBTableView;
  FilterFormState: TTableViewFilterFormState;
  OnDataSetFilteredEventHandler: TDataSetEvent;
  OnCustomizingEventHandler: TOnCustomizingEventHandler
 );
var TableViewFilterForm: TTableViewFilterForm;
begin

  TableViewFilterForm :=
    TTableViewFilterForm.CreateTableViewFilterForm(
      TableViewFilterFormClass,
      DataSetTableView,
      nil,
      OnCustomizingEventHandler
    );

  try

    TableViewFilterForm.ApplyFilterState(
      FilterFormState,
      OnDataSetFilteredEventHandler
    );


  finally

    FreeAndNil(TableViewFilterForm);
    
  end;

end;

procedure TTableViewFilterForm.AssignFilterPanelData(
  const ColumnField: TcxGridDBColumn;
  FilterFieldControls: TFilterFieldControls;
  FilterPanelData: TFilterPanelData
);
begin

  if Assigned(FilterFieldControls.FilterConditionComboBox) then
    FilterFieldControls.FilterConditionComboBox.ItemIndex :=
      FindItemIndexOfFilterConditionComboBoxByFilterConditionIndex(
        FilterFieldControls.FilterConditionComboBox,
        FilterPanelData.ConditionExpressionIndex
      );
        {FilterPanelData.ConditionExpressionIndex;}

  FilterFieldControls.SelectFieldCheckBox.Checked :=
    FilterPanelData.IsFilterFieldSelected;

  with FilterFieldControls do begin

    if FilterFieldValueControl is TWinControl then
      if FilterPanelData.IsFilterFieldControlFocused then
        FFocusedFilterFieldValueControl :=
          FilterFieldValueControl as TWinControl;

    SetValueForFilterFieldControl(
      ColumnField,
      FilterFieldValueControl,
      FilterPanelData.FilterValue
    );

  end;

end;

//////////////////////////////////////////////
procedure TTableViewFilterForm.btnApplyClick(Sender: TObject);
var FilterData: TFilterDataSetData;
begin

  if not ValidateFilterFieldInputValues then begin

    ShowWarningMessage(Self.Handle, '�� ��� ���� ������������� ������ ' +
        '���������� ��������', '���������');
    Exit;

  end;

  FilterData := CreateFilterDataByInputValues;

  FilterDataSet(True, @FilterData);

  btnApply.Enabled := not DataSet.Filtered;
  btnCancelPrevFilter.Enabled := DataSet.Filtered;

end;
 //////////////////////////////////////////
procedure TTableViewFilterForm.btnCancelClick(Sender: TObject);
begin

  Close;
  ModalResult := mrCancel;

end;
/////////////////
procedure TTableViewFilterForm.btnCancelPrevFilterClick(Sender: TObject);
begin

  CancelPreviousFilter;

  btnApply.Enabled := True;
  btnCancelPrevFilter.Enabled := False;

end;
///////////////////////////////////////////////////////////
function TTableViewFilterForm.GetFilterFieldName(const ColumnField: TcxGridDBColumn): string;
begin

  Result := ColumnField.DataBinding.FieldName;

  case GetDataSetFieldType(ColumnField) of

    FieldHasStringType:
    begin

      if UseCaseInSensitiveFilter.Checked then
        Result := 'lower(' + Result + ')';

    end;

  end;

end;
///////////////////////////////////////////////////////////
function TTableViewFilterForm.GetFilterConditionExpression(
  const ColumnField: TcxGridDBColumn;
  FilterConditionsComboBox: TComboBox;
  FilterFieldValueControl: TControl
): String;
var ExceptionMessage: String;
begin

  if not Assigned(FilterConditionsComboBox) then
  begin

    if (FilterFieldValueControl is TCheckBox) or
       (FilterFieldValueControl is TComboBox)
    then
      Result := '='

    else ExceptionMessage := '������� ���������� �� ������� ��� ���� %s';

  end

  else Result := GetCurrentFilterConditionExpression(FilterConditionsComboBox);

  if Result = '' then
    ExceptionMessage := '������� ���������� �� ������� ��� ���� %s';

  if ExceptionMessage <> '' then
    raise Exception.CreateFmt(ExceptionMessage, [FilterFieldValueControl.ClassName]);

end;
/////////////////////////////////////
function TTableViewFilterForm.GetFilterFieldInputValue(
      const ColumnField: TcxGridDBColumn;
      FilterConditionsComboBox: TComboBox;
      FilterFieldValueControl: TControl
    ): String;
var DateTimePicker: TDateTimePicker;
    FilterConditionExpression: String;
    FieldType: TDataSetFieldType;
begin

  if FilterFieldValueControl is TCheckBox then begin

    Result :=
      GetCheckBoxFilterValueString(FilterFieldValueControl as TCheckBox);

  end

  else if FilterFieldValueControl is TEdit then begin
    
    FieldType := GetDataSetFieldType(ColumnField);

    if (FieldType = FieldHasRealType) or (FieldType = FieldHasCurrencyType)
    then begin

      Result :=
        GetFloatControlFilterValueString(FilterFieldValueControl as TEdit);

    end

    else begin

      FilterConditionExpression := GetCurrentFilterConditionExpression(FilterConditionsComboBox);

      Result :=
        GetEditFilterValueString(
          FilterFieldValueControl as TEdit,
          (FilterConditionExpression = CONTAINS_FILTER_COND_EXPR) or
          (FilterConditionExpression = NOT_CONTAINS_FILTER_COND_EXPR),
          UseCaseInSensitiveFilter.Checked
        );

    end;

  end

  else if FilterFieldValueControl is TSpinEdit then begin

    Result :=
      GetSpinEditFilterValueString(FilterFieldValueControl as TSpinEdit);

  end

  else if FilterFieldValueControl is TDateTimePicker then begin

    Result :=
      GetDateTimeFilterFieldInputValue(
        ColumnField,
        FilterConditionsComboBox,
        FilterFieldValueControl as TDateTimePicker
      );

  end

  else if FilterFieldValueControl is TComboBox then begin

    Result :=
      GetComboBoxFilterValueString(
        FilterFieldValueControl as TComboBox,
        GetDataSetFieldType(ColumnField)
      );

  end

  else raise Exception.CreateFmt('��� %s �� �������� � ���������� ��������� ����������', [FilterFieldValueControl.ClassName]);

end;

function TTableViewFilterForm.CreateFilterFieldExpression(
  const ColumnField: TcxGridDBColumn;
  FilterConditionsComboBox: TComboBox;
  FilterFieldValueControl: TControl): String;
var FilterFieldName, FilterFieldValue, s, FilterConditionExpression: String;
begin

    Result := '';
    
    Result :=
      CreateExpressionForFilterFieldByOtherWayIfValueControlIsDateRange(
        ColumnField, FilterConditionsComboBox, FilterFieldValueControl
      );

    if Result <> '' then Exit;
    
    FilterFieldName := GetFilterFieldName(ColumnField);
    FilterConditionExpression := GetFilterConditionExpression(ColumnField, FilterConditionsComboBox, FilterFieldValueControl);
    FilterFieldValue := GetFilterFieldInputValue(ColumnField, FilterConditionsComboBox, FilterFieldValueControl);

    Result := '(' + FilterFieldName + FilterConditionExpression + FilterFieldValue + ')';

    { Due to bug with "like" operator in
      zeos (6.6.6 version)'s dataset filter }
    if (FilterConditionExpression = CONTAINS_FILTER_COND_EXPR) and
        (Length(ExtractString(FilterFieldValue, '*', '*')) > 1) then begin

      Result := '((' + FilterFieldName + ' not like ' + QuotedStr('?') +
                ') and ' + Result + ')';

    end;   
    
end;
/////////////////////////////////////////////////////////////////
function TTableViewFilterForm.CreateFilterDataByInputValues: TFilterDataSetData;
var I: Integer;
    FilterFieldControls: TFilterFieldControls;
    SelectFieldCheckBox: TCheckBox;
    Field: TcxGridDBColumn;
    FilterFieldExpression: String;
begin

  { ����������� ����� ���������� �� ����������� �������
    �� �������� �� ������� ���� �� ������ ������ �� ZEOS }
  if UseCaseInSensitiveFilter.Checked then
    Result.FilterOptions := [foCaseInsensitive]

  else Result.FilterOptions := [];

  Result.Filter := '';

  for I := 0 to FFilterFieldControlsList.Count - 1 do begin

    FilterFieldControls := TFilterFieldControls(FFilterFieldControlsList[I]);

    SelectFieldCheckBox := FilterFieldControls.SelectFieldCheckBox;

    if not SelectFieldCheckBox.Checked then Continue;

    Field := GetDataSetFieldByColumnIndex(SelectFieldCheckBox.Tag);

    FilterFieldExpression := CreateFilterFieldExpression(

      Field,
      FilterFieldControls.FilterConditionComboBox,
      FilterFieldControls.FilterFieldValueControl

    );

    if Result.Filter = '' then
      Result.Filter := FilterFieldExpression

    else Result.Filter := Result.Filter + ' and ' + FilterFieldExpression;

  end;

end;
///////////////////////////////
procedure TTableViewFilterForm.CreateFilterFieldsLayout;
var I: Integer;
    FilterScrollBox: TScrollBox;
    FilterGroupBox: TGroupBox;
    DataSet: TDataSet;
begin

  FilterGroupBox := CreateFilterGroupBox([akLeft, akTop]);
  FilterScrollBox := CreateFilterScrollBox(FilterGroupBox, [akLeft, akTop]);

  FFilterGroupBox := FilterGroupBox;

  for I := 0 to FDataSetTableView.ColumnCount - 1 do begin

    if CanCreateFilterPanelForColumn(FDataSetTableView.Columns[I])
    then begin

      AddFilterPanelToScrollBox(
        FilterScrollBox,
        CreateFilterFieldPanel(FilterScrollBox, FDataSetTableView.Columns[I])
      );

    end;

  end;

  AddScrollBarsSizeToScrollBoxSize(FilterScrollBox);
  AddFitlerScrollBoxToFilterGroupBox(FilterGroupBox, FilterScrollBox);

  // GroupBox, Form correcting
  FCalculatedHeight := Height + FilterGroupBox.Height + FilterGroupBox.Top;

  // �������� ������� ����� � ���������� � ������������ ������� ����������
  Height := FCalculatedHeight;

  ClientWidth := Max(ClientWidth, FilterOptionsGroupBox.Left + FilterGroupBox.Width + FilterOptionsGroupBox.Left);

  // ��������� ��������� ���������� �� ����� � ������ �������� ���
  // ������������� ������� ���������� � ���������� ����
  AlignFilterFieldSubPanels(FilterScrollBox);
  FilterScrollBox.Anchors := [akLeft, akTop, akRight, akBottom];

  // ��������� ������� ���������� �������� ��������
  SetAnchorsToFilterFieldPanels([akLeft, akTop, akRight], FilterScrollBox);

  // �������� ������� FilterScrollBox, FilterGroupBox � ������������ � ����������� ��������� �����
  FilterGroupBox.Width := ClientWidth - FilterOptionsGroupBox.Left - FilterOptionsGroupBox.Left;
  //FilterScrollBox.Width := FilterGroupBox.Width - FILTER_SCROLL_BOX_LEFT_MARGIN - FILTER_SCROLL_BOX_RIGHT_MARGIN;
  FilterGroupBox.Anchors := [akLeft, akTop, akRight, akBottom];

  FFilterFieldPanelsParentControl := FilterScrollBox;

  // ������ ����� ��������� ������ ������� �������
  // (����� �� ����������� ������ �����)
  if FCalculatedHeight > FMaxHeight then begin

    Height := FMaxHeight;
    FCalculatedHeight := FMaxHeight;

  end;

  // �������� ����������� ��������� ����� ������ �����,
  // ����������� ������ ������ (��������, � ������
  // ������� �������� ����� ��������� �����)

end;

destructor TTableViewFilterForm.Destroy;
begin

  //DestroyLastState;
  FreeListWithItems(FFilterFieldControlsList);
  //FreeAndNil(FDefaultFilterFieldValueControlValidator);
  
  inherited;

end;

procedure TTableViewFilterForm.DestroyLastState;
begin

  FreeAndNil(FLastState);

end;

procedure TTableViewFilterForm.FilterByAllFieldsCheckBoxClick(Sender: TObject);
begin

  SetActivatedAllFilterFieldPanels(SelectAllFieldsCheckBox.Checked);

end;

function TTableViewFilterForm.ValidateFilterFieldInputValues: Boolean;
var I: Integer;
    FilterFieldControls: TFilterFieldControls;
    FilterFieldValueValid: Boolean;
begin

  Result := True;

  for I := 0 to FFilterFieldControlsList.Count - 1 do begin

    FilterFieldControls := TFilterFieldControls(FFilterFieldControlsList[I]);

    if (not FilterFieldControls.SelectFieldCheckBox.Checked) then Continue;

    FilterFieldValueValid := FilterFieldControls.FilterFieldValueControlValidator.IsValid;

    Result := Result and FilterFieldValueValid;

  end;

end;

function TTableViewFilterForm.CreateFilterConditionsComboBox(
  ParentControl: TWinControl;
  FilterFieldValueControl: TControl;
  const Field: TcxGridDBColumn
): TComboBox;
var DisabledConditionIdxs: TIntArray;
begin

  // �������� ������� ���������-������� ����������� ������, ������� ������ ���� ������
  // � ������������ � ����� ������ ����
  DisabledConditionIdxs := GetDisableFilterConditionIndicesByField(Field);

  // ���� ���������� ������ � ��������� ���������� ������ ���� ��������
  // (��������, ������ ��� ������� ���������� ��� ����� �������� ��������
  // ��� ���������� ���������������� ���� �� �������� ���������, � ����
  // ������ ���������� ������ ���������)
  if DisabledConditionIdxs[0] <> DISABLE_ALL_FILTER_CONDITIONS then
  begin

    // ������� ��������� ������ � ������������ ��������� ����������
    Result := CreateDisabledFilterConditionsComboBox(
                ParentControl,
                FilterFieldValueControl,
                DisabledConditionIdxs
              );


    if Result is TDateTimeStackedControlComboBox then begin

      Result.ItemIndex :=
        FindItemIndexOfFilterConditionComboBoxByFilterConditionIndex(
          Result,
          DATE_RANGE_FILTER_COND_IDX
        );
      Result.OnChange(Result);

    end

    else Result.ItemIndex := 0;

  end

  else Result := nil;

end;

procedure TTableViewFilterForm.FilterDataSet(const Filtered: Boolean; const PFilterData: PFilterDataSetData);
var t: TZQuery;
begin

  DataSet.DisableControls;

  if Assigned(PFilterData) then begin

    DataSet.Filter := PFilterData^.Filter;
    DataSet.FilterOptions := PFilterData^.FilterOptions;

  end;

  Screen.Cursor := crHourGlass;

  if Assigned(FOnDataSetFiltering) then
    FOnDataSetFiltering(Self, DataSet);

  SetDataSetFiltered(Filtered);

  Screen.Cursor := crDefault;

  DataSet.EnableControls;

  if Assigned(FOnDataSetFiltered) then
    FOnDataSetFiltered(Self, DataSet, Filtered);

end;

function TTableViewFilterForm.FindItemIndexOfFilterConditionComboBoxByFilterConditionIndex(
  FilterConditionComboBox: TComboBox;
  const FilterConditionIndex: Integer): Integer;
var I: Integer;
begin

  for I := 0 to FilterConditionComboBox.Items.Count - 1 do begin

    if Integer(FilterConditionComboBox.Items.Objects[I]) =
        FilterConditionIndex
    then begin

      Result := I;
      Exit;
      
    end;

  end;

  Result := -1;

end;

procedure TTableViewFilterForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin

  if FMustSaveStateBeforeClosing then
    SaveCurrentState;

end;

procedure TTableViewFilterForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var FilterScrollBox: TScrollBox;
    I: Integer;
begin

  // ������������ ������� ���������� ��� ������� ����������
  // ������ ����� ��� TScrollBox ��� ����������� ���������
  // �����������
  if not (FFilterFieldPanelsParentControl is TScrollBox) then
    raise Exception.CreateFmt('��� %s �� �������� TScrollBox', [FFilterFieldPanelsParentControl.ClassName]);

  FilterScrollBox := FFilterFieldPanelsParentControl as TScrollBox;

  Handled := PtInRect(FilterScrollBox.ClientRect, FilterScrollBox.ScreenToClient(MousePos));

  if Handled then begin

    for I := 1 to Mouse.WheelScrollLines do begin

      try

        if WheelDelta > 0 then
          FilterScrollBox.Perform(WM_VSCROLL, SB_LINEUP, 0)

        else FilterScrollBox.Perform(WM_VSCROLL, SB_LINEDOWN, 0);

      finally

        FilterScrollBox.Perform(WM_VSCROLL, SB_ENDSCROLL, 0);

      end;

    end;

  end;

end;

procedure TTableViewFilterForm.FormShow(Sender: TObject);
begin

  if Assigned(FFocusedFilterFieldValueControl) then
    FFocusedFilterFieldValueControl.SetFocus;
  
end;

function TTableViewFilterForm.GetCheckBoxFilterValueString(
  CheckBox: TCheckBox): String;
begin

  Result := BoolToStr(CheckBox.Checked, True);
  
end;

function TTableViewFilterForm.GetComboBoxFilterValueString(
  ComboBox: TComboBox;
  const FilterFieldType: TDataSetFieldType
): String;
begin

  Result := ComboBox.Items[ComboBox.ItemIndex];

  if (FilterFieldType = FieldHasDateType) or
     (FilterFieldType = FieldHasDateTimeType) or
     (FilterFieldType = FieldHasTimeType) or
     (FilterFieldType = FieldHasStringType)
  then begin


    Result :=
      IfThen(
        UseCaseInSensitiveFilter.Checked,
        Format('lower(%s)', [QuotedStr(Result)]),
        QuotedStr(Result)
      );

  end;
  
end;

function TTableViewFilterForm.GetCurrentFilterConditionExpression(
  FilterConditionsComboBox: TComboBox): String;
var FilterConditionIndex: Integer;
begin

  FilterConditionIndex :=
    GetCurrentFilterConditionIndex(FilterConditionsComboBox);

  Result := GetFilterConditionExpressionByIndex(FilterConditionIndex);

end;

function TTableViewFilterForm.GetCurrentFilterConditionIndex(
  FilterConditionsComboBox: TComboBox): Integer;
begin

  Result := Integer(

              FilterConditionsComboBox.Items.Objects[
                FilterConditionsComboBox.ItemIndex
              ]

            );

end;

function TTableViewFilterForm.GetDataSet: TDataSet;
begin

  Result := FDataSetTableView.DataController.DataSource.DataSet;

end;

function TTableViewFilterForm.GetDataSetFieldByColumnIndex(
  const ColumnIndex: Integer): TcxGridDBColumn;
begin

  Result := FDataSetTableView.Columns[ColumnIndex];

end;

function TTableViewFilterForm.GetDisableFilterConditionIndicesByField(
  const ColumnField: TcxGridDBColumn): TIntArray;
begin

  case GetDataSetFieldType(ColumnField) of

    FieldHasStringType:
    begin

      Result := TIntArray.Create(
                  LESS_THAN_FILTER_COND_IDX,
                  LESS_OR_EQUAL_THAN_FILTER_COND_IDX,
                  GREATER_THAN_FILTER_COND_IDX,
                  GREATER_OR_EQUAL_THAN_FILTER_COND_IDX,
                  DATE_RANGE_FILTER_COND_IDX
                );

    end;

    FieldHasIntegerType,
    FieldHasCurrencyType,
    FieldHasRealType,
    FieldHasTimeType:
    begin

      Result := TIntArray.Create(
                  CONTAINS_FILTER_COND_IDX,
                  NOT_CONTAINS_FILTER_COND_IDX,
                  DATE_RANGE_FILTER_COND_IDX
                );

    end;

    FieldHasDateType, FieldHasDateTimeType:
    begin

      Result := TIntArray.Create(
                  CONTAINS_FILTER_COND_IDX,
                  NOT_CONTAINS_FILTER_COND_IDX
                );
                
    end;

    FieldHasBooleanType:
      Result := TIntArray.Create(DISABLE_ALL_FILTER_CONDITIONS);

    else Result := TIntArray.Create(ENABLE_ALL_FILTER_CONDITIONS);
    
  end;

end;

function TTableViewFilterForm.GetEditFilterValueString(
  Edit: TEdit;
  const UseLikeExpression: Boolean;
  const UseCaseSensitivity: Boolean
): String;
begin

  Result :=
    QuotedStr(
      IfThen(UseLikeExpression, '*' + Edit.Text + '*', Edit.Text)
    );

  Result :=
    IfThen(UseCaseSensitivity, 'lower(' + Result + ')', Result); 

end;

function TTableViewFilterForm.GetFilterConditionExpressionByIndex(
  const FilterConditionIndex: Integer): String;
var FilterConditionIndexToExpression: TFilterConditionIndexToExpression;
begin

  if FilterConditionIndex = DATE_RANGE_FILTER_COND_IDX then begin

    Result := '';
    Exit;
    
  end;

  for FilterConditionIndexToExpression in FilterConditionIndicesToExpressions do
    if FilterConditionIndexToExpression.ConditionIndex = FilterConditionIndex then
    begin

      Result := FilterConditionIndexToExpression.ConditionExpression;
      Exit;

    end;
           
  Result := '';

end;

function TTableViewFilterForm.GetFilterSubPanel(Panel: TPanel): TPanel;
var I: Integer;
begin

  for I := 0 to Panel.ControlCount - 1 do
    if Panel.Controls[I] is TPanel then begin

      Result := Panel.Controls[I] as TPanel;
      Exit;

    end;

  Result := nil;

end;

function TTableViewFilterForm.SetFilterSubPanel(
  ParentPanel,
  TargetSubPanel: TPanel): TPanel;
var I: Integer;
begin

  for I := 0 to ParentPanel.ControlCount - 1 do
    if ParentPanel.Controls[I] is TPanel then begin

      Result := ParentPanel.Controls[I] as TPanel;

      ParentPanel.RemoveControl(Result);
      ParentPanel.InsertControl(TargetSubPanel);
      
      Exit;
      
    end;

  Result := nil;

end;

procedure TTableViewFilterForm.Init(const ACaption: String; ADataSetTableView: TcxGridDBTableView);
var AppBarData: TAppBarData;
i: integer;
begin

  FFilterFieldLayoutMargin.Left := FILTER_FIELD_LAYOUT_LEFT_MARGIN;
  FFilterFieldLayoutMargin.Top := FILTER_FIELD_LAYOUT_TOP_MARGIN;
  FFilterFieldLayoutMargin.Right := FILTER_FIELD_LAYOUT_RIGHT_MARGIN;
  FFilterFieldLayoutMargin.Bottom := FILTER_FIELD_LAYOUT_BOTTOM_MARGIN;

  FFilterControlMargin.Left := FILTER_CONTROL_LEFT_MARGIN;
  FFilterControlMargin.Top := FILTER_CONTROL_TOP_MARGIN;
  FFilterControlMargin.Right := FILTER_CONTROL_RIGHT_MARGIN;
  FFilterControlMargin.Bottom := FILTER_CONTROL_BOTTOM_MARGIN;

  FFilterGroupBoxDefCaption := FILTER_GROUP_BOX_DEFAULT_CAPTION;
  FFormDefaultMinWidth := Width;

  FFilterFieldControlsList := TList.Create;

  if ACaption = '' then
    Caption := DEFAULT_FORM_CAPTION

  else Caption := ACaption;

  AppBarData.cbSize := SizeOf(TAppBarData);

  SHAppBarMessage(ABM_GETTASKBARPOS, AppBarData);

  FMaxHeight := Screen.Height - (AppBarData.rc.Bottom - AppBarData.rc.Top);

  //////////////////////////////////////////////////////////
  DataSetTableView := ADataSetTableView;

end;

procedure TTableViewFilterForm.InternalSetLastState(
  ALastState: TTableViewFilterFormState);
var I: Integer;
    FilterFieldControls: TFilterFieldControls;
    FilterPanelData: TFilterPanelData;
begin
  for I := 0 to FFilterFieldControlsList.Count - 1 do begin

    FilterFieldControls := TFilterFieldControls(
                              FFilterFieldControlsList[I]
                           );

    FilterPanelData := ALastState.FindFilterPanelData(
                          TcxGridDBColumn(
                            DataSetTableView.Columns[
                              FilterFieldControls.SelectFieldCheckBox.Tag
                            ]
                          ).DataBinding.FieldName
                       );

    if not Assigned(FilterPanelData) then Continue;
    
    AssignFilterPanelData(
      DataSetTableView.Columns[
        FilterFieldControls.SelectFieldCheckBox.Tag
      ],
      FilterFieldControls,
      FilterPanelData
    );

  end;

  SelectAllFieldsCheckBox.Checked := ALastState.FChooseAllFilterFields;
  UseCaseInSensitiveFilter.Checked := ALastState.FUseInsensitiveTextFilter;

  if {(not DataSet.Filtered) and} (ALastState.FilterActivated) then
    btnApply.Click;
end;

function TTableViewFilterForm.IsFilterFieldValueControlKnown(
  FilterFieldValueControl: TControl): Boolean;
begin

  Result :=
        (FilterFieldValueControl is TEdit) or
        (FilterFieldValueControl is TSpinEdit) or
        (FilterFieldValueControl is TCheckBox) or
        (FilterFieldValueControl is TDateTimePicker) or
        (FilterFieldValueControl is TComboBox) or
        (FilterFieldValueControl is TDateTimeStackedControl);
        
end;

procedure TTableViewFilterForm.
  OnAfterFilterFieldValueFloatEditValidate(
    Sender: TObject;
    const IsValid: Boolean
  );
begin

  btnApply.Enabled := IsValid;

end;

procedure TTableViewFilterForm.OnBooleanCheckBoxClickHandle(Sender: TObject);
begin

  with Sender as TCheckBox do begin

    if Checked then Caption := '��'
    else Caption := '���';

  end;

  btnApply.Enabled := True;
  
  AdjustCheckBoxSize(Sender as TCheckBox);

end;

procedure TTableViewFilterForm.OnDateTimeStackedControlComboBoxChanged(
  Sender: TObject);
var DateTimeStackedControlComboBox: TDateTimeStackedControlComboBox;
begin

  DateTimeStackedControlComboBox :=
    Sender as TDateTimeStackedControlComboBox;

  if GetCurrentFilterConditionIndex(
       DateTimeStackedControlComboBox
     ) = DATE_RANGE_FILTER_COND_IDX
  then
    DateTimeStackedControlComboBox.
      DateTimeStackedControl.
        ActivateDateRangePanel

  else
    DateTimeStackedControlComboBox.
      DateTimeStackedControl.
        ActivateDateTimePicker;

  CenterPanelChildControlsByVert(
    DateTimeStackedControlComboBox.Parent as TPanel
  );

  btnApply.Enabled := True;

end;

procedure TTableViewFilterForm.OnFilterComboBoxConditionChanged(
  Sender: TObject);
begin

  btnApply.Enabled := True;
  
end;

procedure TTableViewFilterForm.OnFilterFieldValueDateTimePickerChange(
  Sender: TObject);
begin

  btnApply.Enabled := True;
  
end;

procedure TTableViewFilterForm.OnFilterFieldValueSpinEditChange(
  Sender: TObject);
begin

  btnApply.Enabled := True;
  
end;

procedure TTableViewFilterForm.OnFilterFieldValueTextEditChanged(
  Sender: TObject);
begin

  inherited;

  with Sender as TCustomEdit do begin

    btnApply.Enabled := True;
    
  end;
  
end;

procedure TTableViewFilterForm.OnSelectFilterFieldHandle(Sender: TObject);
var FieldNameCheckBox: TCheckBox;
    FilterFieldSubPanel: TPanel;
    FilterValueControl: TControl;
    RegExprValidateEdit: TRegExprValidateEdit;
    RegExprValidateRichEdit: TRegExprValidateRichEdit;
    RegExprValidateMemo: TRegExprValidateMemo;
begin

  FieldNameCheckBox := Sender as TCheckBox;
  FilterFieldSubPanel := GetFilterSubPanel(FieldNameCheckBox.Parent as TPanel);

  SetEnabledChildControls(FieldNameCheckBox.Checked, FilterFieldSubPanel);

  if FieldNameCheckBox.Checked then
    Inc(FSelectFilterFieldCount)

  else Dec(FSelectFilterFieldCount);

  FilterValueControl := GetFilterValueControlFromSubPanel(FilterFieldSubPanel);

  if FilterValueControl is TRegExprValidateEdit then begin

    RegExprValidateEdit := FilterValueControl as TRegExprValidateEdit;
    
    if (Trim(RegExprValidateEdit.Text) <> '') and FieldNameCheckBox.Checked then
      RegExprValidateEdit.IsValid

    else RegExprValidateEdit.Color := clWindow;

  end
  
  else if FilterValueControl is TRegExprValidateRichEdit then begin

    RegExprValidateRichEdit := FilterValueControl as TRegExprValidateRichEdit;

    if (Trim(RegExprValidateRichEdit.Text) <> '') and FieldNameCheckBox.Checked then
      RegExprValidateRichEdit.IsValid

    else RegExprValidateRichEdit.Color := clWindow;

  end

  else if FilterValueControl is TRegExprValidateMemo then begin

    RegExprValidateMemo := FilterValueControl as TRegExprValidateMemo;
    
    if (Trim(RegExprValidateMemo.Text) <> '') and FieldNameCheckBox.Checked then
      RegExprValidateMemo.IsValid

    else RegExprValidateMemo.Color := clWindow;

  end;

  UpdateApplyButtonActivity;
  UpdateResetFilterSettingsButtonActivity;

end;

procedure TTableViewFilterForm.ResetFilterSettingsButtonClick(Sender: TObject);
begin

  if SelectAllFieldsCheckBox.Checked then
    SelectAllFieldsCheckBox.Checked := False

  else
    SetActivatedAllFilterFieldPanels(False);

end;

procedure TTableViewFilterForm.SetDataSetFiltered(const Filtered: Boolean);
begin
  DataSet.Filtered := Filtered;
end;

procedure TTableViewFilterForm.SetDataSetTableView(
  DataSetTableView: TcxGridDBTableView);
begin

  FDataSetTableView := DataSetTableView;

  if Assigned(FDataSetTableView) then begin

    CreateFilterFieldsLayout;
    btnCancelPrevFilter.Enabled := DataSet.Filtered;

  end;

end;

procedure TTableViewFilterForm.SetLastState(
  ALastState: TTableViewFilterFormState);
begin

  if (not FMustSaveStateBeforeClosing) or (not Assigned(ALastState))
  then Exit;

  InternalSetLastState(ALastState);
  
end;

procedure TTableViewFilterForm.SetValueForDateTimeStackedControl(
  DateTimeStackedControl: TDateTimeStackedControl;
  Value: TCloneable
);
begin

  if Value is TDateTimeRange then begin

    DateTimeStackedControl.DateRangePanel.AssignFromDateTimeRange(
      Value as TDateTimeRange
    );

    DateTimeStackedControl.ActivateDateRangePanel;

  end

  else begin

    DateTimeStackedControl.DateTimePicker.DateTime :=
      (Value as TVariant).Value;

    DateTimeStackedControl.ActivateDateTimePicker;
    
  end;

  CenterPanelChildControlsByVert(DateTimeStackedControl.Parent as TPanel);
  
end;

procedure TTableViewFilterForm.SetValueForFilterFieldControl(
  const ColumnField: TcxGridDBColumn;
  FilterFieldValueControl: TControl;
  Value:  TCloneable
);
var FilterVariantValue: TVariant;
begin

  if FilterFieldValueControl is TDateTimeStackedControl then begin

    SetValueForDateTimeStackedControl(
      FilterFieldValueControl as TDateTimeStackedControl, Value
    );
    Exit;
    
  end;

  if not (Value is TVariant) then Exit;

  FilterVariantValue := Value as TVariant;

  if FilterFieldValueControl is TEdit then
       (FilterFieldValueControl as TEdit).Text :=
          VarToStr(FilterVariantValue.Value)

  else if FilterFieldValueControl is TSpinEdit then
      (FilterFieldValueControl as TSpinEdit).Value :=
        FilterVariantValue.Value

  else if FilterFieldValueControl is TCheckBox then
      (FilterFieldValueControl as TCheckBox).Checked :=
        FilterVariantValue.Value

  else if FilterFieldValueControl is TDateTimePicker then
      (FilterFieldValueControl as TDateTimePicker).DateTime :=
        FilterVariantValue.Value

  else if FilterFieldValueControl is TComboBox then
      (FilterFieldValueControl as TComboBox).ItemIndex :=
        FilterVariantValue.Value;

end;

procedure TTableViewFilterForm.UpdateApplyButtonActivity;
begin

  btnApply.Enabled := FSelectFilterFieldCount > 0;

end;

procedure TTableViewFilterForm.UpdateResetFilterSettingsButtonActivity;
begin

  ResetFilterSettingsButton.Enabled := FSelectFilterFieldCount > 0;
  
end;

procedure TTableViewFilterForm.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin

  if FCalculatedHeight > 0 then
    Msg.MinMaxInfo.ptMaxTrackSize.Y := FCalculatedHeight;

  if FFormDefaultMinWidth > 0 then
    Msg.MinMaxInfo.ptMinTrackSize.X := FFormDefaultMinWidth;

end;

{ TFilterFieldControls }

constructor TFilterFieldControls.Create(
ASelectFieldCheckBox: TCheckBox;
  AFilterConditionComboBox: TComboBox;
  AFilterFieldValueControl: TControl;
  AFilterFieldValueControlValidator: TFilterFieldValueControlValidator
);
begin

  SelectFieldCheckBox := ASelectFieldCheckBox;
  FilterConditionComboBox := AFilterConditionComboBox;
  FilterFieldValueControl := AFilterFieldValueControl;

  if not Assigned(AFilterFieldValueControlValidator) then
    FilterFieldValueControlValidator := TDefaultFilterFieldValueControlValidator.Create

  else FilterFieldValueControlValidator := AFilterFieldValueControlValidator;

end;

destructor TFilterFieldControls.Destroy;
begin

  FreeAndNil(FilterFieldValueControl);
  inherited;
  
end;

{ TDateAndTimePicker }

constructor TDateAndTimePicker.Create(AOwner: TComponent);
begin

  inherited;

  OnChange := OnChangeHandle;

end;

procedure TDateAndTimePicker.OnChangeHandle(Sender: TObject);
begin

  SetDateTimeFromCaption;

end;

procedure TDateAndTimePicker.SetDateTimeFromCaption;
begin

  //DateTime := StrToDateTime(Caption);

end;

{ TDefaultFilterFieldValueControlValidator }

function TDefaultFilterFieldValueControlValidator.IsValid: Boolean;
begin

    Result := True;

end;

{ TRegExprValidateEditValidator }

constructor TValidateEditValidator.Create(
  AValidateEdit: TValidateEdit);
begin

  inherited Create;

  FValidateEdit := AValidateEdit;

end;

function TValidateEditValidator.IsValid: Boolean;
begin

  Result := FValidateEdit.IsValid;
  
end;

class function TTableViewFilterForm.CreateTableViewFilterForm(
  ATableViewFilterFormClass: TTableViewFilterFormClass;
  ADataSetTableView: TcxGridDBTableView;
  AOwner: TComponent;
  OnCustomizingEventHandler: TOnCustomizingEventHandler;
  const ACaption, AFilterGroupBoxCaption: String;
  const AFilterFieldPanelMargin, AFilterControlMargin: PRect
): TTableViewFilterForm;
begin

  Result := ATableViewFilterFormClass.Create(nil, ACaption, AOwner);

  if AOwner is TCustomForm then
    Result.PopupParent := AOwner as TCustomForm;

  Result.FilterGroupBoxCaption := AFilterGroupBoxCaption;

  if Assigned(AFilterFieldPanelMargin)  then
    Result.FilterFieldPanelMargin := AFilterFieldPanelMargin^;

  if Assigned(AFilterControlMargin) then
    Result.FilterControlMargin := AFilterControlMargin^;

  if Assigned(OnCustomizingEventHandler) then
    OnCustomizingEventHandler(Result);

  Result.DataSetTableView := ADataSetTableView;
  
end;

class function TTableViewFilterForm.ShowTableViewFilterForm(
  ATableViewFilterFormClass: TTableViewFilterFormClass;
  ADataSetTableView: TcxGridDBTableView;
  AOwner: TComponent;
  OnCustomizingEventHandler: TOnCustomizingEventHandler = nil;
  const AModal: Boolean = True;
  const ACaption: String = '';
  const AFilterGroupBoxCaption: String = FILTER_GROUP_BOX_DEFAULT_CAPTION;
  const AFilterFieldPanelMargin: PRect = nil;
  const AFilterControlMargin: PRect = nil

): TTableViewFilterForm;
begin

  Result :=
    TTableViewFilterForm.CreateTableViewFilterForm(
      ATableViewFilterFormClass,
      ADataSetTableView,
      AOwner,
      OnCustomizingEventHandler,
      ACaption,
      AFilterGroupBoxCaption,
      AFilterFieldPanelMargin,
      AFilterControlMargin
    );

  if AModal then begin

    try

      Result.ShowModal;

    finally

      FreeAndNil(Result);

    end;

  end

  else begin

    try

      Result.Show;

    except

      FreeAndNil(Result);

    end;

  end;

end;

{ TFilterPanelData }

function TFilterPanelData.Clone: TFilterPanelData;
begin

  Result := TFilterPanelData.Create;

  try

    Result.FIsFilterFieldSelected := FIsFilterFieldSelected;
    Result.IsFilterFieldControlFocused := FIsFilterFieldControlFocused;
    Result.FFilterFieldName := FFilterFieldName;
    Result.ConditionExpressionIndex := ConditionExpressionIndex;
    Result.FilterValue := FFilterValue.Clone as TCloneable
    
  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

constructor TFilterPanelData.Create(
  const AIsFilterFieldControlFocused: Boolean;
  const AIsFilterFieldSelected: Boolean;
  const AFilterFieldName: String;
  const AConditionExpressionIndex: Integer;
  const AFilterValue: TCloneable
);
begin

  inherited Create;

  FIsFilterFieldControlFocused := AIsFilterFieldControlFocused;
  FIsFilterFieldSelected := AIsFilterFieldSelected;
  FFilterFieldName := AFilterFieldName;
  FConditionExpressionIndex := AConditionExpressionIndex;
  FFilterValue := AFilterValue;

end;

constructor TFilterPanelData.Create;
begin

  inherited;
  
end;

destructor TFilterPanelData.Destroy;
begin

  FreeAndNil(FFilterValue);
  inherited;

end;

{ TTableViewFilterFormState }

procedure TTableViewFilterFormState.AddFilterPanelData(
  AFilterPanelData: TFilterPanelData);
begin

  FFilterPanelDataList.Add(AFilterPanelData);

end;

function TTableViewFilterFormState.Clone: TTableViewFilterFormState;
begin

  Result := NewInstance as TTableViewFilterFormState;

  Result.FFilterPanelDataList := FFilterPanelDataList.Clone;

  Result.FUseInsensitiveTextFilter := FUseInsensitiveTextFilter;
  Result.FChooseAllFilterFields := FChooseAllFilterFields;
  Result.FFilterActivated := FFilterActivated;
  
end;

constructor TTableViewFilterFormState.Create;
begin

  inherited;

  FFilterPanelDataList := TFilterPanelDataList.Create;

end;

destructor TTableViewFilterFormState.Destroy;
begin

  FreeAndNil(FFilterPanelDataList);
  inherited;

end;

function TTableViewFilterFormState.FindFilterPanelData(
  const AFieldName: String): TFilterPanelData;
var I: Integer;
    FilterPanelData: TFilterPanelData;
begin

  for I := 0 to FFilterPanelDataList.Count - 1 do begin

    FilterPanelData := TFilterPanelData(FFilterPanelDataList[I]);

    if FilterPanelData.FilterFieldName = AFieldName then begin

      Result := FilterPanelData;
      Exit;

    end;

  end;

  Result := nil;

end;

procedure TTableViewFilterFormState.RemoveFilterPanelData(
  const AFieldName: String);
begin

  FFilterPanelDataList.Remove(FindFilterPanelData(AFieldName));
  
end;

function TTableViewFilterFormState.ToDataSetFilter: String;

var I: Integer;
    FilterPanelData: TFilterPanelData;
    LFilterFieldName,
    LFilterCondition,
    LFilterValue,
    FilterFieldExpression: String;
    FilterVariantValue: Variant;
    FilterValueType: TVarType;
    IsFilterFieldString: Boolean;

  function GetFilterConditionExpressionByIndex(
    const ConditionIndex: Integer
  ): String;
  var FilterConditionInfo: TFilterConditionIndexToExpression;
  begin

    for FilterConditionInfo in FilterConditionIndicesToExpressions do
      if FilterConditionInfo.ConditionIndex = ConditionIndex then
      begin

        Result := FilterConditionInfo.ConditionExpression;
        Exit;

      end;

    Result := '';

  end;

begin

  for I := 0 to FFilterPanelDataList.Count - 1 do begin

    with TFilterPanelData(FFilterPanelDataList[I]) do begin

      if not IsFilterFieldSelected then
        Continue;

      if not ((FilterValue is TVariant) or
              (FilterValue is TDateTimeRange)) then
        raise Exception.Create('������������ ��� �������� ������������ ����');

      LFilterFieldName := FilterFieldName;

      LFilterCondition :=
        GetFilterConditionExpressionByIndex(
          ConditionExpressionIndex
        );

      FilterVariantValue := (FilterValue as TVariant).Value;
      LFilterValue := VarToStr(FilterVariantValue);

      FilterValueType := VarType(FilterVariantValue);

      if (FilterValueType = varOleStr) or
         (FilterValueType = varDate) or
         (FilterValueType = varString)
      then begin

        IsFilterFieldString :=
          (FilterValueType = varOleStr) or (FilterValueType = varString);

        if IsFilterFieldString and
           ((ConditionExpressionIndex = CONTAINS_FILTER_COND_IDX) or
            (ConditionExpressionIndex = NOT_CONTAINS_FILTER_COND_IDX))
        then LFilterValue := '*' + LFilterValue + '*';

        LFilterValue := QuotedStr(LFilterValue);

        if FUseInsensitiveTextFilter and IsFilterFieldString
        then begin

          LFilterFieldName := 'lower(' + LFilterFieldName + ')';
          LFilterValue := 'lower(' + LFilterValue + ')';

        end;

      end;

      FilterFieldExpression :=
        '(' + LFilterFieldName + ' ' +
              LFilterCondition + ' ' +
              LFilterValue +
        ')';

      if Result = '' then
        Result := FilterFieldExpression

      else Result := Result + ' and ' + FilterFieldExpression;

    end;

  end;
    
end;

{ TDateTimeStackedControl }

procedure TDateTimeStackedControl.ActivateDateRangePanel;
begin

  ActiveControl := FDateRangePanel;

end;

procedure TDateTimeStackedControl.ActivateDateTimePicker;
begin

  ActiveControl := FDateTimePicker;

end;

function TDateTimeStackedControl.IsDateRangePanelActiveControl: Boolean;
begin

  Result := ActiveControl = FDateRangePanel;

end;

function TDateTimeStackedControl.IsDateTimePickerActiveControl: Boolean;
begin

  Result := ActiveControl = FDateTimePicker;

end;

{ TDateTimeStackedControlComboBox }

constructor TDateTimeStackedControlComboBox.Create(AOwner: TComponent);
begin

  inherited;

end;

constructor TDateTimeStackedControlComboBox.Create(
  DateTimeStackedControl: TDateTimeStackedControl; AOwner: TComponent);
begin

  inherited Create(AOwner);

  Self.DateTimeStackedControl := DateTimeStackedControl;
  
end;

{ TFilterPanelDataListEnumerator }

constructor TFilterPanelDataListEnumerator.Create(
  FilterPanelDataList: TFilterPanelDataList);
begin

  inherited Create(FilterPanelDataList);
  
end;

function TFilterPanelDataListEnumerator.GetCurrentFilterPanelData: TFilterPanelData;
begin

  Result := TFilterPanelData(GetCurrent);

end;

{ TFilterPanelDataList }

function TFilterPanelDataList.Clone: TFilterPanelDataList;
var FilterPanelData: TFilterPanelData;
begin

  Result := TFilterPanelDataList.Create;

  try

    for FilterPanelData in Self do
      Result.Add(FilterPanelData.Clone);

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;
  
end;

function TFilterPanelDataList.GetEnumerator: TFilterPanelDataListEnumerator;
begin

  Result := TFilterPanelDataListEnumerator.Create(Self);
  
end;

function TFilterPanelDataList.GetFilterPanelDataByIndex(
  Index: Integer): TFilterPanelData;
begin

  Result := TFilterPanelData(Get(Index));
  
end;

procedure TFilterPanelDataList.Notify(Ptr: Pointer; Action: TListNotification);
begin

  inherited;

  if Action in [lnDeleted] then
    if Assigned(Ptr) then
      TFilterPanelData(Ptr).Destroy;

end;

procedure TFilterPanelDataList.SetFilterPanelDataByIndex(Index: Integer;
  FilterPanelData: TFilterPanelData);
begin

  Put(Index, FilterPanelData);
  
end;

end.
