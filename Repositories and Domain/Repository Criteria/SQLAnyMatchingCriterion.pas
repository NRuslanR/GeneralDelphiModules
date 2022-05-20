unit SQLAnyMatchingCriterion;

interface

uses

  AbstractRepositoryCriteriaUnit,
  VariantListUnit,
  SysUtils;

type

  TFieldValueArray = array of Variant;

  TSQLAnyMatchingCriterion = class (TAbstractRepositoryCriterion)

    protected

      FFieldName: String;
      FFieldValues: TVariantList;
      
      function GetExpression: String; override;

    public
      
      constructor Create(
        const FieldName: String;
        const FieldValues: TFieldValueArray
      ); overload;

      constructor Create(
        const FieldName: String;
        const FieldValues: TVariantList
      ); overload;
      
  end;

implementation

uses

  SQLCastingFunctions;

{ TSQLAnyMatchingCriterion }

constructor TSQLAnyMatchingCriterion.Create(const FieldName: String;
  const FieldValues: TFieldValueArray);
var
    FieldValueList: TVariantList;
begin

  FieldValueList := TVariantList.CreateFrom(FieldValues);

  try

    Create(FieldName, FieldValueList);
    
  finally

    FreeAndNil(FieldValueList);
    
  end;

end;

constructor TSQLAnyMatchingCriterion.Create(
  const FieldName: String;
  const FieldValues: TVariantList
);
begin

  inherited Create;

  FFieldName := FieldName;
  FFieldValues := FieldValues;
  
end;

function TSQLAnyMatchingCriterion.GetExpression: String;
begin

  Result :=
    Format(
      '%s IN (%s)',
      [
        FFieldName,
        CreateSQLValueListString(FFieldValues)
      ]
    );

end;

end.