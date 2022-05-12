unit AbstractObjectRegistry;

interface

uses

  IGetSelfUnit,
  SysUtils,
  VariantListUnit,
  Classes;

type

  IObjectRegistryKey = interface (IGetSelf)

    function Equals(OtherKey: IObjectRegistryKey): Boolean;

  end;
  
  TAbstractObjectRegistryKey = class abstract (TInterfacedObject, IObjectRegistryKey)

    public

      function Equals(OtherKey: IObjectRegistryKey): Boolean; virtual; abstract;

      function GetSelf: TObject;

  end;

  TObjectRegistryVariantKey = class (TAbstractObjectRegistryKey)

    protected

      FVariant: Variant;
      
    public

      constructor From(VariantValue: Variant);

      function Equals(OtherKey: IObjectRegistryKey): Boolean; override;

  end;

  TObjectRegistryPointerKey = class (TAbstractObjectRegistryKey)

    protected

      FPointer: Pointer;

    public

      constructor From(PointerValue: Pointer); overload;

      function Equals(OtherKey: IObjectRegistryKey): Boolean; override;

  end;

  TObjectRegistryClassKey = class (TAbstractObjectRegistryKey)

    protected

      FClass: TClass;

    public

      constructor From(ClassValue: TClass);

      property ObjectClass: TClass read FClass;
      
      function Equals(OtherKey: IObjectRegistryKey): Boolean; override;

  end;

  TObjectRegistryClassCombinationKey = class (TAbstractObjectRegistryKey)

    protected

      FClassList: TVariantList;

    public

      constructor From(Classes: array of TClass); overload;
      constructor From(ClassList: TVariantList); overload;

      property ClassList: TVariantList read FClassList;

      function Equals(OtherKey: IObjectRegistryKey): Boolean; override;
      
  end;

  TObjectRegistryKeys = class;

  TObjectRegistryKeysEnumerator = class (TListEnumerator)

    private

      function GetCurrentObjectRegistryKey: IObjectRegistryKey;

    public

      constructor Create(ObjectRegistryKeys: TObjectRegistryKeys);

      property Current: IObjectRegistryKey read GetCurrentObjectRegistryKey;

  end;
  
  TObjectRegistryKeys = class (TList)

    private

      type

        TKeyHolder = class

          Key: IObjectRegistryKey;

          constructor Create(Key: IObjectRegistryKey);
          
        end;

    private


      function GetObjectRegistryKeyByIndex(Index: Integer): IObjectRegistryKey;
      
      function AddKeyHolder(Key: IObjectRegistryKey): Integer;
      function FindKeyHolder(key: IObjectRegistryKey): TKeyHolder;
      function FindKeyHolderIndex(Key: IObjectRegistryKey): Integer;

      procedure RaiseExceptionIfKeyAlreadyExists(Key: IObjectRegistryKey);

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;
      
    public

      function Add(Key: IObjectRegistryKey): Integer;
      procedure Remove(Key: IObjectRegistryKey);
      function ContainsKey(Key: IObjectRegistryKey): Boolean;
      
      function GetEnumerator: TObjectRegistryKeysEnumerator;

      property Items[Index: Integer]: IObjectRegistryKey
      read GetObjectRegistryKeyByIndex; default;
      
  end;

  TObjectRegistryException = class (Exception)


  end;

  TObjectRegistryItem = class

    RegistryKey: IObjectRegistryKey;
    RegistryObject: TObject;
    RegistryInterface: IInterface;

    destructor Destroy; override;

    constructor Create(
      RegistryKey: IObjectRegistryKey;
      RegistryObject: TObject;
      RegistryInterface: IInterface
    );

  end;

  IObjectRegistryItem = interface

    function RegistryKey: IObjectRegistryKey;
    function RegistryObject: TObject;
    function RegistryInterface: IInterface;

  end;

  TGuardedObjectRegistryItem = class (TInterfacedObject, IObjectRegistryItem)

    private

      FItem: TObjectRegistryItem;

      constructor Create(Item: TObjectRegistryItem);
      
    public

      function RegistryKey: IObjectRegistryKey;
      function RegistryObject: TObject;
      function RegistryInterface: IInterface;

  end;

  IObjectRegistry = interface;
  
  TObjectRegistryEnumerator = class

    private

      FObjectRegistry: IObjectRegistry;
      FRegistryKeys: TObjectRegistryKeys;
      FRegistryKeysEnumerator: TObjectRegistryKeysEnumerator;
      
      function GetCurrentObjectRegistryItem: IObjectRegistryItem;

    public

      destructor Destroy; override;
      
      constructor Create(ObjectRegistry: IObjectRegistry);

      function MoveNext: Boolean;
      property Current: IObjectRegistryItem read GetCurrentObjectRegistryItem;

  end;

  IObjectRegistry = interface (IInterface)

    procedure RegisterObject(
      RegistryKey: IObjectRegistryKey;
      RegistryObject: TObject
    );

    procedure UnregisterObject(RegistryKey: IObjectRegistryKey);

    function IsObjectExists(RegistryKey: IObjectRegistryKey): Boolean;
    
    function GetObject(RegistryKey: IObjectRegistryKey): TObject;

    procedure RegisterInterface(
      RegistryKey: IObjectRegistryKey;
      RegistryInterface: IInterface
    );

    procedure UnregisterInterface(RegistryKey: IObjectRegistryKey);

    function GetInterface(RegistryKey: IObjectRegistryKey): IInterface; overload;
    procedure GetInterface(RegistryKey: IObjectRegistryKey; const GUID: TGUID; out Result); overload;

    procedure Clear;

    function Count: Integer;

    function GetKeys: TObjectRegistryKeys;
    
    function GetObjectRegistryItem(Key: IObjectRegistryKey): IObjectRegistryItem;

    function GetEnumerator: TObjectRegistryEnumerator;
    
    property Items[Key: IObjectRegistryKey]: IObjectRegistryItem
    read GetObjectRegistryItem; default;

  end;

  TAbstractObjectRegistry = class abstract (TInterfacedObject, IObjectRegistry)

    private

      FFreeRegisteredObjectsOnDestroy: Boolean;
      
    protected

      function FindObjectRegistryItem(
        RegistryKey: IObjectRegistryKey
      ): TObjectRegistryItem; virtual; abstract;

      procedure AddObjectRegistryItem(
        ObjectRegistryItem: TObjectRegistryItem
      ); virtual; abstract;

      procedure RemoveObjectRegistryItem(
        RegistryKey: IObjectRegistryKey
      ); virtual; abstract;
      
      procedure AssignRegistryObject(
        RegistryItem: TObjectRegistryItem;
        RegistryObject: TObject
      ); virtual;

      procedure AssignRegistryInterface(
        RegistryItem: TObjectRegistryItem;
        RegistryInterface: IInterface
      ); virtual;
      
    public

      function GetSelf: TObject;
      
      procedure RegisterObject(
        RegistryKey: IObjectRegistryKey;
        RegistryObject: TObject
      ); virtual;

      procedure UnregisterObject(RegistryKey: IObjectRegistryKey); virtual;

      function IsObjectExists(RegistryKey: IObjectRegistryKey): Boolean; virtual;
      
      function GetObject(RegistryKey: IObjectRegistryKey): TObject; virtual;

      procedure RegisterInterface(
        RegistryKey: IObjectRegistryKey;
        RegistryInterface: IInterface
      ); virtual;

      procedure UnregisterInterface(RegistryKey: IObjectRegistryKey); virtual;
      
      function GetInterface(RegistryKey: IObjectRegistryKey): IInterface; overload; virtual;
      procedure GetInterface(RegistryKey: IObjectRegistryKey; const GUID: TGUID; out Result); overload; virtual;
      
      procedure Clear; virtual; abstract;

    public
    
      function Count: Integer; virtual; abstract;

      function GetKeys: TObjectRegistryKeys; virtual; abstract;
    
      function GetObjectRegistryItem(Key: IObjectRegistryKey): IObjectRegistryItem;

      function GetEnumerator: TObjectRegistryEnumerator;

      property Items[Key: IObjectRegistryKey]: IObjectRegistryItem
      read GetObjectRegistryItem; default;

    public

      property FreeRegisteredObjectsOnDestroy: Boolean
      read FFreeRegisteredObjectsOnDestroy
      write FFreeRegisteredObjectsOnDestroy;


  end;

