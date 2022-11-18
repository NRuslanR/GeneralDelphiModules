unit RoleTableDef;

interface

uses

  TableDef;

const

  ROLE_TABLE_NAME = 'doc.roles';
  ROLE_TABLE_NAME_ALIAS_1 = 'r1';
  ROLE_TABLE_NAME_ALIAS_2 = 'r2';

  ROLE_TABLE_ID_FIELD = 'id';
  ROLE_TABLE_NAME_FIELD = 'name';
  ROLE_TABLE_DESCRIPTION_FIELD = 'description';

  EMPLOYEE_ROLE_ID_FIELD = 'role_id';
  EMPLOYEE_ROLE_NAME_FIELD = 'role_name';
  EMPLOYEE_ROLE_DESCRIPTION_FIELD = 'role_description';

  ROLE_TABLE_ID_FIELD_ALIAS_1 =
    ROLE_TABLE_NAME_ALIAS_1 + '_' + ROLE_TABLE_ID_FIELD;

  ROLE_TABLE_NAME_FIELD_ALIAS_1 =
    ROLE_TABLE_NAME_ALIAS_1 + '_' + ROLE_TABLE_NAME_FIELD;

  ROLE_TABLE_DESCRIPTION_FIELD_ALIAS_1 =
    ROLE_TABLE_NAME_ALIAS_1 + '_' + ROLE_TABLE_DESCRIPTION_FIELD;

  ROLE_TABLE_ID_FIELD_ALIAS_2 =
    ROLE_TABLE_NAME_ALIAS_2 + '_' + ROLE_TABLE_ID_FIELD;

  ROLE_TABLE_NAME_FIELD_ALIAS_2 =
    ROLE_TABLE_NAME_ALIAS_2 + '_' + ROLE_TABLE_NAME_FIELD;

  ROLE_TABLE_DESCRIPTION_FIELD_ALIAS_2 =
    ROLE_TABLE_NAME_ALIAS_2 + '_' + ROLE_TABLE_DESCRIPTION_FIELD;

type

  TRoleTableDef = class (TTableDef)

    public

      NameColumnName: String;
      ServiceNameColumnName: String;
      DescriptionColumnName: String;
      
  end;


implementation

end.
