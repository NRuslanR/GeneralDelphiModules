unit FoxitPDFDocumentProcessorUnit;

interface

uses IPDFDocumentProcessorUnit,
     SysUtils,
     DebenuPDFLibrary1411,
     Classes,
     Windows;

type

  TFoxitPDFLibraryInitializationFailedException = class (Exception)

  end;

  TFoxitPDFDocumentLoadingFailedException = class (Exception)

  end;

  TFoxitPDFDocumentProcessor = class (TInterfacedObject,
                                      IPDFDocumentProcessor)

    strict private

      FSelectedDocumentPath: String;
      FFoxitPDFLibrary: TDebenuPDFLibrary1411;

      procedure Initialize;

    public

      destructor Destroy; override;

      constructor Create;

      procedure LoadFromFile(const FilePath: String);

      function GetPageWidth: Double;
      function GetPageHeight: Double;

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

      function GetSelectedDocumentPath: String;

  end;
  
implementation

uses Variants;

{ TFoxitPDFDocumentProcessor }

constructor TFoxitPDFDocumentProcessor.Create;
begin

  Initialize;

end;

destructor TFoxitPDFDocumentProcessor.Destroy;
begin

  UnloadCurrentDocument;
  FreeAndNil(FFoxitPDFLibrary);

  inherited;

end;

procedure TFoxitPDFDocumentProcessor.Initialize;
var IsFoxitInitializationSuccess: Boolean;
begin

   FFoxitPDFLibrary := TDebenuPDFLibrary1411.Create;

   IsFoxitInitializationSuccess:=
    FFoxitPDFLibrary.UnlockKey('ja3ga3fn8b67th8uy3f74st7y') = 1;

   if not IsFoxitInitializationSuccess then
      raise TFoxitPDFLibraryInitializationFailedException.Create(
        'Не удалось инициализировать библиотеку Debenu Foxit !'
      );

end;

procedure TFoxitPDFDocumentProcessor.LoadFromFile(
  const FilePath: String);
var IsPDFDocumentLoadingSuccess: Boolean;
begin

  IsPDFDocumentLoadingSuccess := FFoxitPDFLibrary.LoadFromFile(FilePath, '') = 1;

  if not IsPDFDocumentLoadingSuccess then
    raise TFoxitPDFDocumentLoadingFailedException.CreateFmt(
      'Не удалось загрузить документ "%s": Ошибка %d!', [FilePath, FFoxitPDFLibrary.LastErrorCode]
    );

  FSelectedDocumentPath := FilePath;
  
end;

procedure TFoxitPDFDocumentProcessor.RenderPageToDC(const DPI: Double;
  const PageNumber: Integer; DeviceContext: HDC);
begin


  FFoxitPDFLibrary.RenderPageToDC(
    DPI, PageNumber, DeviceContext
  );
  
end;

procedure TFoxitPDFDocumentProcessor.RenderPageToStream(
  const DPI: Double;
  const PageNumber: Integer;
  const Options: Integer;
  Stream: TStream
);
begin

  FFoxitPDFLibrary.RenderPageToStream(DPI, PageNumber, Options, Stream);

end;

function TFoxitPDFDocumentProcessor.SelectDocument(
  const DocumentId: Variant): Variant;
begin

  Result := FFoxitPDFLibrary.SelectDocument(DocumentId);

end;

procedure TFoxitPDFDocumentProcessor.UnloadCurrentDocument;
begin
  
  UnloadDocument(FFoxitPDFLibrary.SelectedDocument);

end;

procedure TFoxitPDFDocumentProcessor.UnloadDocument(const DocumentId: Variant);
begin

  if DocumentId = 0 then Exit;
  
  if FFoxitPDFLibrary.RemoveDocument(DocumentId) = 0 then
    raise Exception.CreateFmt(
            'Не удалось выгрузить содержимое документа с ' +
            'идентификатором %s из памяти', [VarToStr(DocumentId)]
          );

end;

function TFoxitPDFDocumentProcessor.GetPageCount: Integer;
begin

  Result := FFoxitPDFLibrary.PageCount;
  
end;

function TFoxitPDFDocumentProcessor.GetPageHeight: Double;
begin

  Result := FFoxitPDFLibrary.PageHeight;

end;

function TFoxitPDFDocumentProcessor.GetPageWidth: Double;
begin

  Result := FFoxitPDFLibrary.PageWidth;
  
end;

function TFoxitPDFDocumentProcessor.GetSelectedDocumentId: Variant;
begin

  Result := FFoxitPDFLibrary.SelectedDocument;

  if Result = 0 then
    Result := Null;
  
end;

function TFoxitPDFDocumentProcessor.GetSelectedDocumentPath: String;
begin

  Result := FSelectedDocumentPath;
  
end;

end.
