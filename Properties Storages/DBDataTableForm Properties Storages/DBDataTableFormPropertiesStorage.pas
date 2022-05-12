unit DBDataTableFormPropertiesStorage;

interface

uses

  IObjectPropertiesStorageUnit,
  DBDataTableFormUnit,
  IPropertiesStorageUnit,
  DBDataTableFilterFormStatePropertiesStorage,
  StandardDefaultObjectPropertiesStorage,
  TableViewFilterFormUnit,
  SysUtils,
  Classes;

const

  LAST_FOCUSED_RECORD_SECTION_NAME = 'LastFocusedRecord';
  LAST_FOCUSED_RECORD_ID_KEY_NAME = 'LastFocusedRecordId';

  LAST_FOCUSED_FIELD_SECTION_NAME = 'LastFocusedField';
  LAST_FOCUSED_FIELD_NAME_KEY_NAME = 'LastFocusedFieldName';
  
type

  TDBDataTableFormPropertiesStorage = class abstract (TStandardDefaultObjectPropertiesStorage)
      
    protected

      procedure InternalRestorePropertiesForObject(
        TargetObject: TObject;
        PropertiesStorage: IPropertiesStorage
      ); overload; override;

      procedure RestoreDBDataTableFormProperties(
        DBDataTableForm: TDBDataTableForm;
        PropertiesStorage: IPropertiesStorage
      ); overload; virtual;

    protected
    
      procedure InternalSaveObjectProperties(
        TargetObject: TObject;
        PropertiesStorage: IPropertiesStorage
      ); overload; override;

      procedure SaveDBDataTableFormProperties(
        DBDataTableForm: TDBDataTableForm;
        PropertiesStorage: IPropertiesStorage
      ); overload; virtual;


    protected

      FFilterFormStatePropertiesStorage: IObjectPropertiesStorage;

      function GetFilterFormStatePropertiesStorage: TDBDataTableFilterFormStatePropertiesStorage;
      
      procedure SetFilterFormStatePropertiesStorage(
        const Value: TDBDataTableFilterFormStatePropertiesStorage
      );

    protected

      procedure RestoreDBDataGridProperties(
        DBDataTableForm: TDBDataTableForm;
        PropertiesStorage: IPropertiesStorage
      ); virtual; abstract;

      procedure SaveDBDataGridProperties(
        DBDataTableForm: TDBDataTableForm;
        PropertiesStorage: IPropertiesStorage
      ); virtual; abstract;
      
    public

      constructor Create(
        PropertiesStorage: IPropertiesStorage;
        DefaultPropertiesStorage: IPropertiesStorage = nil
      ); overload;
      
      constructor Create(
        FilterFormStatePropertiesStorage: TDBDataTableFilterFormStatePropertiesStorage;
        PropertiesStorage: IPropertiesStorage;
        DefaultPropertiesStorage: IPropertiesStorage = nil
      ); overload;

    published

      property FilterFormStatePropertiesStorage: TDBDataTableFilterFormStatePropertiesStorage
      read GetFilterFormStatePropertiesStorage
      write SetFilterFormStatePropertiesStorage;

  end;
  
implementation

uses

  Variants,
  AuxDebugFunctionsUnit,
  PropertiesIniFileUnit,
  StandardObjectPropertiesStorage;

{ TDBDataTableFormPropertiesStorage }

constructor TDBDataTableFormPropertiesStorage.Create(
  PropertiesStorage,
  DefaultPropertiesStorage: IPropertiesStorage);
begin

  inherited Create(PropertiesStorage, DefaultPropertiesStorage);

end;

constructor TDBDataTableFormPropertiesStorage.Create(
  FilterFormStatePropertiesStorage: TDBDataTableFilterFormStatePropertiesStorage;
  PropertiesStorage, DefaultPropertiesStorage: IPropertiesStorage
);
begin

  inherited Create(PropertiesStorage, DefaultPropertiesStorage);

  FFilterFormStatePropertiesStorage := FilterFormStatePropertiesStorage;

end;


