unit DBDataTableFilterFormStatePropertiesIniFile;

interface

uses

  DBDataTableFilterFormStatePropertiesStorage,
  PropertiesIniFileUnit,
  TableViewFilterFormUnit,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  TDBDataTableFilterFormStatePropertiesIniFile = class (TDBDataTableFilterFormStatePropertiesStorage)

    public

      constructor Create(
        const IniFilePath: String;
        const DefaultIniFilePath: String = ''
      );

  end;


implementation

uses

  Cloneable,
  SimpleDateRangePanelUnit,
  VariantTypeUnit,
  Variants,
  AuxiliaryStringFunctions;

{ TDBDataTableFilterFormStatePropertiesIniFile }

constructor TDBDataTableFilterFormStatePropertiesIniFile.Create(
  const IniFilePath, DefaultIniFilePath: String);
var
    DefaultPropertiesStorage: IPropertiesStorage;
begin

  if Trim(DefaultIniFilePath) <> '' then
    DefaultPropertiesStorage := TPropertiesIniFile.Create(DefaultIniFilePath, True, False)

  else DefaultPropertiesStorage := nil;
  
  inherited Create(
    TPropertiesIniFile.Create(IniFilePath, True, False),
    DefaultPropertiesStorage
  );
  
end;

end.
