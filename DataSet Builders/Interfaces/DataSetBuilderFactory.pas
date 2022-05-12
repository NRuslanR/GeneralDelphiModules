unit DataSetBuilderFactory;

interface

uses

  DataSetBuilder,
  SysUtils;

type

  IDataSetBuilderFactory = interface

    function CreateDataSetBuilder: IDataSetBuilder;

  end;
  
implementation

end.
