unit AbstractDataSetHolder;

interface

uses

  DB,
  VariantListUnit,
  IGetSelfUnit,
  DataSetTypes,
  Disposable,
  SysUtils,
  Classes,
  Variants;

type

  TDataSetHolderFilterApplyingMode = (famDisableControls, famNotDisableControls);
  TDataSetHolderFilterResetMode = (frmEnableControls, frmNotEnableControls);

  IDataSetRecordIdGenerator = interface (IGetSelf)

    function GetIdType: TFieldType;
    function GetIdSize: Integer;
    function GenerateNewId: Variant;
    
  end;

  TAbstractDataSetRecordIdGenerator = class (TInterfacedObject, IDataSetRecordIdGenerator)

    public

      function GetSelf: TObject;

      function GetIdType: TFieldType; virtual; abstract;
      function GetIdSize: Integer; virtual; abstract;
      function GenerateNewId: Variant; virtual; abstract;

  end;

  TIntegerDataSetRecordIdGenerator = class (TAbstractDataSetRecordIdGenerator)

    protected

      FCurrentGeneratedId: Integer;
      
    public

      function GetIdType: TFieldType; override;
      function GetIdSize: Integer; override;
      function GenerateNewId: Variant; override;

  end;

  TNegativeIntegerDataSetRecordIdGenerator = class (TAbstractDataSetRecordIdGenerator)

    protected

      FIntegerDataSetRecordIdGenerator: IDataSetRecordIdGenerator;

    public

      destructor Destroy; override;
      constructor Create(
        IntegerDataSetRecordIdGenerator: TIntegerDataSetRecordIdGenerator
      );

      function GetIdType: TFieldType; override;
      function GetIdSize: Integer; override;
      function GenerateNewId: Variant; override;
      
  end;

  IDataSetRecordIdGeneratorFactory = interface

    function CreateRecordIdGenerator: IDataSetRecordIdGenerator;

  end;

  TAbstractDataSetRecordIdGeneratorFactory = class (TInterfacedObject, IDataSetRecordIdGeneratorFactory)

    public

      function CreateRecordIdGenerator: IDataSetRecordIdGenerator; virtual; abstract;

  end;

  TDataSetRecordIdGeneratorType = (gtIntegerSerial, gtNegativeIntegerSerial);
  
  TIntegerDataSetRecordIdGeneratorFactory = class (TAbstractDataSetRecordIdGeneratorFactory)

    public

      function CreateRecordIdGenerator: IDataSetRecordIdGenerator; override;

  end;

  TNegativeIntegerDataSetRecordIdGeneratorFactory = class (TAbstractDataSetRecordIdGeneratorFactory)

    private

      FIntegerDataSetRecordIdGeneratorFactory: TIntegerDataSetRecordIdGeneratorFactory;
      
    public

      constructor Create(IntegerDataSetRecordIdGeneratorFactory: TIntegerDataSetRecordIdGeneratorFactory);
      
      function CreateRecordIdGenerator: IDataSetRecordIdGenerator; override;
      
  end;

  TAbstractDataSetFieldDefs = class (TInterfacedObject, IDisposable)

    private

      FRecordStatusFieldName: String;

    protected

      function GetRecordStatusFieldName: String; virtual;
      procedure SetRecordStatusFieldName(const Value: String); virtual;

    public

      constructor Create; virtual;
      
    public

      RecordIdFieldName: String;
      IsRecordIdGeneratedFieldName: String;
      CanBeChangedFieldName: String;
      CanBeRemovedFieldName: String;
      IsSelectedFieldName: String;

      property RecordStatusFieldName: String
      read GetRecordStatusFieldName write SetRecordStatusFieldName;
      
  end;

  TAbstractDataSetFieldDefsClass = class of TAbstractDataSetFieldDefs;

  TAbstractDataSetHolder = class;

  TDataSetTraverseHandler = procedure (DataSetHolder: TAbstractDataSetHolder; Context: TObject) of object;
  TDataSetTraverseProcedure = procedure (DataSetHolder: TAbstractDataSetHolder; Context: TObject);
  
  TAbstractDataSetHolder = class abstract (TInterfacedObject, IDisposable)

    private

      function GetRecordIdGenerator: IDataSetRecordIdGenerator;

    protected

      procedure Initialize; virtual;
      
    protected

      FViewAllowed: Boolean;
      FAddingAllowed: Boolean;
      FEditingAllowed: Boolean;
      FRemovingAllowed: Boolean;
      
    protected
      
      function IsFieldDefsHasValidType(
        FieldDefs: TAbstractDataSetFieldDefs
      ): Boolean; virtual;
      
      procedure RaiseExceptionIfFieldDefsHasNotValidType(
        FieldDefs: TAbstractDataSetFieldDefs
      ); virtual;
      
    protected

      FRecordAddedStatusValue: Variant;
      FRecordChangedStatusValue: Variant;
      FRecordRemovedStatusValue: Variant;
      FRecordNonChangedStatusValue: Variant;

    protected

      FOnDataSetRecordInsertedEventHandler: TDataSetNotifyEvent;
      FOnDataSetRecordChangedEventHandler: TDataSetNotifyEvent;
      FOnDataSetRecordRemovedEventHandler: TDataSetNotifyEvent;
      
    protected

      FDataSet: TDataSet;
      FFreeDataSet: IInterface;

      FFieldDefs: TAbstractDataSetFieldDefs;
      FFreeFieldDefs: IDisposable;
      
      FRecordIdGenerator: IDataSetRecordIdGenerator;
      FGenerateRecordIdOnAdding: Boolean;

      function GetDataSet: TDataSet; virtual;
      procedure SetDataSet(const Value: TDataSet); virtual;
      procedure SetFieldDefs(const Value: TAbstractDataSetFieldDefs); virtual;
      procedure SetRecordIdGenerator(Value: IDataSetRecordIdGenerator); virtual;
      procedure SubscribeOnDataSetEvents(DataSet: TDataSet);

    protected

      procedure OnDataSetRecordInserted(DataSet: TDataSet); virtual;
      procedure OnDataSetRecordChanged(DataSet: TDataSet); virtual;
      procedure OnDataSetRecordRemoved(DataSet: TDataSet); virtual;

    protected

      function GetGenerateRecordIdOnAdding: Boolean;
      procedure SetGenerateRecordIdOnAdding(const Value: Boolean);

      function GetIsRecordIdGeneratedFieldValue: Boolean;
      function GetRecordIdFieldValue: Variant;
      
      procedure SetIsRecordIdGeneratedFieldValue(const Value: Boolean);
      procedure SetRecordIdFieldValue(const Value: Variant);

      function GetCanBeChangedFieldValue: Variant;
      function GetCanBeRemovedFieldValue: Variant;

      procedure SetCanBeChangedFieldValue(const Value: Variant);
      procedure SetCanBeRemovedFieldValue(const Value: Variant);

      function GetRecordStatusFieldValue: Variant;

      function GetSelectedRecordIds: TVariantList;
      procedure SetSelectedRecordIds(const Value: TVariantList);

    protected

      function GetRecordAddedStatusValue: Variant; virtual;
      procedure SetRecordAddedStatusValue(const Value: Variant); virtual;

      function GetRecordChangedStatusValue: Variant; virtual;
      procedure SetRecordChangedStatusValue(const Value: Variant); virtual;

      function GetRecordNonChangedStatusValue: Variant; virtual;
      procedure SetRecordNonChangedStatusValue(const Value: Variant); virtual;

      function GetRecordRemovedStatusValue: Variant; virtual;
      procedure SetRecordRemovedStatusValue(const Value: Variant); virtual;

    protected
	
	    function GetIsRecordIdGeneratedFieldName: String;
      function GetRecordIdFieldName: String;
      
      procedure SetIsRecordIdGeneratedFieldName(const Value: String);
      procedure SetRecordIdFieldName(const Value: String);
	  
      function GetCanBeChangedFieldName: String;
      function GetCanBeRemovedFieldName: String;
      
      procedure SetCanBeChangedFieldName(const Value: String);
      procedure SetCanBeRemovedFieldName(const Value: String);

      function GetRecordStatusFieldName: String; virtual;
      procedure SetRecordStatusFieldName(const Value: String); virtual;

    protected

      function GetIsSelectedFieldName: String;
      function GetIsSelectedFieldValue: Variant;
      function GetSelectable: Boolean;

      procedure SetIsSelectedFieldName(const Value: String);
      procedure SetIsSelectedFieldValue(const Value: Variant);
      procedure SetSelectable(const Value: Boolean);

    protected

      function GetHasCurrentRecordAddedStatus: Boolean;
      function GetHasCurrentRecordChangedStatus: Boolean;
      function GetHasCurrentRecordNonChangedStatus: Boolean;
      function GetHasCurrentRecordRemovedStatus: Boolean;

    protected

      procedure MarkAllRecordsByStatusValue(const StatusValue: Variant);

      procedure SetRecordStatusFieldValue(const StatusValue: Variant);

    protected

      procedure SetRecordsSelected(const RecordIds: TVariantList; const Selected: Boolean);

    private

      procedure InternalForEach(CallWrapper: IGetSelf; Context: TObject);
      
    public

      constructor Create; virtual;
      constructor CreateFrom(DataSet: TDataSet); overload; virtual;
      constructor CreateFrom(DataSet: TDataSet; FieldDefs: TAbstractDataSetFieldDefs); overload; virtual;

      function GetDataSetFieldValue(
        const FieldName: String;
        DefaultValue: Variant
      ): Variant;

      procedure SetDataSetFieldValue(
        const FieldName: String;
        const Value: Variant
      );

      procedure Open;

      function IsDataSetFieldExists(const FieldName: String): Boolean;
      
      function Eof: Boolean; virtual;
      function Bof: Boolean; virtual;
      function IsEmpty: Boolean; virtual;
      function RecordCount: Integer; virtual; 
    
      procedure Append; virtual;
      procedure AppendWithoutRecordIdGeneration; virtual;
      procedure AppendRecord(const Values: array of TVarRec); virtual;
      procedure Edit; virtual;
      procedure Post; virtual;
      procedure Delete; virtual;

      function IsFieldExists(const FieldName: String): Boolean;
      
      procedure Next; virtual;
      procedure First; virtual;

      procedure Refresh;

      function GetBookmark: TRecordBookmark;
      function GotoBookmark(Bookmark: TRecordBookmark): Boolean;
      function GotoBookmarkAndFree(Bookmark: TRecordBookmark): Boolean;
      
      procedure EnableControls; virtual;
      procedure DisableControls; virtual;
      
      procedure GenerateNewIdForCurrentRecord; virtual;
      function GetIsCurrentRecordIdGenerated: Boolean; virtual;
      
      procedure ApplyFilter(
        const Expression: String;
        const FilterMode: TDataSetHolderFilterApplyingMode = famNotDisableControls
      );

      procedure RevealRecordsWithGeneratedId(
        const FilterMode: TDataSetHolderFilterApplyingMode = famDisableControls
      );
      
      procedure ResetFilter(
        const FilterMode: TDataSetHolderFilterResetMode = frmEnableControls
      );

      function ContainsRecords(const RecordIds: TVariantList): Boolean;
      
      function LocateByRecordId(const IdFieldValues: Variant; const Options: TLocateOptions = []): Boolean;
	    function Locate(const FieldNames: String; const FieldValues: Variant; const Options: TLocateOptions = []): Boolean;

      function LookupByRecordId(const IdFieldValues: Variant; const ResultFieldNames: String): Variant;
      function Lookup(const KeyFieldNames: String; const KeyFieldValues: Variant; const ResultFieldNames: String): Variant;

      function IsInEdit: Boolean;
      function IsInAppend: Boolean;
      function IsInEditOrAppend: Boolean;

      function ExtractDataSet: TDataSet;
      function ExtractRecordIdGenerator: IDataSetRecordIdGenerator;

      function HasRecordGeneratedId(const RecordId: Variant): Boolean;

      procedure SetFieldValueForEach(const FieldName: String; const FieldValue: Variant);
      
    public

      procedure FilterByRecordStatus(
        const Status: Variant
      );

      procedure RevealAllRecords;
      procedure RevealAddedRecords;
      procedure RevealChangedRecords;
      procedure RevealNonRemovedRecords;
      procedure RevealRemovedRecords;

      procedure MarkAllRecordsAsNonChanged;
      procedure MarkAllRecordsAsCommited;
      procedure MarkRemovedRecordsAsNonChanged;
      procedure MarkCurrentRecordAsAdded;
      procedure MarkCurrentRecordAsChanged;
      procedure MarkCurrentRecordAsChangedIfIdIsNotGenerated;
      procedure MarkCurrentRecordAsRemoved;
      procedure MarkCurrentRecordAsRemovedOrDeleteIfIdIsGenerated;
      procedure MarkCurrentRecordAsNonChanged;

      function AreChangedRecordsExists: Boolean;

      procedure RejectLocalChanges;

      procedure SetFieldValue(const FieldName: String; const Value: Variant);

      procedure DeSelectRecords(RecordIds: TVariantList);

      procedure ForEach(TraverseHandler: TDataSetTraverseHandler; Context: TObject = nil); overload;
      procedure ForEach(TraverseProcedure: TDataSetTraverseProcedure; Context: TObject = nil); overload;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; virtual; abstract;

    published

      property DataSet: TDataSet
      read GetDataSet write SetDataSet;

      property FieldDefs: TAbstractDataSetFieldDefs
      read FFieldDefs write SetFieldDefs;
      
      property RecordIdGenerator: IDataSetRecordIdGenerator
      read GetRecordIdGenerator write SetRecordIdGenerator;

      property IsCurrentRecordIdGenerated: Boolean
      read GetIsCurrentRecordIdGenerated;

    published

	    property RecordIdFieldName: String
      read GetRecordIdFieldName write SetRecordIdFieldName;

      property IsRecordIdGeneratedFieldName: String
      read GetIsRecordIdGeneratedFieldName
      write SetIsRecordIdGeneratedFieldName;
      									
      property CanBeChangedFieldName: String
      read GetCanBeChangedFieldName write SetCanBeChangedFieldName;

      property CanBeRemovedFieldName: String
      read  GetCanBeRemovedFieldName write SetCanBeRemovedFieldName;

      property RecordStatusFieldName: String
      read GetRecordStatusFieldName write SetRecordStatusFieldName;

      property IsSelectedFieldName: String
      read GetIsSelectedFieldName write SetIsSelectedFieldName;

    published

      property RecordIdFieldValue: Variant
      read GetRecordIdFieldValue write SetRecordIdFieldValue;

      property IsRecordIdGeneratedFieldValue: Boolean
      read GetIsRecordIdGeneratedFieldValue
      write SetIsRecordIdGeneratedFieldValue;

      property CanBeChangedFieldValue: Variant
      read GetCanBeChangedFieldValue write SetCanBeChangedFieldValue;

      property CanBeRemovedFieldValue: Variant
      read  GetCanBeRemovedFieldValue write SetCanBeRemovedFieldValue;

      property IsSelectedFieldValue: Variant
      read GetIsSelectedFieldValue write SetIsSelectedFieldValue;
      
      property GenerateRecordIdOnAdding: Boolean
      read GetGenerateRecordIdOnAdding write SetGenerateRecordIdOnAdding;
      
    published

      property RecordAddedStatusValue: Variant
      read GetRecordAddedStatusValue
      write SetRecordAddedStatusValue;

      property RecordChangedStatusValue: Variant
      read GetRecordChangedStatusValue
      write SetRecordChangedStatusValue;

      property RecordRemovedStatusValue: Variant
      read GetRecordRemovedStatusValue
      write SetRecordRemovedStatusValue;

      property RecordNonChangedStatusValue: Variant
      read GetRecordNonChangedStatusValue
      write SetRecordNonChangedStatusValue;

      property RecordStatusFieldValue: Variant
      read GetRecordStatusFieldValue;

    published

      property HasCurrentRecordAddedStatus: Boolean
      read GetHasCurrentRecordAddedStatus;

      property HasCurrentRecordChangedStatus: Boolean
      read GetHasCurrentRecordChangedStatus;

      property HasCurrentRecordRemovedStatus: Boolean
      read GetHasCurrentRecordRemovedStatus;

      property HasCurrentRecordNonChangedStatus: Boolean
      read GetHasCurrentRecordNonChangedStatus;

    published

      property Selectable: Boolean
      read GetSelectable write SetSelectable;

      property SelectedRecordIds: TVariantList
      read GetSelectedRecordIds write SetSelectedRecordIds;
      
    published

      property ViewAllowed: Boolean read FViewAllowed write FViewAllowed;
      property AddingAllowed: Boolean read FAddingAllowed write FAddingAllowed;
      property EditingAllowed: Boolean read FEditingAllowed write FEditingAllowed;
      property RemovingAllowed: Boolean read FRemovingAllowed write FRemovingAllowed;

    published

      property OnDataSetRecordInsertedEventHandler: TDataSetNotifyEvent
      read FOnDataSetRecordInsertedEventHandler
      write FOnDataSetRecordInsertedEventHandler;
      
      property OnDataSetRecordChangedEventHandler: TDataSetNotifyEvent
      read FOnDataSetRecordChangedEventHandler
      write FOnDataSetRecordChangedEventHandler;
      
      property OnDataSetRecordRemovedEventHandler: TDataSetNotifyEvent
      read FOnDataSetRecordRemovedEventHandler
      write FOnDataSetRecordRemovedEventHandler;

  end;
  
