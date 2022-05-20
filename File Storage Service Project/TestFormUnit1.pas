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
      '\\srv-doc\Doc_Oborot\umz_doc' { ���� � ������� ����� ��������� },
      'user_umz_doc' { ������������ },
      'L0r4vtyN' { ������ }
    );

  FileStorageServiceClient.Connect; // ���������� � ��������� ����������

  { �������� ���� �� ���������� ��������� }
  FileStorageServiceClient.GetFile('���� � ����� �� ��������� ���������');

  { ��������� ����� � ��������� ��������� }
  FileStorageServiceClient.PutFile(
    '���� � ����� �� ��������� ������',
    '���� � �����, �� �������� �� ������ ' +
    '���������� �� ��������� ������'
  );

  { ������� ���� �� ���������� ��������� }
  FileStorageServiceClient.RemoveFile('���� � ����� �� ��������� ���������');

  FileStorageServiceClient.Disconnect; // ����������� �� ���������

   { ������������� PathBuilder.
       ����� �����-������� ��������� ���� ��������
       ������ �� ��������� ��������� }

  PathBuilder := FileStorageServiceClient.PathBuilder;

  RemoteFilePath :=
    PathBuilder.
    AddPartOfPath(
      '����������1'
    ).AddPartOfPath('����������2').
    AddPartOfPath('����������3').
    BuildPath;

  FileStorageServiceClient.GetFile(RemoteFilePath);
  
end;

end.
