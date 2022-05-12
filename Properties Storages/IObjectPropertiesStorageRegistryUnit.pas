unit IObjectPropertiesStorageRegistryUnit;

interface

uses

  IGetSelfUnit,
  IObjectPropertiesStorageUnit,
  DefaultObjectPropertiesStorage,
  ObjectClasses,
  SysUtils,
  Classes;

type

  TRegisterObjectPropertiesStorageOption =
    (
      RegisterWithInheritanceCheckingOptionIfObjectClassNotFound,
      RegisterWithoutInheritanceCheckingOption
    );

  IObjectPropertiesStorageRegistry = interface (IGetSelf)

    procedure RegisterObjectPropertiesStorageForObjectClass(
      ObjectClass: TClass;
      ObjectPropertiesStorage: IObjectPropertiesStorage;
      const RegisterOption: TRegisterObjectPropertiesStorageOption = RegisterWithInheritanceCheckingOptionIfObjectClassNotFound
    );

    function GetObjectClasses: TClasses;
    
    function GetPropertiesStorageForObjectClass(ObjectClass: TClass): IObjectPropertiesStorage;
    function GetDefaultObjectPropertiesStorage(ObjectClass: TClass): IDefaultObjectPropertiesStorage;
    
  end;

implementation

end.