implementation

uses

  AuxDebugFunctionsUnit;
  
{ TObjectRegistryVariantKey }

constructor TObjectRegistryVariantKey.From(VariantValue: Variant);
begin

  inherited Create;

  FVariant := VariantValue;
  
end;

function TObjectRegistryVariantKey.Equals(
  OtherKey: IObjectRegistryKey
): Boolean;
begin

  Result :=
    Assigned(OtherKey) and
    (OtherKey.Self is TObjectRegistryVariantKey) and
    TObjectRegistryVariantKey(OtherKey).FVariant = FVariant;

end;

{ TObjectRegistryPointerKey }

constructor TObjectRegistryPointerKey.From(PointerValue: Pointer);
begin

  inherited Create;

  FPointer := PointerValue;
  
end;

function TObjectRegistryPointerKey.Equals(
  OtherKey: IObjectRegistryKey): Boolean;
begin

  Result :=
    Assigned(OtherKey) and
    (OtherKey.Self is TObjectRegistryPointerKey) and
    (TObjectRegistryPointerKey(OtherKey.Self).FPointer = FPointer);
    
end;

{ TObjectRegistryClassKey }

constructor TObjectRegistryClassKey.From(ClassValue: TClass);
begin

  inherited Create;

  FClass := ClassValue;
  
