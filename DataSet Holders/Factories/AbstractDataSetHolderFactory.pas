unit AbstractDataSetHolderFactory;

interface

uses

  AbstractDataSetHolder,
  DataSetBuilder,
  DB,
  SysUtils,
  Classes;

type

  IDataSetHolderFactoryOptions = interface

    function EnableRecordAccessRights(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
    function EnableRecordAccessRights: Boolean; overload;

    function EnableRecordStatus(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
    function EnableRecordStatus: Boolean; overload;

    function RecordIdGeneratorFactory(Value: IDataSetRecordIdGeneratorFactory): IDataSetHolderFactoryOptions; overload;
    function RecordIdGeneratorFactory: IDataSetRecordIdGeneratorFactory; overload;

    function EnableRecordIdGeneratingOnAdding(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
    function EnableRecordIdGeneratingOnAdding: Boolean; overload;

    function OpenAfterCreate(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
    function OpenAfterCreate: Boolean; overload;

    function IdType(const Value: TFieldType): IDataSetHolderFactoryOptions; overload;
    function IdType: TFieldType; overload;

    function IdSize(const Value: Integer): IDataSetHolderFactoryOptions; overload;
    function IdSize: Integer; overload;
    
  end;

  TDataSetHolderFactoryOptions = class (TInterfacedObject, IDataSetHolderFactoryOptions)
                                             
    private

      class var FDefault: IDataSetHolderFactoryOptions;

      class function GetDefaultOptions: IDataSetHolderFactoryOptions; static;

    private

      FEnableRecordAccessRights: Boolean;
      FEnableRecordStatus: Boolean;
      FRecordIdGeneratorFactory: IDataSetRecordIdGeneratorFactory;
      FEnableRecordIdGeneratingOnAdding: Boolean;
      FIdType: TFieldType;
      FIdSize: Integer;
      FOpenAfterCreate: Boolean;
      
    public

      function EnableRecordAccessRights(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
      function EnableRecordAccessRights: Boolean; overload;

      function EnableRecordStatus(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
      function EnableRecordStatus: Boolean; overload;

      function RecordIdGeneratorFactory(Value: IDataSetRecordIdGeneratorFactory): IDataSetHolderFactoryOptions; overload;
      function RecordIdGeneratorFactory: IDataSetRecordIdGeneratorFactory; overload;

      function EnableRecordIdGeneratingOnAdding(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
      function EnableRecordIdGeneratingOnAdding: Boolean; overload;

      function OpenAfterCreate(const Value: Boolean): IDataSetHolderFactoryOptions; overload;
      function OpenAfterCreate: Boolean; overload;

      function IdType(const Value: TFieldType): IDataSetHolderFactoryOptions; overload;
      function IdType: TFieldType; overload;

      function IdSize(const Value: Integer): IDataSetHolderFactoryOptions; overload;
      function IdSize: Integer; overload;

      class property Default: IDataSetHolderFactoryOptions read GetDefaultOptions;

  end;

  IDataSetHolderFactory = interface

    function GetOptions: IDataSetHolderFactoryOptions;
    procedure SetOptions(Value: IDataSetHolderFactoryOptions);
    
    function CreateDataSetHolder: TAbstractDataSetHolder;

    property Options: IDataSetHolderFactoryOptions
    read GetOptions write SetOptions;
    
  end;

  TAbstractDataSetHolderFactory = class (TInterfacedObject, IDataSetHolderFactory)

    private

      FDataSetBuilder: IDataSetBuilder;
      FOptions: IDataSetHolderFactoryOptions;

    protected

      function CreateDataSetHolderInstance: TAbstractDataSetHolder; virtual;
      function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; virtual; abstract;
      procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); virtual;

      procedure CustomizeDataSetBuilder(
        DataSetBuilder: IDataSetBuilder;
        DataSetHolder: TAbstractDataSetHolder
      ); virtual;

    public

      constructor Create(
        DataSetBuilder: IDataSetBuilder;
        Options: IDataSetHolderFactoryOptions = nil
      );
      
      function GetOptions: IDataSetHolderFactoryOptions;
      procedure SetOptions(Value: IDataSetHolderFactoryOptions);

      function CreateDataSetHolder: TAbstractDataSetHolder;

      property Options: IDataSetHolderFactoryOptions
      read GetOptions write SetOptions;

  end;                     

implementation

{ TAbstractDataSetHolderFactory }

constructor TAbstractDataSetHolderFactory.Create(
  DataSetBuilder: IDataSetBuilder;
  Options: IDataSetHolderFactoryOptions
);
begin

  inherited Create;

  FDataSetBuilder := DataSetBuilder;

  if Assigned(Options) then
    FOptions := Options

  else FOptions := TDataSetHolderFactoryOptions.Default;
  
end;

function TAbstractDataSetHolderFactory.CreateDataSetHolder: TAbstractDataSetHolder;
begin

  Result := CreateDataSetHolderInstance;

  if Assigned(Options.RecordIdGeneratorFactory) then begin

    Result.RecordIdGenerator :=
      Options.RecordIdGeneratorFactory.CreateRecordIdGenerator;

  end;
  
  CustomizeDataSetBuilder(FDataSetBuilder, Result);

  Result.DataSet := FDataSetBuilder.Build;

  if Options.EnableRecordStatus then begin

    Result.RecordNonChangedStatusValue := 0;
    Result.RecordAddedStatusValue := 1;
    Result.RecordChangedStatusValue := 2;
    Result.RecordRemovedStatusValue := 3;

  end;

  Result.GenerateRecordIdOnAdding := Options.EnableRecordIdGeneratingOnAdding;

  Result.DataSet.Active := Options.OpenAfterCreate;
  
end;

function TAbstractDataSetHolderFactory.CreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := InternalCreateDataSetHolderInstance;

  FillDataSetFieldDefs(Result.FieldDefs);
  
end;

procedure TAbstractDataSetHolderFactory.CustomizeDataSetBuilder(
  DataSetBuilder: IDataSetBuilder;
  DataSetHolder: TAbstractDataSetHolder
);
var
    RecordIdType: TFieldType;
    RecordIdSize: Integer;
begin

  with DataSetHolder.FieldDefs do begin

    if RecordIdFieldName <> '' then begin
      
      DataSetBuilder.AddField(RecordIdFieldName, Options.IdType, Options.IdSize);

    end;

    if CanBeChangedFieldName <> '' then
      DataSetBuilder.AddField(CanBeChangedFieldName, ftBoolean);

    if CanBeRemovedFieldName <> '' then
      DataSetBuilder.AddField(CanBeRemovedFieldName, ftBoolean);

    if IsRecordIdGeneratedFieldName <> '' then
      DataSetBuilder.AddField(IsRecordIdGeneratedFieldName, ftBoolean);

    if RecordStatusFieldName <> '' then
      DataSetBuilder.AddField(RecordStatusFieldName, ftInteger);

  end;

end;

procedure TAbstractDataSetHolderFactory.FillDataSetFieldDefs(
  FieldDefs: TAbstractDataSetFieldDefs);
begin

  with FieldDefs do begin

    RecordIdFieldName := 'record_id';
    
    if Options.EnableRecordAccessRights then begin

      CanBeChangedFieldName := 'can_be_changed';
      CanBeRemovedFieldName := 'can_be_removed';

    end;

    if Options.EnableRecordStatus then begin

      RecordStatusFieldName := 'status';
      
    end;

    if Assigned(Options.RecordIdGeneratorFactory) then begin

      IsRecordIdGeneratedFieldName := 'is_record_id_generated';
      
    end;

  end;

end;

function TAbstractDataSetHolderFactory.GetOptions: IDataSetHolderFactoryOptions;
begin

  Result := FOptions;

end;

procedure TAbstractDataSetHolderFactory.SetOptions(
  Value: IDataSetHolderFactoryOptions);
begin

  FOptions := Value;

end;

{ TDataSetHolderFactoryOptions }

function TDataSetHolderFactoryOptions.EnableRecordAccessRights(
  const Value: Boolean): IDataSetHolderFactoryOptions;
begin

  FEnableRecordAccessRights := Value;

  Result := Self;

end;

function TDataSetHolderFactoryOptions.EnableRecordAccessRights: Boolean;
begin

  Result := FEnableRecordAccessRights;

end;

function TDataSetHolderFactoryOptions.EnableRecordIdGeneratingOnAdding: Boolean;
begin

  Result := FEnableRecordIdGeneratingOnAdding;

end;

function TDataSetHolderFactoryOptions.EnableRecordIdGeneratingOnAdding(
  const Value: Boolean): IDataSetHolderFactoryOptions;
begin

  FEnableRecordIdGeneratingOnAdding := Value;

  Result := Self;

end;

function TDataSetHolderFactoryOptions.EnableRecordStatus(
  const Value: Boolean): IDataSetHolderFactoryOptions;
begin

  FEnableRecordStatus := Value;

  Result := Self;

end;

function TDataSetHolderFactoryOptions.EnableRecordStatus: Boolean;
begin

  Result := FEnableRecordStatus;

end;

class function TDataSetHolderFactoryOptions.GetDefaultOptions: IDataSetHolderFactoryOptions;
begin

  if not Assigned(FDefault) then begin

    FDefault :=
      TDataSetHolderFactoryOptions
        .Create
          .EnableRecordAccessRights(False)
          .EnableRecordStatus(False)
          .EnableRecordIdGeneratingOnAdding(False)
          .OpenAfterCreate(True)
          .IdType(ftInteger)
          .RecordIdGeneratorFactory(nil);

  end;

  Result := FDefault;

end;

function TDataSetHolderFactoryOptions.IdSize: Integer;
begin

  Result := FIdSize;

end;

function TDataSetHolderFactoryOptions.IdSize(
  const Value: Integer): IDataSetHolderFactoryOptions;
begin

  FIdSize := Value;

  Result := Self;
  
end;

function TDataSetHolderFactoryOptions.IdType: TFieldType;
begin

  Result := FIdType;

end;

function TDataSetHolderFactoryOptions.IdType(
  const Value: TFieldType): IDataSetHolderFactoryOptions;
begin

  FIdType := Value;

  Result := Self;

end;

function TDataSetHolderFactoryOptions.OpenAfterCreate(
  const Value: Boolean): IDataSetHolderFactoryOptions;
begin

  FOpenAfterCreate := Value;

  Result := Self;

end;

function TDataSetHolderFactoryOptions.OpenAfterCreate: Boolean;
begin

  Result := FOpenAfterCreate;

end;

function TDataSetHolderFactoryOptions.RecordIdGeneratorFactory: IDataSetRecordIdGeneratorFactory;
begin

  Result := FRecordIdGeneratorFactory;

end;

function TDataSetHolderFactoryOptions.RecordIdGeneratorFactory(
  Value: IDataSetRecordIdGeneratorFactory): IDataSetHolderFactoryOptions;
begin

  FRecordIdGeneratorFactory := Value;

  Result := Self;
  
end;

end.
