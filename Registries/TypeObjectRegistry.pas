unit TypeObjectRegistry;

interface

uses

  AbstractObjectRegistry,
  IGetSelfUnit,
  ObjectClasses,
  Hashes,
  SysUtils,
  Classes;

type

  ITypeObjectRegistrationOptions = interface (IGetSelf)

    function AllowObjectUsingByTypeInheritance: Boolean; overload;

    function AllowObjectUsingByTypeInheritance(
      Value: Boolean
    ): ITypeObjectRegistrationOptions; overload;

  end;

  TTypeObjectRegistrationOptions =
    class (TInterfacedObject, ITypeObjectRegistrationOptions)

      protected

        FAllowObjectUsingByTypeInheritance: Boolean;
        
      public

        function AllowObjectUsingByTypeInheritance: Boolean; overload;

        function AllowObjectUsingByTypeInheritance(
          Value: Boolean
        ): ITypeObjectRegistrationOptions; overload;

      public

        function GetSelf: TObject;

    end;

  TRegisteredObjectsLifeTimeOption = (
    ltoFreeRegisteredObjectsOnDestroy,
    ltoNotFreeRegisteredObjectsOnDestroy
  );

  ITypeObjectRegistryItem = interface

    function ObjectClass: TClass;
    function RegistryObject: TObject;
    function RegistryInterface: IInterface;

  end;

  TTypeObjectRegistryItem = class (TInterfacedObject, ITypeObjectRegistryItem)

    private

      FItem: IObjectRegistryItem;
      
      constructor Create(Item: IObjectRegistryItem);
      
    public

      function ObjectClass: TClass;
      function RegistryObject: TObject;
      function RegistryInterface: IInterface;

  end;

  TTypeObjectRegistry = class;
  
  TTypeObjectRegistryEnumerator = class

    private

      FTypeObjectRegistry: TTypeObjectRegistry;
      FObjectRegistryEnumerator: TObjectRegistryEnumerator;
      
      function GetCurrentTypeObjectRegistryItem: ITypeObjectRegistryItem;
      
    public

      destructor Destroy; override;
      
      constructor Create(TypeObjectRegistry: TTypeObjectRegistry);
      
      function MoveNext: Boolean;

      property Current: ITypeObjectRegistryItem read GetCurrentTypeObjectRegistryItem;
      
  end;
  
  TTypeObjectRegistry = class

    private

      FObjectRegistry: IObjectRegistry;

    private

      type

        TTypeObjectRegistrationOptionsHolder = class

          TypeObjectRegistrationOptions: ITypeObjectRegistrationOptions;

          constructor Create(
            TypeObjectRegistrationOptions: ITypeObjectRegistrationOptions
          );

        end;

    private

      FUseSearchByNearestAncestorTypeIfTargetObjectNotFound: Boolean;

      FTypeObjectRegistrationOptionsSet: TObjectHash;

      function GetObjectByNearestAncestorType(RelatedType: TClass): TObject;
      function GetInterfaceByNearestAncestorType(RelatedType: TClass): IInterface; overload;

      function IsTypeObjectRegistrationOptionExists(RelatedType: TClass): Boolean;

      procedure SaveTypeObjectRegistrationOptions(
        RelatedType: TClass;
        Options: ITypeObjectRegistrationOptions
      );

    private

      function GetTypeObjectRegistrationOptionsHolder(RelatedType: TClass): TTypeObjectRegistrationOptionsHolder;

      procedure CreateTypeObjectRegistrationOptionsHolder(
        RelatedType: TClass; Options: ITypeObjectRegistrationOptions
      );

      procedure RemoveTypeObjectRegistrationOptionsHolder(RelatedType: TClass);
      
    public

      destructor Destroy; override;
      constructor Create(ObjectRegistry: IObjectRegistry);

    public

      procedure RegisterObject(
        RelatedType: TClass;
        TargetObject: TObject;
        Options: ITypeObjectRegistrationOptions = nil
      ); overload;

      procedure RegisterObject(
        RelatedTypes: array of TClass;
        TargetObject: TObject
      ); overload;
      
      procedure RegisterInterface(
        RelatedType: TClass;
        TargetInterface: IInterface;
        Options: ITypeObjectRegistrationOptions = nil
      ); overload;

      procedure RegisterInterface(
        RelatedTypes: array of TClass;
        TargetInterface: IInterface
      ); overload;

      procedure UnregisterObject(RelatedType: TClass);
      procedure UnregisterInterface(RelatedType: TClass);

      function IsObjectExists(RelatedType: TClass): Boolean;
      function IsInterfaceExists(RelatedType: TClass): Boolean;

      function GetTypes: TClasses;

      function GetObject(RelatedType: TClass): TObject; overload;
      function GetObject(RelatedTypes: array of TClass): TObject; overload;

      function GetInterface(RelatedType: TClass): IInterface; overload;
      procedure GetInterface(RelatedType: TClass; const GUID: TGUID; out Result); overload; virtual;
      function GetInterface(RelatedTypes: array of TClass): IInterface; overload;

      function GetTypeObjectRegistrationOptions(RelatedType: TClass): ITypeObjectRegistrationOptions;

      procedure Clear;

      function Count: Integer;
      
      function GetTypeObjectRegistryItem(ObjectClass: TClass): ITypeObjectRegistryItem;

      function GetEnumerator: TTypeObjectRegistryEnumerator;

      property Items[ObjectClass: TClass]: ITypeObjectRegistryItem
      read GetTypeObjectRegistryItem; default;

    public

      class function CreateInMemoryTypeObjectRegistry(
        const Option: TRegisteredObjectsLifeTimeOption = ltoNotFreeRegisteredObjectsOnDestroy
      ): TTypeObjectRegistry; static;
      
    public

      property UseSearchByNearestAncestorTypeIfTargetObjectNotFound: Boolean
      read FUseSearchByNearestAncestorTypeIfTargetObjectNotFound
      write FUseSearchByNearestAncestorTypeIfTargetObjectNotFound;

  end;

