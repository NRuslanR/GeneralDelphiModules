inherited Form1: TForm1
  Caption = 'Form1'
  ClientHeight = 537
  ClientWidth = 962
  ExplicitTop = 8
  ExplicitWidth = 978
  ExplicitHeight = 576
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 962
    Height = 40
    ExplicitWidth = 962
    ExplicitHeight = 40
    inherited RefreshSeparator: TToolButton
      Left = 552
      Wrap = False
      ExplicitLeft = 552
    end
    inherited SelectFilterDataToolButton: TToolButton
      Left = 560
      Top = 0
      ExplicitLeft = 560
      ExplicitTop = 0
    end
    inherited SelectFilteredRecordsSeparator: TToolButton
      Left = 628
      Top = 0
      ExplicitLeft = 628
      ExplicitTop = 0
    end
    inherited PrintDataToolButton: TToolButton
      Left = 636
      Top = 0
      ExplicitLeft = 636
      ExplicitTop = 0
    end
    inherited ExportDataToolButton: TToolButton
      Left = 704
      Top = 0
      ExplicitLeft = 704
      ExplicitTop = 0
    end
    inherited ExportDataSeparator: TToolButton
      Left = 787
      Top = 0
      ExplicitLeft = 787
      ExplicitTop = 0
    end
    inherited ExitToolButton: TToolButton
      Left = 795
      Top = 0
      ExplicitLeft = 795
      ExplicitTop = 0
    end
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Top = 518
    Width = 962
    ExplicitTop = 518
    ExplicitWidth = 962
  end
  inherited SearchByColumnPanel: TScrollBox
    Top = 487
    Width = 962
    TabOrder = 1
    ExplicitTop = 487
    ExplicitWidth = 962
  end
  inherited DataRecordMovingToolBar: TToolBar
    Top = 40
    Width = 962
    TabOrder = 2
    ExplicitTop = 40
    ExplicitWidth = 962
  end
  inherited ClientAreaPanel: TPanel
    Top = 62
    Width = 962
    Height = 425
    TabOrder = 3
    ExplicitTop = 62
    ExplicitWidth = 962
    ExplicitHeight = 425
    inherited DataLoadingCanceledPanel: TPanel
      Top = 72
      ExplicitTop = 72
    end
    inherited WaitDataLoadingPanel: TPanel
      Top = 164
      ExplicitTop = 164
    end
    inherited DataRecordGrid: TcxGrid
      Width = 960
      Height = 423
      ExplicitLeft = 0
      ExplicitWidth = 960
      ExplicitHeight = 423
      inherited DataRecordGridTableView: TcxGridDBTableView
        DataController.DataModeController.SmartRefresh = True
        DataController.KeyFieldNames = 'Value'
        inherited IsSelectedColumn: TcxGridDBColumn
          DataBinding.ValueType = 'Boolean'
          Visible = True
        end
        object ValueColumn: TcxGridDBColumn
          DataBinding.FieldName = 'Value'
        end
      end
    end
  end
  inherited TargetDataSource: TDataSource
    DataSet = ClientDataSet1
  end
  object ClientDataSet1: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'RecId'
        Attributes = [faReadonly]
        DataType = ftInteger
      end
      item
        Name = 'Value'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 152
    Top = 368
    Data = {
      790000009619E0BD010000001800000002000300000003000000540005526563
      496404000100020001000B5345525645525F43414C4302000380FFFF0556616C
      7565010049000000010005574944544802000200140000000000010000000554
      68697264000002000000065365636F6E64000003000000054669727374}
    object ClientDataSet1Value: TStringField
      FieldName = 'Value'
    end
  end
end
