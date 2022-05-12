unit PDFDocumentRenderingThreadUnit;

interface

uses

  Windows, Classes, Graphics, SysUtils, DebenuPDFLibrary1411,
  IPDFDocumentProcessorUnit,
  PDFDocumentExceptionsUnit,
  CancellationThreadUnit;

const

  DEFAULT_DOCUMENT_DPI = 110;

type

  TRenderedPDFDocumentPageNumberNotValidException = class (Exception)

  end;

  TRenderedPDFDocument = class abstract

    protected

      FPageCount: Integer;
      FCurrentScaleFactor: Double;
      FCurrentRotationAngleDegree: Single;
      FCurrentPageBitmapNumber: Integer;
      FDocumentFilePath: String;

      procedure RotatePageBitmap(
        PageBitmap: TBitmap;
        const AngleDegree: Single
      );

      function GetCurrentPageBitmap: TBitmap; virtual; abstract;

      procedure SetCurrentPageBitmapNumber(
        const PageBitmapNumber: Integer
      );

      procedure InternalSetCurrentPageBitmapNumber(
        const PageBitmapNumber: Integer
      ); virtual; abstract;

      function GetPageCount: Integer; virtual;

      procedure RaiseExceptionIfPageBitmapNumberNotValid(
        const PageBitmapNumber: Integer
      );

      procedure SetDocumentScaleFactor(
        const ScaleFactor: Double
      );
      procedure SetDocumentRotationAngleDegree(
        const RotationAngleDegree: Single
      );

    public

      constructor Create;
      
      property CurrentPageBitmap: TBitmap read GetCurrentPageBitmap;

      property CurrentPageBitmapNumber: Integer
       read FCurrentPageBitmapNumber write SetCurrentPageBitmapNumber;

      property PageCount: Integer read GetPageCount;

      property ScaleFactor: Double
      read FCurrentScaleFactor write SetDocumentScaleFactor;

      property RotationAngleDegree: Single
      read FCurrentRotationAngleDegree write SetDocumentRotationAngleDegree;
      
      function GoToNextPageBitmap: TBitmap; virtual;
      function GoToPreviousPageBitmap: TBitmap; virtual;

      function InternalGetBitmapOfDocumentPageByCurrentPageNumber:
        TBitmap; virtual; abstract;

      function IsNextPageExists: Boolean; virtual;
      function IsPreviousPageExists: Boolean; virtual;

      function IsPageBitmapNumberValid(
        const PageBitmapNumber: Integer
      ): Boolean; virtual;

      property DocumentFilePath: String read FDocumentFilePath;
      
  end;

  TSinglePagedRenderedPDFDocument = class (TRenderedPDFDocument)

    private

      FCurrentPageBitmap: TBitmap;
      FDocumentProcessor: IPDFDocumentProcessor;

    protected

      function GetCurrentPageBitmap: TBitmap; override;

      procedure InternalSetCurrentPageBitmapNumber(
        const PageBitmapNumber: Integer
      ); override;

    public

      destructor Destroy; override;
                             
      constructor Create(DocumentProcessor: IPDFDocumentProcessor);

      function InternalGetBitmapOfDocumentPageByCurrentPageNumber:
        TBitmap; override;

  end;

  TFullPagedRenderedPDFDocument = class (TRenderedPDFDocument)

    private

      FPageBitmaps: TList;

      procedure FreePageBitmaps;
      procedure Add(PageBitmap: TBitmap);

    protected

      function GetCurrentPageBitmap: TBitmap; override;

      procedure InternalSetCurrentPageBitmapNumber(
        const PageBitmapNumber: Integer
      ); override;

    public

      destructor Destroy; override;

      constructor Create;

      function InternalGetBitmapOfDocumentPageByCurrentPageNumber:
        TBitmap; override;

  end;

  TOnPDFDocumentPageRenderFinishedEventHandler =
    procedure(Sender: TObject;
    const CurrentPageNumber: Integer;
    RenderedPageBitmap: TBitmap
  ) of object;

  TOnPDFDocumentRenderingFinishedEventHandler =
    procedure(
      Sender: TObject;
      RenderedPDFDocument: TRenderedPDFDocument
    ) of object;

  TOnPDFDocumentRenderingErrorOccurredEventHandler =
    procedure (
      Sender: TObject;
      Error: Exception
    ) of object;

  TOutputPDFDocumentView =
    (
      dvSinglePagedPDFDocument,
      dvFullPagedPDFDocument
    );

  TPDFDocumentRenderingThread = class(TCancellationThread)

   private
    { Private declarations }

    FProcessableDocumentPath: String;
    FPDFDocumentProcessor: IPDFDocumentProcessor;
    FCurrentRenderedPageNumber: Integer;
    FCurrentRenderedPageBitmap: TBitmap;
    FWasPDFDocumentRendered: Boolean;
    FOutputPDFDocumentView: TOutputPDFDocumentView;
    FRenderedPDFDocument: TRenderedPDFDocument;
    FLastError: Exception;

    FOnPDFDocumentRenderingErrorOccurredEventHandler: TOnPDFDocumentRenderingErrorOccurredEventHandler;
    FOnPDFDocumentPageRenderFinishedEventHandler: TOnPDFDocumentPageRenderFinishedEventHandler;
    FOnPDFDocumentRenderingFinishedEventHandler: TOnPDFDocumentRenderingFinishedEventHandler;

    procedure UnloadDocumentIfOutputDocumentViewIsFullPaged;
    procedure LoadDocumentFromPath;
    procedure CreatePDFDocumentPageBitmapsMemento;
    
    procedure RenderCurrentDocumentPageFromStream(
      Stream: TMemoryStream
    );

    procedure UnloadDocument;
    procedure RenderDocument;
    procedure RenderDocumentAsFullPaged;
    procedure RenderDocumentAsSinglePaged;

    procedure RaiseOnPDFDocumentPageRenderFinishedEventHandler;
    procedure RaiseOnPDFDocumentRenderingFinishedEventHandler;
    procedure RaiseOnPDFDocumentRenderingErrorOccurredEventHandler;

    function RaiseOnCancellationEventHandlerIfWasRequested: Boolean;

  public

    destructor Destroy; override;
    
    constructor Create(
      const DocumentPath: String;
      PDFDocumentProcessor: IPDFDocumentProcessor;
      const OutputDocumentView: TOutputPDFDocumentView = dvFullPagedPDFDocument
    );

    property

      OnPDFDocumentPageRenderFinishedEventHandler: TOnPDFDocumentPageRenderFinishedEventHandler

      read FOnPDFDocumentPageRenderFinishedEventHandler
      write FOnPDFDocumentPageRenderFinishedEventHandler;

    property

      OnPDFDocumentRenderingFinishedEventHandler: TOnPDFDocumentRenderingFinishedEventHandler

      read FOnPDFDocumentRenderingFinishedEventHandler
      write FOnPDFDocumentRenderingFinishedEventHandler;

    property

      OnPDFDocumentRenderingErrorOccurredEventHandler:
        TOnPDFDocumentRenderingErrorOccurredEventHandler

      read FOnPDFDocumentRenderingErrorOccurredEventHandler
      write FOnPDFDocumentRenderingErrorOccurredEventHandler;

  protected

    procedure Execute; override;

  public

    property ProcessableDocumentPath: String read FProcessableDocumentPath;

  end;

