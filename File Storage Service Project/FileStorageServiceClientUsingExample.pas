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