unit AuxDataSetFunctionsUnit;

interface

uses SysUtils, Classes, DB;

// DataSet is located at first record
function IsDataSetAtFirstRecord(ADataSet: TDataSet): Boolean;

// DataSet is located at last record
function IsDataSetAtLastRecord(ADataSet: TDataSet): Boolean;

procedure SetFieldsToDataSetFromOther(
  DestDataSet, SourceDataSet: TDataSet
);

procedure CreateFieldInDataSet(
  DataSet: TDataSet;
  const FieldName: String;
  const FieldType: TFieldType;
  const Size: Integer = 0
);

procedure AddDataSetRecord(
  DataSet: TDataSet;
  const FieldNames: array of String;
  const FieldValues: array of Variant
);

procedure AddDataSetRecordByIndices(
  DataSet: TDataSet;
  const FieldValues: array of Variant
);

procedure ChangeDataSetRecord(
  DataSet: TDataSet;
  const FieldNames: array of String;
  const FieldValues: array of Variant
); overload;

procedure ChangeDataSetRecordByFieldIndices(
  DataSet: TDataSet;
  FieldValues: array of Variant
); overload;

function GetDataSetFieldMaxValue(DataSet: TDataSet; const FieldName: String): Variant;

implementation

uses

  Variants;

function IsDataSetAtFirstRecord(ADataSet: TDataSet): Boolean;
begin

  Result := ADataSet.Bof and (not ADataSet.IsEmpty);

end;

function IsDataSetAtLastRecord(ADataSet: TDataSet): Boolean;
begin

  Result := ADataSet.Eof and (not ADataSet.IsEmpty);

end;

procedure SetFieldsToDataSetFromOther(
  DestDataSet, SourceDataSet: TDataSet
);
var SourceField: TField;
    DestFieldDef: TFieldDef;
begin

   for SourceField in SourceDataSet.Fields do begin

      CreateFieldInDataSet(
        DestDataSet,
        SourceField.FieldName,
        SourceField.DataType,
        SourceField.Size
      );

   end;

end;

procedure CreateFieldInDataSet(
  DataSet: TDataSet;
  const FieldName: String;
  const FieldType: TFieldType;
  const Size: Integer = 0
);
var FieldDef: TFieldDef;
begin

  FieldDef := DataSet.FieldDefs.AddFieldDef;

  FieldDef.Name := FieldName;
  FieldDef.DataType := FieldType;
  FieldDef.Size := Size;
  
  FieldDef.CreateField(DataSet);

end;

procedure SetDataSetFieldValues(
  DataSet: TDataSet;
  const FieldNames: array of String;
  const FieldValues: array of Variant
);
var
    I: Integer;
begin

  for I := 0 to High(FieldNames) do
    DataSet.FieldByName(FieldNames[I]).Value := FieldValues[I];

end;

procedure SetDataSetFieldValuesByIndices(
  DataSet: TDataSet;
  const FieldValues: array of Variant
);
  var
    I, J: Integer;
begin

  J := 0;

  for I := DataSet.FieldCount - Length(FieldValues) to DataSet.FieldCount - 1
  do begin

    DataSet.Fields.Fields[I].Value := FieldValues[J];

    Inc(J);

  end;

end;

procedure AddDataSetRecord(
  DataSet: TDataSet;
  const FieldNames: array of String;
  const FieldValues: array of Variant
);
var
    I: Integer;
begin

  DataSet.DisableControls;

  try

    DataSet.Append;

    SetDataSetFieldValues(DataSet, FieldNames, FieldValues);

    DataSet.Post;

  finally

    DataSet.EnableControls;

  end;

end;

procedure AddDataSetRecordByIndices(
  DataSet: TDataSet;
  const FieldValues: array of Variant
);
begin

  DataSet.DisableControls;

  try

    DataSet.Append;

    SetDataSetFieldValuesByIndices(DataSet, FieldValues);

    DataSet.Post;

  finally

    DataSet.EnableControls;

  end;

end;


procedure ChangeDataSetRecord(
  DataSet: TDataSet;
  const FieldNames: array of String;
  const FieldValues: array of Variant
);
begin

  DataSet.DisableControls;

  try

    DataSet.Edit;

    SetDataSetFieldValues(DataSet, FieldNames, FieldValues);

    DataSet.Post;

  finally

    DataSet.EnableControls;

  end;

end;

procedure ChangeDataSetRecordByFieldIndices(
  DataSet: TDataSet;
  FieldValues: array of Variant
);
begin

  DataSet.DisableControls;

  try

    DataSet.Edit;

    SetDataSetFieldValuesByIndices(DataSet, FieldValues);

    DataSet.Post;

  finally

    DataSet.EnableControls;

  end;

end;

function GetDataSetFieldMaxValue(DataSet: TDataSet; const FieldName: String): Variant;
var
    MaxValue: Variant;
    CurrentValue: Variant;
    RecordPointer: Pointer;
begin

  RecordPointer := DataSet.GetBookmark;

  try

    while not DataSet.Eof do begin

      CurrentValue := DataSet.FieldByName(FieldName).AsVariant;

      if VarIsNull(CurrentValue) or VarIsClear(CurrentValue) then begin

        DataSet.Next;

        Continue;

      end;

      if VarIsClear(MaxValue) or (MaxValue < CurrentValue)
      then MaxValue := CurrentValue;

      DataSet.Next;

    end;

    Result := MaxValue;
    
  finally

    DataSet.GotoBookmark(RecordPointer);
    DataSet.FreeBookmark(RecordPointer);

  end;

end;

end.
