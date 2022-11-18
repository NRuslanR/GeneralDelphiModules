unit EmployeeContactInfoTableDef;

interface

uses

  TableDef;

const

  EMPLOYEE_EMAIL_TABLE_NAME = 'exchange.person_email';
  EMPLOYEE_EMAIL_TABLE_NAME_ALIAS_1 = 'pe1';
  EMPLOYEE_EMAIL_TABLE_NAME_ALIAS_2 = 'pe2';

  EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME = 'email';
  EMPLOYEE_EMAIL_TABLE_EMPLOYEE_ID_FIELD_NAME = 'person_id';

  EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME_ALIAS_1 =
    EMPLOYEE_EMAIL_TABLE_NAME_ALIAS_1 + '_' +
    EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME;

  EMPLOYEE_EMAIL_TABLE_EMPLOYEE_ID_FIELD_NAME_ALIAS_1 =
    EMPLOYEE_EMAIL_TABLE_NAME_ALIAS_1 + '_' +
    EMPLOYEE_EMAIL_TABLE_EMPLOYEE_ID_FIELD_NAME;

  EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME_ALIAS_2 =
    EMPLOYEE_EMAIL_TABLE_NAME_ALIAS_2 + '_' +
    EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME;

  EMPLOYEE_EMAIL_TABLE_EMPLOYEE_ID_FIELD_NAME_ALIAS_2 =
    EMPLOYEE_EMAIL_TABLE_NAME_ALIAS_2 + '_' +
    EMPLOYEE_EMAIL_TABLE_EMPLOYEE_ID_FIELD_NAME;

type

  TEmployeeEmailTableDef = class (TTableDef)

    public

      EmployeeIdColumnName: String;
      EmailColumnName: String;

  end;

  TEmployeeTelephoneTableDef = class (TTableDef)

    public

      EmployeeIdColumnName: String;
      TelephoneNumberColumnName: String;
      
  end;
  
implementation

end.
