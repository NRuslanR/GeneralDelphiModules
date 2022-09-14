object EmployeeSelectionCardFrame: TEmployeeSelectionCardFrame
  Left = 0
  Top = 0
  Width = 525
  Height = 186
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  TabStop = True
  object ButtonsPanel: TPanel
    Left = 0
    Top = 136
    Width = 525
    Height = 50
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ChooseButton: TcxButton
      Left = 16
      Top = 13
      Width = 75
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 0
    end
  end
  object EmployeeInfoPanel: TPanel
    Left = 0
    Top = 0
    Width = 525
    Height = 136
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      525
      136)
    object NameLabel: TLabel
      Left = 86
      Top = 12
      Width = 23
      Height = 13
      Caption = #1048#1084#1103':'
    end
    object PersonnelNumberLabel: TLabel
      Left = 16
      Top = 42
      Width = 93
      Height = 13
      Caption = #1058#1072#1073#1077#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088':'
    end
    object SpecialityLabel: TLabel
      Left = 48
      Top = 72
      Width = 61
      Height = 13
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
    end
    object TelephoneLabel: TLabel
      Left = 61
      Top = 102
      Width = 48
      Height = 13
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
    end
    object NameEdit: TRegExprValidateEdit
      Left = 115
      Top = 15
      Width = 395
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
      InvalidHint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      InvalidColor = 10520575
      RegularExpression = '.+'
    end
    object PersonnelNumberEdit: TRegExprValidateEdit
      Left = 115
      Top = 42
      Width = 395
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 1
      InvalidHint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      InvalidColor = 10520575
      RegularExpression = '.+'
    end
    object SpecialityEdit: TRegExprValidateEdit
      Left = 115
      Top = 72
      Width = 395
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 2
      InvalidHint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      InvalidColor = 10520575
      RegularExpression = '.+'
    end
    object TelephoneEdit: TRegExprValidateEdit
      Left = 115
      Top = 102
      Width = 395
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 3
      InvalidHint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      InvalidColor = 10520575
      RegularExpression = '.*'
    end
  end
end
