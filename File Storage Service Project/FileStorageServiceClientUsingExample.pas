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