unit DataSetQueryExecutor;

interface

uses

  AbstractQueryExecutor,
  DB,
  QueryExecutor,
  SysUtils,
  Classes;

type

  TDataSetQueryExecutor = class (TAbstractQueryExecutor)

    public

      function PrepareDataSet(
        const QueryPattern: String;
        QueryParams: TQueryParams = nil
      ): TDataSet; virtual; abstract;

  end;

implementation

end.