implementation

uses

  NameValue,
  VariantFunctions,
  AuxDataSetFunctionsUnit,
  AuxDebugFunctionsUnit;

type


  TDataSetTraverseCallWrapper = class (TInterfacedObject, IGetSelf)

    private

      FTraverseHandler: TDataSetTraverseHandler;
      FTraverseProcedure: TDataSetTraverseProcedure;

    public

      constructor Create(TraverseHandler: TDataSetTraverseHandler); overload;
      constructor Create(TraverseProcedure: TDataSetTraverseProcedure); overload;

      function GetSelf: TObject;

      procedure Call(DataSetHolder: TAbstractDataSetHolder; Context: TObject);
      
  end;
  
{ TAbstractDataSetHolder }

procedure TAbstractDataSetHolder.Append;
begin

  FDataSet.Append;
                            
  if GenerateRecordIdOnAdding and Assigned(RecordIdGenerator) then
    GenerateNewIdForCurrentRecord;
  
end;

procedure TAbstractDataSetHolder.AppendRecord(const Values: array of TVarRec);
begin

  DataSet.AppendRecord(Values);
  
end;

procedure TAbstractDataSetHolder.AppendWithoutRecordIdGeneration;
begin

  FDataSet.Append;
  
end;

procedure TAbstractDataSetHolder.ApplyFilter(const Expression: String;
    const FilterMode: TDataSetHolderFilterApplyingMode = famNotDisableControls
);
begin

  try

    if not FDataSet.ControlsDisabled then
      FDataSet.DisableControls;

    FDataSet.Filter := Expression;
    FDataSet.Filtered := True;
    
  finally

    if FilterMode = famNotDisableControls then
      FDataSet.EnableControls;
      
  end;

