unit DBSequenceNumberGeneratorUnit;

interface

uses

  INumberGeneratorUnit,
  SequenceNumberGeneratorUnit,
  QueryExecutor,
  DataReader,
  SysUtils,
  Classes;

type

  TDBSequenceNumberGenerator = class (TSequenceNumberGenerator)

    protected

      FQueryExecutor: IQueryExecutor;
      
      FNumberFieldName: String;
      FTableName: String;
      FFilterStatement: String;

    protected

      function InternalGetNextNumber: LongInt; override;
      procedure InternalReset; override;

    protected

      function LoadCurrentNumberFromDatabase: LongInt; virtual;

      procedure SaveCurrentNumberToDatabase(
        const PreviousNumber: Variant
      ); virtual;

    protected

      function PrepareCurrentNumberFetchingQuery: String; virtual;

      function PrepareCurrentNumberSavingQuery(
        const PreviousNumber: Variant;
        const CurrentNumber: LongInt
      ): String; virtual;
      
      function ExecuteCurrentNumberFetchingQuery(
        const QueryText: String
      ): IDataReader; virtual;

    public

      constructor Create(QueryExecutor: IQueryExecutor);

      property NumberFieldName: String
      read FNumberFieldName write FNumberFieldName;

      property TableName: String
      read FTableName write FTableName;

      property FilterStatement: String
      read FFilterStatement write FFilterStatement;
      
  end;

implementation

uses

  Variants;
  
{ TDBSequenceNumberGenerator }

constructor TDBSequenceNumberGenerator.Create(QueryExecutor: IQueryExecutor);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;
  
end;

function TDBSequenceNumberGenerator.ExecuteCurrentNumberFetchingQuery(
  const QueryText: String): IDataReader;
begin

  Result := FQueryExecutor.ExecuteSelectionQuery(QueryText);

end;

function TDBSequenceNumberGenerator.InternalGetNextNumber: LongInt;
var PreviousNumber: LongInt;
begin

  FCurrentNumber := LoadCurrentNumberFromDatabase;

  PreviousNumber := FCurrentNumber;
  
  Inc(FCurrentNumber);

  SaveCurrentNumberToDatabase(PreviousNumber);

  Result := FCurrentNumber;
  
end;

procedure TDBSequenceNumberGenerator.InternalReset;
begin

  inherited;

  SaveCurrentNumberToDatabase(Null);
  
end;

function TDBSequenceNumberGenerator.LoadCurrentNumberFromDatabase: LongInt;
var QueryText: String;
    DataReader: IDataReader;
    CurrentNumberVariant: Variant;
begin

  QueryText := PrepareCurrentNumberFetchingQuery;

  DataReader := ExecuteCurrentNumberFetchingQuery(QueryText);

  if DataReader.RecordCount = 0 then
    CurrentNumberVariant := Null

  else CurrentNumberVariant := DataReader[NumberFieldName];

  if VarIsNull(CurrentNumberVariant) then
    raise TCurrentNumberNotFoundException.Create('');

  Result := CurrentNumberVariant;

end;

function TDBSequenceNumberGenerator.PrepareCurrentNumberFetchingQuery: String;
begin

  Result :=
    Format(
      'SELECT %s FROM %s WHERE %s FOR UPDATE',
      [
        NumberFieldName,
        TableName,
        FilterStatement
      ]
    );
    
end;

function TDBSequenceNumberGenerator.PrepareCurrentNumberSavingQuery(
  const PreviousNumber: Variant;
  const CurrentNumber: LongInt
): String;
begin

  Result :=
    Format(
      'UPDATE %s SET %s=%d',
      [
        TableName,
        NumberFieldName,
        CurrentNumber
      ]
    );

  if not VarIsNull(PreviousNumber) then begin

    Result :=
      Result +
      Format(
        ' WHERE %s=%s',
        [
          NumberFieldName,
          VarToStr(PreviousNumber)
        ]
      );

  end;

  if FilterStatement <> '' then begin

    if VarIsNull(PreviousNumber) then
      Result := Result + ' WHERE ' + FilterStatement

    else Result := Result + ' AND ' + FilterStatement;

  end;

end;

procedure TDBSequenceNumberGenerator.SaveCurrentNumberToDatabase(
  const PreviousNumber: Variant
);
var QueryText: String;
begin

  QueryText := PrepareCurrentNumberSavingQuery(PreviousNumber, FCurrentNumber);

  FQueryExecutor.ExecuteModificationQuery(QueryText);
  
end;

end.
