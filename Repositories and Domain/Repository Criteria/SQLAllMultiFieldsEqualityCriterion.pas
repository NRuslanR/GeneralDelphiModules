unit SQLAllMultiFieldsEqualityCriterion;

interface

uses

  AbstractRepositoryCriteriaUnit,
  VariantListUnit,
  Classes,
  SysUtils;

type

  TFieldNames = TStrings;
  TFieldValues = TVariantList;

  TSQLAllMultiFieldsEqualityCriterion = class (TAbstractRepositoryCriterion)

    protected

      FFieldNames: TFieldNames;
      FFieldValues: TFieldValues;
          
      function GetExpression: String; override;

    public

      destructor Destroy; override;
      
      constructor Create(
        FieldNames: TFieldNames;
        FieldValues: TFieldValues
      ); overload;

      constructor Create(
        FieldNames: array of String;
        FieldValues: array of Variant
      ); overload;
      
  end;

implementation

uses

  StrUtils,
  AuxiliaryStringFunctions,
  SQLCastingFunctions;

{ TSQLAllMultiFieldsEqualityCriterion }

constructor TSQLAllMultiFieldsEqualityCriterion.Create(
  FieldNames: TFieldNames;
  FieldValues: TFieldValues
);
begin

  inherited Create;

  FFieldNames := FieldNames;
  FFieldValues := FieldValues;
  
end;

constructor TSQLAllMultiFieldsEqualityCriterion.Create(
  FieldNames: array of String;
  FieldValues: array of Variant
);
var
    LFieldNames: TFieldNames;
    LFieldValues: TFieldValues;
begin

  LFieldNames := nil;
  LFieldValues := nil;

  try

    LFieldNames := CreateStringListFrom(FieldNames);
    LFieldValues := TFieldValues.CreateFrom(FieldValues);
    
    Create(LFieldNames, LFieldValues);
    
  except

    FreeAndNil(LFieldNames);
    FreeAndNil(LFieldValues);

  end;

end;

destructor TSQLAllMultiFieldsEqualityCriterion.Destroy;
begin

  FreeAndNil(FFieldNames);
  FreeAndNil(FFieldValues);
  
  inherited;

end;

function TSQLAllMultiFieldsEqualityCriterion.GetExpression: String;
var
    I: Integer;
    FieldExpression: String;
begin

  for I := 0 to FFieldNames.Count - 1 do begin

    FieldExpression := FFieldNames[I] + '=' + AsSQLString(FFieldValues[I]);

    Result :=
      IfThen(Result = '', FieldExpression, Result + ' AND ' + FieldExpression);

  end;
    
end;

end.
