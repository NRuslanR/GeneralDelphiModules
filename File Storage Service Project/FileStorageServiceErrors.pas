unit FileStorageServiceErrors;

interface

uses

  SysUtils;

type

  TFileStorageServiceException = class (Exception)

    private

      FErrorCode: Cardinal;
      
    public

      constructor Create(
        const ErrorCode: Cardinal;
        const Msg: String
      );

      property ErrorCode: Cardinal read FErrorCode;
      
  end;

  TFileNotFoundException = class (TFileStorageServiceException)

    public

      constructor Create(
        const ErrorCode: Cardinal;
        const FileName, FilePath: String
      );
      
  end;

  TFileSharingViolationException = class (TFileStorageServiceException)

    public

      constructor Create(
        const ErrorCode: Cardinal;
        const FileName, FilePath: String
      );

  end;

implementation

{ TFileNotFoundException }

constructor TFileNotFoundException.Create(
  const ErrorCode: Cardinal;
  const FileName, FilePath: String
);
begin

  inherited Create(
    ErrorCode,
    Format(
      'Файл "%s" по пути "%s" отсутствует"',
      [FileName, FilePath]
    )
  );
  
end;

{ TFileStorageServiceException }

constructor TFileStorageServiceException.Create(
  const ErrorCode: Cardinal;
  const Msg: String
);
begin

  inherited Create(Msg);

  FErrorCode := ErrorCode;
  
end;

{ TFileSharingViolationException }

constructor TFileSharingViolationException.Create(const ErrorCode: Cardinal;
  const FileName, FilePath: String);
begin

  inherited Create(
    ErrorCode,
    Format(
      'Попытка одновременного доступа к файлу "%s" по пути "%s"',
      [
        FileName,
        FilePath
      ]
    )
  );
  
end;

end.