end;

function TAbstractDataSetHolder.AreChangedRecordsExists: Boolean;
var PreviousFilter: String;
begin

  PreviousFilter := DataSet.Filter;

  try

    DataSet.DisableControls;

    DataSet.Filter :=
      Format(
        '%s<>%s',
        [
          RecordStatusFieldName,
          RecordNonChangedStatusValue
        ]
      );

    DataSet.Filtered := True;

    Result := DataSet.RecordCount > 0;

  finally

    if PreviousFilter <> '' then begin

      DataSet.Filter := PreviousFilter;
      DataSet.Filtered := True;

    end

    else begin

      DataSet.Filter := '';
      DataSet.Filtered := False;

    end;

    DataSet.EnableControls;

  end;
  
end;

function TAbstractDataSetHolder.Bof: Boolean;
begin

  Result := FDataSet.Bof;
  
end;

function TAbstractDataSetHolder.ContainsRecords(
  const RecordIds: TVariantList): Boolean;
var
    RecordId: Variant;
begin

  for RecordId in RecordIds do
    if not LookupByRecordId(RecordId, RecordIdFieldName) then begin

      Result := False;
      Exit;

    end;

  Result := True;
    
end;

constructor TAbstractDataSetHolder.Create;
begin

  inherited;

  Initialize;
  