implementation

uses

  InMemoryObjectRegistry;

{ TTypeObjectRegistrationOptions }

function TTypeObjectRegistrationOptions.AllowObjectUsingByTypeInheritance: Boolean;
begin

  Result := FAllowObjectUsingByTypeInheritance;

end;

function TTypeObjectRegistrationOptions.AllowObjectUsingByTypeInheritance(
  Value: Boolean): ITypeObjectRegistrationOptions;
begin

  FAllowObjectUsingByTypeInheritance := Value;

  Result := Self;
  
end;

function TTypeObjectRegistrationOptions.GetSelf: TObject;
begin

  Result := Self;

end;

{ TTypeObjectRegistry }

procedure TTypeObjectRegistry.Clear;
begin

  FObjectRegistry.Clear;

end;

function TTypeObjectRegistry.Count: Integer;
begin

  Result := FObjectRegistry.Count;
  
end;

constructor TTypeObjectRegistry.Create(ObjectRegistry: IObjectRegistry);
begin

  inherited Create;

  FObjectRegistry := ObjectRegistry;
  FTypeObjectRegistrationOptionsSet := TObjectHash.Create;
  
end;

class function TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(
  const Option: TRegisteredObjectsLifeTimeOption
): TTypeObjectRegistry;
var InMemoryObjectRegistry: TInMemoryObjectRegistry;
begin

  InMemoryObjectRegistry := TInMemoryObjectRegistry.Create;

  if Option = ltoFreeRegisteredObjectsOnDestroy then
    InMemoryObjectRegistry.FreeRegisteredObjectsOnDestroy := True

  else InMemoryObjectRegistry.FreeRegisteredObjectsOnDestroy := False;

  Result := TTypeObjectRegistry.Create(InMemoryObjectRegistry);

