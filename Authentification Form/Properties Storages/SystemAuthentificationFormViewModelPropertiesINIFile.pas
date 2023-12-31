unit SystemAuthentificationFormViewModelPropertiesINIFile;

interface

uses

  SystemAuthentificationFormViewModel,
  AbstractSystemAuthentificationFormViewModelPropertiesStorage,
  PropertiesIniFileUnit,
  SysUtils,
  Classes;

const

  LOG_ON_INFO_SECTION_NAME = 'LogOnInfo';
  LOGIN_PROPERTY_NAME = 'Login';

type

  TSystemAuthentificationFormViewModelPropertiesINIFile =
    class (
      TAbstractSystemAuthentificationFormViewModelPropertiesStorage
    )

      protected

        FPropertiesINIFile: TPropertiesIniFile;

      protected

        procedure SaveSystemAuthentificationFormViewModelProperties(
          ViewModel: TSystemAuthentificationFormViewModel
        ); override;

        procedure RestoreSystemAuthentificationFormViewModelProperties(
          ViewModel: TSystemAuthentificationFormViewModel
        ); override;

      public

        destructor Destroy; override;

        constructor Create(const PropertiesINIFilePath: String);
        
    end;
    
implementation

{ TSystemAuthentificationFormViewModelPropertiesINIFile }

constructor TSystemAuthentificationFormViewModelPropertiesINIFile.Create(
  const PropertiesINIFilePath: String);
begin

  inherited Create;

  FPropertiesINIFile := TPropertiesIniFile.Create(PropertiesINIFilePath);
  
end;

destructor TSystemAuthentificationFormViewModelPropertiesINIFile.Destroy;
begin

  FreeAndNil(FPropertiesINIFile);
  
  inherited;

end;

procedure TSystemAuthentificationFormViewModelPropertiesINIFile.
  RestoreSystemAuthentificationFormViewModelProperties(
    ViewModel: TSystemAuthentificationFormViewModel
  );
begin

  inherited;

  FPropertiesINIFile.GoToSection(LOG_ON_INFO_SECTION_NAME);

  ViewModel.ClientLogin :=
    FPropertiesINIFile.ReadValueForProperty(LOGIN_PROPERTY_NAME, varString, '');
    
end;

procedure TSystemAuthentificationFormViewModelPropertiesINIFile.
  SaveSystemAuthentificationFormViewModelProperties(
    ViewModel: TSystemAuthentificationFormViewModel
  );
begin

  inherited;

  FPropertiesINIFile.GoToSection(LOG_ON_INFO_SECTION_NAME);

  FPropertiesINIFile.WriteValueForProperty(
    LOGIN_PROPERTY_NAME, ViewModel.ClientLogin
  );
  
end;

end.
