unit StandardObjectPropertiesStorage;

interface

uses

  IPropertiesStorageUnit,
  IObjectPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  {$M+}
  TStandardObjectPropertiesStorage = class abstract (TInterfacedObject, IObjectPropertiesStorage)

    protected

      FPropertiesStorage: IPropertiesStorage;

      procedure InternalSaveObjectProperties(
        TargetObject: TObject;
        PropertiesStorage: IPropertiesStorage
      ); virtual; abstract;

      procedure InternalRestorePropertiesForObject(
        TargetObject: TObject;
        PropertiesStorage: IPropertiesStorage
      ); virtual; abstract;

    public

      constructor Create(PropertiesStorage: IPropertiesStorage);

      procedure SaveObjectProperties(TargetObject: TObject);
      procedure RestorePropertiesForObject(TargetObject: TObject);

      function GetSelf: TObject;

    published

      property PropertiesStorage: IPropertiesStorage read FPropertiesStorage;

  end;
  {$M-}
  
implementation

{ TStandardObjectPropertiesStorage }

constructor TStandardObjectPropertiesStorage.Create(
  PropertiesStorage: IPropertiesStorage);
begin

  inherited Create;

  FPropertiesStorage := PropertiesStorage;
  
end;

function TStandardObjectPropertiesStorage.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TStandardObjectPropertiesStorage.RestorePropertiesForObject(
  TargetObject: TObject);
begin

  InternalRestorePropertiesForObject(TargetObject, FPropertiesStorage);

end;

procedure TStandardObjectPropertiesStorage.SaveObjectProperties(
  TargetObject: TObject);
begin

  InternalSaveObjectProperties(TargetObject, FPropertiesStorage);

end;

end.
