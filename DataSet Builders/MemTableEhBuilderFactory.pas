unit MemTableEhBuilderFactory;

interface

uses

  DataSetBuilder,
  DataSetBuilderFactory;

type

  TMemTableEhBuilderFactory = class (TAbstractDataSetBuilderFactory)

    public

      function CreateDataSetBuilder: IDataSetBuilder; override;

  end;

implementation

uses

  MemTableEhBuilder;
  
{ TMemTableEhBuilderFactory }

function TMemTableEhBuilderFactory.CreateDataSetBuilder: IDataSetBuilder;
begin

  Result := TMemTableEhBuilder.Create;

end;

end.
