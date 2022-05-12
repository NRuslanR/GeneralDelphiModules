unit AbstractDataReader;

interface

uses

  DB,
  DataReader,
  SysUtils,
  Classes;

type

  {$IF CompilerVersion >= 21.0}
    {$LEGACYIFEND ON}
  {$IFEND}

  TAbstractDataReader = class abstract (TInterfacedObject, IDataReader)

    public

      procedure Restart; virtual; abstract;
    
      function Next: Boolean; virtual; abstract;
      function Previous: Boolean; virtual; abstract;
      
      function AtEnd: Boolean; virtual; abstract;
      
      function GetRecordCount: Integer; virtual; abstract;
      function GetValue(const FieldName: String): Variant; virtual; abstract;
      function GetValueAsString(const FieldName: String): String; virtual; abstract;
      function GetValueAsInteger(const FieldName: String): Integer; virtual; abstract;
      function GetValueAsFloat(const FieldName: String): Double; virtual; abstract;
      function GetValueAsDateTime(const FieldName: String): TDateTime; virtual; abstract;
      function GetValueAsBoolean(const FieldName: String): Boolean; virtual; abstract;

      {$IF CompilerVersion >= 21.0}
        function GetCurrentRecordPointer: TBookmark; virtual; abstract;
        procedure GoToRecord(RecordPointer: TBookmark); virtual; abstract;
      {$ELSE}
        function GetCurrentRecordPointer: Pointer; virtual; abstract;
        procedure GoToRecord(RecordPointer: Pointer); virtual; abstract;
      {$IFEND}

      property Items[const FieldName: String]: Variant
      read GetValue; default;

      function ToDataSet: TDataSet; virtual; abstract;

      function GetSelf: TObject;
      
  end;
  
implementation

{ TAbstractDataReader }

function TAbstractDataReader.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
