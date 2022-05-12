unit ReflectionServicesUnit;

interface

uses

  TypInfo,
  AuxiliaryStringFunctions,
  Variants,
  SysUtils,
  StrUtils,
  Classes,
  Windows;
  
type

  TReflectionServices = class

    private

      class procedure GetEndObjectAndProperty(
        TargetObject: TObject;
        const PropertyName: String;
        var EndObject: TObject;
        var EndPropertyName: String
      );

    private

      class function InternalGetObjectPropertyValue(
        TargetObject: TObject;
        const PropertyName: String
      ): Variant; static;

      class procedure InternalSetObjectPropertyValue(
        TargetObject: TObject;
        const PropertyName: String;
        const Value: Variant
      ); static;
      
    public

      class function GetClassPropertyTypeAsVariantConstant(
        TargetClass: TClass;
        const PropertyName: String
      ): Word; static;

      class function GetObjectPropertyValue(
        TargetObject: TObject;
        const PropertyName: String
      ): Variant; static;

      class procedure SetObjectPropertyValue(
        TargetObject: TObject;
        const PropertyName: String;
        const Value: Variant
      ); static;

      class function GetObjectPropertyNames(TargetObject: TObject): TStrings; static;
      
      class function GetObjectPropertyNamesExcept(
        TargetObject: TObject;
        ExceptionalPropertyNames: TStrings
      ): TStrings; static;

  end;

  {$IF CompilerVersion >= 21.0}
    {$LEGACYIFEND ON}
  {$IFEND}

implementation

{ TReflectionServices }

class function TReflectionServices.GetObjectPropertyNames(TargetObject: TObject): TStrings;
var
    TypeInfo: PTypeInfo;
    TypeData: PTypeData;
    PropertyList: PPropList;
    PropertyInfo: TPropInfo;
    PropertyCount, I: Integer;
begin

  TypeInfo := TargetObject.ClassInfo;

  if not Assigned(TypeInfo) then Exit;
  
  TypeData := GetTypeData(TypeInfo);

  PropertyCount := TypeData.PropCount;
  
  if PropertyCount = 0 then Exit;

  try

    Result := TStringList.Create;

    try
    
      GetMem(PropertyList, Sizeof(PPropInfo) * PropertyCount);

      GetPropList(TypeInfo, tkProperties, PropertyList);

      for I := 0 to PropertyCount - 1 do begin

        PropertyInfo := PropertyList[I]^;

        Result.Add(PropertyInfo.Name);

      end;

    except

      FreeAndNil(Result);

      Raise;
      
    end;

  finally

    FreeMem(PropertyList);
    
  end;

end;

class function TReflectionServices.GetObjectPropertyNamesExcept(
  TargetObject: TObject;
  ExceptionalPropertyNames: TStrings
): TStrings;
var
    ObjectPropNames: TStrings;
    PropName: String;
begin

  ObjectPropNames := TReflectionServices.GetObjectPropertyNames(TargetObject);

  try

    Result := TStringList.Create;

    try

      for PropName in ObjectPropNames do
        if
          not Assigned(ExceptionalPropertyNames)
          or (ExceptionalPropertyNames.IndexOf(PropName) = -1)
        then
          Result.Add(PropName);

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(ObjectPropNames);
    
  end;

end;

class function TReflectionServices.GetObjectPropertyValue(
  TargetObject: TObject;
  const PropertyName: String
): Variant;
var
    EndObject: TObject;
    EndPropertyName: String;
begin

  GetEndObjectAndProperty(TargetObject, PropertyName, EndObject, EndPropertyName);

  if Assigned(EndObject) then
    Result := InternalGetObjectPropertyValue(EndObject, EndPropertyName)

  else Result := Null;

end;

class procedure TReflectionServices.SetObjectPropertyValue(
  TargetObject: TObject;
  const PropertyName: String;
  const Value: Variant
);
var 
    EndObject: TObject;
    EndPropertyName: String;
