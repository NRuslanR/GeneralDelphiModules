unit IPropertiesStorageUnit;

interface

uses

  VariantListUnit,
  Classes,
  IGetSelfUnit;

type

  IPropertiesStorage = interface (IGetSelf)
    ['{7D1F9179-9880-4BD8-B6CF-1906DBDDE78E}']

    procedure GoToSection(const SectionId: Variant);

    function GetSectionIds: TVariantList;
    
    function IsSectionExists(const SectionId: Variant): Boolean;

    function IsPropertyExists(const SectionId: Variant; const PropertyName: String): Boolean; overload;
    function IsPropertyExists(const PropertyName: String): Boolean; overload;

    function GetCurrentSection: String;

    procedure WriteValueForProperty(
      const PropertyName: String;
      const Value: Variant
    );

    procedure WriteValueForPropertyAsVariant(
      const PropertyName: String;
      const Value: Variant
    );

    function ReadValueForProperty(
      const PropertyName: String;
      const ValueType: TVarType;
      const DefaultValue: Variant
    ): Variant;

    procedure ClearAllProperties; overload;
    procedure ClearAllProperties(const SectionId: Variant); overload;

    function GetPropertyNames(const SectionId: Variant): TStrings;

    procedure RemoveProperty(const SectionId: Variant; const PropertyName: String);
    procedure RemoveProperties(const SectionId: Variant; PropertyNames: TStrings);

    procedure RemoveSection(const SectionId: Variant);
    procedure RemoveSections(const SectionIds: TVariantList);
    
    procedure Commit;
    procedure Rollback;

    property CurrentSection: String read GetCurrentSection;

  end;

implementation

end.
