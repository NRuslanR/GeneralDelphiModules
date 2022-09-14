object OKCancelFrame: TOKCancelFrame
  Left = 0
  Top = 0
  Width = 180
  Height = 31
  Constraints.MaxHeight = 31
  Constraints.MaxWidth = 180
  Constraints.MinHeight = 31
  Constraints.MinWidth = 180
  TabOrder = 0
  TabStop = True
  object OKButton: TcxButton
    Left = 3
    Top = 3
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 0
  end
  object CancelButton: TcxButton
    Left = 101
    Top = 3
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = CancelButtonClick
  end
end