end;

constructor TAbstractDataSetHolder.CreateFrom(
  DataSet: TDataSet;
  FieldDefs: TAbstractDataSetFieldDefs
);
begin

  CreateFrom(DataSet);

  Self.FieldDefs := FieldDefs;
  
end;

constructor TAbstractDataSetHolder.CreateFrom(DataSet: TDataSet);
begin

  inherited;

  Initialize;
  
  Self.DataSet := DataSet;
  
end;

procedure TAbstractDataSetHolder.Delete;
begin

  FDataSet.Delete;
  
end;

procedure TAbstractDataSetHolder.DeSelectRecords(RecordIds: TVariantList);
begin

  SetRecordsSelected(RecordIds, False);
  
end;

procedure TAbstractDataSetHolder.DisableControls;
begin

  //if not FDataSet.ControlsDisabled then { it's not correctly working for nested DisableControls/EnableControls cases }
    FDataSet.DisableControls;

end;

procedure TAbstractDataSetHolder.Edit;
begin

  FDataSet.Edit;
  
end;

procedure TAbstractDataSetHolder.EnableControls;
begin

  //if FDataSet.ControlsDisabled then { it's not correctly working for nested DisableControls/EnableControls cases }
    FDataSet.EnableControls;
  
end;

function TAbstractDataSetHolder.Eof: Boolean;
begin

  Result := FDataSet.Eof;

end;

function TAbstractDataSetHolder.ExtractDataSet: TDataSet;
begin

  Result := FDataSet;

end;

function TAbstractDataSetHolder.
  ExtractRecordIdGenerator: IDataSetRecordIdGenerator;
begin

  Result := RecordIdGenerator;

end;

procedure TAbstractDataSetHolder.FilterByRecordStatus(const Status: Variant);
begin

  DataSet.Filter :=
    Format(
      '%s=%s',
      [RecordStatusFieldName, Status]
    );

  DataSet.Filtered := True;

end;

procedure TAbstractDataSetHolder.First;
begin

  FDataSet.First;
  
end;

procedure TAbstractDataSetHolder.ForEach(
  TraverseHandler: TDataSetTraverseHandler;
  Context: TObject
);
begin

  InternalForEach(TDataSetTraverseCallWrapper.Create(TraverseHandler), Context);

end;

procedure TAbstractDataSetHolder.ForEach(
  TraverseProcedure: TDataSetTraverseProcedure; Context: TObject);
begin

  InternalForEach(TDataSetTraverseCallWrapper.Create(TraverseProcedure), Context);

end;

procedure TAbstractDataSetHolder.InternalForEach(CallWrapper: IGetSelf;
  Context: TObject);
var
    CurrentRecordPointer: TRecordBookmark;
begin

  CurrentRecordPointer := nil;

  DisableControls;

  try

    CurrentRecordPointer := GetBookmark;

    First;

    while not Eof do begin

      TDataSetTraverseCallWrapper(CallWrapper.Self).Call(Self, Context);
      
      Next;

    end;

  finally

    try

      GotoBookmarkAndFree(CurrentRecordPointer);

    finally

      EnableControls;

    end;

  end;

end;


procedure TAbstractDataSetHolder.GenerateNewIdForCurrentRecord;
begin

  if not Assigned(FRecordIdGenerator) then begin

    raise Exception.Create(
      'RecordIdGenerator not Assigned'
    );

  end;

  if not Assigned(FFieldDefs) then begin

    raise Exception.Create(
      'FieldDefs not assigned for record id generation'
    );

  end;

  if (Trim(FieldDefs.RecordIdFieldName) = '') or
     (Trim(FieldDefs.IsRecordIdGeneratedFieldName) = '')
  then begin

    raise Exception.Create(
      'Field names not assigned for record id generation'
    );

  end;
  
  RecordIdFieldValue := FRecordIdGenerator.GenerateNewId;
  IsRecordIdGeneratedFieldValue := True;

end;

function TAbstractDataSetHolder.GetBookmark: TRecordBookmark;
begin

  Result := FDataSet.GetBookmark;

end;

function TAbstractDataSetHolder.GetCanBeChangedFieldName: String;
begin

  Result := FFieldDefs.CanBeChangedFieldName;
  
end;

function TAbstractDataSetHolder.GetCanBeChangedFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(
      FFieldDefs.CanBeChangedFieldName, Null
    );

end;

function TAbstractDataSetHolder.GetCanBeRemovedFieldName: String;
begin

  Result := FFieldDefs.CanBeRemovedFieldName;
  
end;

function TAbstractDataSetHolder.GetCanBeRemovedFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(
      FFieldDefs.CanBeRemovedFieldName,
      Null
    );

end;

function TAbstractDataSetHolder.GetDataSet: TDataSet;
begin

  Result := FDataSet;
  
end;

function TAbstractDataSetHolder.GetDataSetFieldValue(const FieldName: String;
  DefaultValue: Variant): Variant;
var
    Field: TField;
begin

  Field := FDataSet.FindField(FieldName);

  if not Assigned(Field) then
    Result := Null

  else if Field.IsNull then
    Result := DefaultValue

  else
    Result := Field.AsVariant;

end;

