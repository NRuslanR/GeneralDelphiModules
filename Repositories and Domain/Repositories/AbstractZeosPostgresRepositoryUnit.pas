{ refactor: перенести некоторые методы в родительские классы,
  и для родительских сделать тоже самое }
unit AbstractZeosPostgresRepositoryUnit;

interface

uses

  AbstractRepositoryUnit,
  AbstractZeosDBRepositoryUnit,
  TableColumnMappingsUnit,
  DBTableMappingUnit,
  DomainObjectUnit,
  DomainObjectListUnit;

type

  TAbstractZeosPostgresRepository = class abstract (TAbstractZeosDBRepository)

    protected

      procedure Initialize; override;

      function CreateDBTableMapping: TDBTableMapping; override;

      procedure PrepareUpdateDomainObjectListQuery(
        DomainObjectList: TDomainObjectList
      ); override;
      
      function GetCustomTrailingInsertQueryTextPart: String; override;

      procedure RaiseExceptionFromLastErrorIfItBackEndFailure;


  end;

implementation

uses

  SysUtils,
  Variants,
  AbstractDBRepositoryUnit,
  PostgresTableMapping;

{ TAbstractZeosPostgresRepository }

procedure TAbstractZeosPostgresRepository.Initialize;
begin

  inherited;

  DomainObjectInvariantsComplianceEnabled := False;

end;


procedure TAbstractZeosPostgresRepository.PrepareUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
var QueryText: String;
    DomainObjectColumnNameList: String;
    VALUESRowsLayout: String;
    TableMapping: TPostgresTableMapping;

    function CreateIdentityColumnComparisonList(
      const FirstTableName, SecondTableName: String
    ): String;
    var ColumnMapping: TTableColumnMapping;
        IdentityColumnComparisonString: String;
    begin

      Result := '';

      for ColumnMapping in FDBTableMapping.PrimaryKeyColumnMappings do
      begin

        IdentityColumnComparisonString :=
          FirstTableName + '.' + ColumnMapping.ColumnName +
          '=' +
          SecondTableName + '.' + ColumnMapping.ColumnName;

        if Result = '' then
          Result := IdentityColumnComparisonString

        else Result := Result + ' AND ' + IdentityColumnComparisonString;
        
      end;

    end;

begin

  DomainObjectColumnNameList :=
    FDBTableMapping.GetUniqueObjectColumnCommaSeparatedList(
      UseNonQualifiedColumnNaming
     ) + ',' +
    FDBTableMapping.GetModificationColumnCommaSeparatedList;

  VALUESRowsLayout :=
    CreateVALUESRowsLayoutStringFromDomainObjectList(
      DomainObjectList, UsePrimaryKeyColumns
    );

  TableMapping := FDBTableMapping as TPostgresTableMapping;
  
  QueryText :=
    Format(
      'UPDATE %s as t1 SET %s ' +
      'FROM (VALUES %s) as t2(%s) ' +
      'WHERE %s',
      [
        TableMapping.TableName,
        TableMapping.GetUpdateListForMultipleUpdates('t2'),
        VALUESRowsLayout,
        DomainObjectColumnNameList,
        CreateIdentityColumnComparisonList('t1', 't2')
      ]
    ) + ' ' + GetCustomTrailingUpdateQueryTextPart;

  FOperationalQuery.SQL.Text := QueryText;

end;

procedure TAbstractZeosPostgresRepository.RaiseExceptionFromLastErrorIfItBackEndFailure;
begin

  if HasError and (LastError.ErrorMessage <> '') then
    raise Exception.Create(LastError.ErrorMessage);
  
end;

function TAbstractZeosPostgresRepository.CreateDBTableMapping: TDBTableMapping;
begin

  Result := TPostgresTableMapping.Create;
  
end;

function TAbstractZeosPostgresRepository.GetCustomTrailingInsertQueryTextPart: String;
begin

  if not FReturnSurrogateIdOfDomainObjectAfterAdding then begin

    Result := inherited GetCustomTrailingInsertQueryTextPart;
    Exit;

  end;

  Result := 'RETURNING ' +
            FDBTableMapping.GetUniqueObjectColumnCommaSeparatedList(
              UseFullyQualifiedColumnNaming
            );

end;

end.
