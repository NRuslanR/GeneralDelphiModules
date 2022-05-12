unit IPDFDocumentProcessorUnit;

interface

uses Classes, Windows;

type

  IPDFDocumentProcessor = interface
    ['{0198FEC4-F20A-4993-BEF2-E4A472E8F321}']

    procedure LoadFromFile(const FilePath: String);

    function GetPageWidth: Double;
    function GetPageHeight: Double;
    function GetSelectedDocumentPath: String;
    function GetSelectedDocumentId: Variant;
    function GetPageCount: Integer;
    function SelectDocument(const DocumentId: Variant): Variant;

    procedure RenderPageToStream(
      const DPI: Double;
      const PageNumber: Integer;
      const Options: Integer;
      Stream: TStream
    );
    procedure RenderPageToDC(
      const DPI: Double;
      const PageNumber: Integer;
      DeviceContext: HDC
    );

    procedure UnloadDocument(const DocumentId: Variant);
    procedure UnloadCurrentDocument;

    property PageCount: Integer read GetPageCount;
    property SelectedDocumentId: Variant read GetSelectedDocumentId;
    property SelectedDocumentPath: String read GetSelectedDocumentPath;

    property PageWidth: Double read GetPageWidth;
    property PageHeight: Double read GetPageHeight;
    
  end;

implementation

end.
