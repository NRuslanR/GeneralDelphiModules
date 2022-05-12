unit InMemoryObjectRegistry;

interface

uses

  AbstractObjectRegistry,
  SysUtils,
  Classes;

type

  TInMemoryObjectRegistry = class (TAbstractObjectRegistry)

    protected

      FObjectRegistryItemList: TList;
      
    protected

      function FindObjectRegistryItem(
        RegistryKey: IObjectRegistryKey
      ): TObjectRegistryItem; override;

      procedure AddObjectRegistryItem(
        ObjectRegistryItem: TObjectRegistryItem
      ); override;

      procedure RemoveObjectRegistryItem(
        RegistryKey: IObjectRegistryKey
      ); override;

    public

      constructor Create;
      destructor Destroy; override;

    public

      function Count: Integer; override;

      function GetKeys: TObjectRegistryKeys; override;

    public

      procedure Clear; override;
      
  end;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxCollectionFunctionsUnit;
  
{ TInMemoryObjectRegistry }

procedure TInMemoryObjectRegistry.AddObjectRegistryItem(
  ObjectRegistryItem: TObjectRegistryItem
);
begin

  FObjectRegistryItemList.Add(ObjectRegistryItem);

end;

procedure TInMemoryObjectRegistry.Clear;
var
    RegistryItem: TObjectRegistryItem;
begin

  while FObjectRegistryItemList.Count > 0 do begin

    RegistryItem := TObjectRegistryItem(FObjectRegistryItemList[0]);

    if FreeRegisteredObjectsOnDestroy then
      RegistryItem.RegistryObject.Free;

    FObjectRegistryItemList.Remove(RegistryItem);

    RegistryItem.Free;

  end;

end;

function TInMemoryObjectRegistry.Count: Integer;
begin

  Result := FObjectRegistryItemList.Count;
  
end;

constructor TInMemoryObjectRegistry.Create;
begin

  FObjectRegistryItemList := TList.Create;
  
end;

destructor TInMemoryObjectRegistry.Destroy;
begin

  Clear;

  FreeAndNil(FObjectRegistryItemList);
  
  inherited;

end;

function TInMemoryObjectRegistry.FindObjectRegistryItem(
  RegistryKey: IObjectRegistryKey
): TObjectRegistryItem;
var ItemPointer: Pointer;
begin

  for ItemPointer in FObjectRegistryItemList do begin

    Result := TObjectRegistryItem(ItemPointer);

    if Result.RegistryKey.Equals(RegistryKey) then
      Exit;

  end;

  Result := nil;
  
end;

function TInMemoryObjectRegistry.GetKeys: TObjectRegistryKeys;
var
    ItemPointer: Pointer;
    Item: TObjectRegistryItem;
begin

  Result := TObjectRegistryKeys.Create;

  try

    for ItemPointer in FObjectRegistryItemList do begin

      Item := TObjectRegistryItem(ItemPointer);

      Result.Add(Item.RegistryKey);
      
    end;
  
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

procedure TInMemoryObjectRegistry.RemoveObjectRegistryItem(
  RegistryKey: IObjectRegistryKey
);
var Item: TObjectRegistryItem;
begin

  Item := FindObjectRegistryItem(RegistryKey);

  if Assigned(Item) then begin

    FObjectRegistryItemList.Remove(Item);

    if FreeRegisteredObjectsOnDestroy then
      Item.RegistryObject.Free;

    Item.Destroy;
    
  end;

end;

end.
