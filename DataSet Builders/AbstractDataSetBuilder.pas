unit AbstractDataSetBuilder;

interface

uses

  DataSetBuilder,
  DB,
  SysUtils,
  Classes;

type

  TAbstractDataSetBuilder = class (TInterfacedObject, IDataSetBuilder)

    protected

      FDataSet: TDataSet;

      function DataSet: TDataSet;

    protected

      function CreateDataSet: TDataSet; virtual; abstract;
      procedure InitializeDataSet(DataSet: TDataSet); virtual;

    protected

      procedure CopyDataSetData(Target, Source: TDataSet); virtual;

    public

      function GetSelf: TObject;
      
      function AddField(
        const FieldName: String
      ): IDataSetBuilder; overload; virtual;

      function AddField(
        const FieldName: String;
        const FieldType: TFieldType
      ): IDataSetBuilder; overload; virtual;

      function AddField(
        const FieldName: String;
        const FieldType: TFieldType;
        const Size: Integer
      ): IDataSetBuilder; overload; virtual;

      function Build: TDataSet; virtual;

      function BuildCopy(
        Original: TDataSet;
        const Option: TDataSetCopyBuildingOption = cbCopyWithData
      ): TDataSet; virtual;
      
      procedure ClearFields;

  end;

implementation

uses

  AuxDataSetFunctionsUnit;

{ TAbstractDataSetBuilder }

function TAbstractDataSetBuilder.AddField(
  const FieldName: String
): IDataSetBuilder;
begin

  Result := AddField(FieldName, ftVariant);
  
end;

function TAbstractDataSetBuilder.AddField(
  const FieldName: String;
  const FieldType: TFieldType
): IDataSetBuilder;
begin

  Result := AddField(FieldName, FieldType, 0);

end;

function TAbstractDataSetBuilder.AddField(
  const FieldName: String;
  const FieldType: TFieldType;
  const Size: Integer
): IDataSetBuilder;
begin

  CreateFieldInDataSet(DataSet, FieldName, FieldType, Size);

  Result := Self;

end;

function TAbstractDataSetBuilder.Build: TDataSet;
begin

  Result := FDataSet;

  FDataSet := nil;
  
end;

function TAbstractDataSetBuilder.BuildCopy(
  Original: TDataSet;
  const Option: TDataSetCopyBuildingOption
): TDataSet;
var
    Field: TField;
begin

  for Field in Original.Fields do
    AddField(Field.FieldName, Field.DataType, Field.Size);

  Result := Build;

  if Option = cbCopyWithData then
    CopyDataSetData(Result, Original);

end;

procedure TAbstractDataSetBuilder.ClearFields;
begin

  FDataSet.Fields.Clear;
  FDataSet.FieldDefs.Clear;
  
end;

procedure TAbstractDataSetBuilder.CopyDataSetData(Target, Source: TDataSet);
begin

  Target.Assign(Source);

end;

function TAbstractDataSetBuilder.DataSet: TDataSet;
begin

  if not Assigned(FDataSet) then begin

    FDataSet := CreateDataSet;

    InitializeDataSet(FDataSet);

  end;

  Result := FDataSet;
  
end;

function TAbstractDataSetBuilder.GetSelf: TObject;
begin

end;

procedure TAbstractDataSetBuilder.InitializeDataSet(DataSet: TDataSet);
begin

end;

end.