function TDBDataTableFormPropertiesStorage.
  GetFilterFormStatePropertiesStorage: TDBDataTableFilterFormStatePropertiesStorage;
begin

  if Assigned(FFilterFormStatePropertiesStorage) then
    Result := TDBDataTableFilterFormStatePropertiesStorage(FFilterFormStatePropertiesStorage.Self)

  else Result := nil;
  
end;

procedure TDBDataTableFormPropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  RestoreDBDataTableFormProperties(
    TargetObject as TDBDataTableForm,
    PropertiesStorage
  );

end;

procedure TDBDataTableFormPropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  SaveDBDataTableFormProperties(
    TargetObject as TDBDataTableForm,
    PropertiesStorage
  );

end;

procedure TDBDataTableFormPropertiesStorage.RestoreDBDataTableFormProperties(
  DBDataTableForm: TDBDataTableForm;
  PropertiesStorage: IPropertiesStorage
);
var
    FilterFormState: TTableViewFilterFormState;
    LastFocusedRecordKeyValue: Variant;
    LastFocusedFieldName: Variant;
begin

  if
    not Assigned(DBDataTableForm) or
    not Assigned(DBDataTableForm.DataRecordGridTableView)

  then Exit;
 
  FilterFormState := DBDataTableForm.GetTableViewFilterFormClass.GetTableViewFilterFormStateClass.Create;

  try

    RestoreDBDataGridProperties(DBDataTableForm, PropertiesStorage);

    if Assigned(FilterFormStatePropertiesStorage) then begin

      FilterFormStatePropertiesStorage.RestorePropertiesForObject(FilterFormState);

      DBDataTableForm.FilterFormLastState := FilterFormState;

    end;

    PropertiesStorage.GoToSection(LAST_FOCUSED_RECORD_SECTION_NAME);
    
    LastFocusedRecordKeyValue :=
      PropertiesStorage.ReadValueForProperty(
        LAST_FOCUSED_RECORD_ID_KEY_NAME,
        varVariant,
        Null
      );

    if not VarIsEmpty(LastFocusedRecordKeyValue) then
      DBDataTableForm.SetRequestedFocusedRecord(LastFocusedRecordKeyValue);


  except

    FreeAndNil(FilterFormState);

    Raise;

  end;
  
end;

procedure TDBDataTableFormPropertiesStorage.SaveDBDataTableFormProperties(
  DBDataTableForm: TDBDataTableForm;
  PropertiesStorage: IPropertiesStorage
);
var
    CurrentRecordKeyValue: Variant;
    DBDataTableRecordFocusedField: TDBDataTableRecordField;
begin

  if
    not Assigned(DBDataTableForm) or
    not Assigned(DBDataTableForm.DataRecordGridTableView)

  then Exit;

  SaveDBDataGridProperties(DBDataTableForm, PropertiesStorage);

  CurrentRecordKeyValue := DBDataTableForm.GetCurrentRecordKeyValue;

  if not VarIsNull(CurrentRecordKeyValue) then begin
  
    PropertiesStorage.GoToSection(LAST_FOCUSED_RECORD_SECTION_NAME);

    PropertiesStorage.WriteValueForPropertyAsVariant(
      LAST_FOCUSED_RECORD_ID_KEY_NAME,
      CurrentRecordKeyValue
    );

  end;

  if Assigned(FilterFormStatePropertiesStorage) then begin

    if PropertiesStorage = DefaultPropertiesStorage then begin

      FilterFormStatePropertiesStorage.SaveDefaultObjectProperties(
        DBDataTableForm.FilterFormLastState
      );

    end

    else begin

      FilterFormStatePropertiesStorage.SaveObjectProperties(
        DBDataTableForm.FilterFormLastState
      );

    end;

  end;

end;

procedure TDBDataTableFormPropertiesStorage.SetFilterFormStatePropertiesStorage(
  const Value: TDBDataTableFilterFormStatePropertiesStorage
);
begin

  FFilterFormStatePropertiesStorage := Value;
  
end;

end.
