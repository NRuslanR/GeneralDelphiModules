unit DataSetAdapter;

interface

uses

  DataHolder,
  DB;

type

  TDataSetAdapter = class (TInterfacedObject, IDataHolder)

    private

      FDataSet: TDataSet;
      
    public

      constructor Create(DataSet: TDataSet);

      function GetSelf: TObject;
      
      function GetFieldValue(const FieldName: String): Variant;
      function IsFieldValueNull(const FieldName: String): Boolean;
      function GetFieldValueAsString(const FieldName: String): String;
      function GetFieldValueAsInteger(const FieldName: String): Integer;
      function GetFieldValueAsDateTime(const FieldName: String): TDateTime;
      function GetFieldValueAsFloat(const FieldName: String): Double;
      function GetFieldValueAsBoolean(const FieldName: String): Boolean;

  end;
  
implementation

{ TDataSetAdapter }

constructor TDataSetAdapter.Create(DataSet: TDataSet);
begin

  inherited Create;

  FDataSet := DataSet;

end;

function TDataSetAdapter.GetFieldValue(const FieldName: String): Variant;
begin

  Result := FDataSet.FieldByName(FieldName).AsVariant;

end;

function TDataSetAdapter.GetFieldValueAsBoolean(
  const FieldName: String): Boolean;
begin

  Result := FDataSet.FieldByName(FieldName).AsBoolean;
  
end;

function TDataSetAdapter.GetFieldValueAsDateTime(
  const FieldName: String): TDateTime;
begin

  Result := FDataSet.FieldByName(FieldName).AsDateTime;

end;

function TDataSetAdapter.GetFieldValueAsFloat(const FieldName: String): Double;
begin

  Result := FDataSet.FieldByName(FieldName).AsFloat;
  
end;

function TDataSetAdapter.GetFieldValueAsInteger(
  const FieldName: String): Integer;
begin

  Result := FDataSet.FieldByName(FieldName).AsInteger;
  
end;

function TDataSetAdapter.GetFieldValueAsString(const FieldName: String): String;
begin

  Result := FDataSet.FieldByName(FieldName).AsString;

end;

function TDataSetAdapter.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDataSetAdapter.IsFieldValueNull(const FieldName: String): Boolean;
begin

  Result := FDataSet.FieldByName(FieldName).IsNull;
  
end;

end.
