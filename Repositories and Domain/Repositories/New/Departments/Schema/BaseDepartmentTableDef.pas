unit BaseDepartmentTableDef;

interface

uses

  TableDef,
  SysUtils;

type

  TBaseDepartmentTableDef = class (TTableDef)

    public

      CodeColumnName: String;
      ShortNameColumnName: String;
      FullNameColumnName: String;
      TopLevelDepartmentIdColumnName: String;
      TopLevelDepartmentThresholdId: Variant;

      constructor Create;
      
  end;


implementation

uses

  Variants;

{ TBaseDepartmentTableDef }

constructor TBaseDepartmentTableDef.Create;
begin

  inherited Create;

  TopLevelDepartmentThresholdId := Null;

end;

end.
