unit PropertiesIniFileUnit;

interface

uses
     IGetSelfUnit,
     IPropertiesStorageUnit,
     AbstractPropertiesStorage,
     VariantListUnit,
     IniFiles,
     SysUtils,
     Classes;

type

  TPropertiesIniFile = class (TAbstractPropertiesStorage)

    private

      FIniFile: TIniFile;
      FNameOfCurrentSection: String;
      FCreateIniFileIfNotExists: Boolean;
      FRaiseExceptionIfIniFileNotExists: Boolean;
      
      function GetIniFilePath: String;
      procedure SetIniFilePath(const Value: String);

      procedure CreateIniFileIfNecessary;
      
    public

      destructor Destroy; override;

      constructor Create(
        const SettingsIniFilePath: String;
        const CreateIniFileIfNotExists: Boolean = False;
        const RaiseExceptionIfIniFileNotExists: Boolean = True
      );

      procedure GoToSection(const SectionId: Variant); override;

      function GetSectionIds: TVariantList; override;
      
      function GetCurrentSection: String; override;
      
      procedure WriteValueForProperty(
        const PropertyName: String;
        const Value: Variant
      ); override;

      procedure WriteValueForPropertyAsVariant(
        const PropertyName: String;
        const Value: Variant
      ); override;

      function ReadValueForProperty(
        const PropertyName: String;
        const ValueType: TVarType;
        const DefaultValue: Variant
      ): Variant; override;

      function ReadSections: TStrings;

      function IsSectionExists(const SectionId: Variant): Boolean; override;
      function IsPropertyExists(const SectionId: Variant; const PropertyName: String): Boolean; override;
      
      function IsKeyExists(const Section, KeyName: String): Boolean;
      
      procedure ClearAllProperties(const SectionId: Variant); override;

      function GetPropertyNames(const SectionId: Variant): TStrings; override;

      procedure RemoveProperty(const SectionId: Variant; const PropertyName: String); override;

      procedure RemoveSection(const SectionId: Variant); override;

      procedure Commit; override;
      procedure Rollback; override;

    published

      property CreateIniFileIfNotExists: Boolean
      read FCreateIniFileIfNotExists write FCreateIniFileIfNotExists;

      property RaiseExceptionIfIniFileNotExists: Boolean
      read FRaiseExceptionIfIniFileNotExists write FRaiseExceptionIfIniFileNotExists;
      
      property IniFilePath: String read GetIniFilePath write SetIniFilePath;
      property CurrentSection: String read GetCurrentSection;
      
  end;

implementation

uses

  AuxiliaryStringFunctions,
  Variants;

{ TPropertiesIniFile }

procedure TPropertiesIniFile.ClearAllProperties(const SectionId: Variant);
begin

  FIniFile.EraseSection(SectionId);
  
end;

procedure TPropertiesIniFile.Commit;
begin

end;

constructor TPropertiesIniFile.Create(
  const SettingsIniFilePath: String;
  const CreateIniFileIfNotExists: Boolean;
  const RaiseExceptionIfIniFileNotExists: Boolean
);
begin

  inherited Create;

  FCreateIniFileIfNotExists := CreateIniFileIfNotExists;
  FRaiseExceptionIfIniFileNotExists := RaiseExceptionIfIniFileNotExists;
  
  FIniFile := TIniFile.Create(SettingsIniFilePath);

end;

procedure TPropertiesIniFile.CreateIniFileIfNecessary;
begin

  if
    FCreateIniFileIfNotExists
    and not DirectoryExists(ExtractFileDir(FIniFile.FileName))
  then
    ForceDirectories(ExtractFileDir(FIniFile.FileName));
    
end;

destructor TPropertiesIniFile.Destroy;
begin

  FreeAndNil(FIniFile);
  inherited;

end;

function TPropertiesIniFile.GetCurrentSection: String;
begin

  Result := FNameOfCurrentSection;
  
end;

function TPropertiesIniFile.GetIniFilePath: String;
begin

  Result := FIniFile.FileName;
  
end;

function TPropertiesIniFile.GetPropertyNames(
  const SectionId: Variant): TStrings;
begin

  Result := TStringList.Create;

  try

    FIniFile.ReadSectionValues(SectionId, Result);
  
  except

    FreeAndNil(Result);

    Raise;
    
  end;
  
end;

function TPropertiesIniFile.GetSectionIds: TVariantList;
var
    SectionNames: TStrings;
    SectionName: String;
begin

  SectionNames := ReadSections;

  try

    Result := TVariantList.Create;
    
    try

      for SectionName in SectionNames do
        Result.Add(SectionName);
        
    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(SectionNames);
    
  end;

end;

