inherited SystemAdministrationForm: TSystemAdministrationForm
  Caption = 'SystemAdministrationForm'
  ClientHeight = 605
  ClientWidth = 854
  Position = poMainFormCenter
  ExplicitWidth = 870
  ExplicitHeight = 644
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Height = 605
    ExplicitHeight = 605
  end
  inherited SectionListPanel: TPanel
    Height = 605
    ExplicitHeight = 605
    DesignSize = (
      233
      605)
    inherited SectionsTreeList: TcxDBTreeList
      Height = 589
      ExplicitHeight = 589
    end
  end
  inherited SectionContentPanel: TScrollBox
    Width = 617
    Height = 605
    ExplicitWidth = 617
    ExplicitHeight = 605
  end
end
