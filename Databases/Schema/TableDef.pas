unit TableDef;

interface

uses

  Disposable,
  IGetSelfUnit;
  
type

  TTableDef = class (TInterfacedObject, IGetSelf, IDisposable)

    public

      TableName: String;
      IdColumnName: String;

      function GetSelf: TObject;

      property Self: TObject read GetSelf;
      
  end;

  TTableDefClass = class of TTableDef;

implementation

{ TTableDef }

function TTableDef.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
