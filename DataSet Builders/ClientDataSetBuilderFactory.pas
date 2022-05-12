unit ClientDataSetBuilderFactory;

interface

uses

  DataSetBuilder,
  DataSetBuilderFactory;

type

  TClientDataSetBuilderFactory = class (TInterfacedObject, IDataSetBuilderFactory)

    public

      function CreateDataSetBuilder: IDataSetBuilder; 
      
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
