object TestFormA: TTestFormA
  Left = 0
  Top = 0
  Caption = 'TestFormA'
  ClientHeight = 469
  ClientWidth = 708
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 32
    Top = 32
    Width = 601
    Height = 281
    Caption = 'Panel1'
    TabOrder = 0
    object RegExprValidateEdit1: TRegExprValidateEdit
      Left = 24
      Top = 32
      Width = 209
      Height = 21
      TabOrder = 0
      Text = 'RegExprValidateEdit1'
      InvalidColor = 10520575
      RegularExpression = '.*'
    end
    object Memo1: TMemo
      Left = 24
      Top = 144
      Width = 185
      Height = 89
      Lines.Strings = (
        'Memo1')
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 32
    Top = 352
    Width = 137
    Height = 25
    Caption = 'Show TestFormB'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DateTimePicker1: TDateTimePicker
    Left = 216
    Top = 352
    Width = 186
    Height = 21
    Date = 43991.604519502320000000
    Time = 43991.604519502320000000
    TabOrder = 2
  end
end
