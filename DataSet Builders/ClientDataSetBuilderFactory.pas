unit ClientDataSetBuilderFactory;

interface

uses

  DataSetBuilder,
  DataSetBuilderFactory;

type

  TClientDataSetBuilderFactory = class (TAbstractDataSetBuilderFactory)

    public

      function CreateDataSetBuilder: IDataSetBuilder; override;
      
  end;

implementation

uses

  ClientDataSetBuilder;

{ TClientDataSetBuilderFactory }

function TClientDataSetBuilderFactory.CreateDataSetBuilder: IDataSetBuilder;
begin

  Result := TClientDataSetBuilder.Create;
  
end;

end.