function TAbstractDataSetHolder.GetGenerateRecordIdOnAdding: Boolean;
begin

  Result := FGenerateRecordIdOnAdding;

end;

function TAbstractDataSetHolder.GetHasCurrentRecordAddedStatus: Boolean;
begin


  Result := not VarIsNull(RecordAddedStatusValue) and (GetRecordStatusFieldValue = RecordAddedStatusValue);
  
end;

function TAbstractDataSetHolder.GetHasCurrentRecordChangedStatus: Boolean;
begin

  Result := not VarIsNull(RecordChangedStatusValue) and (GetRecordStatusFieldValue = RecordChangedStatusValue);
  
end;

function TAbstractDataSetHolder.GetHasCurrentRecordNonChangedStatus: Boolean;
begin

  Result := not VarIsNull(RecordNonChangedStatusValue) and (GetRecordStatusFieldValue = RecordNonChangedStatusValue);
  
end;

function TAbstractDataSetHolder.GetHasCurrentRecordRemovedStatus: Boolean;
begin

  Result := not VarIsNull(RecordNonChangedStatusValue) and (GetRecordStatusFieldValue = RecordRemovedStatusValue);
  
end;

function TAbstractDataSetHolder.GetIsCurrentRecordIdGenerated: Boolean;
begin

  Result := False;

end;

function TAbstractDataSetHolder.GetIsRecordIdGeneratedFieldName: String;
begin

  Result := FieldDefs.IsRecordIdGeneratedFieldName;
  
end;

function TAbstractDataSetHolder.GetIsRecordIdGeneratedFieldValue: Boolean;
begin

  Result :=
    GetDataSetFieldValue(
      FFieldDefs.IsRecordIdGeneratedFieldName,
      False
    );
    
end;

function TAbstractDataSetHolder.GetIsSelectedFieldName: String;
begin

  Result := FFieldDefs.IsSelectedFieldName;

end;

function TAbstractDataSetHolder.GetIsSelectedFieldValue: Variant;
begin

  if Selectable then
    Result := GetDataSetFieldValue(IsSelectedFieldName, Null)

  else Result := Null;

end;

function TAbstractDataSetHolder.GetRecordAddedStatusValue: Variant;
begin

  Result := FRecordAddedStatusValue;

end;

function TAbstractDataSetHolder.GetRecordChangedStatusValue: Variant;
begin

  Result := FRecordChangedStatusValue;
  
end;

function TAbstractDataSetHolder.GetRecordIdFieldName: String;
begin

  Result := FieldDefs.RecordIdFieldName;
  
end;

function TAbstractDataSetHolder.GetRecordIdFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(
      FFieldDefs.RecordIdFieldName,
      Null
    );
    
end;

function TAbstractDataSetHolder.GetRecordIdGenerator: IDataSetRecordIdGenerator;
begin

  Result := FRecordIdGenerator;
  
end;

function TAbstractDataSetHolder.GetRecordNonChangedStatusValue: Variant;
begin

  Result := FRecordNonChangedStatusValue;

end;

function TAbstractDataSetHolder.GetRecordRemovedStatusValue: Variant;
begin

  Result := FRecordRemovedStatusValue;

end;

function TAbstractDataSetHolder.GetRecordStatusFieldName: String;
begin

  Result := FieldDefs.RecordStatusFieldName;

end;

function TAbstractDataSetHolder.GetRecordStatusFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(RecordStatusFieldName, Null);
  
end;

function TAbstractDataSetHolder.GetSelectable: Boolean;
begin

  Result := IsDataSetFieldExists(IsSelectedFieldName);
  
end;

function TAbstractDataSetHolder.GetSelectedRecordIds: TVariantList;
var
    CurrentRecordPointer: TRecordBookmark;
begin

  if not Selectable then begin

    Result := nil;
    Exit;

  end;

  CurrentRecordPointer := GetBookmark;

  try

    Result := TVariantList.Create;

    try

      while not Eof do
        if IsSelectedFieldValue then
          Result.Add(RecordIdFieldValue);

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    GotoBookmarkAndFree(CurrentRecordPointer);

  end;


end;

function TAbstractDataSetHolder.GotoBookmark(Bookmark: TRecordBookmark): Boolean;
begin

  Result := Assigned(Bookmark) and FDataSet.BookmarkValid(Bookmark);

  if Result then
    FDataSet.GotoBookmark(Bookmark);

end;

function TAbstractDataSetHolder.GotoBookmarkAndFree(Bookmark: TRecordBookmark): Boolean;
begin

  Result := GotoBookmark(Bookmark);

  if Result then
    FDataSet.FreeBookmark(Bookmark);
    
end;

function TAbstractDataSetHolder.HasRecordGeneratedId(
  const RecordId: Variant): Boolean;
var
    VarRes: Variant;
begin

  VarRes := LookupByRecordId(RecordId, IsRecordIdGeneratedFieldName);

  Result := not VarIsNullOrEmpty(VarRes) and VarRes;

end;

procedure TAbstractDataSetHolder.Initialize;
begin

  FieldDefs := GetDataSetFieldDefsClass.Create;

  ViewAllowed := True;
  AddingAllowed := True;
  EditingAllowed := True;
  RemovingAllowed := True;

  FRecordAddedStatusValue := Null;
  FRecordChangedStatusValue := Null;
  FRecordRemovedStatusValue := Null;
  FRecordNonChangedStatusValue := Null;

end;

function TAbstractDataSetHolder.IsDataSetFieldExists(
  const FieldName: String): Boolean;
begin

  Result := Assigned(FDataSet.FindField(FieldName));
  
end;

function TAbstractDataSetHolder.IsEmpty: Boolean;
begin

  Result := FDataSet.IsEmpty;
  
end;

function TAbstractDataSetHolder.
  IsFieldDefsHasValidType(FieldDefs: TAbstractDataSetFieldDefs): Boolean;
begin

  Result := FieldDefs.ClassType = GetDataSetFieldDefsClass;
  
end;

function TAbstractDataSetHolder.IsFieldExists(const FieldName: String): Boolean;
begin

  Result := Assigned(FDataSet.FindField(FieldName));
  
end;

function TAbstractDataSetHolder.IsInAppend: Boolean;
begin

  Result := FDataSet.State in [dsInsert];

end;

function TAbstractDataSetHolder.IsInEdit: Boolean;
begin

  Result := FDataSet.State in [dsEdit];

end;

function TAbstractDataSetHolder.IsInEditOrAppend: Boolean;
begin

  Result := IsInAppend or IsInEdit;
  
