unit DataSetBuilder;

interface

uses

  DB,
  IGetSelfUnit,
  SysUtils;

type

  TDataSetCopyBuildingOption = (cbCopyWithData, cbCopyWithoutData);

  IDataSetBuilder = interface (IGetSelf)

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

    function BuildCopy(
      Original: TDataSet;
      const Option: TDataSetCopyBuildingOption = cbCopyWithData
    ): TDataSet;

    function Build: TDataSet;

  end;

implementation

end.