begin

  GetEndObjectAndProperty(TargetObject, PropertyName, EndObject, EndPropertyName);

  if Assigned(EndObject) then
    InternalSetObjectPropertyValue(EndObject, EndPropertyName, Value);
  
end;

class procedure TReflectionServices.GetEndObjectAndProperty(
  TargetObject: TObject;
  const PropertyName: String;

  var EndObject: TObject;
  var EndPropertyName: String
);
var
    I: Integer;
    NestedPropertyNames: TStrings;
    PropertyValueVariant: Variant;
begin

  if Trim(PropertyName) = '' then begin

    EndObject := nil;
    EndPropertyName := '';
    
    Exit;

  end;

  NestedPropertyNames := SplitStringByDelimiter(PropertyName, '.');

  if NestedPropertyNames.Count < 2 then begin

    EndObject := TargetObject;
    EndPropertyName := PropertyName;

    Exit;

  end;

  for I := 0 to NestedPropertyNames.Count - 2 do begin

    PropertyValueVariant :=
      InternalGetObjectPropertyValue(TargetObject, NestedPropertyNames[I]);

    if not VarIsType(PropertyValueVariant, varByRef) then begin

      EndObject := nil;
      EndPropertyName := '';

      Exit;

    end;

    TargetObject := TObject(TVarData(PropertyValueVariant).VPointer);

  end;

  EndObject := TargetObject;
  EndPropertyName := NestedPropertyNames[I];

end;

class function TReflectionServices.InternalGetObjectPropertyValue(
  TargetObject: TObject; const PropertyName: String): Variant;
var
    ClassTypeInfo: PTypeInfo;
    ClassTypeData: PTypeData;
    PropertyList: PPropList;
    PropertyInfo: TPropInfo;
    I, PropertyCount: Integer;
begin

  Result := Null;

  ClassTypeInfo := TargetObject.ClassInfo;

  if not Assigned(ClassTypeInfo) then Exit;
  
  ClassTypeData := GetTypeData(ClassTypeInfo);

  PropertyCount := ClassTypeData.PropCount;
  
  if PropertyCount = 0 then Exit;

  try

    GetMem(PropertyList, Sizeof(PPropInfo) * PropertyCount);

    GetPropList(ClassTypeInfo, tkProperties, PropertyList);

    for I := 0 to PropertyCount - 1 do begin

      PropertyInfo := PropertyList[I]^;

      if PropertyInfo.Name <> PropertyName then
        Continue;

      case PropertyInfo.PropType^.Kind of

        tkInteger, tkEnumeration:
        begin

          Result := GetOrdProp(TargetObject, PropertyName);

          if PropertyInfo.PropType^.Name = 'Boolean' then
            Result := VarAsType(Result, varBoolean);

        end;

        tkSet:

          Result := GetSetProp(TargetObject, PropertyName);

        tkLString, tkWString, tkString {$IF CompilerVersion >= 21.0} , tkUString {$IFEND}:

          Result := GetStrProp(TargetObject, PropertyName);

        tkFloat:
        begin

          Result := GetFloatProp(TargetObject, PropertyName);

          if PropertyInfo.PropType^.Name = 'TDateTime' then
            Result := FloatToDateTime(Result);

        end;

        tkInt64:

          Result := GetInt64Prop(TargetObject, PropertyName);

        tkVariant:

          Result := GetVariantProp(TargetObject, PropertyName);

        tkClass:
        begin

          TVarData(Result).VType := varByRef;
          TVarData(Result).VPointer :=
            Pointer(GetObjectProp(TargetObject, PropertyName));

        end;

        tkInterface:
        begin
                                   
          TVarData(Result).VType := varByRef;
          TVarData(Result).VPointer :=
            Pointer(GetInterfaceProp(TargetObject, PropertyName));
            
        end

        else

          raise Exception.Create('Unexpected property kind was encountered');

      end;

      Break;

    end;

  finally

    FreeMem(PropertyList);

  end;

end;