end;

function TAbstractDataSetHolder.Locate(const FieldNames: String;
  const FieldValues: Variant; const Options: TLocateOptions): Boolean;
begin

  DebugOutput(FDataSet.RecordCount);
  
  Result := FDataSet.Locate(FieldNames, FieldValues, Options);
  
end;

function TAbstractDataSetHolder.LocateByRecordId(const IdFieldValues: Variant;
  const Options: TLocateOptions): Boolean;
begin

  Result := Locate(RecordIdFieldName, IdFieldValues, Options);
  
end;

function TAbstractDataSetHolder.Lookup(const KeyFieldNames: String;
  const KeyFieldValues: Variant; const ResultFieldNames: String): Variant;
begin

  Result := DataSet.Lookup(KeyFieldNames, KeyFieldValues, ResultFieldNames);
  
end;

function TAbstractDataSetHolder.LookupByRecordId(const IdFieldValues: Variant;
  const ResultFieldNames: String): Variant;
begin

  Result := Lookup(RecordIdFieldName, IdFieldValues, ResultFieldNames);
  
end;

procedure TAbstractDataSetHolder.MarkAllRecordsAsCommited;
var PreviousFocusedRecordPointer: TRecordBookmark;
begin

  PreviousFocusedRecordPointer := DataSet.GetBookmark;

  try

    DataSet.DisableControls;

    RevealRemovedRecords;

    DataSet.First;

    while not DataSet.Eof do
      DataSet.Delete;

    RevealAllRecords;

    while not DataSet.Eof do begin

      MarkCurrentRecordAsNonChanged;
      
      DataSet.Next;

    end;

  finally

    try

      GotoBookmarkAndFree(PreviousFocusedRecordPointer);
      
    finally

      DataSet.EnableControls;
      
    end;

  end;
end;

procedure TAbstractDataSetHolder.MarkAllRecordsAsNonChanged;
begin

  MarkAllRecordsByStatusValue(RecordNonChangedStatusValue);
  
end;

procedure TAbstractDataSetHolder.MarkAllRecordsByStatusValue(
  const StatusValue: Variant);
var PreviousFocusedRecordPointer: TRecordBookmark;
begin

  PreviousFocusedRecordPointer := DataSet.GetBookmark;
  
  try

    DataSet.DisableControls;

    RevealAllRecords;
    
    DataSet.First;

    while not DataSet.Eof do begin

      SetRecordStatusFieldValue(StatusValue);
      
      DataSet.Next;

    end;
    
  finally

    try

      GotoBookmarkAndFree(PreviousFocusedRecordPointer);

    finally

      DataSet.EnableControls;

    end;

  end;
  
end;

procedure TAbstractDataSetHolder.MarkCurrentRecordAsChanged;
begin

  SetRecordStatusFieldValue(RecordChangedStatusValue);
  
end;

procedure TAbstractDataSetHolder.MarkCurrentRecordAsChangedIfIdIsNotGenerated;
begin

  if not IsRecordIdGeneratedFieldValue then
    MarkCurrentRecordAsChanged;
    
end;

procedure TAbstractDataSetHolder.MarkCurrentRecordAsAdded;
begin

  SetRecordStatusFieldValue(RecordAddedStatusValue);
  
end;

procedure TAbstractDataSetHolder.MarkCurrentRecordAsNonChanged;
begin

  SetRecordStatusFieldValue(RecordNonChangedStatusValue);
  
end;

procedure TAbstractDataSetHolder.MarkCurrentRecordAsRemovedOrDeleteIfIdIsGenerated;
begin

  if IsRecordIdGeneratedFieldValue then
    Delete

  else MarkCurrentRecordAsRemoved;
  
end;

procedure TAbstractDataSetHolder.MarkCurrentRecordAsRemoved;
begin

  SetRecordStatusFieldValue(RecordRemovedStatusValue);
  
end;

procedure TAbstractDataSetHolder.MarkRemovedRecordsAsNonChanged;
var PreviousFilter: String;
begin

  PreviousFilter := DataSet.Filter;

  DataSet.DisableControls;

  try

    RevealRemovedRecords;

    DataSet.First;

    while not DataSet.Eof do begin

      MarkCurrentRecordAsNonChanged;

    end;

    if PreviousFilter <> '' then begin

      DataSet.Filter := PreviousFilter;
      DataSet.Filtered := True;
      
    end;

  finally

    DataSet.EnableControls;

  end;
end;

procedure TAbstractDataSetHolder.Next;
begin

  FDataSet.Next;
  
end;

procedure TAbstractDataSetHolder.OnDataSetRecordChanged(DataSet: TDataSet);
begin

  if Assigned(FOnDataSetRecordChangedEventHandler) then
    FOnDataSetRecordChangedEventHandler(DataSet);
    
end;

procedure TAbstractDataSetHolder.OnDataSetRecordInserted(DataSet: TDataSet);
begin

  if Assigned(FOnDataSetRecordInsertedEventHandler) then
    FOnDataSetRecordInsertedEventHandler(DataSet);
    
end;

procedure TAbstractDataSetHolder.OnDataSetRecordRemoved(DataSet: TDataSet);
begin

  if Assigned(FOnDataSetRecordRemovedEventHandler) then
    FOnDataSetRecordRemovedEventHandler(DataSet);
    
end;

procedure TAbstractDataSetHolder.Open;
begin

  FDataSet.Open;
  
end;

procedure TAbstractDataSetHolder.Post;
begin

  FDataSet.Post;
  
end;

procedure TAbstractDataSetHolder.RaiseExceptionIfFieldDefsHasNotValidType(
  FieldDefs: TAbstractDataSetFieldDefs
);
begin

  if not IsFieldDefsHasValidType(FieldDefs) then begin

    raise Exception.CreateFmt(
      'DataSet FieldDefs had invalid type. ' +
      'Was expecting "%s" but actual was being "%s"',
      [
        GetDataSetFieldDefsClass.ClassName,
        FieldDefs.ClassName
      ]
    );
    
  end;

end;

function TAbstractDataSetHolder.RecordCount: Integer;
begin

  Result := FDataSet.RecordCount;
  
end;

procedure TAbstractDataSetHolder.Refresh;
begin

  {
  if DataSet.IsUniDirectional then begin

    DataSet.Close;
    DataSet.Open;

  end

  else begin

    DataSet.Refresh;

  end;}

  DataSet.Close;
  DataSet.Open;

end;

