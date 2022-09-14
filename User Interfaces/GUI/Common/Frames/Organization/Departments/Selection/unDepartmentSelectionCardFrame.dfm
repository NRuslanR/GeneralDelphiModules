object DepartmentSelectionCardFrame: TDepartmentSelectionCardFrame
  Left = 0
  Top = 0
  Width = 462
  Height = 150
  Constraints.MaxHeight = 157
  TabOrder = 0
  TabStop = True
  object ButtonsPanel: TPanel
    Left = 0
    Top = 99
    Width = 462
    Height = 51
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
  object DepartmentInfoPanel: TPanel
    Left = 0
    Top = 0
    Width = 462
    Height = 99
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      462
      99)
    object CodeLabel: TLabel
      Left = 114
      Top = 9
      Width = 24
      Height = 13
      Caption = #1050#1086#1076':'
    end
    object FullNameLabel: TLabel
      Left = 22
      Top = 67
      Width = 116
      Height = 13
      Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object ShortNameLabel: TLabel
      Left = 16
      Top = 38
      Width = 122
      Height = 13
      Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object CodeEdit: TRegExprValidateEdit
      Left = 144
      Top = 9
      Width = 308
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
      InvalidHint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      InvalidColor = 10520575
      RegularExpression = '.+'
    end
    object FullNameEdit: TRegExprValidateEdit
      Left = 144
      Top = 38
      Width = 308
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 1
      InvalidHint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      InvalidColor = 10520575
      RegularExpression = '.+'
    end
    object ShortNameEdit: TRegExprValidateEdit
      Left = 144
      Top = 67
      Width = 308
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 2
      InvalidHint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      InvalidColor = 10520575
      RegularExpression = '.+'
    end
  end
end