class procedure TReflectionServices.InternalSetObjectPropertyValue(
  TargetObject: TObject;
  const PropertyName: String;
  const Value: Variant
);
var
    ClassTypeInfo: PTypeInfo;
    ClassTypeData: PTypeData;
    PropertyList: PPropList;
    PropertyInfo: TPropInfo;
    I, PropertyCount: Integer;
    Int64Value: Int64;
begin

  if (Value = Unassigned) or (Value = Null) then
    Exit;
  
  ClassTypeInfo := TargetObject.ClassInfo;

  if not Assigned(ClassTypeInfo) then Exit;

  ClassTypeData := GetTypeData(ClassTypeInfo);

  PropertyCount := ClassTypeData.PropCount;

  if PropertyCount = 0 then begin

    Exit;

  end;

  try

    GetMem(PropertyList, Sizeof(PPropInfo) * PropertyCount);

    GetPropList(ClassTypeInfo, tkProperties, PropertyList);

    for I := 0 to PropertyCount - 1 do begin

      PropertyInfo := PropertyList[I]^;

      if PropertyInfo.Name <> PropertyName then
        Continue;

      case PropertyInfo.PropType^.Kind of

        tkInteger, tkEnumeration:

          SetOrdProp(TargetObject, PropertyName, Value);

        tkSet:

          SetSetProp(TargetObject, PropertyName, Value);

        tkLString, tkWString, tkString {$IF CompilerVersion >= 21.0}, tkUString {$IFEND}:

          SetStrProp(TargetObject, PropertyName, Value);

        tkFloat:

          SetFloatProp(TargetObject, PropertyName, Value);

        tkInt64:
        begin

          Int64Value := Value;

          SetInt64Prop(TargetObject, PropertyName, Int64Value);

        end;

        tkVariant:

          SetVariantProp(TargetObject, PropertyName, Value);

        tkClass:
        begin

          SetObjectProp(
            TargetObject, PropertyName, TObject(TVarData(Value).VPointer)
          );

        end;

        tkInterface:
        begin

          SetInterfaceProp(
            TargetObject, PropertyName, IInterface(TVarData(Value).VPointer)
          );
          
        end

        else

          raise Exception.Create('Unexpected property kind was encountered !');

      end;

      Break;

    end;

  finally

    FreeMem(PropertyList);

  end;

end;

class function TReflectionServices.GetClassPropertyTypeAsVariantConstant(
  TargetClass: TClass; const PropertyName: String): Word;
var
    ClassTypeInfo: PTypeInfo;
    ClassTypeData: PTypeData;
    PropertyList: PPropList;
    PropertyInfo: TPropInfo;
    I, PropertyCount: Integer;
begin

  Result := varNull;

  ClassTypeInfo := TargetClass.ClassInfo;

  if not Assigned(ClassTypeInfo) then Exit;
  
  ClassTypeData := GetTypeData(ClassTypeInfo);

  PropertyCount := ClassTypeData.PropCount;

  if PropertyCount = 0 then Exit;

  try

    GetMem(PropertyList, Sizeof(PPropInfo) * PropertyCount);

    GetPropList(ClassTypeInfo, tkProperties, PropertyList);

    for I := 0 to PropertyCount - 1 do begin

      PropertyInfo := PropertyList[I]^;

      if PropertyInfo.Name <> PropertyName then
        Continue;

      case PropertyInfo.PropType^.Kind of

        tkInteger, tkEnumeration:

          Result := varInteger;

        tkSet:

          Result := varUnknown;

        tkLString, tkWString, tkString {$IF CompilerVersion >= 21.0}, tkUString {$IFEND}:

          Result := varString;

        tkFloat:
        begin

          if PropertyInfo.PropType^.Name = 'TDateTime' then
            Result := varDate

          else if PropertyInfo.PropType^.Name = 'Single' then
            Result := varSingle

          else Result := varDouble;

        end;

        tkInt64:

          Result := varInt64;

        tkVariant:

          Result := varVariant;

        tkClass, tkInterface:

          Result := varByRef;

        else

          raise Exception.Create('Unexpected property kind was encountered !');

      end;

      Break;

    end;

  finally

    FreeMem(PropertyList);

  end;

end;

end.