implementation

uses AuxiliaryFunctionsForExceptionHandlingUnit,
     Variants,
     AuxGraphicFunctions;

{ turn to strategy object }
function CreateBitmapOfGivenPDFDocumentPage(
  PDFDocumentProcessor: IPDFDocumentProcessor;
  const DPI: Double;
  const PageNumber: Integer
): TBitmap;
var DocumentPageStream: TMemoryStream;
    PageBitmap: TBitmap;
begin

  DocumentPageStream := nil;

  try
    try

      DocumentPageStream := TMemoryStream.Create;

      PDFDocumentProcessor.RenderPageToStream(
        DPI, PageNumber, 0, DocumentPageStream
      );

      DocumentPageStream.Seek(0, soFromBeginning);

      Result := TBitmap.Create;
      Result.LoadFromStream(DocumentPageStream);

    except

      on e: Exception do
        OutputDebugString(PChar(e.Message));
    end;
    
  finally

    FreeAndNil(DocumentPageStream);

  end;

end;

constructor TPDFDocumentRenderingThread.Create(
  const DocumentPath: String;
  PDFDocumentProcessor: IPDFDocumentProcessor;
  const OutputDocumentView: TOutputPDFDocumentView
);
begin

  inherited Create(True);

  FOutputPDFDocumentView := OutputDocumentView;
  FProcessableDocumentPath := DocumentPath;
  FPDFDocumentProcessor := PDFDocumentProcessor;

