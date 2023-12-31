unit SystemAdministrationFormViewModelMapper;

interface

uses

  SystemAdministrationFormViewModelMapperInterface,
  SystemAdministrationFormViewModel,
  SystemAdministrationPrivilegeSetHolder,
  SystemAdministrationPrivileges,
  SystemAdministrationPrivilegeViewModel,
  DB,
  SysUtils,
  Classes;

type

  TSystemAdministrationFormViewModelMapper =
    class (TInterfacedObject, ISystemAdministrationFormViewModelMapper)

      protected

        function GetSystemAdministrationFormViewModelClass: TSystemAdministrationFormViewModelClass; virtual;

        function CreateSystemAdministrationPrivilegeDataSet(
          FieldDefs: TSystemAdministrationPrivilegeSetFieldDefs
        ): TDataSet; virtual;

        function GetSystemAdministrationPrivilegeSetHolderClass: TSystemAdministrationPrivilegeSetHolderClass; virtual;

        function GetSystemAdministrationPrivilegeSetFieldDefsClass: TSystemAdministrationPrivilegeSetFieldDefsClass; virtual;

        procedure InitializeSystemAdministrationPrivilegeSetFieldDefs(
          FieldDefs: TSystemAdministrationPrivilegeSetFieldDefs
        ); virtual;
        
        procedure FillSystemAdministrationFormViewModelFrom(
          ViewModel: TSystemAdministrationFormViewModel;
          SystemAdministrationPrivileges: TSystemAdministrationPrivileges
        ); virtual;

        function CreateSystemAdministrationPrivilegeViewModelFrom(
          SystemAdministrationPrivilege: TSystemAdministrationPrivilege
        ): TSystemAdministrationPrivilegeViewModel; virtual;

        function GetSystemAdministrationPrivilegeViewModelClass:
          TSystemAdministrationPrivilegeViewModelClass; virtual;

        procedure FillSystemAdministrationPrivilegeViewModelFrom(
          PrivilegeViewModel: TSystemAdministrationPrivilegeViewModel;
          SystemAdministrationPrivilege: TSystemAdministrationPrivilege
        ); virtual;
          
      public

        function MapSystemAdministrationFormViewModelFrom(
          SystemAdministrationPrivileges: TSystemAdministrationPrivileges
        ): TSystemAdministrationFormViewModel; virtual;
        
    end;


implementation

uses

  DBClient;
  
{ TSystemAdministrationFormViewModelMapper }

function TSystemAdministrationFormViewModelMapper.
  MapSystemAdministrationFormViewModelFrom(
    SystemAdministrationPrivileges: TSystemAdministrationPrivileges
  ): TSystemAdministrationFormViewModel;
var SystemAdministrationPrivilegeSetFieldDefs: TSystemAdministrationPrivilegeSetFieldDefs;
    SystemAdministrationPrivilegeDataSet: TDataSet;
begin

  Result := GetSystemAdministrationFormViewModelClass.Create;

  try

    SystemAdministrationPrivilegeSetFieldDefs :=
      GetSystemAdministrationPrivilegeSetFieldDefsClass.Create;

    InitializeSystemAdministrationPrivilegeSetFieldDefs(
      SystemAdministrationPrivilegeSetFieldDefs
    );

    SystemAdministrationPrivilegeDataSet :=
      CreateSystemAdministrationPrivilegeDataSet(
        SystemAdministrationPrivilegeSetFieldDefs
      );

    Result.SystemAdministrationPrivilegeSetHolder :=
      GetSystemAdministrationPrivilegeSetHolderClass.CreateFrom(
        SystemAdministrationPrivilegeDataSet
      );

    Result.SystemAdministrationPrivilegeSetHolder.FieldDefs :=
      SystemAdministrationPrivilegeSetFieldDefs;
      
    FillSystemAdministrationFormViewModelFrom(Result, SystemAdministrationPrivileges);
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;

    end;

  end;

end;

function TSystemAdministrationFormViewModelMapper.GetSystemAdministrationFormViewModelClass: TSystemAdministrationFormViewModelClass;
begin

  Result := TSystemAdministrationFormViewModel;
  
end;

