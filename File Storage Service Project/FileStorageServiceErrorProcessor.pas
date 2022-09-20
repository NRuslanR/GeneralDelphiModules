unit FileStorageServiceErrorProcessor;

interface

uses

  SysUtils;

type

  TFileStorageServiceErrorData = record

    ErrorCode: Cardinal;
    FileName: String;
    FilePath: String;
    ErrorMessage: String;

    constructor Create(
      const ErrorCode: Cardinal;
      const FileName: String;
      const FilePath: String;
      const ErrorMessage: String = ''
    );

  end;

  IFileStorageServiceErrorProcessor = interface

    procedure RaiseExceptionByErrorData(ErrorData: TFileStorageServiceErrorData);
    
  end;
  
implementation

{ TFileStorageServiceErrorData }

constructor TFileStorageServiceErrorData.Create(
  const ErrorCode: Cardinal;
  const FileName, FilePath: String;
  const ErrorMessage: String
);
begin

  Self.ErrorCode := ErrorCode;
  Self.FileName := FileName;
  Self.FilePath := FilePath;
  Self.ErrorMessage := ErrorMessage;
  
end;

end.