end;

procedure TPDFDocumentRenderingThread.CreatePDFDocumentPageBitmapsMemento;
begin

  case FOutputPDFDocumentView of

    dvSinglePagedPDFDocument:
    begin

      FRenderedPDFDocument := TSinglePagedRenderedPDFDocument.Create(FPDFDocumentProcessor);

    end;

    dvFullPagedPDFDocument:
    begin

      FRenderedPDFDocument := TFullPagedRenderedPDFDocument.Create;

    end;

  end;
  
end;

destructor TPDFDocumentRenderingThread.Destroy;
begin
  
  if not FWasPDFDocumentRendered then
    FreeAndNil(FRenderedPDFDocument);

  inherited;

end;

procedure TPDFDocumentRenderingThread.Execute;
begin

  try

    LoadDocumentFromPath;
    CreatePDFDocumentPageBitmapsMemento;
    RenderDocument;

  except

    on e: Exception do begin

      if Assigned(FOnPDFDocumentRenderingErrorOccurredEventHandler) then
      begin

        FLastError := e;
        Synchronize(RaiseOnPDFDocumentRenderingErrorOccurredEventHandler);

      end;

    end;

  end;

end;

procedure TPDFDocumentRenderingThread.LoadDocumentFromPath;
begin

  try

    FPDFDocumentProcessor.LoadFromFile(FProcessableDocumentPath);

  except

    on e: Exception do begin

      raise TPDFDocumentLoadingFailedException.CreateFmt(
              '%s',
              [e.Message],
              CloneException(e)
            );

    end;

  end;

end;

procedure TPDFDocumentRenderingThread.RaiseOnPDFDocumentRenderingErrorOccurredEventHandler;
begin

  if RaiseOnCancellationEventHandlerIfWasRequested then Exit;

  UnloadDocumentIfOutputDocumentViewIsFullPaged;
  
  FOnPDFDocumentRenderingErrorOccurredEventHandler(
    Self,
    FLastError
  );
  
end;

function TPDFDocumentRenderingThread.RaiseOnCancellationEventHandlerIfWasRequested: Boolean;
begin

  if IsCancelled then
    UnloadDocumentIfOutputDocumentViewIsFullPaged;

  Result := RaiseOnCancellationEventHandlerIf;

  if Result then
    FOnCancellationEventHandler := nil;

end;

procedure TPDFDocumentRenderingThread.RaiseOnPDFDocumentPageRenderFinishedEventHandler;
begin

  if RaiseOnCancellationEventHandlerIfWasRequested then Exit;
  
  FOnPDFDocumentPageRenderFinishedEventHandler(
    Self, FCurrentRenderedPageNumber, FCurrentRenderedPageBitmap
  );
  
end;

procedure TPDFDocumentRenderingThread.RaiseOnPDFDocumentRenderingFinishedEventHandler;
begin

  if RaiseOnCancellationEventHandlerIfWasRequested then Exit;

  UnloadDocumentIfOutputDocumentViewIsFullPaged;

  FOnPDFDocumentRenderingFinishedEventHandler(
    Self, FRenderedPDFDocument
  );

end;

procedure TPDFDocumentRenderingThread.RenderCurrentDocumentPageFromStream(
  Stream: TMemoryStream
);
begin

  FCurrentRenderedPageBitmap := TBitmap.Create;
  FCurrentRenderedPageBitmap.LoadFromStream(Stream);

  with FRenderedPDFDocument as TFullPagedRenderedPDFDocument do
    Add(FCurrentRenderedPageBitmap);

  if Assigned(FOnPDFDocumentPageRenderFinishedEventHandler) then
    Synchronize(RaiseOnPDFDocumentPageRenderFinishedEventHandler);

end;

procedure TPDFDocumentRenderingThread.RenderDocument;
var CurrentRenderedPageNumber: Integer;
    DocumentPageStream: TMemoryStream;
begin

  case FOutputPDFDocumentView of

    dvSinglePagedPDFDocument: RenderDocumentAsSinglePaged;
    dvFullPagedPDFDocument: RenderDocumentAsFullPaged;

  end;

  FRenderedPDFDocument.FDocumentFilePath := FProcessableDocumentPath;
  
  if Assigned(FOnPDFDocumentRenderingFinishedEventHandler) then begin

    Synchronize(RaiseOnPDFDocumentRenderingFinishedEventHandler);

  end;

  FWasPDFDocumentRendered := True;

