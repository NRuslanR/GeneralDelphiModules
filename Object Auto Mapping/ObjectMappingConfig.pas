unit ObjectMappingConfig;

interface

uses

  ObjectMapper,
  SysUtils,
  Classes;

type

  TOnObjectPropertyMappingEventHandler =
    procedure (
      PropertyName: String;
      PropertyValue: Variant;
      MappedObject: TObject
    ) of object;

  TOnObjectPropertyMappingFuncEventHandler =
    procedure (
      PropertyName: String;
      PropertyValue: Variant;
      MappedObject: TObject
    );
    
  IObjectMappingConfig = interface

    function Types(MappeableType, MappedType: TClass): IObjectMappingConfig;
    function Property(MappeableTypePropName, MappedTypePropName: String): IObjectMappingConfig;
    function Property(MappeableTypePropName: String; MappingEventHandler: TOnObjectPropertyMappingEventHandler): IObjectMappingConfig;
    function Property(MappeableTypePropName: String; MappingEventHandler: TOnObjectPropertyMappingFuncEventHandler): IObjectMappingConfig;
    function CreateMapper: IObjectMapper;

  end;

implementation

end.
