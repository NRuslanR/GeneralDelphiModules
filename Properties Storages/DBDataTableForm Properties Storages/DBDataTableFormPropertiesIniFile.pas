unit DBDataTableFormPropertiesIniFile;

interface

uses

  DBDataTableFormPropertiesStorage,
  DBDataTableFilterFormStatePropertiesStorage,
  DBDataTableFormUnit,
  TableViewFilterFormUnit,
  PropertiesIniFileUnit,
  cxGrid,
  IPropertiesStorageUnit,
  cxGridCustomTableView,
  cxGridDBTableView,
  SysUtils,
  Classes;

const

  LAST_FOCUSED_RECORD_SECTION_NAME = 'LastFocusedRecord';
  LAST_FOCUSED_RECORD_ID_KEY_NAME = 'LastFocusedRecordId';

  LAST_FOCUSED_FIELD_SECTION_NAME = 'LastFocusedField';
  LAST_FOCUSED_FIELD_NAME_KEY_NAME = 'LastFocusedFieldName';
  
type

   TDBDataTableFormPropertiesIniFile = class (TDBDataTableFormPropertiesStorage)

      protected

        procedure RestoreDBDataGridProperties(
          DBDataTableForm: TDBDataTableForm;
          PropertiesStorage: IPropertiesStorage
        ); override;

        procedure SaveDBDataGridProperties(
          DBDataTableForm: TDBDataTableForm;
          PropertiesStorage: IPropertiesStorage
        ); override;

      public

        constructor Create(
          const IniFilePath: String;
          const DefaultIniFilePath: String = ''
        ); overload;

        constructor Create(
          FilterFormStatePropertiesStorage: TDBDataTableFilterFormStatePropertiesStorage;
          const IniFilePath: String;
          const DefaultIniFilePath: String = ''
        ); overload;

   end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit,
  cxGridCustomView;

{ TDBDataTableFormPropertiesIniFile }

constructor TDBDataTableFormPropertiesIniFile.Create(
  const IniFilePath: String;
  const DefaultIniFilePath: String
);
begin

  Create(nil, IniFilePath, DefaultIniFilePath);
  
end;

constructor TDBDataTableFormPropertiesIniFile.Create(
  FilterFormStatePropertiesStorage: TDBDataTableFilterFormStatePropertiesStorage;
  const IniFilePath: String;
  const DefaultIniFilePath: String = ''
);
var
    DefaultPropertiesStorage: IPropertiesStorage;
begin

  if Trim(DefaultIniFilePath) <> '' then
    DefaultPropertiesStorage := TPropertiesIniFile.Create(DefaultIniFilePath, True, False)

  else DefaultPropertiesStorage := nil;

  inherited Create(
    FilterFormStatePropertiesStorage,
    TPropertiesIniFile.Create(IniFilePath, True, False),
    DefaultPropertiesStorage
  );
  
end;

procedure TDBDataTableFormPropertiesIniFile.RestoreDBDataGridProperties(
  DBDataTableForm: TDBDataTableForm;
  PropertiesStorage: IPropertiesStorage
);
begin

  with TPropertiesIniFile(PropertiesStorage.Self) do begin

    if not RaiseExceptionIfIniFileNotExists and not FileExists(IniFilePath) then Exit;

    DBDataTableForm.DataRecordGridTableView.RestoreFromIniFile(
      IniFilePath,
      True,
      False,
      [gsoUseFilter, gsoUseSummary]
    );

  end;

end;

procedure TDBDataTableFormPropertiesIniFile.SaveDBDataGridProperties(
  DBDataTableForm: TDBDataTableForm;
  PropertiesStorage: IPropertiesStorage
);
begin

  with TPropertiesIniFile(PropertiesStorage.Self) do begin

    if not RaiseExceptionIfIniFileNotExists and not FileExists(IniFilePath) then Exit;
    
    DBDataTableForm.DataRecordGridTableView.StoreToIniFile(
      IniFilePath,
      True,
      [gsoUseFilter, gsoUseSummary]
    );

  end;

end;

end.