function TSystemAdministrationFormViewModelMapper.GetSystemAdministrationPrivilegeSetFieldDefsClass: TSystemAdministrationPrivilegeSetFieldDefsClass;
begin

  Result := TSystemAdministrationPrivilegeSetFieldDefs;
  
end;

function TSystemAdministrationFormViewModelMapper.GetSystemAdministrationPrivilegeSetHolderClass: TSystemAdministrationPrivilegeSetHolderClass;
begin

  Result := TSystemAdministrationPrivilegeSetHolder;
  
end;

procedure TSystemAdministrationFormViewModelMapper.InitializeSystemAdministrationPrivilegeSetFieldDefs(
  FieldDefs: TSystemAdministrationPrivilegeSetFieldDefs);
begin

  with FieldDefs do begin

    PrivilegeIdFieldName := 'privilege_id';
    TopLevelPrivilegeIdFieldName := 'top_level_privilege_id';
    PrivilegeNameFieldName := 'privilege_name';
    MustBeContentFieldName := 'must_be_content';

  end;

end;

function TSystemAdministrationFormViewModelMapper.
  CreateSystemAdministrationPrivilegeDataSet(
    FieldDefs: TSystemAdministrationPrivilegeSetFieldDefs
  ): TDataSet;
var ClientDataSet: TClientDataSet;
begin

  ClientDataSet := TClientDataSet.Create(nil);

  try

    ClientDataSet.FieldDefs.Add(FieldDefs.PrivilegeIdFieldName, ftInteger);
    ClientDataSet.FieldDefs.Add(FieldDefs.TopLevelPrivilegeIdFieldName, ftInteger);
    ClientDataSet.FieldDefs.Add(FieldDefs.PrivilegeNameFieldName, ftString, 300);
    ClientDataSet.FieldDefs.Add(FieldDefs.MustBeContentFieldName, ftBoolean);

    ClientDataSet.CreateDataSet;

    ClientDataSet.Open;
    
    Result := ClientDataSet;

  except

    on e: Exception do begin

      FreeAndNil(ClientDataSet);

      raise;
      
    end;

  end;

end;

procedure TSystemAdministrationFormViewModelMapper.
  FillSystemAdministrationFormViewModelFrom(
    ViewModel: TSystemAdministrationFormViewModel;
    SystemAdministrationPrivileges: TSystemAdministrationPrivileges
  );
var SystemAdministrationPrivilege: TSystemAdministrationPrivilege;
    SystemAdministrationPrivilegeViewModel: TSystemAdministrationPrivilegeViewModel;
begin

  for SystemAdministrationPrivilege in SystemAdministrationPrivileges do begin

    SystemAdministrationPrivilegeViewModel :=
      CreateSystemAdministrationPrivilegeViewModelFrom(
        SystemAdministrationPrivilege
      );
      
    ViewModel.AddSection(SystemAdministrationPrivilegeViewModel);
    
  end;

end;

function TSystemAdministrationFormViewModelMapper.
  CreateSystemAdministrationPrivilegeViewModelFrom(
    SystemAdministrationPrivilege: TSystemAdministrationPrivilege
  ): TSystemAdministrationPrivilegeViewModel;
begin

  Result := GetSystemAdministrationPrivilegeViewModelClass.Create;

  try

    FillSystemAdministrationPrivilegeViewModelFrom(
      Result, SystemAdministrationPrivilege
    );
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function TSystemAdministrationFormViewModelMapper.GetSystemAdministrationPrivilegeViewModelClass: TSystemAdministrationPrivilegeViewModelClass;
begin

  Result := TSystemAdministrationPrivilegeViewModel;

end;

procedure TSystemAdministrationFormViewModelMapper.
  FillSystemAdministrationPrivilegeViewModelFrom(
    PrivilegeViewModel: TSystemAdministrationPrivilegeViewModel;
    SystemAdministrationPrivilege: TSystemAdministrationPrivilege
  );
begin

  PrivilegeViewModel.PrivilegeId := SystemAdministrationPrivilege.Identity;
  PrivilegeViewModel.TopLevelPrivilegeId := SystemAdministrationPrivilege.TopLevelPrivilegeIdentity;
  PrivilegeViewModel.PrivilegeName := SystemAdministrationPrivilege.Name;
  PrivilegeViewModel.MustBeContent := SystemAdministrationPrivilege.HasServices;
  
end;

end.
