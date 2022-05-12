unit DomainObjectBaseUnit;

interface

uses

     ClonableUnit,
     CopyableUnit,
     EquatableUnit,
     DomainException,
     IDomainObjectBaseUnit,
     IDomainObjectBaseListUnit,
     TypInfo,
     Classes;

type

  {$M+}
  TDomainObjectBase = class abstract
                         (
                          TInterfacedObject,
                          IDomainObjectBase,
                          IClonable,
                          IEquatable,
                          ICopyable
                         )

    protected

      type

        TCopyMode = (cmDeep, cmShallow);

        TPropertyHandler =
          procedure(
            PropertyInfo: TPropInfo;
            FirstDomainObject, SecondDomainObject: TDomainObjectBase;
            var Result: Variant;
            var FinishLoop: Boolean
          ) of object;

    protected

      FNestedObjectsAutoDestroyingEnabled: Boolean;
      FInvariantsComplianceRequested: Boolean;

      function GetSelf: TObject;

      procedure FreeNestedBaseDomainObject(NestedDomainObject: TDomainObjectBase);
      procedure FreeNestedBaseDomainObjectList(NestedDomainObjectList: IDomainObjectBaseList);
  
      procedure FreeNestedBaseDomainObjects; virtual;

      procedure RunPropertyHandlingLoopFor(
        FirstDomainObject, SecondDomainObject: TDomainObjectBase;
        PropertyHandler: TPropertyHandler;
        var PropertyHandlerResult: Variant;
        const DefaultPropertyHandlerResult: Variant
      );

      procedure PropertyHandlerForEqualsMethod(
        PropertyInfo: TPropInfo;
        FirstDomainObject, SecondDomainObject: TDomainObjectBase;
        var PropertyHandlerResult: Variant;
        var FinishLoop: Boolean
      );

      procedure PropertyHandlerForCloneMethod(
        PropertyInfo: TPropInfo;
        FirstDomainObject, SecondDomainObject: TDomainObjectBase;
        var PropertyHandlerResult: Variant;
        var FinishLoop: Boolean
      );

      procedure PropertyHandlerForCopyMethods(
        PropertyInfo: TPropInfo;
        FirstDomainObject, SecondDomainObject: TDomainObjectBase;
        var PropertyHandlerResult: Variant;
        var FinishLoop: Boolean
      );

      procedure PropertyHandlerForFreeNestedBaseDomainObjectMethod(
        PropertyInfo: TPropInfo;
        FirstDomainObject, SecondDomainObject: TDomainObjectBase;
        var PropertyHandlerResult: Variant;
        var FinishLoop: Boolean
      );

      function CreateNewInstance: TDomainObjectBase;

      function InternalClone: TObject; virtual;
      procedure InternalCopyFrom(Copyable: TObject); virtual;
      function InternalEquals(Equatable: TObject): Boolean; virtual;
      procedure InternalDeepCopyFrom(Copyable: TObject); virtual;

      procedure SetInvariantsComplianceRequested(const Value: Boolean); virtual;

    protected

      procedure RaiseExceptionIfInvariantsComplianceRequested(
        const Msg: String
      ); overload;

      procedure RaiseExceptionIfInvariantsComplianceRequested(
        ExceptionType: TDomainExceptionClass;
        const Msg: String
      ); overload;
      
      procedure RaiseExceptionIfInvariantsComplianceRequested(
        const Msg: String;
        const Args: array of const
      ); overload;

      procedure RaiseExceptionIfInvariantsComplianceRequested(
        ExceptionType: TDomainExceptionClass;
        const Msg: String;
        const Args: array of const
      ); overload;

    protected
    
      procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
        const Condition: Boolean;
        const Msg: String
      ); overload;

      procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
        const Condition: Boolean;
        ExceptionType: TDomainExceptionClass;
        const Msg: String
      ); overload;

      procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
        const Condition: Boolean;
        const Msg: String;
        const Args: array of const
      ); overload;

      procedure RaiseConditionalExceptionIfInvariantsComplianceRequested(
        const Condition: Boolean;
        ExceptionType: TDomainExceptionClass;
        const Msg: String;
        const Args: array of const
      ); overload;

    public

      destructor Destroy; override;
      constructor Create; virtual;

      procedure CopyFrom(Copyable: TObject); virtual;
      procedure DeepCopyFrom(Copyable: TObject); virtual;
      function Equals(Equatable: TObject): Boolean; virtual;
      function Clone: TObject; virtual;

      function GetPropertyValue(const PropertyName: String): Variant;
      function IsPropertyValueEqual(const PropertyName: String; const Value: Variant): Boolean; overload;
      function IsPropertyValueEqual(const PropertyName: String; Value: TObject): Boolean; overload;

      function PropertiesEqualsExcept(BaseDomainObject: TDomainObjectBase; ExceptionalFieldNames: TStrings): Boolean;
      function PropertiesEquals(BaseDomainObject: TDomainObjectBase): Boolean;

      function GetPropertyNames: TStrings;
      function GetPropertyNamesExcept(ExceptionalFieldNames: TStrings): TStrings;

      property InvariantsComplianceRequested: Boolean
      read FInvariantsComplianceRequested
      write SetInvariantsComplianceRequested;

  end;
  {$M-}

  {$IF CompilerVersion >= 21.0}
    {$LEGACYIFEND ON}
  {$IFEND}

  TDomainObjectBaseClass = class of TDomainObjectBase;

