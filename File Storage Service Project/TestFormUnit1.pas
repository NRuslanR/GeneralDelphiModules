unit TestFormUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm5 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure TestFileStorageService;
    
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses

  AuxSystemFunctionsUnit,
  AuxDebugFunctionsUnit,
  IFileStorageServiceClientUnit,
  DateUtils,
  StrUtils,
  LocalNetworkFileStorageServiceClientUnit;

{ TForm5 }

procedure TForm5.FormCreate(Sender: TObject);
begin

  TestFileStorageService;
  
end;

procedure TForm5.TestFileStorageService;
var FileStorageServiceClient: IFileStorageServiceClient;
    FilePath, RemoteFilePath, FileName: String;
    NewInnerFilePath: String;
    CurDate: TDateTime;
    PathBuilder: IPathBuilder;
begin
  
  FileStorageServiceClient :=
    TLocalNetworkFileStorageServiceClient.Create(
      '\\srv-doc\Doc_Oborot\umz_doc' { путь к базовой папке хранилища },
      'user_umz_doc' { пользователь },
      'L0r4vtyN' { пароль }
    );

  FileStorageServiceClient.Connect; // соединение с удаленным хранилищем

  { получить файл из удаленного хранилища }
  FileStorageServiceClient.GetFile('путь к файлу на удаленном хранилище');

  { отправить файла в удаленное хранилище }
  FileStorageServiceClient.PutFile(
    'путь к файлу на локальной машине',
    'путь к файла, по которому он должен ' +
    'находиться на удаленной машине'
  );

  { удалить файл из удаленного хранилища }
  FileStorageServiceClient.RemoveFile('путь к файла на удаленном хранилище');

  FileStorageServiceClient.Disconnect; // отключиться от хранилища

   { использование PathBuilder.
       Знает каким-образом построить пути хранения
       файлов на удаленном хранилище }

  PathBuilder := FileStorageServiceClient.PathBuilder;

  RemoteFilePath :=
    PathBuilder.
    AddPartOfPath(
      'Директория1'
    ).AddPartOfPath('Директория2').
    AddPartOfPath('Директория3').
    BuildPath;

  FileStorageServiceClient.GetFile(RemoteFilePath);
  
end;

end.