procedure TAbstractDataSetHolder.RejectLocalChanges;
var DeletableRecordBookmarkList: TList;
    DeletableRecordBookmark: TRecordBookmark;
begin

  DeletableRecordBookmarkList := nil;

  DataSet.DisableControls;

  try

    DataSet.First;

    while not DataSet.Eof do begin

      if RecordStatusFieldValue = RecordNonChangedStatusValue
      then begin

        DataSet.Next;

        Continue;

      end;

      if not Assigned(DeletableRecordBookmarkList) then
        DeletableRecordBookmarkList := TList.Create;

      DeletableRecordBookmarkList.Add(DataSet.GetBookmark);

      DataSet.Next;

    end;

    if Assigned(DeletableRecordBookmarkList) then begin

      for DeletableRecordBookmark in DeletableRecordBookmarkList do begin

        DataSet.GotoBookmark(DeletableRecordBookmark);

        DataSet.Delete;
        
      end;
        
    end;
    
  finally

    try

      if Assigned(DeletableRecordBookmarkList) then begin

        for DeletableRecordBookmark in DeletableRecordBookmarkList do
          DataSet.FreeBookmark(DeletableRecordBookmark);

        FreeAndNil(DeletableRecordBookmarkList);

      end;

    finally

      DataSet.EnableControls;

    end;

  end;
  
end;

procedure TAbstractDataSetHolder.ResetFilter(
  const FilterMode: TDataSetHolderFilterResetMode = frmEnableControls
);
begin

  try

    FDataSet.DisableControls;

    FDataSet.Filter := '';
    FDataSet.Filtered := False;
    
  finally

    if FilterMode = frmEnableControls then
      FDataSet.EnableControls;
      
  end;
  
end;

procedure TAbstractDataSetHolder.RevealAddedRecords;
begin

  FilterByRecordStatus(RecordAddedStatusValue);
  
end;

procedure TAbstractDataSetHolder.RevealAllRecords;
begin

  DataSet.Filter := '';
  DataSet.Filtered := False;
  
end;

procedure TAbstractDataSetHolder.RevealChangedRecords;
begin

  FilterByRecordStatus(RecordChangedStatusValue);
  
end;

procedure TAbstractDataSetHolder.RevealNonRemovedRecords;
begin

  DataSet.Filter :=
    Format(
      '%s<>%s',
      [
        RecordStatusFieldName,
        RecordRemovedStatusValue
      ]
    );

  DataSet.Filtered := True;

end;

procedure TAbstractDataSetHolder.RevealRecordsWithGeneratedId(
  const FilterMode: TDataSetHolderFilterApplyingMode
);
begin

  ApplyFilter(
    Format(
      '%s=true',
      [
        FieldDefs.IsRecordIdGeneratedFieldName
      ]
    ),
    FilterMode
  );
  
end;

procedure TAbstractDataSetHolder.RevealRemovedRecords;
begin

  FilterByRecordStatus(RecordRemovedStatusValue);
  
end;

procedure TAbstractDataSetHolder.SetCanBeChangedFieldName(const Value: String);
begin

  FFieldDefs.CanBeChangedFieldName := Value;
  
end;

procedure TAbstractDataSetHolder.SetCanBeChangedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(FFieldDefs.CanBeChangedFieldName, Value);

end;

procedure TAbstractDataSetHolder.SetCanBeRemovedFieldName(const Value: String);
begin

  FFieldDefs.CanBeRemovedFieldName := Value;
  
end;

procedure TAbstractDataSetHolder.SetCanBeRemovedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(FFieldDefs.CanBeRemovedFieldName, Value);

end;

procedure TAbstractDataSetHolder.SetDataSet(const Value: TDataSet);
begin

  FDataSet := Value;
  FFreeDataSet := FDataSet;
  
  if Assigned(FDataSet) then
    SubscribeOnDataSetEvents(FDataSet);

end;

procedure TAbstractDataSetHolder.SetDataSetFieldValue(
  const FieldName: String;
  const Value: Variant
);
var PreviousState: TDataSetState;
begin

  PreviousState := DataSet.State;

  if not IsInEditOrAppend then
    DataSet.Edit;

  DataSet.FieldByName(FieldName).AsVariant := Value;

  if PreviousState <> DataSet.State then
    DataSet.Post;
  
end;

procedure TAbstractDataSetHolder.SetFieldDefs(
  const Value: TAbstractDataSetFieldDefs);
begin

  if Assigned(Value) then
    RaiseExceptionIfFieldDefsHasNotValidType(Value);

  FFieldDefs := Value;
  FFreeFieldDefs := FFieldDefs;

end;

procedure TAbstractDataSetHolder.SetFieldValue(const FieldName: String;
  const Value: Variant);
begin

  SetDataSetFieldValue(FieldName, Value);
  
end;

procedure SetFieldValueForEachProc(DataSetHolder: TAbstractDataSetHolder; Context: TObject);
begin

  with TCNameValue(Context) do
    DataSetHolder.SetFieldValue(Name, Value);

end;

procedure TAbstractDataSetHolder.SetFieldValueForEach(
  const FieldName: String;
  const FieldValue: Variant
);
var
    NameValue: TCNameValue;
    Free: IDisposable;
begin

  NameValue := TCNameValue.Create(FieldName, FieldValue);

  Free := NameValue;
  
  ForEach(SetFieldValueForEachProc, NameValue);
  
end;

procedure TAbstractDataSetHolder.SetGenerateRecordIdOnAdding(
  const Value: Boolean);
begin

  FGenerateRecordIdOnAdding := Value;
  
end;

procedure TAbstractDataSetHolder.SetIsRecordIdGeneratedFieldName(
  const Value: String);
begin

  FieldDefs.IsRecordIdGeneratedFieldName := Value;
  
end;

procedure TAbstractDataSetHolder.SetIsRecordIdGeneratedFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(FFieldDefs.IsRecordIdGeneratedFieldName, Value);

end;

procedure TAbstractDataSetHolder.SetIsSelectedFieldName(const Value: String);
begin

  FieldDefs.IsSelectedFieldName := Value;

end;

procedure TAbstractDataSetHolder.SetIsSelectedFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(IsSelectedFieldName, Value);

end;

procedure TAbstractDataSetHolder.SetRecordAddedStatusValue(
  const Value: Variant);
begin

  FRecordAddedStatusValue := Value;

end;

procedure TAbstractDataSetHolder.SetRecordChangedStatusValue(
  const Value: Variant);
begin

  FRecordChangedStatusValue := Value;

end;

