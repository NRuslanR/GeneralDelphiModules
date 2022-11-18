unit DepartmentTableDef;

interface

uses

  BaseDepartmentTableDef,
  SysUtils;

type

  TDepartmentTableDef = class (TBaseDepartmentTableDef)

    public

      IsTopLevelDepartmentKindredColumnName: String;

  end;
  
implementation

end.
