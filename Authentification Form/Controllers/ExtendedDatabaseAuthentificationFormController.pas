unit ExtendedDatabaseAuthentificationFormController;

interface

uses

  DatabaseAuthentificationFormController,
  ExtendedDatabaseAuthentificationFormViewModel,
  DatabaseAuthentificationFormViewModel,
  unExtendedDatabaseAuthentificationForm,
  SystemAuthentificationFormViewModel,
  AuthentificationData,
  ServiceInfo,
  Forms,
  SysUtils,
  Classes;

type

  TExtendedDatabaseAuthentificationFormController =
    class (TDatabaseAuthentificationFormController)

      protected

        procedure FillClientServiceAuthentificationDataFromViewModel(
          ClientServiceAuthentificationData:
            TClientServiceAuthentificationData;

          ViewModel: TSystemAuthentificationFormViewModel
        ); override;
        

        function
        UpdateDatabaseAuthentificationFormViewModelOnSuccessAuthentification(
          ViewModel: TDatabaseAuthentificationFormViewModel
        ): Boolean; override;

      protected

        function GetSystemAuthentificationFormViewModelClass:
          TSystemAuthentificationFormViewModelClass; override;

      protected

        function GetFormClass: TFormClass; override;
        
    end;
    
implementation

{ TExtendedDatabaseAuthentificationFormController }

procedure TExtendedDatabaseAuthentificationFormController.
  FillClientServiceAuthentificationDataFromViewModel(
    ClientServiceAuthentificationData: TClientServiceAuthentificationData;
    ViewModel: TSystemAuthentificationFormViewModel
  );
begin

  inherited;

  with
    ClientServiceAuthentificationData as
    TUserDatabaseServerAuthentificationData,
    ViewModel as TExtendedDatabaseAuthentificationFormViewModel
  do begin

    DatabaseServerInfo.Host := CurrentHost;
    DatabaseServerInfo.Port := Port;
    
  end;

end;

function TExtendedDatabaseAuthentificationFormController.
  GetFormClass: TFormClass;
begin

  Result := TExtendedDatabaseAuthentificationForm;

end;

function TExtendedDatabaseAuthentificationFormController.
  GetSystemAuthentificationFormViewModelClass:
    TSystemAuthentificationFormViewModelClass;
begin

  Result := TExtendedDatabaseAuthentificationFormViewModel;

end;

function TExtendedDatabaseAuthentificationFormController.
  UpdateDatabaseAuthentificationFormViewModelOnSuccessAuthentification(
    ViewModel: TDatabaseAuthentificationFormViewModel
  ): Boolean;
var IsAuthentificatingHostNew: Boolean;
begin

  Result :=
    inherited
    UpdateDatabaseAuthentificationFormViewModelOnSuccessAuthentification(
      ViewModel
    );

  with ViewModel as TExtendedDatabaseAuthentificationFormViewModel
  do begin

    IsAuthentificatingHostNew := Hosts.IndexOf(CurrentHost) = -1;

    Result := Result or IsAuthentificatingHostNew;

    if IsAuthentificatingHostNew then
      Hosts.Add(CurrentHost);
    
  end;

end;

end.