implementation

uses

  Variants,
  Windows,
  SysUtils,
  VariantFunctions,
  Forms,
  AuxDebugFunctionsUnit,
  DomainObjectListUnit,
  ReflectionServicesUnit,
  DomainObjectBaseListUnit;

{ TDomainObjectBase }

function TDomainObjectBase.Clone: TObject;
begin

  Result := InternalClone;

end;

procedure TDomainObjectBase.CopyFrom(Copyable: TObject);
begin

  InternalCopyFrom(Copyable);

end;

constructor TDomainObjectBase.Create;
begin

  inherited;

  FNestedObjectsAutoDestroyingEnabled := True;
  InvariantsComplianceRequested := True;

end;

function TDomainObjectBase.CreateNewInstance: TDomainObjectBase;
begin

  Result := TDomainObjectBaseClass(ClassType).Create;

end;

procedure TDomainObjectBase.DeepCopyFrom(Copyable: TObject);
begin

  InternalDeepCopyFrom(Copyable);

end;

destructor TDomainObjectBase.Destroy;
begin

  DebugOutput(ClassName);
  
  if FNestedObjectsAutoDestroyingEnabled then
    FreeNestedBaseDomainObjects;

  inherited;

end;

function TDomainObjectBase.Equals(Equatable: TObject): Boolean;
begin

  Result := InternalEquals(Equatable);

end;

procedure TDomainObjectBase.FreeNestedBaseDomainObject(
  NestedDomainObject: TDomainObjectBase
);
var FreeDomainObjectBase: IDomainObjectBase;
begin

  FreeDomainObjectBase := NestedDomainObject;

end;

procedure TDomainObjectBase.FreeNestedBaseDomainObjectList(
  NestedDomainObjectList: IDomainObjectBaseList);
begin

end;

procedure TDomainObjectBase.FreeNestedBaseDomainObjects;
var NotResult: Variant;
begin

  RunPropertyHandlingLoopFor(
    Self,
    nil,
    PropertyHandlerForFreeNestedBaseDomainObjectMethod,
    NotResult,
    NotResult
  );

end;

function TDomainObjectBase.GetPropertyNames: TStrings;
begin

  Result := TReflectionServices.GetObjectPropertyNames(Self);
  
end;

function TDomainObjectBase.GetPropertyNamesExcept(
  ExceptionalFieldNames: TStrings): TStrings;
begin

  Result :=
    TReflectionServices.GetObjectPropertyNamesExcept(
      Self, ExceptionalFieldNames
    );

end;

function TDomainObjectBase.GetPropertyValue(
  const PropertyName: String): Variant;
