unit DataReader;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes,
  DB;

type

  {$IF CompilerVersion >= 21.0}
    {$LEGACYIFEND ON}
  {$IFEND}

  IDataReader = interface (IGetSelf)
  ['{74A93A57-CC9A-401D-988D-5098834713E0}']
  
    procedure Restart;
    
    function Next: Boolean;
    function Previous: Boolean;

    function AtEnd: Boolean;

    function GetRecordCount: Integer;
    function GetValue(const FieldName: String): Variant;
    function GetValueAsString(const FieldName: String): String;
    function GetValueAsInteger(const FieldName: String): Integer;
    function GetValueAsFloat(const FieldName: String): Double;
    function GetValueAsDateTime(const FieldName: String): TDateTime;
    function GetValueAsBoolean(const FieldName: String): Boolean;

    {$IF CompilerVersion >= 21.0}
      function GetCurrentRecordPointer: TBookmark;
      procedure GoToRecord(RecordPointer: TBookmark);
    {$ELSE}
      function GetCurrentRecordPointer: Pointer;
      procedure GoToRecord(RecordPointer: Pointer);
    {$IFEND}

    property Items[const FieldName: String]: Variant
    read GetValue; default;

    property RecordCount: Integer
    read GetRecordCount;
    
  end;

implementation

end.
