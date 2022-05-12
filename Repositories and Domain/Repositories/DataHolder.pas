unit DataHolder;

interface

uses

  IGetSelfUnit;

type

  IDataHolder = interface (IGetSelf)

    function GetFieldValue(const FieldName: String): Variant;
    function IsFieldValueNull(const FieldName: String): Boolean;
    function GetFieldValueAsString(const FieldName: String): String;
    function GetFieldValueAsInteger(const FieldName: String): Integer;
    function GetFieldValueAsDateTime(const FieldName: String): TDateTime;
    function GetFieldValueAsFloat(const FieldName: String): Double;
    function GetFieldValueAsBoolean(const FieldName: String): Boolean;
    
  end;
  
implementation

end.
