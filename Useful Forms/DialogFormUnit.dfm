object DialogForm: TDialogForm
  Left = 0
  Top = 0
  ClientHeight = 598
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonsFooterPanel: TPanel
    Left = 0
    Top = 551
    Width = 767
    Height = 47
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      767
      47)
    object btnCancel: TcxButton
      Left = 684
      Top = 14
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 0
      OnClick = btnCancelClick
      LookAndFeel.SkinName = ''
    end
    object btnOK: TcxButton
      Left = 589
      Top = 14
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1050
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
