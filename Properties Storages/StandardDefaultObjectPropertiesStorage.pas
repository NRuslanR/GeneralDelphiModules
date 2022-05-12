unit StandardDefaultObjectPropertiesStorage;

interface

uses

  StandardObjectPropertiesStorage,
  IObjectPropertiesStorageUnit,
  IPropertiesStorageUnit,
  DefaultObjectPropertiesStorage,
  SysUtils;

type

  TStandardDefaultObjectPropertiesStorage =
    class abstract (
      TStandardObjectPropertiesStorage,
      IObjectPropertiesStorage,
      IDefaultObjectPropertiesStorage
    )

      protected

        FDefaultPropertiesStorage: IPropertiesStorage;

        procedure InternalRestoreDefaultObjectProperties(
          TargetObject: TObject;
          DefaultPropertiesStorage: IPropertiesStorage
        ); virtual;

        procedure InternalSaveDefaultObjectProperties(
          TargetObject: TObject;
          DefaultPropertiesStorage: IPropertiesStorage
        ); virtual;

      public

        constructor Create(
          PropertiesStorage: IPropertiesStorage;
          DefaultPropertiesStorage: IPropertiesStorage = nil
        );

        procedure RestoreDefaultObjectProperties(TargetObject: TObject);
        procedure SaveDefaultObjectProperties(TargetObject: TObject);

        property DefaultPropertiesStorage: IPropertiesStorage
        read FDefaultPropertiesStorage write FDefaultPropertiesStorage;

    end;
    
implementation

{ TStandardDefaultObjectPropertiesStorage }

constructor TStandardDefaultObjectPropertiesStorage.Create(PropertiesStorage,
  DefaultPropertiesStorage: IPropertiesStorage);
begin

  inherited Create(PropertiesStorage);

  FDefaultPropertiesStorage := DefaultPropertiesStorage;

end;

procedure TStandardDefaultObjectPropertiesStorage.InternalRestoreDefaultObjectProperties(
  TargetObject: TObject; DefaultPropertiesStorage: IPropertiesStorage);
begin

  InternalRestorePropertiesForObject(TargetObject, DefaultPropertiesStorage);

end;

procedure TStandardDefaultObjectPropertiesStorage.InternalSaveDefaultObjectProperties(
  TargetObject: TObject; DefaultPropertiesStorage: IPropertiesStorage);
begin

  InternalSaveObjectProperties(TargetObject, DefaultPropertiesStorage);
  
end;

procedure TStandardDefaultObjectPropertiesStorage.RestoreDefaultObjectProperties(
  TargetObject: TObject);
begin

  if Assigned(FDefaultPropertiesStorage) then
    InternalRestoreDefaultObjectProperties(TargetObject, FDefaultPropertiesStorage);

end;

procedure TStandardDefaultObjectPropertiesStorage.SaveDefaultObjectProperties(
  TargetObject: TObject);
begin

  if Assigned(FDefaultPropertiesStorage) then
    InternalSaveDefaultObjectProperties(TargetObject, FDefaultPropertiesStorage);
  
end;

end.
