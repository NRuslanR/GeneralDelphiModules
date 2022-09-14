unit DataSetBuilderFactory;

interface

uses

  DataSetBuilder,
  SysUtils;

type

  IDataSetBuilderFactory = interface

    function CreateDataSetBuilder: IDataSetBuilder;

  end;

  TAbstractDataSetBuilderFactory = class (TInterfacedObject, IDataSetBuilderFactory)

    public

      function CreateDataSetBuilder: IDataSetBuilder; virtual; abstract;
      
  end;

implementation

end.