end;

procedure TTypeObjectRegistry.CreateTypeObjectRegistrationOptionsHolder(
  RelatedType: TClass; Options: ITypeObjectRegistrationOptions);
begin

  FTypeObjectRegistrationOptionsSet[RelatedType.ClassName] :=
    TTypeObjectRegistrationOptionsHolder.Create(Options);
    
end;

destructor TTypeObjectRegistry.Destroy;
begin

  FreeAndNil(FTypeObjectRegistrationOptionsSet);
  
  inherited;

end;

function TTypeObjectRegistry.GetInterface(RelatedType: TClass): IInterface;
begin

  Result := FObjectRegistry.GetInterface(TObjectRegistryClassKey.From(RelatedType));

  if
    Assigned(Result)
    or not UseSearchByNearestAncestorTypeIfTargetObjectNotFound
  then Exit;

  Result := GetInterfaceByNearestAncestorType(RelatedType);
  
end;

function TTypeObjectRegistry.GetEnumerator: TTypeObjectRegistryEnumerator;
begin

  Result := TTypeObjectRegistryEnumerator.Create(Self);

end;

procedure TTypeObjectRegistry.GetInterface(
  RelatedType: TClass;
  const GUID: TGUID;
  out Result
);
var
    Int: IInterface;
begin

  Int := GetInterface(RelatedType);

  if Assigned(Int) then
    Supports(Int, GUID, Result);
    
end;

function TTypeObjectRegistry.GetInterfaceByNearestAncestorType(
  RelatedType: TClass
): IInterface;
var NearestAncestorType: TClass;
    TypeObjectRegistrationOptions: ITypeObjectRegistrationOptions;
begin

  NearestAncestorType := RelatedType.ClassParent;

  while Assigned(NearestAncestorType) do begin

    if IsTypeObjectRegistrationOptionExists(NearestAncestorType) then begin

      TypeObjectRegistrationOptions :=
        GetTypeObjectRegistrationOptions(NearestAncestorType);

      if TypeObjectRegistrationOptions.AllowObjectUsingByTypeInheritance
      then begin
      
        Result :=
          FObjectRegistry
            .GetInterface(TObjectRegistryClassKey.From(NearestAncestorType));

      end

      else Result := nil;

      Exit;

    end;

    NearestAncestorType := NearestAncestorType.ClassParent;

  end;

  Result := nil;

end;

function TTypeObjectRegistry.GetObject(RelatedType: TClass): TObject;
begin

  Result :=
    FObjectRegistry.GetObject(TObjectRegistryClassKey.From(RelatedType));

  if
    Assigned(Result) or
    not UseSearchByNearestAncestorTypeIfTargetObjectNotFound
  then Exit;

  Result := GetObjectByNearestAncestorType(RelatedType);

end;

function TTypeObjectRegistry.GetObject(RelatedTypes: array of TClass): TObject;
begin

  Result :=
    FObjectRegistry.GetObject(TObjectRegistryClassCombinationKey.From(RelatedTypes));

end;

function TTypeObjectRegistry.GetObjectByNearestAncestorType(
  RelatedType: TClass): TObject;
var NearestAncestorType: TClass;
    TypeObjectRegistrationOptions: ITypeObjectRegistrationOptions;
begin

  NearestAncestorType := RelatedType.ClassParent;

  while Assigned(NearestAncestorType) do begin

    if IsTypeObjectRegistrationOptionExists(NearestAncestorType) then begin

      TypeObjectRegistrationOptions :=
        GetTypeObjectRegistrationOptions(NearestAncestorType);

      if TypeObjectRegistrationOptions.AllowObjectUsingByTypeInheritance
      then begin
      
        Result :=
          FObjectRegistry
            .GetObject(TObjectRegistryClassKey.From(NearestAncestorType));

      end

      else Result := nil;

      Exit;

    end;

    NearestAncestorType := NearestAncestorType.ClassParent;

  end;

  Result := nil;
  