begin

  Result := TReflectionServices.GetObjectPropertyValue(Self, PropertyName);

end;

function TDomainObjectBase.GetSelf: TObject;
begin

  Result := Self;

end;

function TDomainObjectBase.InternalClone: TObject;
var NotResult: Variant;
    DomainObjectBase: TDomainObjectBase;
begin

  Result := CreateNewInstance;

  DomainObjectBase := Result as TDomainObjectBase;

  DomainObjectBase.InvariantsComplianceRequested := False;
  
  RunPropertyHandlingLoopFor(
    Result as TDomainObjectBase,
    Self as TDomainObjectBase,
    PropertyHandlerForCloneMethod,
    NotResult,
    NotResult
  );

  DomainObjectBase.InvariantsComplianceRequested := True;
  
end;

procedure TDomainObjectBase.InternalCopyFrom(Copyable: TObject);
var CopyMode: Variant;
begin

  CopyMode := cmShallow;

  InvariantsComplianceRequested := False;
  
  RunPropertyHandlingLoopFor(
    Self as TDomainObjectBase,
    Copyable as TDomainObjectBase,
    PropertyHandlerForCopyMethods,
    CopyMode,
    CopyMode
  );

  InvariantsComplianceRequested := True;
  
end;

procedure TDomainObjectBase.InternalDeepCopyFrom(Copyable: TObject);
var CopyMode: Variant;
begin

  CopyMode := cmDeep;

  InvariantsComplianceRequested := False;
  
  RunPropertyHandlingLoopFor(
    Self as TDomainObjectBase,
    Copyable as TDomainObjectBase,
    PropertyHandlerForCopyMethods,
    CopyMode,
    CopyMode
  );

  InvariantsComplianceRequested := True;

end;

function TDomainObjectBase.InternalEquals(Equatable: TObject): Boolean;
var ArePropertiesEquals: Variant;
begin

  ArePropertiesEquals := True;

  RunPropertyHandlingLoopFor(
    Self as TDomainObjectBase,
    Equatable as TDomainObjectBase,
    PropertyHandlerForEqualsMethod,
    ArePropertiesEquals,
    False
  );

  Result := ArePropertiesEquals or (Equatable = Self);

end;

function TDomainObjectBase.IsPropertyValueEqual(const PropertyName: String;
  Value: TObject): Boolean;
begin

  Result := IsPropertyValueEqual(PropertyName, ObjectToVariant(Value));

end;

function TDomainObjectBase.IsPropertyValueEqual(const PropertyName: String;
  const Value: Variant): Boolean;
begin

  Result := GetPropertyValue(PropertyName) = Value;
  
end;

function TDomainObjectBase
  .PropertiesEquals(BaseDomainObject: TDomainObjectBase): Boolean;
begin

  Result := PropertiesEqualsExcept(BaseDomainObject, nil);
  
end;

function TDomainObjectBase.PropertiesEqualsExcept(
  BaseDomainObject: TDomainObjectBase;
  ExceptionalFieldNames: TStrings
): Boolean;
var
    ObjectPropNames: TStrings;
    PropName: String;
begin

  if BaseDomainObject.ClassType <> ClassType then Exit;

  ObjectPropNames :=
    TReflectionServices.GetObjectPropertyNamesExcept(Self, ExceptionalFieldNames);

  try

    for PropName in ObjectPropNames do begin

      if
        TReflectionServices.GetObjectPropertyValue(Self, PropName)
        <>
        TReflectionServices.GetObjectPropertyValue(BaseDomainObject, PropName)
      then begin

        Result := False;
        Exit;

      end;

    end;

    Result := True;
    
  finally

    FreeAndNil(ObjectPropNames);

  end;
  
end;

procedure TDomainObjectBase.PropertyHandlerForCloneMethod(
  PropertyInfo: TPropInfo;
  FirstDomainObject, SecondDomainObject: TDomainObjectBase;
  var PropertyHandlerResult: Variant;
  var FinishLoop: Boolean
);
var PropertyName: String;
    PropertyObject,
    OtherPropertyObject, OtherPropertyClonedObject: TObject;
    I: Integer;
