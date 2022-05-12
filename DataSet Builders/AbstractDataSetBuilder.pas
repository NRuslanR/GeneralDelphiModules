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
      
    public

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

function TAbstractDataSetBuilder.DataSet: TDataSet;
begin

  if not Assigned(FDataSet) then begin

    FDataSet := CreateDataSet;

    InitializeDataSet(FDataSet);

  end;

  Result := FDataSet;
  
end;

procedure TAbstractDataSetBuilder.InitializeDataSet(DataSet: TDataSet);
begin

end;

end.
