object SectionStackedForm: TSectionStackedForm
  Left = 0
  Top = 0
  Caption = 'SectionStackedForm'
  ClientHeight = 739
  ClientWidth = 1030
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 233
    Top = 0
    Width = 4
    Height = 739
    Color = clBtnFace
    ParentColor = False
    ExplicitHeight = 411
  end
  object SectionListPanel: TPanel
    Left = 0
    Top = 0
    Width = 233
    Height = 739
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitHeight = 411
    DesignSize = (
      233
      739)
    object SectionsTreeList: TcxDBTreeList
      Left = 8
      Top = 8
      Width = 223
      Height = 723
      Anchors = [akLeft, akTop, akRight, akBottom]
      Bands = <
        item
        end>
      DataController.DataSource = SectionsDataSource
      LookAndFeel.SkinName = 'UserSkin'
      OptionsData.Editing = False
      OptionsData.Deleting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.HideFocusRect = False
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderAutoHeight = True
      RootValue = -1
      TabOrder = 0
      OnCustomDrawDataCell = SectionsTreeListCustomDrawDataCell
      OnFocusedNodeChanged = SectionsTreeListFocusedNodeChanged
      ExplicitHeight = 395
      object SectionIdColumn: TcxDBTreeListColumn
        Visible = False
        Options.Customizing = False
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object ParentSectionIdColumn: TcxDBTreeListColumn
        Visible = False
        Options.Customizing = False
        Position.ColIndex = 1
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object SectionNameColumn: TcxDBTreeListColumn
        Caption.AlignHorz = taCenter
        Caption.AlignVert = vaCenter
        Caption.Text = #1056#1072#1079#1076#1077#1083#1099
        Options.Customizing = False
        Position.ColIndex = 2
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
  end
  object SectionContentPanel: TScrollBox
    Left = 237
    Top = 0
    Width = 793
    Height = 739
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
    ExplicitWidth = 427
    ExplicitHeight = 411
  end
  object SectionsDataSource: TDataSource
    Left = 16
    Top = 368
  end
end