end;

procedure TPDFDocumentRenderingThread.RenderDocumentAsFullPaged;
var CurrentRenderedPageNumber: Integer;
    DocumentPageStream: TMemoryStream;
begin

  for CurrentRenderedPageNumber := 1 to FPDFDocumentProcessor.PageCount do
  begin

      if RaiseOnCancellationEventHandlerIfWasRequested then Exit;

      FCurrentRenderedPageNumber := CurrentRenderedPageNumber;
      DocumentPageStream := TMemoryStream.Create;

      try

         FCurrentRenderedPageBitmap :=
          CreateBitmapOfGivenPDFDocumentPage(
            FPDFDocumentProcessor,
            DEFAULT_DOCUMENT_DPI,
            CurrentRenderedPageNumber
          );

        if RaiseOnCancellationEventHandlerIfWasRequested then Exit;

        with FRenderedPDFDocument as TFullPagedRenderedPDFDocument do
          Add(FCurrentRenderedPageBitmap);

        if Assigned(FOnPDFDocumentPageRenderFinishedEventHandler) then
          Synchronize(RaiseOnPDFDocumentPageRenderFinishedEventHandler);

      finally

        FreeAndNil(DocumentPageStream);

      end;

  end;

  FRenderedPDFDocument.CurrentPageBitmapNumber := 1;
  
end;

procedure TPDFDocumentRenderingThread.RenderDocumentAsSinglePaged;
begin

  FRenderedPDFDocument.CurrentPageBitmapNumber := 1;

  FCurrentRenderedPageNumber := 1;
  FCurrentRenderedPageBitmap := FRenderedPDFDocument.CurrentPageBitmap;

  if Assigned(FOnPDFDocumentPageRenderFinishedEventHandler) then
    Synchronize(RaiseOnPDFDocumentPageRenderFinishedEventHandler);

end;

procedure TPDFDocumentRenderingThread.UnloadDocument;
begin

  FPDFDocumentProcessor.UnloadCurrentDocument;
  
end;

procedure TPDFDocumentRenderingThread.UnloadDocumentIfOutputDocumentViewIsFullPaged;
begin

  if FOutputPDFDocumentView = dvFullPagedPDFDocument then
    UnloadDocument;
  
end;

{ TFullPagedRenderedPDFDocument }

procedure TFullPagedRenderedPDFDocument.Add(PageBitmap: TBitmap);
begin

  FPageBitmaps.Add(PageBitmap);

  FPageCount := FPageBitmaps.Count;
  
end;

constructor TFullPagedRenderedPDFDocument.Create;
begin

  inherited;

  FPageBitmaps := TList.Create;
  
end;

destructor TFullPagedRenderedPDFDocument.Destroy;
begin

  FreePageBitmaps;
  inherited;

end;

procedure TFullPagedRenderedPDFDocument.FreePageBitmaps;
var PageBitmap: TBitmap;
    I: Integer;
begin

  for I := 0 to FPageBitmaps.Count - 1 do begin

    PageBitmap := TBitmap(FPageBitmaps[I]);

    FreeAndNil(PageBitmap);

  end;

  FreeAndNil(FPageBitmaps);

end;

function TFullPagedRenderedPDFDocument.GetCurrentPageBitmap: TBitmap;
begin

  Result := TBitmap(FPageBitmaps[FCurrentPageBitmapNumber - 1]);

end;

function TFullPagedRenderedPDFDocument.InternalGetBitmapOfDocumentPageByCurrentPageNumber: TBitmap;
begin

  Result := CurrentPageBitmap;
  
end;

procedure TFullPagedRenderedPDFDocument.InternalSetCurrentPageBitmapNumber(
  const PageBitmapNumber: Integer);
begin

  FCurrentPageBitmapNumber := PageBitmapNumber;
  
end;

{ TRenderedPDFDocument }

constructor TRenderedPDFDocument.Create;
begin

  inherited;

  FCurrentScaleFactor := 1;
  FCurrentRotationAngleDegree := 0;
  
end;

function TRenderedPDFDocument.GetPageCount: Integer;
begin

  Result := FPageCount;

end;

function TRenderedPDFDocument.GoToNextPageBitmap: TBitmap;
begin

  if not IsNextPageExists then
    Result := nil

  else begin

    Inc(FCurrentPageBitmapNumber);

    Result := InternalGetBitmapOfDocumentPageByCurrentPageNumber;
    
  end;