begin

  if not Assigned(PropertyInfo.SetProc) then
    Exit;

  PropertyName := PropertyInfo.Name;
    
  case PropertyInfo.PropType^.Kind of

    tkInteger, tkEnumeration:

      SetOrdProp(
        FirstDomainObject, PropertyName,
        GetOrdProp(SecondDomainObject, PropertyName)
      );

    tkSet:


      SetSetProp(
        FirstDomainObject, PropertyName,
        GetSetProp(SecondDomainObject, PropertyName)
      );

    tkString, tkLString, tkWString {$IF CompilerVersion >= 21.0}, tkUString {$IFEND}:

      SetStrProp(
        FirstDomainObject, PropertyName,
        GetStrProp(SecondDomainObject, PropertyName)
      );

    tkVariant:

      SetVariantProp(
        FirstDomainObject, PropertyName,
        GetVariantProp(SecondDomainObject, PropertyName)
      );

    tkFloat:

      SetFloatProp(
        FirstDomainObject, PropertyName,
        GetFloatProp(SecondDomainObject, PropertyName)
      );

    tkInt64:

      SetInt64Prop(
        FirstDomainObject, PropertyName,
        GetInt64Prop(SecondDomainObject, PropertyName)
      );

    tkClass, tkInterface:
    begin
          
      PropertyObject := GetObjectProp(FirstDomainObject, PropertyName);
      OtherPropertyObject := GetObjectProp(SecondDomainObject, PropertyName);

      if not Assigned(OtherPropertyObject) then begin

        if Assigned(PropertyObject) then
         { FreeNestedBaseDomainObject(PropertyObject as TDomainObjectBase) };

        SetObjectProp(FirstDomainObject, PropertyName, nil);

      end

      else if (OtherPropertyObject is TDomainObjectBase) or
              (OtherPropertyObject is TDomainObjectList)
      then begin

        if Assigned(PropertyObject) then
         { FreeNestedBaseDomainObject(PropertyObject as TDomainObjectBase) };

        if OtherPropertyObject is TDomainObjectBase then
          OtherPropertyClonedObject :=
            (OtherPropertyObject as TDomainObjectBase).Clone;

        if OtherPropertyObject is TDomainObjectBaseList then
          OtherPropertyClonedObject :=
            (OtherPropertyObject as TDomainObjectBaseList).Clone;
            
        SetObjectProp(
          FirstDomainObject, PropertyName,
          OtherPropertyClonedObject
        );

      end

      else
        SetObjectProp(
          FirstDomainObject, PropertyName, OtherPropertyObject
        );

    end;

  end;

end;

procedure TDomainObjectBase.PropertyHandlerForCopyMethods(
  PropertyInfo: TPropInfo;
  FirstDomainObject, SecondDomainObject: TDomainObjectBase;
  var PropertyHandlerResult: Variant;
  var FinishLoop: Boolean
);
var PropertyName: String;
    PropertyObject, OtherPropertyObject: TObject;
