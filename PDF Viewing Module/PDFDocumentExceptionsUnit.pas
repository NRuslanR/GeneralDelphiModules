unit PDFDocumentExceptionsUnit;

interface

uses ExceptionWithInnerExceptionUnit;

type

  TPDFDocumentException =
    class abstract (TExceptionWithInnerException)

      public

    end;

  TPDFDocumentLoadingFailedException =
    class (TPDFDocumentException)

      public

    end;

implementation

end.
