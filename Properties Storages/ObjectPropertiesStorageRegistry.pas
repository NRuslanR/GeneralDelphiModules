unit ObjectPropertiesStorageRegistry;

interface

uses

  IObjectPropertiesStorageRegistryUnit,
  IObjectPropertiesStorageUnit,
  DefaultObjectPropertiesStorage,
  ObjectClasses,
  TypeObjectRegistry,
  SysUtils,
  Classes;

type
    
  TObjectPropertiesStorageRegistry = class (TInterfacedObject, IObjectPropertiesStorageRegistry)

    protected

      class var FInstance: IObjectPropertiesStorageRegistry;

      FInternalRegistry: TTypeObjectRegistry;

      class function GetInstance: IObjectPropertiesStorageRegistry; static;

      procedure AddOrUpdateObjectPropertiesStorage(
        ObjectClass: TClass;
        ObjectPropertiesStorage: IObjectPropertiesStorage;
        const RegisterOption: TRegisterObjectPropertiesStorageOption
      );

    public

      constructor Create; virtual;
      destructor Destroy; override;

      function GetSelf: TObject;

      procedure RegisterObjectPropertiesStorageForObjectClass(
        ObjectClass: TClass;
        ObjectPropertiesStorage: IObjectPropertiesStorage;
        const RegisterOption: TRegisterObjectPropertiesStorageOption = RegisterWithInheritanceCheckingOptionIfObjectClassNotFound
      );
      
      function GetPropertiesStorageForObjectClass(
        ObjectClass: TClass
      ): IObjectPropertiesStorage;

      function GetDefaultObjectPropertiesStorage(ObjectClass: TClass): IDefaultObjectPropertiesStorage;

      function GetObjectClasses: TClasses;

      class property Current: IObjectPropertiesStorageRegistry
      read GetInstance write FInstance;
      
  end;

implementation

uses AuxCollectionFunctionsUnit;

{ TObjectPropertiesStorageRegistry }

procedure TObjectPropertiesStorageRegistry.AddOrUpdateObjectPropertiesStorage(
  ObjectClass: TClass;
  ObjectPropertiesStorage: IObjectPropertiesStorage;
  const RegisterOption: TRegisterObjectPropertiesStorageOption
);
begin

  FInternalRegistry.RegisterInterface(
    ObjectClass,
    ObjectPropertiesStorage,
    TTypeObjectRegistrationOptions.Create.AllowObjectUsingByTypeInheritance(
      RegisterOption = RegisterWithInheritanceCheckingOptionIfObjectClassNotFound
    )
  );
  
end;

constructor TObjectPropertiesStorageRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FInternalRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TObjectPropertiesStorageRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TObjectPropertiesStorageRegistry.GetDefaultObjectPropertiesStorage(
  ObjectClass: TClass
): IDefaultObjectPropertiesStorage;
begin

  Supports(GetPropertiesStorageForObjectClass(ObjectClass), IDefaultObjectPropertiesStorage, Result);
  
end;

class function TObjectPropertiesStorageRegistry.GetInstance: IObjectPropertiesStorageRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TObjectPropertiesStorageRegistry.Create;

  Result := FInstance;
  
end;

function TObjectPropertiesStorageRegistry.GetObjectClasses: TClasses;
begin

  Result := FInternalRegistry.GetTypes;
  
end;

function TObjectPropertiesStorageRegistry.GetPropertiesStorageForObjectClass(
  ObjectClass: TClass): IObjectPropertiesStorage;
begin

  Result := IObjectPropertiesStorage(FInternalRegistry.GetInterface(ObjectClass));

end;

function TObjectPropertiesStorageRegistry.GetSelf: TObject;
begin

  Result := Self;

end;

procedure TObjectPropertiesStorageRegistry.RegisterObjectPropertiesStorageForObjectClass(
  ObjectClass: TClass;
  ObjectPropertiesStorage: IObjectPropertiesStorage;
  const RegisterOption: TRegisterObjectPropertiesStorageOption
);
begin

  AddOrUpdateObjectPropertiesStorage(
    ObjectClass, ObjectPropertiesStorage, RegisterOption
  );

end;

end.