end;

function TTypeObjectRegistry.
  GetTypeObjectRegistrationOptions(
    RelatedType: TClass
  ): ITypeObjectRegistrationOptions;
var OptionsHolder: TTypeObjectRegistrationOptionsHolder;
begin

  OptionsHolder := GetTypeObjectRegistrationOptionsHolder(RelatedType);

  if Assigned(OptionsHolder) then
    Result := OptionsHolder.TypeObjectRegistrationOptions

  else Result := nil;
  
end;

function TTypeObjectRegistry.GetTypeObjectRegistrationOptionsHolder(
  RelatedType: TClass): TTypeObjectRegistrationOptionsHolder;
begin

  if not FTypeObjectRegistrationOptionsSet.Exists(RelatedType.ClassName) then
    Result := nil

  else begin

    Result :=
      TTypeObjectRegistrationOptionsHolder(
        FTypeObjectRegistrationOptionsSet[RelatedType.ClassName]
      );

  end;
  
end;

function TTypeObjectRegistry.GetTypeObjectRegistryItem(
  ObjectClass: TClass): ITypeObjectRegistryItem;
begin

  Result :=
    TTypeObjectRegistryItem.Create(
      FObjectRegistry[
        TObjectRegistryClassKey.From(ObjectClass)
      ]
    );
  
end;

function TTypeObjectRegistry.GetTypes: TClasses;
var
    Key: IObjectRegistryKey;
    Keys: TObjectRegistryKeys;
begin

  Keys := FObjectRegistry.GetKeys;
  
  try

    Result := TClasses.Create;
    
    try

      for Key in Keys do
        Result.Add(TObjectRegistryClassKey(Key.Self).ObjectClass);

    except

      FreeAndNil(Result);

      Raise;

    end;
      
  finally

    FreeAndNil(Keys);

  end;

end;

function TTypeObjectRegistry.IsInterfaceExists(RelatedType: TClass): Boolean;
begin

  Result := Assigned(GetInterface(RelatedType));
  
end;

function TTypeObjectRegistry.IsObjectExists(RelatedType: TClass): Boolean;
begin

  Result :=
    FObjectRegistry.IsObjectExists(TObjectRegistryClassKey.From(RelatedType));

end;

function TTypeObjectRegistry.IsTypeObjectRegistrationOptionExists(
  RelatedType: TClass): Boolean;
begin

  Result := Assigned(GetTypeObjectRegistrationOptionsHolder(RelatedType));

end;

procedure TTypeObjectRegistry.RegisterInterface(
  RelatedType: TClass;
  TargetInterface: IInterface;
  Options: ITypeObjectRegistrationOptions
);
begin

  FObjectRegistry.RegisterInterface(
    TObjectRegistryClassKey.From(RelatedType),
    TargetInterface
  );

  SaveTypeObjectRegistrationOptions(RelatedType, Options);
  
end;

procedure TTypeObjectRegistry.RegisterObject(
  RelatedType: TClass;
  TargetObject: TObject;
  Options: ITypeObjectRegistrationOptions
);
begin

  FObjectRegistry.RegisterObject(
    TObjectRegistryClassKey.From(RelatedType),
    TargetObject
  );

  SaveTypeObjectRegistrationOptions(RelatedType, Options);

end;

procedure TTypeObjectRegistry.RemoveTypeObjectRegistrationOptionsHolder(
  RelatedType: TClass);
begin

  FTypeObjectRegistrationOptionsSet.Delete(RelatedType.ClassName);

end;