begin

  if not Assigned(PropertyInfo.SetProc) then
    Exit;

  PropertyName := PropertyInfo.Name;

  case PropertyInfo.PropType^.Kind of

    tkInteger, tkEnumeration:

      SetOrdProp(
        FirstDomainObject, PropertyName,
        GetOrdProp(SecondDomainObject, PropertyName)
      );

    tkSet:

      SetSetProp(
        FirstDomainObject, PropertyName,
        GetSetProp(SecondDomainObject, PropertyName)
      );

    tkString, tkLString, tkWString {$IF CompilerVersion >= 21.0}, tkUString {$IFEND}:

      SetStrProp(
        FirstDomainObject, PropertyName,
        GetStrProp(SecondDomainObject, PropertyName)
      );

    tkVariant:

      SetVariantProp(
        FirstDomainObject, PropertyName,
        GetVariantProp(SecondDomainObject, PropertyName)
      );

    tkFloat:

      SetFloatProp(
        FirstDomainObject, PropertyName,
        GetFloatProp(SecondDomainObject, PropertyName)
      );

    tkInt64:

      SetInt64Prop(
        FirstDomainObject, PropertyName,
        GetInt64Prop(SecondDomainObject, PropertyName)
      );

    tkClass, tkInterface:
    begin

      PropertyObject := GetObjectProp(FirstDomainObject, PropertyName);
      OtherPropertyObject := GetObjectProp(SecondDomainObject, PropertyName);

      if (not Assigned(OtherPropertyObject)) or
         ((not (OtherPropertyObject is TDomainObjectBase)) or
         (PropertyHandlerResult = cmShallow))
      then  begin

        if Assigned(PropertyObject) and
           (PropertyObject is TDomainObjectBase)
        then
         { FreeNestedBaseDomainObject(PropertyObject as TDomainObjectBase) };

        SetObjectProp(
          FirstDomainObject, PropertyName, OtherPropertyObject
        );

      end

      else begin

        if not Assigned(PropertyObject) then begin

          PropertyObject :=
            (OtherPropertyObject as TDomainObjectBase).CreateNewInstance;

          SetObjectProp(FirstDomainObject, PropertyName, PropertyObject);

        end;

        (PropertyObject as TDomainObjectBase).
          DeepCopyFrom(OtherPropertyObject);

      end;

    end;

  end;

end;

procedure TDomainObjectBase.PropertyHandlerForEqualsMethod(
  PropertyInfo: TPropInfo;
  FirstDomainObject, SecondDomainObject: TDomainObjectBase;
  var PropertyHandlerResult: Variant;
  var FinishLoop: Boolean
);
var ArePropertiesEqualed: Boolean;
    PropertyObject, OtherPropertyObject: TObject;
    PropertyName: String;
begin

  PropertyName := PropertyInfo.Name;

  case PropertyInfo.PropType^.Kind of

    tkInteger, tkEnumeration:

      ArePropertiesEqualed :=

        GetOrdProp(FirstDomainObject, PropertyName) =
        GetOrdProp(SecondDomainObject, PropertyName);

    tkSet:

      ArePropertiesEqualed :=
        GetSetProp(FirstDomainObject, PropertyName) =
        GetSetProp(SecondDomainObject, PropertyName);
        
    tkString, tkLString, tkWString {$IF CompilerVersion >= 21.0}, tkUString {$IFEND}:

      ArePropertiesEqualed :=
        GetStrProp(FirstDomainObject, PropertyName) =
        GetStrProp(SecondDomainObject, PropertyName);

    tkVariant:

      ArePropertiesEqualed :=
        GetVariantProp(FirstDomainObject, PropertyName) =
        GetVariantProp(SecondDomainObject, PropertyName);

    tkFloat:

      ArePropertiesEqualed :=
        GetFloatProp(FirstDomainObject, PropertyName) =
        GetFloatProp(SecondDomainObject, PropertyName);

    tkInt64:

      ArePropertiesEqualed :=
        GetInt64Prop(FirstDomainObject, PropertyName) =
        GetInt64Prop(SecondDomainObject, PropertyName);

    tkClass, tkInterface:
    begin

      PropertyObject := GetObjectProp(FirstDomainObject, PropertyName);
      OtherPropertyObject := GetObjectProp(SecondDomainObject, PropertyName);

      if Assigned(PropertyObject) and
         (PropertyObject is TDomainObjectBase) and
         Assigned(OtherPropertyObject)
      then ArePropertiesEqualed :=
            (PropertyObject as TDomainObjectBase).Equals(OtherPropertyObject)

      else ArePropertiesEqualed := OtherPropertyObject = PropertyObject;

    end;

  end;

  PropertyHandlerResult := PropertyHandlerResult and ArePropertiesEqualed;

  FinishLoop := not ArePropertiesEqualed;

end;

procedure TDomainObjectBase.PropertyHandlerForFreeNestedBaseDomainObjectMethod(
  PropertyInfo: TPropInfo;
  FirstDomainObject, SecondDomainObject: TDomainObjectBase;
  var PropertyHandlerResult: Variant;
  var FinishLoop: Boolean);