procedure TAbstractDataSetHolder.SetRecordIdFieldName(const Value: String);
begin

  FieldDefs.RecordIdFieldName := Value;
  
end;

procedure TAbstractDataSetHolder.SetRecordIdFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(FFieldDefs.RecordIdFieldName, Value);

end;

procedure TAbstractDataSetHolder.SetRecordIdGenerator(
  Value: IDataSetRecordIdGenerator);
begin

  FRecordIdGenerator := Value;
  
end;

procedure TAbstractDataSetHolder.SetRecordNonChangedStatusValue(
  const Value: Variant);
begin

  FRecordNonChangedStatusValue := Value;

end;

procedure TAbstractDataSetHolder.SetRecordRemovedStatusValue(
  const Value: Variant);
begin

  FRecordRemovedStatusValue := Value;

end;

procedure TAbstractDataSetHolder.SetRecordsSelected(
  const RecordIds: TVariantList; const Selected: Boolean);
var
    CurrentRecordPointer: TRecordBookmark;
    RecordId: Variant;
begin

  if not Selectable then  Exit;

  CurrentRecordPointer := GetBookmark;

  try

    for RecordId in RecordIds do
      if LocateByRecordId(RecordId) then
        IsSelectedFieldValue := Selected;

  finally

    GotoBookmarkAndFree(CurrentRecordPointer);

  end;

end;

procedure TAbstractDataSetHolder.SetRecordStatusFieldName(const Value: String);
begin

  FieldDefs.RecordStatusFieldName := Value;
  
end;

procedure TAbstractDataSetHolder.SetRecordStatusFieldValue(
  const StatusValue: Variant);
begin

  SetDataSetFieldValue(RecordStatusFieldName, StatusValue);
  
end;

procedure TAbstractDataSetHolder.SetSelectable(const Value: Boolean);
begin

  if not Selectable then
    CreateFieldInDataSet(FDataSet, IsSelectedFieldName, ftBoolean);
  
end;

procedure TAbstractDataSetHolder.SetSelectedRecordIds(
  const Value: TVariantList);
begin

  SetRecordsSelected(Value, True);

end;

procedure TAbstractDataSetHolder.SubscribeOnDataSetEvents(DataSet: TDataSet);
begin

  DataSet.AfterInsert := OnDataSetRecordInserted;
  DataSet.AfterPost := OnDataSetRecordChanged;
  DataSet.AfterDelete := OnDataSetRecordRemoved;
  
end;

{ TIntegerDataSetRecordIdGenerator }

function TIntegerDataSetRecordIdGenerator.GenerateNewId: Variant;
begin

  Inc(FCurrentGeneratedId);

  Result := FCurrentGeneratedId;
  
end;

function TIntegerDataSetRecordIdGenerator.GetIdSize: Integer;
begin

  Result := 0;

end;

function TIntegerDataSetRecordIdGenerator.GetIdType: TFieldType;
begin

  Result := ftInteger;
  
end;

{ TNegativeIntegerDataSetRecordIdGenerator }

constructor TNegativeIntegerDataSetRecordIdGenerator.Create(
  IntegerDataSetRecordIdGenerator: TIntegerDataSetRecordIdGenerator);
begin

  inherited Create;

  FIntegerDataSetRecordIdGenerator := IntegerDataSetRecordIdGenerator;
  
end;

destructor TNegativeIntegerDataSetRecordIdGenerator.Destroy;
begin

  inherited;

end;

function TNegativeIntegerDataSetRecordIdGenerator.GenerateNewId: Variant;
begin

  Result := -FIntegerDataSetRecordIdGenerator.GenerateNewId;

end;

function TNegativeIntegerDataSetRecordIdGenerator.GetIdSize: Integer;
begin

  Result := 0;
  
end;

function TNegativeIntegerDataSetRecordIdGenerator.GetIdType: TFieldType;
begin

  Result := ftInteger;
  
end;

{ TAbstractDataSetFieldDefs }

constructor TAbstractDataSetFieldDefs.Create;
begin

  inherited;
  
end;

function TAbstractDataSetFieldDefs.GetRecordStatusFieldName: String;
begin

  Result := FRecordStatusFieldName;

end;

procedure TAbstractDataSetFieldDefs.SetRecordStatusFieldName(
  const Value: String);
begin

  FRecordStatusFieldName := Value;
  
end;

{ TAbstractDataSetRecordIdGenerator }

function TAbstractDataSetRecordIdGenerator.GetSelf: TObject;
begin

  Result := Self;
  
end;

{ TDataSetTraverseCallWrapper }

constructor TDataSetTraverseCallWrapper.Create(
  TraverseHandler: TDataSetTraverseHandler);
begin

  inherited Create;

  FTraverseHandler := TraverseHandler;

end;

constructor TDataSetTraverseCallWrapper.Create(
  TraverseProcedure: TDataSetTraverseProcedure);
begin

  inherited Create;

  FTraverseProcedure := TraverseProcedure;

end;

function TDataSetTraverseCallWrapper.GetSelf: TObject;
begin

  Result := Self;

end;

procedure TDataSetTraverseCallWrapper.Call(DataSetHolder: TAbstractDataSetHolder; Context: TObject);
begin

  if Assigned(FTraverseHandler) then
    FTraverseHandler(DataSetHolder, Context)

  else if Assigned(FTraverseProcedure) then
    FTraverseProcedure(DataSetHolder, Context);
       
end;

{ TIntegerDataSetRecordIdGeneratorFactory }

function TIntegerDataSetRecordIdGeneratorFactory.CreateRecordIdGenerator: IDataSetRecordIdGenerator;
begin

  Result := TIntegerDataSetRecordIdGenerator.Create;
end;

{ TNegativeIntegerDataSetRecordIdGeneratorFactory }

constructor TNegativeIntegerDataSetRecordIdGeneratorFactory.Create(
  IntegerDataSetRecordIdGeneratorFactory: TIntegerDataSetRecordIdGeneratorFactory);
begin

  inherited Create;

  FIntegerDataSetRecordIdGeneratorFactory := IntegerDataSetRecordIdGeneratorFactory;

end;

function TNegativeIntegerDataSetRecordIdGeneratorFactory.CreateRecordIdGenerator: IDataSetRecordIdGenerator;
begin

  Result :=
    TNegativeIntegerDataSetRecordIdGenerator.Create(
      TIntegerDataSetRecordIdGenerator(
        FIntegerDataSetRecordIdGeneratorFactory.CreateRecordIdGenerator.Self
      )
    );
    
end;

end.
