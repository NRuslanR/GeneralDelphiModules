inherited DialogForm: TDialogForm
  ClientHeight = 375
  ClientWidth = 549
  ExplicitWidth = 565
  ExplicitHeight = 414
  DesignSize = (
    549
    375)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TcxButton
    Left = 379
    Top = 342
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TcxButton
    Left = 466
    Top = 342
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = btnCancelClick
    LookAndFeel.SkinName = ''
  end
end
