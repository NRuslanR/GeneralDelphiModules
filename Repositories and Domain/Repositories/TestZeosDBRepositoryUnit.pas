unit TestZeosDBRepositoryUnit;

interface

uses AbstractZeosDBRepositoryUnit, DomainObjectUnit,
     AbstractRepositoryCriteriaUnit, Classes;

type

  TMeasurementType = class (TDomainObject)

    private

      FName: String;

    public

      property Name: String read FName write FName;

  end;

  TTestZeosDBRepository = class (TAbstractZeosDBRepository)

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

implementation

uses AuxZeosFunctions;

{ TTestZeosDBRepository }

constructor TTestZeosDBRepository.Create(Connection: TComponent);
begin

  inherited;

  FIsAddingTransactional := False;
  FIsUpdatingTransactional := False;
  FIsRemovingTransactional := False;
  
end;

constructor TTestZeosDBRepository.Create;
begin

  inherited;

  FIsAddingTransactional := False;
  FIsUpdatingTransactional := False;
  FIsRemovingTransactional := False;
  
end;

function TTestZeosDBRepository.CreateDomainObject: TDomainObject;
begin

  Result := TMeasurementType.Create;

end;

procedure TTestZeosDBRepository.FillDomainObjectFromDataHolder(
  DomainObject: TDomainObject;
  DataHolder: TObject
);
begin

  with DomainObject as TMeasurementType do begin

    Identity := FOperationalQuery.FieldByName('id').AsVariant;
    Name := FOperationalQuery.FieldByName('name').AsString;
    
  end;

end;

procedure TTestZeosDBRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TMeasurementType do begin

    InitQuery(FOperationalQuery,
      'insert into omo.measurement_types (name) values (:pname)',
      ['pname'],
      [Name]
    );

  end;

end;

procedure TTestZeosDBRepository.PrepareFindDomainObjectByIdentityQuery(
  Identity: Variant);
begin

  begin

    InitQuery(FOperationalQuery,
      'select * from omo.measurement_types where id = :pid',
      ['pid'],
      [Identity]
    );

  end;

end;

procedure TTestZeosDBRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion);
begin

  begin

    InitQuery(FOperationalQuery,
      'select * from omo.measurement_types where ' + Criteria.Expression,
      [], []
    );

  end;

end;

procedure TTestZeosDBRepository.PrepareLoadAllDomainObjectsQuery;
begin

  begin

    InitQuery(FOperationalQuery,
      'select * from omo.measurement_types',
      [],
      []
    );

  end;

end;

procedure TTestZeosDBRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TMeasurementType do begin

    InitQuery(FOperationalQuery,
      'delete from omo.measurement_types where id = :pid',
      ['pid'],
      [Identity]
    );

  end;

end;

procedure TTestZeosDBRepository.PrepareUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  with DomainObject as TMeasurementType do begin

    InitQuery(FOperationalQuery,
      'update omo.measurement_types set name = :pname where id = :pid',
      ['pname', 'pid'],
      [Name, Identity]
    );

  end;

end;

end.