var DomainObjectBase: TObject;
begin

  if (PropertyInfo.PropType^.Kind <> tkClass) then Exit;

  DomainObjectBase := GetObjectProp(FirstDomainObject, PropertyInfo.Name);

  if Assigned(DomainObjectBase)
     and (
      (DomainObjectBase is TDomainObjectBase)
      {or (DomainObjectBase is TDomainObjectBaseList)}
     )
  then begin


    if DomainObjectBase is TDomainObjectBase then
      FreeNestedBaseDomainObject(DomainObjectBase as TDomainObjectBase)
    {
    else
      FreeNestedBaseDomainObjectList(DomainObjectBase as TDomainObjectBaseList);
    }
      
  end;

end;

procedure TDomainObjectBase.RaiseExceptionIfInvariantsComplianceRequested(
  const Msg: String);
begin

  RaiseExceptionIfInvariantsComplianceRequested(TDomainException, Msg);
  
end;

procedure TDomainObjectBase.RaiseExceptionIfInvariantsComplianceRequested(
  ExceptionType: TDomainExceptionClass;
  const Msg: String
);
begin

  if InvariantsComplianceRequested then
    Raise ExceptionType.Create(Msg);
  
end;

procedure TDomainObjectBase.RaiseExceptionIfInvariantsComplianceRequested(
  const Msg: String;
  const Args: array of const
);
begin

  RaiseExceptionIfInvariantsComplianceRequested(TDomainException, Msg, Args);

end;

procedure TDomainObjectBase.RaiseExceptionIfInvariantsComplianceRequested(
  ExceptionType: TDomainExceptionClass;
  const Msg: String;
  const Args: array of const
);
begin

  Raise ExceptionType.CreateFmt(Msg, Args);
  
end;

procedure TDomainObjectBase.RunPropertyHandlingLoopFor(
  FirstDomainObject,
  SecondDomainObject: TDomainObjectBase;
  PropertyHandler: TPropertyHandler;
  var PropertyHandlerResult: Variant;
  const DefaultPropertyHandlerResult: Variant
);
var PropertyList: PPropList;
    ClassTypeData: PTypeData;
    PropertyInfo: TPropInfo;
    PropertyName: String;
    PropertyObject, OtherPropertyObject: TObject;
    FinishLoop: Boolean;
    I: Integer;
begin

  FinishLoop := False;

  ClassTypeData := GetTypeData(ClassInfo);

  try

    GetMem(PropertyList, SizeOf(PPropInfo) * ClassTypeData.PropCount);

    GetPropList(ClassInfo, tkProperties, PropertyList);

    if ClassTypeData.PropCount = 0 then begin

      PropertyHandlerResult := DefaultPropertyHandlerResult;
      Exit;
      
    end;

    for I := 0 to ClassTypeData.PropCount - 1 do begin

      PropertyInfo := PropertyList[I]^;

      PropertyHandler(
        PropertyInfo,
        FirstDomainObject, SecondDomainObject,
        PropertyHandlerResult,
        FinishLoop
      );

      if FinishLoop then
        Exit;

    end;

  finally

    FreeMem(PropertyList);

  end;

end;

procedure TDomainObjectBase.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  FInvariantsComplianceRequested := Value;

end;

procedure TDomainObjectBase.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  const Msg: String
  );
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(Msg);

end;

procedure TDomainObjectBase.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  ExceptionType: TDomainExceptionClass;
  const Msg: String
);
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(ExceptionType, Msg);

end;

procedure TDomainObjectBase.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  const Msg: String;
  const Args: array of const
);
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(Msg, Args);

end;

procedure TDomainObjectBase.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean;
  ExceptionType: TDomainExceptionClass;
  const Msg: String;
  const Args: array of const
);
begin

  if Condition then
    RaiseExceptionIfInvariantsComplianceRequested(ExceptionType, Msg, Args);

end;

end.