end;

function TObjectRegistryClassKey.Equals(OtherKey: IObjectRegistryKey): Boolean;
begin

  Result :=
    Assigned(OtherKey) and
    (OtherKey.Self is TObjectRegistryClassKey) and
    (TObjectRegistryClassKey(OtherKey.Self).FClass = FClass);
    
end;

{ TAbstractObjectRegistry }

procedure TAbstractObjectRegistry.AssignRegistryInterface(
  RegistryItem: TObjectRegistryItem; RegistryInterface: IInterface);
begin

  RegistryItem.RegistryInterface := RegistryInterface;
  
end;

procedure TAbstractObjectRegistry.AssignRegistryObject(
  RegistryItem: TObjectRegistryItem; RegistryObject: TObject);
begin

  if FFreeRegisteredObjectsOnDestroy then
    FreeAndNil(RegistryItem.RegistryObject);
    
  RegistryItem.RegistryObject := RegistryObject;
  
end;

function TAbstractObjectRegistry.GetInterface(
  RegistryKey: IObjectRegistryKey): IInterface;
var RegistryItem: TObjectRegistryItem;
begin

  RegistryItem := FindObjectRegistryItem(RegistryKey);

  if Assigned(RegistryItem) then
    Result := RegistryItem.RegistryInterface

  else Result := nil;
  
end;

function TAbstractObjectRegistry.GetEnumerator: TObjectRegistryEnumerator;
begin

  Result := TObjectRegistryEnumerator.Create(Self);
  
end;

procedure TAbstractObjectRegistry.GetInterface(
  RegistryKey: IObjectRegistryKey;
  const GUID: TGUID;
  out Result
);
var
    Int: IInterface;
begin

  Int := GetInterface(RegistryKey);

  if Assigned(Int) then
    Supports(Int, GUID, Result);

end;

function TAbstractObjectRegistry.GetObject(
  RegistryKey: IObjectRegistryKey): TObject;
var RegistryItem: TObjectRegistryItem;
begin

  RegistryItem := FindObjectRegistryItem(RegistryKey);

  if Assigned(RegistryItem) then
    Result := RegistryItem.RegistryObject

  else Result := nil;

end;

function TAbstractObjectRegistry.GetObjectRegistryItem(
  Key: IObjectRegistryKey): IObjectRegistryItem;
var
    Item: TObjectRegistryItem;
begin

  Item := FindObjectRegistryItem(Key);

  if Assigned(Item) then
    Result := TGuardedObjectRegistryItem.Create(Item)

  else Result := nil;
  
end;

function TAbstractObjectRegistry.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TAbstractObjectRegistry.IsObjectExists(
  RegistryKey: IObjectRegistryKey): Boolean;