procedure TPropertiesIniFile.GoToSection(const SectionId: Variant);
begin

  FNameOfCurrentSection := SectionId;
  
end;

function TPropertiesIniFile.IsKeyExists(const Section,
  KeyName: String): Boolean;
begin

  Result := IsPropertyExists(Section, KeyName);
  
end;

function TPropertiesIniFile.IsPropertyExists(const SectionId: Variant;
  const PropertyName: String): Boolean;
begin

  Result := FIniFile.ValueExists(SectionId, PropertyName);

end;

function TPropertiesIniFile.IsSectionExists(const SectionId: Variant): Boolean;
begin

  Result := FIniFile.SectionExists(SectionId);
  
end;

function TPropertiesIniFile.ReadSections: TStrings;
begin

  Result := TStringList.Create;

  FIniFile.ReadSections(Result);

end;

function TPropertiesIniFile.ReadValueForProperty(
  const PropertyName: String;
  const ValueType: TVarType;
  const DefaultValue: Variant
): Variant;
var ValueWithTypeExpression: String;
    TypeAndValueStrings: TStrings;
    VarType: Word;
begin

  if
    not FRaiseExceptionIfIniFileNotExists
    and not FileExists(FIniFile.FileName)
  then begin

    Result := DefaultValue;
    Exit;
    
  end;
  
  case ValueType of

    varSmallInt, varInteger, varByte,
    varWord, varLongWord, varInt64, varShortInt:

      Result :=
        FIniFile.ReadInteger(FNameOfCurrentSection, PropertyName, DefaultValue);

    varSingle, varDouble, varCurrency:

      Result :=
        FIniFile.ReadFloat(FNameOfCurrentSection, PropertyName, DefaultValue);

    varDate:

      Result :=
        FIniFile.ReadDateTime(
          FNameOfCurrentSection, PropertyName, DefaultValue
        );

    varVariant:
    begin

      ValueWithTypeExpression :=
        FIniFile.ReadString(
          FNameOfCurrentSection, PropertyName, ''
        );

      if ValueWithTypeExpression = '' then begin

        Result := DefaultValue;
        Exit;

      end;

      TypeAndValueStrings :=
        SplitStringByDelimiter(ValueWithTypeExpression, '|');

      if TypeAndValueStrings.Count < 2 then begin

        Result := DefaultValue;
        
      end

      else begin

        VarType := StrToInt(TypeAndValueStrings[0]);

        Result := VarAsType(TypeAndValueStrings[1], VarType);

      end;

    end;      

    varBoolean:

      Result :=
        FIniFile.ReadBool(FNameOfCurrentSection, PropertyName, DefaultValue);

    else

    Result :=
      FIniFile.ReadString(FNameOfCurrentSection, PropertyName, DefaultValue);

  end;
 
end;

procedure TPropertiesIniFile.RemoveProperty(const SectionId: Variant;
  const PropertyName: String);
begin

  FIniFile.DeleteKey(SectionId, PropertyName);
  
end;

procedure TPropertiesIniFile.RemoveSection(const SectionId: Variant);
begin

  FIniFile.EraseSection(SectionId);
  
end;

procedure TPropertiesIniFile.Rollback;
begin

end;

procedure TPropertiesIniFile.SetIniFilePath(const Value: String);
begin

  FreeAndNil(FIniFile);

  FIniFile := TIniFile.Create(Value);

end;

procedure TPropertiesIniFile.WriteValueForProperty(
  const PropertyName: String;
  const Value: Variant
);
var ValueType: TVarType;
begin

  CreateIniFileIfNecessary;
  
  ValueType := VarType(Value);

  case ValueType of

    varSmallInt, varInteger, varByte,
    varWord, varLongWord, varInt64, varShortInt:

      FIniFile.WriteInteger(FNameOfCurrentSection, PropertyName, Value);

    varSingle, varDouble, varCurrency:

      FIniFile.WriteFloat(FNameOfCurrentSection, PropertyName, Value);

    varDate:

      FIniFile.WriteDateTime(FNameOfCurrentSection, PropertyName, Value);
      
    varBoolean:

      FIniFile.WriteBool(FNameOfCurrentSection, PropertyName, Value);
      
  else FIniFile.WriteString(FNameOfCurrentSection, PropertyName, Value);

  end;

end;

procedure TPropertiesIniFile.WriteValueForPropertyAsVariant(
  const PropertyName: String; const Value: Variant);
begin

  CreateIniFileIfNecessary;
  
  FIniFile.WriteString(
    FNameOfCurrentSection,
    PropertyName,
    Format(
      '%d|%s',
      [
        VarType(Value),
        VarToStr(Value)
      ]
    )
  );

end;

end.