end;

function TRenderedPDFDocument.GoToPreviousPageBitmap: TBitmap;
begin

  if not IsPreviousPageExists then
    Result := nil

  else begin

    Dec(FCurrentPageBitmapNumber);

    Result := InternalGetBitmapOfDocumentPageByCurrentPageNumber;
    
  end;
  
end;

function TRenderedPDFDocument.IsNextPageExists: Boolean;
begin

  Result := (FCurrentPageBitmapNumber + 1) <= FPageCount;

end;

function TRenderedPDFDocument.IsPageBitmapNumberValid(
  const PageBitmapNumber: Integer): Boolean;
begin

  Result := (PageBitmapNumber >= 1) and (PageBitmapNumber <= FPageCount);

end;

function TRenderedPDFDocument.IsPreviousPageExists: Boolean;
begin

  Result := (FCurrentPageBitmapNumber - 1) >= 1;
  
end;

procedure TRenderedPDFDocument.RaiseExceptionIfPageBitmapNumberNotValid(
  const PageBitmapNumber: Integer);
begin

  if not IsPageBitmapNumberValid(PageBitmapNumber) then
    raise TRenderedPDFDocumentPageNumberNotValidException.CreateFmt(
            'Страница с номером "%d" отсутствует !', [PageBitmapNumber]
          );

end;

procedure TRenderedPDFDocument.RotatePageBitmap(
  PageBitmap: TBitmap;
  const AngleDegree: Single
);
begin

  RotateBitmap(PageBitmap, AngleDegree);

end;

procedure TRenderedPDFDocument.SetCurrentPageBitmapNumber(
  const PageBitmapNumber: Integer);
begin

  RaiseExceptionIfPageBitmapNumberNotValid(PageBitmapNumber);

  if FCurrentPageBitmapNumber = PageBitmapNumber then Exit;
  
  InternalSetCurrentPageBitmapNumber(PageBitmapNumber);

end;

procedure TRenderedPDFDocument.SetDocumentRotationAngleDegree(
  const RotationAngleDegree: Single
);
begin

  if FCurrentRotationAngleDegree <> RotationAngleDegree then begin

    FCurrentRotationAngleDegree := RotationAngleDegree;

    InternalGetBitmapOfDocumentPageByCurrentPageNumber;
    
  end;

end;

procedure TRenderedPDFDocument.SetDocumentScaleFactor(
  const ScaleFactor: Double
);
begin

  if FCurrentScaleFactor <> ScaleFactor then begin

    FCurrentScaleFactor := ScaleFactor;

    InternalGetBitmapOfDocumentPageByCurrentPageNumber;
    
  end;

end;

{ TSinglePagedRenderedPDFDocument }

constructor TSinglePagedRenderedPDFDocument.Create(
  DocumentProcessor: IPDFDocumentProcessor);
begin

  inherited Create;

  FCurrentPageBitmap := TBitmap.Create;
  FDocumentProcessor := DocumentProcessor;
  FPageCount := FDocumentProcessor.PageCount;
    
end;

function TSinglePagedRenderedPDFDocument.
  InternalGetBitmapOfDocumentPageByCurrentPageNumber: TBitmap;
begin

  FreeAndNil(FCurrentPageBitmap);

  FCurrentPageBitmap :=
    CreateBitmapOfGivenPDFDocumentPage(
        FDocumentProcessor,
        DEFAULT_DOCUMENT_DPI * FCurrentScaleFactor,
        FCurrentPageBitmapNumber
      );

  RotatePageBitmap(FCurrentPageBitmap, FCurrentRotationAngleDegree);

  Result := FCurrentPageBitmap;
  
end;

procedure TSinglePagedRenderedPDFDocument.InternalSetCurrentPageBitmapNumber(
  const PageBitmapNumber: Integer);
begin
  
  FCurrentPageBitmapNumber := PageBitmapNumber;

  InternalGetBitmapOfDocumentPageByCurrentPageNumber;
  
end;

destructor TSinglePagedRenderedPDFDocument.Destroy;
begin

  FreeAndNil(FCurrentPageBitmap);
  inherited;

end;

function TSinglePagedRenderedPDFDocument.GetCurrentPageBitmap: TBitmap;
begin

  Result := FCurrentPageBitmap;

end;


end.