begin

  Result := Assigned(GetObject(RegistryKey));
  
end;

procedure TAbstractObjectRegistry.RegisterInterface(
  RegistryKey: IObjectRegistryKey;
  RegistryInterface: IInterface
);
var RegistryItem: TObjectRegistryItem;

begin

  if not Assigned(RegistryKey) then
    raise TObjectRegistryException.Create('Registry key was nil');

  if not Assigned(RegistryInterface) then
    raise TObjectRegistryException.Create('Registry interface was nil');

  RegistryItem := FindObjectRegistryItem(RegistryKey);

  if Assigned(RegistryItem) then
    AssignRegistryInterface(RegistryItem, RegistryInterface)

  else begin

    AddObjectRegistryItem(
      TObjectRegistryItem.Create(
        RegistryKey,
        nil,
        RegistryInterface
      )
    );

  end;
  
end;

procedure TAbstractObjectRegistry.RegisterObject(
  RegistryKey: IObjectRegistryKey;
  RegistryObject: TObject
);
var RegistryItem: TObjectRegistryItem;
begin

  if not Assigned(RegistryKey) then
    raise TObjectRegistryException.Create('Registry key was nil');

  if not Assigned(RegistryObject) then
    raise TObjectRegistryException.Create('Registry object was nil');

  RegistryItem := FindObjectRegistryItem(RegistryKey);

  if Assigned(RegistryItem) then
    AssignRegistryObject(RegistryItem, RegistryObject)

  else begin

    AddObjectRegistryItem(
      TObjectRegistryItem.Create(
        RegistryKey,
        RegistryObject,
        nil
      )
    );

  end;

end;

procedure TAbstractObjectRegistry.UnregisterInterface(
  RegistryKey: IObjectRegistryKey);
begin

  RemoveObjectRegistryItem(RegistryKey);
  
end;

procedure TAbstractObjectRegistry.UnregisterObject(
  RegistryKey: IObjectRegistryKey);
begin

  RemoveObjectRegistryItem(RegistryKey);
  
end;

{ TAbstractObjectRegistry.TObjectRegistryItem }

constructor TObjectRegistryItem.Create(
  RegistryKey: IObjectRegistryKey;
  RegistryObject: TObject;
  RegistryInterface: IInterface
);
begin

  inherited Create;

  Self.RegistryKey := RegistryKey;
  Self.RegistryObject := RegistryObject;
  Self.RegistryInterface := RegistryInterface;
  
end;

{ TAbstractObjectRegistryKey }

function TAbstractObjectRegistryKey.GetSelf: TObject;
begin

  Result := Self;
  
end;

destructor TObjectRegistryItem.Destroy;
begin

  inherited;

end;

{ TObjectRegistryKeysEnumerator }

constructor TObjectRegistryKeysEnumerator.Create(
  ObjectRegistryKeys: TObjectRegistryKeys);
begin

  inherited Create(ObjectRegistryKeys);

end;

function TObjectRegistryKeysEnumerator.GetCurrentObjectRegistryKey: IObjectRegistryKey;
begin

  Result := TObjectRegistryKeys.TKeyHolder(GetCurrent).Key;
  
end;

{ TObjectRegistryKeys.TKeyHolder }

constructor TObjectRegistryKeys.TKeyHolder.Create(Key: IObjectRegistryKey);
begin

  inherited Create;

  Self.Key := Key;
  
end;

{ TObjectRegistryKeys }

function TObjectRegistryKeys.Add(Key: IObjectRegistryKey): Integer;
begin

  AddKeyHolder(Key);
  
end;

function TObjectRegistryKeys.AddKeyHolder(Key: IObjectRegistryKey): Integer;
begin

  RaiseExceptionIfKeyAlreadyExists(Key);

  inherited Add(TKeyHolder.Create(Key));
  
end;

function TObjectRegistryKeys.ContainsKey(Key: IObjectRegistryKey): Boolean;
begin

  Result := Assigned(FindKeyHolder(Key));
  
end;

function TObjectRegistryKeys.FindKeyHolder(key: IObjectRegistryKey): TKeyHolder;
var
    Index: Integer;
