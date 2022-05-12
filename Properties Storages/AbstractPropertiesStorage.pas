unit AbstractPropertiesStorage;

interface

uses

  VariantListUnit,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  TAbstractPropertiesStorage = class (TInterfacedObject, IPropertiesStorage)

    public

      procedure GoToSection(const SectionId: Variant); virtual; abstract;

      function GetSectionIds: TVariantList; virtual; abstract;
    
      function IsSectionExists(const SectionId: Variant): Boolean; virtual; abstract;

      function IsPropertyExists(const SectionId: Variant; const PropertyName: String): Boolean; overload; virtual; abstract;
      function IsPropertyExists(const PropertyName: String): Boolean; overload; virtual;
      
      function GetCurrentSection: String; virtual; abstract;

      procedure WriteValueForProperty(
        const PropertyName: String;
        const Value: Variant
      ); virtual; abstract;

      procedure WriteValueForPropertyAsVariant(
        const PropertyName: String;
        const Value: Variant
      ); virtual; abstract;

      function ReadValueForProperty(
        const PropertyName: String;
        const ValueType: TVarType;
        const DefaultValue: Variant
      ): Variant; virtual; abstract;

      procedure ClearAllProperties; overload; virtual;
      procedure ClearAllProperties(const SectionId: Variant); overload; virtual; abstract;

      function GetPropertyNames(const SectionId: Variant): TStrings; virtual; abstract;

      procedure RemoveProperty(const SectionId: Variant; const PropertyName: String); virtual; abstract;
      procedure RemoveProperties(const SectionId: Variant; PropertyNames: TStrings); virtual;

      procedure RemoveSection(const SectionId: Variant); virtual; abstract;
      procedure RemoveSections(const SectionIds: TVariantList); virtual;
    
      procedure Commit; virtual; abstract;
      procedure Rollback; virtual; abstract;

      property CurrentSection: String read GetCurrentSection;

      function GetSelf: TObject;

  end;
  
implementation

{ TAbstractPropertiesStorage }

procedure TAbstractPropertiesStorage.ClearAllProperties;
var
    SectionIds: TVariantList;
    SectionId: Variant;
begin

  SectionIds := GetSectionIds;

  try

    for SectionId in SectionIds do
      ClearAllProperties(SectionId);

  finally

    FreeAndNil(SectionIds);

  end;

end;

function TAbstractPropertiesStorage.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TAbstractPropertiesStorage.IsPropertyExists(
  const PropertyName: String): Boolean;
var
    SectionIds: TVariantList;
    SectionId: Variant;
begin

  SectionIds := GetSectionIds;

  try

    for SectionId in SectionIds do begin

      if IsPropertyExists(SectionId, PropertyName) then begin

        Result := True;
        Exit;

      end;

    end;

    Result := False;

  finally

    FreeAndNil(SectionIds);
    
  end;

end;

procedure TAbstractPropertiesStorage.RemoveProperties(const SectionId: Variant;
  PropertyNames: TStrings);
var
    PropertyName: String;
begin

  for PropertyName in PropertyNames do
    RemoveProperty(SectionId, PropertyName);

end;

procedure TAbstractPropertiesStorage.RemoveSections(
  const SectionIds: TVariantList);
var
    SectionId: Variant;
begin

  for SectionId in SectionIds do
    RemoveSection(SectionId);
    
end;

end.
