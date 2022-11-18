unit EmployeeReplacementTableDef;

interface

uses

  TableDef;

const

  EMPLOYEE_REPLACEMENT_TABLE_NAME = 'doc.employee_replacements';

  EMPLOYEE_REPLACEMENT_TABLE_ID_FIELD = 'id';
  EMPLOYEE_REPLACEMENT_TABLE_REPLACEABLE_ID_FIELD = 'replaceable_id';
  EMPLOYEE_REPLACEMENT_TABLE_DEPUTY_ID_FIELD = 'deputy_id';
  EMPLOYEE_REPLACEMENT_TABLE_REPLACEMENT_PERIOD_START = 'replacement_period_start';
  EMPLOYEE_REPLACEMENT_TABLE_REPLACEMENT_PERIOD_END = 'replacement_period_end';

type

  TEmployeeReplacementTableDef = class (TTableDef)

    public

      ReplaceableIdColumnName: String;
      DeputyIdColumnName: String;
      PeriodStartColumnName: String;
      PeriodEndColumnName: String;

  end;

implementation

end.
