unit DirectoryTraverseEventHandlers;

interface

uses

  SearchFileInfo,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDirectoryTraverseEventHandler = interface (IGetSelf)

    procedure OnFileDiscoveredEventHandler(
      Sender: TObject;
      SearchFileInfo: ISearchFileInfo;
      var ContinueTraverse: Boolean
    );
    
  end;

  TAbstractDirectoryTraverseEventHandler =
    class (TInterfacedObject, IDirectoryTraverseEventHandler)

      public

        function GetSelf: TObject;
        
        procedure OnFileDiscoveredEventHandler(
          Sender: TObject;
          SearchFileInfo: ISearchFileInfo;
          var ContinueTraverse: Boolean
        ); virtual;

    end;

    TSearchFileEventHandler = class (TAbstractDirectoryTraverseEventHandler)

      protected

        FSearchFileName: String;
        FFoundFileInfo: ISearchFileInfo;

      public

        constructor Create(const SearchFileName: String);

        procedure OnFileDiscoveredEventHandler(
          Sender: TObject;
          SearchFileInfo: ISearchFileInfo;
          var ContinueTraverse: Boolean
        ); override;

        property FoundFileInfo: ISearchFileInfo read FFoundFileInfo;
        
    end;

implementation

{ TAbstractDirectoryTraverseEventHandler }

function TAbstractDirectoryTraverseEventHandler.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TAbstractDirectoryTraverseEventHandler.OnFileDiscoveredEventHandler(
  Sender: TObject;
  SearchFileInfo: ISearchFileInfo;
  var ContinueTraverse: Boolean
);
begin

end;

{ TSearchFileEventHandler }

constructor TSearchFileEventHandler.Create(const SearchFileName: String);
begin

  inherited Create;

  FSearchFileName := SearchFileName;
  
end;

procedure TSearchFileEventHandler.OnFileDiscoveredEventHandler(
  Sender: TObject;
  SearchFileInfo: ISearchFileInfo;
  var ContinueTraverse: Boolean
);
begin

  inherited OnFileDiscoveredEventHandler(Sender, SearchFileInfo, ContinueTraverse);

  if SearchFileInfo.FileInfo.Name = FSearchFileName then begin

    FFoundFileInfo := SearchFileInfo;

    ContinueTraverse := False;

  end;

end;

end.
