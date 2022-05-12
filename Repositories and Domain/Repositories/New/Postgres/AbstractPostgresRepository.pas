unit AbstractPostgresRepository;

interface

uses

  AbstractRepository,
  AbstractDBRepository,
  TableColumnMappings,
  DBTableMapping,
  QueryExecutor,
  DomainObjectUnit,
  DomainObjectListUnit;

type

  TAbstractPostgresRepository = class abstract (TAbstractDBRepository)

    protected

      function CreateDBTableMapping: TDBTableMapping; override;

      procedure PrepareUpdateDomainObjectListQuery(
        DomainObjectList: TDomainObjectList;
        var QueryPattern: String;
        var QueryParams: TQueryParams
      ); override;
      
      function GetCustomTrailingInsertQueryTextPart: String; override;
      function GetCustomTrailingUpdateQueryTextPart: String; override;

  end;

implementation

uses

  SysUtils,
  Variants,
  StrUtils,
  PostgresTableMapping;

{ TAbstractPostgresRepository }

procedure TAbstractPostgresRepository.PrepareUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var DomainObjectColumnNameList: String;
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

  QueryPattern :=
    Format(
      'UPDATE %s SET %s ' +
      'FROM (VALUES %s) as t2(%s) ' +
      'WHERE %s',
      [
        TableMapping.TableName,
        TableMapping.GetUpdateListForMultipleUpdates('t2'),
        VALUESRowsLayout,
        DomainObjectColumnNameList,
        CreateIdentityColumnComparisonList(TableMapping.TableName, 't2')
      ]
    ) + ' ' + GetCustomTrailingUpdateQueryTextPart;

  QueryParams := nil;

end;

function TAbstractPostgresRepository.CreateDBTableMapping: TDBTableMapping;
begin

  Result := TPostgresTableMapping.Create;
  
end;

function TAbstractPostgresRepository.GetCustomTrailingInsertQueryTextPart: String;
begin

  Result :=
    IfThen(
      ReturnIdOfDomainObjectAfterAdding,
      'RETURNING ' + FDBTableMapping.GetUniqueObjectColumnCommaSeparatedList(UseFullyQualifiedColumnNaming),
      inherited GetCustomTrailingInsertQueryTextPart
    );

end;

function TAbstractPostgresRepository.GetCustomTrailingUpdateQueryTextPart: String;
begin

  Result :=
    IfThen(
      ReturnIdOfDomainObjectAfterUpdate,
      'RETURNING ' + FDBTableMapping.GetUniqueObjectColumnCommaSeparatedList(UseFullyQualifiedColumnNaming),
      inherited GetCustomTrailingUpdateQueryTextPart
    );

end;

end.
