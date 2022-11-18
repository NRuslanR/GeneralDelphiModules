unit EmployeeTableDef;

interface

uses

  TableDef;

const

  EMPLOYEE_TABLE_NAME = 'doc.employees';
  EMPLOYEE_TABLE_NAME_ALIAS_1 = 'emp1';
  EMPLOYEE_TABLE_NAME_ALIAS_2 = 'emp2';

  EMPLOYEE_TABLE_ID_FIELD = 'id';
  EMPLOYEE_TABLE_NAME_FIELD = 'name';
  EMPLOYEE_TABLE_SURNAME_FIELD = 'surname';
  EMPLOYEE_TABLE_PATRONYMIC_FIELD = 'patronymic';
  EMPLOYEE_TABLE_SPECIALITY_FIELD = 'speciality';
  EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD = 'personnel_number';
  EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD = 'telephone_number';
  EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD = 'department_id';
  EMPLOYEE_TABLE_LEADER_ID_FIELD = 'leader_id';
  EMPLOYEE_TABLE_EXTERNAL_ID_FIELD = 'spr_person_id';
  EMPLOYEE_TABLE_IS_FOREIGN_FIELD = 'is_foreign';
  EMPLOYEE_TABLE_IS_DISMISSED_FIELD = 'was_dismissed';
  EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD = 'head_kindred_department_id';
  EMPLOYEE_TABLE_IS_SD_USER_FIELD = 'is_sd_user';
  EMPLOYEE_TABLE_LEGACY_ID_FIELD = 'spr_person_id';

  EMPLOYEE_TABLE_ID_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_ID_FIELD;

  EMPLOYEE_TABLE_LEGACY_ID_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_LEGACY_ID_FIELD;
     
  EMPLOYEE_TABLE_NAME_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_NAME_FIELD;
    
  EMPLOYEE_TABLE_SURNAME_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_SURNAME_FIELD;
    
  EMPLOYEE_TABLE_PATRONYMIC_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_PATRONYMIC_FIELD;

  EMPLOYEE_TABLE_SPECIALITY_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_SPECIALITY_FIELD;
    
  EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD;
    
  EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD;
    
  EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD;

  EMPLOYEE_TABLE_LEADER_ID_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_LEADER_ID_FIELD;
    
  EMPLOYEE_TABLE_EXTERNAL_ID_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' = EMPLOYEE_TABLE_EXTERNAL_ID_FIELD;

  EMPLOYEE_TABLE_IS_FOREIGN_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_IS_FOREIGN_FIELD;

  EMPLOYEE_TABLE_IS_DISMISSED_FIELD_ALIAS_1 =
    EMPLOYEE_TABLE_NAME_ALIAS_1 + '_' + EMPLOYEE_TABLE_IS_DISMISSED_FIELD;


  EMPLOYEE_TABLE_ID_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_ID_FIELD;

  EMPLOYEE_TABLE_LEGACY_ID_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_LEGACY_ID_FIELD;
    
  EMPLOYEE_TABLE_NAME_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_NAME_FIELD;
    
  EMPLOYEE_TABLE_SURNAME_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_SURNAME_FIELD;
    
  EMPLOYEE_TABLE_PATRONYMIC_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_PATRONYMIC_FIELD;

  EMPLOYEE_TABLE_SPECIALITY_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_SPECIALITY_FIELD;
    
  EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD;
    
  EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD;
    
  EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD;

  EMPLOYEE_TABLE_LEADER_ID_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_LEADER_ID_FIELD;
    
  EMPLOYEE_TABLE_EXTERNAL_ID_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' = EMPLOYEE_TABLE_EXTERNAL_ID_FIELD;

  EMPLOYEE_TABLE_IS_FOREIGN_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_IS_FOREIGN_FIELD;

  EMPLOYEE_TABLE_IS_DISMISSED_FIELD_ALIAS_2 =
    EMPLOYEE_TABLE_NAME_ALIAS_2 + '_' + EMPLOYEE_TABLE_IS_DISMISSED_FIELD;

type

  TEmployeeTableDef = class (TTableDef)

    public

      LegacyIdColumnName: String;
      NameColumnName: String;
      SurnameColumnName: String;
      PatronymicColumnName: String;
      SpecialityColumnName: String;
      PersonnelNumberColumnName: String;
      DepartmentIdColumnName: String;
      TopLevelEmployeeIdColumnName: String;
      IsForeignColumnName: String;
      IsDismissedColumnName: String;

  end;
  
implementation

end.
