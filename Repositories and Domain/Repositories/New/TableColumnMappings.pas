unit TableColumnMappings;

interface

uses

  SysUtils,
  Classes;

type

  TTableColumnMapping = class

    protected

      FColumnName: String;
      FObjectPropertyName: String;
      FAllowMappingOnObjectProperty: Boolean;

    public

      constructor Create; overload;
      constructor Create(
        const ColumnName, ObjectPropertyName: String;
        const AllowMappingOnObjectProperty: Boolean = True
      ); overload;

      property ColumnName: String read FColumnName write FColumnName;
      
      property ObjectPropertyName: String
      read FObjectPropertyName write FObjectPropertyName;

      property AllowMappingOnObjectProperty: Boolean
      read FAllowMappingOnObjectProperty write FAllowMappingOnObjectProperty;

  end;

  TTableColumnMappingClass = class of TTableColumnMapping;

  TTableColumnMappings = class;

  TTableColumnMappingsEnumerator = class (TListEnumerator)

    protected

      function GetCurrentColumnMapping: TTableColumnMapping;

      constructor Create(
        TableColumnMappings: TTableColumnMappings
      );

    public

      property Current: TTableColumnMapping read GetCurrentColumnMapping;

  end;

  TTableColumnMappings = class (TList)

    protected

      procedure FreeColumnMappings;

      function GetColumnMappingByIndex(Index: Integer): TTableColumnMapping;
      procedure SetColumnMappingByIndex(
        Index: Integer;
        ColumnMapping: TTableColumnMapping
      );

      function GetTableColumnMappingClass: TTableColumnMappingClass; virtual;
      
    public

      procedure Clear; override;

      function GetEnumerator: TTableColumnMappingsEnumerator;

      property Items[Index: Integer]: TTableColumnMapping
      read GetColumnMappingByIndex write SetColumnMappingByIndex; default;

      function AddColumnMapping(
        const ColumnName, ObjectPropertyName: String;
        const AllowMappingOnDomainObjectProperty: Boolean = True
      ): TTableColumnMappings; virtual;

      procedure RemoveColumnMapping(
        const ColumnName: String
      ); virtual;

      procedure RemoveColumnMappingByObjectPropertyName(
        const ObjectPropertyName: String
      );

      function FindColumnMappingByColumnName(
        const ColumnName: string
      ): TTableColumnMapping; virtual;

      function FindColumnMappingByObjectPropertyName(
        const ObjectPropertyName: string
      ): TTableColumnMapping; virtual;

      function ToColumnNameList: TStrings;
      function GetColumnNameListString(const Delimiter: String = ','): String;
      function ToAccessResultColumnNameList: TStrings; virtual;

  end;

  TTableColumnMappingsClass = class of TTableColumnMappings;

implementation

uses

  AuxiliaryStringFunctions;
  
{ TTableColumnMapping }

constructor TTableColumnMapping.Create;
begin

  inherited;

end;

constructor TTableColumnMapping.Create(
  const ColumnName, ObjectPropertyName: String;
  const AllowMappingOnObjectProperty: Boolean
);
begin

  inherited Create;

  Self.ColumnName := ColumnName;
  Self.ObjectPropertyName := ObjectPropertyName;
  Self.AllowMappingOnObjectProperty := AllowMappingOnObjectProperty;

end;

{ TTableColumnMappingsEnumerator }

constructor TTableColumnMappingsEnumerator.Create(
  TableColumnMappings: TTableColumnMappings);
begin

  inherited Create(TableColumnMappings);

end;

function TTableColumnMappingsEnumerator.GetCurrentColumnMapping: TTableColumnMapping;
begin

  Result := TTableColumnMapping(GetCurrent);

end;

{ TTableColumnMappings }

function TTableColumnMappings.AddColumnMapping(
  const ColumnName,
  ObjectPropertyName: String;
  const AllowMappingOnDomainObjectProperty: Boolean
): TTableColumnMappings;
var ColumnMapping: TTableColumnMapping;
begin

  Result := Self;

  ColumnMapping := FindColumnMappingByObjectPropertyName(ObjectPropertyName);

  if Assigned(ColumnMapping) then Exit;

  Add(
    GetTableColumnMappingClass.Create(
      ColumnName,
      ObjectPropertyName,
      AllowMappingOnDomainObjectProperty
    )
  );

end;

procedure TTableColumnMappings.Clear;
begin

  FreeColumnMappings;

end;

function TTableColumnMappings.FindColumnMappingByColumnName(
  const ColumnName: string
): TTableColumnMapping;
begin

  for Result in Self do
    if Result.ColumnName = ColumnName then
      Exit;

  Result := nil;

end;

function TTableColumnMappings.FindColumnMappingByObjectPropertyName(
  const ObjectPropertyName: string): TTableColumnMapping;
begin

  for Result in Self do
    if Result.ObjectPropertyName = ObjectPropertyName then
      Exit;

  Result := nil;

end;

procedure TTableColumnMappings.FreeColumnMappings;
var ColumnMapping: TTableColumnMapping;
begin

  for ColumnMapping in Self do
    ColumnMapping.Free;

end;

function TTableColumnMappings.GetColumnMappingByIndex(
  Index: Integer): TTableColumnMapping;
begin

  Result := TTableColumnMapping(Get(Index));

end;

function TTableColumnMappings.GetColumnNameListString(const Delimiter: String): String;
var
    ColumnNameList: TStrings;
begin

  ColumnNameList := ToColumnNameList;

  try

    Result := CreateStringFromStringList(ColumnNameList, Delimiter);
    
  finally

    FreeAndNil(ColumnNameList);

  end;
  
end;

function TTableColumnMappings.GetEnumerator: TTableColumnMappingsEnumerator;
begin

  Result := TTableColumnMappingsEnumerator.Create(Self);

end;

function TTableColumnMappings.GetTableColumnMappingClass: TTableColumnMappingClass;
begin

  Result := TTableColumnMapping;
  
end;

procedure TTableColumnMappings.RemoveColumnMapping(const ColumnName: String);
begin

  Remove(FindColumnMappingByColumnName(ColumnName));

end;

procedure TTableColumnMappings.RemoveColumnMappingByObjectPropertyName(
  const ObjectPropertyName: String);
begin

  Remove(FindColumnMappingByObjectPropertyName(ObjectPropertyName));
  
end;

procedure TTableColumnMappings.SetColumnMappingByIndex(
  Index: Integer;
  ColumnMapping: TTableColumnMapping);
begin

  Put(Index, ColumnMapping);
  
end;

function TTableColumnMappings.ToColumnNameList: TStrings;
var
    TableMapping: TTableColumnMapping;
begin

  Result := TStringList.Create;

  try

    for TableMapping in Self do
      Result.Add(TableMapping.ColumnName);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TTableColumnMappings.ToAccessResultColumnNameList: TStrings;
begin

  Result := ToColumnNameList;
  
end;

end.
