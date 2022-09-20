unit WindowsFileStorageServiceErrorProcessor;

interface

uses

  FileStorageServiceErrors,
  FileStorageServiceErrorProcessor,
  SysUtils;

type

  TWindowsFileStorageServiceErrorProcessor =
    class (TInterfacedObject, IFileStorageServiceErrorProcessor)

      public

        procedure RaiseExceptionByErrorData(ErrorData: TFileStorageServiceErrorData);

    end;

implementation

uses

  StrUtils,
  Windows;

{ TWindowsFileStorageServiceErrorProcessor }

procedure TWindowsFileStorageServiceErrorProcessor.RaiseExceptionByErrorData(
  ErrorData: TFileStorageServiceErrorData);
begin

  with ErrorData do begin

    case ErrorCode of

      ERROR_FILE_NOT_FOUND, ERROR_FILE_INVALID:
      begin

        Raise TFileNotFoundException.Create(
          ErrorCode,
          FileName,
          FilePath
        );

      end;

      ERROR_SHARING_VIOLATION:
      begin

        Raise TFileSharingViolationException.Create(
          ErrorCode,
          FileName,
          FilePath
        );
        
      end

      else begin

        Raise TFileStorageServiceException.Create(
          ErrorCode,
          IfThen(
            Trim(ErrorMessage) <> '',
            ErrorMessage,
            Format(
              'Во время сеанса работы с файловым хранилищем ' +
              'возникла ошибка %d',
              [
                ErrorCode
              ]
            )
          )
        );
        
      end;

    end;

  end;

end;

end.
