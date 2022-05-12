unit TestPostgresMeansRepositoryUnit;

interface

uses AbstractZeosDBRepositoryUnit, DomainObjectUnit, DomainObjectListUnit,
     AbstractRepositoryCriteriaUnit, Classes;

type

  TDevice = class (TDomainObject)

    Name: String;

  end;

  TMean = class (TDevice)

    Range: String;

    function ToString: string;

  end;

  TControl = class (TDevice)

    ControlType: String;

  end;

  TDeviceRepository = class (TAbstractZeosDBRepository)

    protected

      procedure PrepareAddDomainObjectQuery(
            DomainObject: TDomainObject
        ); override;

      procedure PrepareUpdateDomainObjectQuery(
          DomainObject: TDomainObject
      ); override;

      procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject
      ); override;

      procedure PrepareFindDomainObjectByIdentityQuery(
          Identity: Variant
      ); override;

      procedure PrepareLoadAllDomainObjectsQuery; override;

      procedure PrepareFindDomainObjectsByCriteria(
        Criteria: TAbstractRepositoryCriterion
      ); override;

      function CreateDomainObject: TDomainObject; override;
      procedure FillDomainObjectFromDataHolder(
        DomainObject: TDomainObject;
        DataHolder: TObject
      ); override;
      
    public

      constructor Create; overload;
      constructor Create(Connection: TComponent); overload;

  end;

  TMeanRepository = class (TAbstractZeosDBRepository)

    protected

      procedure PrepareAddDomainObjectQuery(
            DomainObject: TDomainObject
        ); override;

      procedure PrepareUpdateDomainObjectQuery(
          DomainObject: TDomainObject
      ); override;

      procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject
      ); override;

      procedure PrepareFindDomainObjectByIdentityQuery(
          Identity: Variant
      ); override;

      procedure PrepareLoadAllDomainObjectsQuery; override;

      procedure PrepareFindDomainObjectsByCriteria(
        Criteria: TAbstractRepositoryCriterion
      ); override;

      function CreateDomainObject: TDomainObject; override;
      procedure FillDomainObjectFromDataHolder(
        DomainObject: TDomainObject;
        DataHolder: TObject
      ); override;
      
    public

      constructor Create; overload;
      constructor Create(Connection: TComponent;
        DeviceRep: TAbstractZeosDBRepository); overload;

  end;

implementation

uses AuxZeosFunctions, ZDataset, SysUtils, Variants;

{ TDeviceRepository }

constructor TDeviceRepository.Create;
begin

  inherited;
  
end;

constructor TDeviceRepository.Create(Connection: TComponent);
begin

  inherited;

end;

function TDeviceRepository.CreateDomainObject: TDomainObject;
begin

  Result := TDevice.Create;

end;

procedure TDeviceRepository.FillDomainObjectFromDataHolder(
  DomainObject: TDomainObject;
  DataHolder: TObject
);
begin

  inherited;

  with DomainObject as TDevice, DataHolder as TZQuery do begin

    Identity := FieldByName('id').AsInteger;
    TDevice(DomainObject).Name := FieldByName('name').AsString;

  end;

end;

procedure TDeviceRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TDevice do begin

    InitQuery(
      FOperationalQuery,
      'insert into omo.devices (id, name) values (:pid, :pname)',
      ['pid', 'pname'], [Identity, Name]
    );
    
  end;

end;

procedure TDeviceRepository.PrepareFindDomainObjectByIdentityQuery(
  Identity: Variant);
begin

  begin

    InitQuery(
      FOperationalQuery,
      'select * from omo.devices where id = :pid',
      ['pid'], [Identity]
    );

  end;

end;

procedure TDeviceRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion);
begin

  inherited;

end;

procedure TDeviceRepository.PrepareLoadAllDomainObjectsQuery;
begin

  inherited;

end;

procedure TDeviceRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TDevice do begin
  InitQuery(
      FOperationalQuery,
      'delete from omo.devices where id = :pid',
      ['pid'], [Identity]
    );
  end;

end;

procedure TDeviceRepository.PrepareUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TDevice do begin
  InitQuery(
      FOperationalQuery,
      'update omo.devices set name = :pname where id = :pid',
      ['pname', 'pid'], [Name, Identity]
    );
  end;

end;

{ TMeanRepository }

constructor TMeanRepository.Create;
begin

  inherited;

  FIsAddingTransactional := True;
  FIsUpdatingTransactional := True;
  FIsRemovingTransactional := True;

end;

constructor TMeanRepository.Create(
  Connection: TComponent; DeviceRep:
  TAbstractZeosDBRepository
);
begin

  inherited;

  FIsAddingTransactional := True;
  FIsUpdatingTransactional := True;
  FIsRemovingTransactional := True;
  
end;

function TMeanRepository.CreateDomainObject: TDomainObject;
begin

  Result := TMean.Create;

end;

procedure TMeanRepository.FillDomainObjectFromDataHolder(
  DomainObject: TDomainObject;
  DataHolder: TObject
);
begin

  inherited;
  
  with DomainObject as TMean, DataHolder as TZQuery do begin

    Range := FieldByName('range').AsString;
    
  end;

end;

procedure TMeanRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TMean do begin

    InitQuery(
      FOperationalQuery,
      'insert into omo.means (id, range) values (:pid, :prange)',
      ['pid', 'prange'], [Identity, Range]);

  end;

end;

procedure TMeanRepository.PrepareFindDomainObjectByIdentityQuery(
  Identity: Variant);
begin

  begin

    InitQuery(
      FOperationalQuery,
      'select b.id, b.name, a.range from omo.means a ' +
      'join omo.devices b on a.id = b.id ' +
      'where a.id = :pid', ['pid'], [Identity]
    );

  end;

end;

procedure TMeanRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion);
begin

  begin

    InitQuery(
      FOperationalQuery,
      'select omo.devices.id, omo.devices.name, omo.means.range from omo.means ' +
      'join omo.devices on omo.devices.id = omo.means.id ' +
      'where ' + Criteria.Expression,[],[]
    );

  end;

end;

procedure TMeanRepository.PrepareLoadAllDomainObjectsQuery;
begin

  begin

    InitQuery(
      FOperationalQuery,
      'select b.id, b.name, a.range from omo.means a ' +
      'join omo.devices b on a.id = b.id ', [],[]
    );

  end;

end;

procedure TMeanRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TMean do begin

    InitQuery(
      FOperationalQuery,
      'delete from omo.means where id = :pid',
      ['pid'], [Identity]
    );
    
  end;

end;

procedure TMeanRepository.PrepareUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TMean do begin

    InitQuery(
      FOperationalQuery,
      'update omo.means set range = :prange where id = :pid',
      ['prange', 'pid'], [Range, Identity]
    );
    
  end;

end;

{ TMean }

function TMean.ToString: string;
begin

  Result := Format('[%s, %s, %s]', [VarToStr(Identity), Name, Range]);

end;

end.
