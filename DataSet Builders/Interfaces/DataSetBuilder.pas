unit DataSetBuilder;

interface

uses

  DB,
  SysUtils;

type

  IDataSetBuilder = interface

    function AddField(
      const FieldName: String
    ): IDataSetBuilder; overload;

    function AddField(
      const FieldName: String;
      const FieldType: TFieldType
    ): IDataSetBuilder; overload;

    function AddField(
      const FieldName: String;
      const FieldType: TFieldType;
      const Size: Integer
    ): IDataSetBuilder; overload;

    function Build: TDataSet;

  end;

implementation

end.