procedure TTypeObjectRegistry.SaveTypeObjectRegistrationOptions(
  RelatedType: TClass; Options: ITypeObjectRegistrationOptions
);
var OptionsHolder: TTypeObjectRegistrationOptionsHolder;
begin

  if not Assigned(Options) then begin

    Options := TTypeObjectRegistrationOptions.Create;

    Options.AllowObjectUsingByTypeInheritance(
      UseSearchByNearestAncestorTypeIfTargetObjectNotFound
    );

  end;

  OptionsHolder := GetTypeObjectRegistrationOptionsHolder(RelatedType);

  if Assigned(OptionsHolder) then
    OptionsHolder.TypeObjectRegistrationOptions := Options

  else CreateTypeObjectRegistrationOptionsHolder(RelatedType, Options);
  
end;

procedure TTypeObjectRegistry.UnregisterInterface(RelatedType: TClass);
begin

  FObjectRegistry.UnregisterInterface(TObjectRegistryClassKey.From(RelatedType));

  RemoveTypeObjectRegistrationOptionsHolder(RelatedType);

end;

procedure TTypeObjectRegistry.UnregisterObject(RelatedType: TClass);
begin

  FObjectRegistry.UnregisterObject(TObjectRegistryClassKey.From(RelatedType));

  RemoveTypeObjectRegistrationOptionsHolder(RelatedType);
  
end;

function TTypeObjectRegistry.GetInterface(
  RelatedTypes: array of TClass): IInterface;
begin

  Result := FObjectRegistry.GetInterface(TObjectRegistryClassCombinationKey.From(RelatedTypes));

end;

procedure TTypeObjectRegistry.RegisterInterface(RelatedTypes: array of TClass;
  TargetInterface: IInterface);
begin

  FObjectRegistry.RegisterInterface(
    TObjectRegistryClassCombinationKey.From(RelatedTypes),
    TargetInterface
  );

end;

procedure TTypeObjectRegistry.RegisterObject(RelatedTypes: array of TClass;
  TargetObject: TObject);
begin

  FObjectRegistry.RegisterObject(
    TObjectRegistryClassCombinationKey.From(RelatedTypes),
    TargetObject
  );

end;

{ TTypeObjectRegistry.TTypeObjectRegistrationOptionsHolder }

constructor TTypeObjectRegistry.TTypeObjectRegistrationOptionsHolder.Create(
  TypeObjectRegistrationOptions: ITypeObjectRegistrationOptions);
begin

  inherited Create;

  Self.TypeObjectRegistrationOptions := TypeObjectRegistrationOptions;
  
end;

{ TTypeObjectRegistryItem }

constructor TTypeObjectRegistryItem.Create(Item: IObjectRegistryItem);
begin

  inherited Create;

  FItem := Item;

end;

function TTypeObjectRegistryItem.RegistryInterface: IInterface;
begin

  Result := FItem.RegistryInterface;

end;

function TTypeObjectRegistryItem.RegistryObject: TObject;
begin

  Result := FItem.RegistryObject;

end;

function TTypeObjectRegistryItem.ObjectClass: TClass;
begin

  Result := TObjectRegistryClassKey(FItem.RegistryKey.Self).ObjectClass;
  
end;

{ TTypeObjectRegistryEnumerator }

constructor TTypeObjectRegistryEnumerator.Create(
  TypeObjectRegistry: TTypeObjectRegistry
);
begin

  inherited Create;

  FTypeObjectRegistry := TypeObjectRegistry;
  FObjectRegistryEnumerator := TypeObjectRegistry.FObjectRegistry.GetEnumerator;
  
end;

destructor TTypeObjectRegistryEnumerator.Destroy;
begin

  inherited;

end;

function TTypeObjectRegistryEnumerator.
  GetCurrentTypeObjectRegistryItem: ITypeObjectRegistryItem;
begin

  Result :=
    FTypeObjectRegistry[
      TObjectRegistryClassKey(
        FObjectRegistryEnumerator.Current.RegistryKey.Self
      ).ObjectClass
    ];
    
end;

function TTypeObjectRegistryEnumerator.MoveNext: Boolean;
begin

  Result := FObjectRegistryEnumerator.MoveNext;
  
end;

end.
