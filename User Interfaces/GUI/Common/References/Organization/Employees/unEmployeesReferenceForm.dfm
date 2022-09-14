inherited EmployeesReferenceForm: TEmployeesReferenceForm
  Caption = 'EmployeesReferenceForm'
  ExplicitWidth = 769
  ExplicitHeight = 719
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    inherited SelectFilteredRecordsSeparator: TToolButton
      ExplicitHeight = 44
    end
    inherited ExportDataToolButton: TToolButton
      ExplicitWidth = 83
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    inherited FirstDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited PrevDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited NextDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited LastDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
  end
  inherited ClientAreaPanel: TPanel
    inherited DataRecordGrid: TcxGrid
      inherited DataRecordGridTableView: TcxGridDBTableView
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.HeaderAutoHeight = True
        object IdColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        object SurnameColumn: TcxGridDBColumn
          Caption = #1060#1072#1084#1080#1083#1080#1103
          SortIndex = 0
          SortOrder = soAscending
        end
        object NameColumn: TcxGridDBColumn
          Caption = #1048#1084#1103
          SortIndex = 1
          SortOrder = soAscending
        end
        object PatronymicColumn: TcxGridDBColumn
          Caption = #1054#1090#1095#1077#1089#1090#1074#1086
          SortIndex = 2
          SortOrder = soAscending
        end
        object SpecialityColumn: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        end
        object PersonnelNumberColumn: TcxGridDBColumn
          Caption = #1058#1072#1073#1077#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088
        end
        object TelephoneColumn: TcxGridDBColumn
          Caption = #1058#1077#1083#1077#1092#1086#1085
        end
        object DepartmentCodeColumn: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
        end
        object DepartmentShortNameColumn: TcxGridDBColumn
          Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
        end
        object DepartmentFullNameColumn: TcxGridDBColumn
          Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
        end
      end
    end
  end
  inherited ExportDataPopupMenu: TPopupMenu
    Left = 40
  end
end