begin

  Index := FindKeyHolderIndex(Key);

  if Index >= 0 then
    Result := TKeyHolder(Get(Index))

  else Result := nil;

end;

function TObjectRegistryKeys.FindKeyHolderIndex(
  Key: IObjectRegistryKey
): Integer;
var
    Index: Integer;
    KeyHolder: TKeyHolder;
begin

  for Index := 0 to Count - 1 do begin

    KeyHolder := TKeyHolder(Get(Index));

    if KeyHolder.Key = Key then begin

      Result := Index;
      Exit;

    end;

  end;

  Result := -1;
  
end;

function TObjectRegistryKeys.GetEnumerator: TObjectRegistryKeysEnumerator;
begin

  Result := TObjectRegistryKeysEnumerator.Create(Self);
  
end;

function TObjectRegistryKeys.GetObjectRegistryKeyByIndex(
  Index: Integer): IObjectRegistryKey;
begin

  Result := TKeyHolder(Get(Index)).Key;

end;

procedure TObjectRegistryKeys.Notify(Ptr: Pointer; Action: TListNotification);
begin

  inherited;

  if Action = lnDeleted then
    TKeyHolder(Ptr).Free;
    
end;

procedure TObjectRegistryKeys.RaiseExceptionIfKeyAlreadyExists(
  Key: IObjectRegistryKey);
begin

  if ContainsKey(Key) then
    Raise Exception.Create('Registry key is already exists');
    
end;

procedure TObjectRegistryKeys.Remove(Key: IObjectRegistryKey);
var
    Index: Integer;
begin

  Index := FindKeyHolderIndex(Key);

  if Index >= 0 then
    Delete(Index);
  
end;

{ TObjectRegistryEnumerator }

constructor TObjectRegistryEnumerator.Create(ObjectRegistry: IObjectRegistry);
begin

  inherited Create;

  FObjectRegistry := ObjectRegistry;
  
  FRegistryKeys := ObjectRegistry.GetKeys;

  FRegistryKeysEnumerator := FRegistryKeys.GetEnumerator;
  
end;

destructor TObjectRegistryEnumerator.Destroy;
begin

  FreeAndNil(FRegistryKeysEnumerator);
  FreeAndNil(FRegistryKeys);
  
  inherited;

end;

function TObjectRegistryEnumerator.GetCurrentObjectRegistryItem: IObjectRegistryItem;
begin

  Result := FObjectRegistry[FRegistryKeysEnumerator.Current];
  
end;

function TObjectRegistryEnumerator.MoveNext: Boolean;
begin

  Result := FRegistryKeysEnumerator.MoveNext;
  
end;

{ TGuardedObjectRegistryItem }

constructor TGuardedObjectRegistryItem.Create(Item: TObjectRegistryItem);
begin

  inherited Create;

  FItem := Item;

end;

function TGuardedObjectRegistryItem.RegistryInterface: IInterface;
begin

  Result := FItem.RegistryInterface;

end;

function TGuardedObjectRegistryItem.RegistryKey: IObjectRegistryKey;
begin

  Result := FItem.RegistryKey;

end;

function TGuardedObjectRegistryItem.RegistryObject: TObject;
begin

  Result := FItem.RegistryObject;
  
end;

{ TObjectRegistryClassCombinationKey }

function TObjectRegistryClassCombinationKey.Equals(
  OtherKey: IObjectRegistryKey): Boolean;
begin

  Result :=
    Assigned(OtherKey)
    and (OtherKey.Self is TObjectRegistryClassCombinationKey)
    and FClassList.ContainsAll(TObjectRegistryClassCombinationKey(OtherKey.Self).FClassList);

end;

constructor TObjectRegistryClassCombinationKey.From(Classes: array of TClass);
var
    ClassValue: TClass;
begin

  inherited Create;

  FClassList := TVariantList.Create;

  for ClassValue in Classes do
    FClassList.AddClass(ClassValue);
    
end;

constructor TObjectRegistryClassCombinationKey.From(ClassList: TVariantList);
begin

  inherited Create;

  FClassList := TVariantList.CreateFrom(ClassList);
  
end;

end.
