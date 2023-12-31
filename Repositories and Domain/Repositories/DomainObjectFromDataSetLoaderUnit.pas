unit DomainObjectFromDataSetLoaderUnit;

interface

uses DB, TableColumnMappingsUnit, DomainObjectBaseUnit;

type

  TDomainObjectFromDataSetLoader = class

    protected

      FColumnMappings: TTableColumnMappings;

      function CanBeValueAssignedToObjectProperty(
        const ObjectPropertyName: String;
        Value: Variant;
        const FieldName: String;
        DataSet: TDataSet
      ): Boolean; virtual;

      function GetFieldNameFromColumnMapping(
        ColumnMapping: TTableColumnMapping
      ): String; virtual;

    public

      constructor Create; overload;
      constructor Create(ColumnMappings: TTableColumnMappings); overload;

      procedure LoadDomainObject(
        DomainObject: TDomainObjectBase;
        DataSet: TDataSet
      ); overload; virtual;

      property ColumnMappings: TTableColumnMappings
      read FColumnMappings write FColumnMappings;
      
  end;

implementation

uses

  Variants,
  ReflectionServicesUnit,
  AuxDebugFunctionsUnit,
  DBTableColumnMappingsUnit,
  Classes;

{ TDomainObjectFromDataSetLoader }

constructor TDomainObjectFromDataSetLoader.Create;
begin
                  
  inherited;

end;

function TDomainObjectFromDataSetLoader.CanBeValueAssignedToObjectProperty(
  const ObjectPropertyName: String;
  Value: Variant;
  const FieldName: String;
  DataSet: TDataSet
): Boolean;
begin

  Result := True;

end;

constructor TDomainObjectFromDataSetLoader.Create(
  ColumnMappings: TTableColumnMappings);
begin

  inherited Create;

  Self.ColumnMappings := ColumnMappings;

end;

function TDomainObjectFromDataSetLoader.GetFieldNameFromColumnMapping(
  ColumnMapping: TTableColumnMapping
): String;
begin

  if ColumnMapping is TDBTableColumnMapping then begin

    with ColumnMapping as TDBTableColumnMapping do begin

      if AliasColumnName <> '' then
        Result := AliasColumnName

      else Result := ColumnName;

    end;

  end

  else Result := ColumnMapping.ColumnName;
    
end;

procedure TDomainObjectFromDataSetLoader.LoadDomainObject(
  DomainObject: TDomainObjectBase;
  DataSet: TDataSet
);
var ColumnMapping: TTableColumnMapping;
    FieldName: String;
    PropertyValue: Variant;
begin

  for ColumnMapping in ColumnMappings do begin

    if not ColumnMapping.AllowMappingOnObjectProperty then
      Continue;
    
    FieldName := GetFieldNameFromColumnMapping(ColumnMapping);

    PropertyValue := DataSet.FieldByName(FieldName).AsVariant;

    if  CanBeValueAssignedToObjectProperty(
          ColumnMapping.ObjectPropertyName,
          PropertyValue,
          FieldName,
          DataSet
        )

    then begin
    
      TReflectionServices.SetObjectPropertyValue(
        DomainObject,
        ColumnMapping.ObjectPropertyName,
        PropertyValue
      );
      
    end;

  end;

end;

end.
