unit LayoutManager;

interface

uses

  Windows,
  LayoutItem,
  Controls,
  SysUtils,
  Classes;

type

  TLayoutItemVisualSettingsHolder = class

    protected

      FLayoutItem: TLayoutItem;

    public

      destructor Destroy; override;
      constructor Create;

    published

      property LayoutItem: TLayoutItem read FLayoutItem write FLayoutItem;
      
  end;

  TLayoutItemVisualSettingsHolders = class;

  TLayoutItemVisualSettingsHoldersEnumerator = class (TListEnumerator)

    protected

      function GetCurrentLayoutItemVisualSettingsHolder:
        TLayoutItemVisualSettingsHolder;

    public

      constructor Create(
        LayoutItemVisualSettingsHolders: TLayoutItemVisualSettingsHolders
      );

      property Current: TLayoutItemVisualSettingsHolder
      read GetCurrentLayoutItemVisualSettingsHolder;

  end;

  TLayoutItemVisualSettingsHolders = class (TList)

    protected

      function GetLayoutItemVisualSettingsHolderByIndex(
        Index: Integer
      ): TLayoutItemVisualSettingsHolder;

      procedure SetLayoutItemVisualSettingsHolderByIndex(
        Index: Integer;
        Value: TLayoutItemVisualSettingsHolder
      );

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function First: TLayoutItemVisualSettingsHolder;
      function Last: TLayoutItemVisualSettingsHolder;
      
      function IndexOfByLayoutItem(LayoutItem: TLayoutItem): Integer;
      function FindByLayoutItem(LayoutItem: TLayoutItem): TLayoutItemVisualSettingsHolder;
      function FindByLayoutItemId(const LayoutItemId: Variant): TLayoutItemVisualSettingsHolder;
      
      procedure RemoveByLayoutItem(LayoutItem: TLayoutItem);
      procedure RemoveByLayoutItemForControl(Control: TControl);

      function IsEmpty: Boolean;
      
      function GetEnumerator: TLayoutItemVisualSettingsHoldersEnumerator;

      property Items[Index: Integer]: TLayoutItemVisualSettingsHolder
      read GetLayoutItemVisualSettingsHolderByIndex
      write SetLayoutItemVisualSettingsHolderByIndex; default;

  end;

  TLayoutManager = class;

  ILayoutItemLocation = interface

    function LayoutManager: TLayoutManager;
    function Position: Integer;

  end;
  
  TLayoutItemLocation = class (TInterfacedObject, ILayoutItemLocation)

    protected

      FLayoutManager: TLayoutManager;
      FPosition: Integer;

    public

      constructor Create(
        const LayoutManager: TLayoutManager;
        const Position: Integer
      );

      function LayoutManager: TLayoutManager;
      function Position: Integer;
    
  end;
  
  TLayoutManager = class abstract (TLayoutItem)

    protected

      FLayoutItemVisualSettingsHolders: TLayoutItemVisualSettingsHolders;

      function CreateLayoutItemVisualSettingsHolder(
        LayoutItem: TLayoutItem
      ): TLayoutItemVisualSettingsHolder; virtual; abstract;

      function CreateLayoutItemVisualSettingsHolderList:
        TLayoutItemVisualSettingsHolders; virtual;
        
      procedure ApplyVisualSettingsForLayoutItem(
        LayoutItemVisualSettingsHolder: TLayoutItemVisualSettingsHolder
      ); virtual; abstract;
      
      function CreateAndAddVisualSettingsHolderFor(LayoutItem: TLayoutItem): TLayoutItemVisualSettingsHolder; overload;
      function CreateAndAddVisualSettingsHolderFor(Control: TControl): TLayoutItemVisualSettingsHolder; overload;
      function CreateAndAddVisualSettingsHolderFor(LayoutManager: TLayoutManager): TLayoutItemVisualSettingsHolder; overload;

      function GetIndexOfLayoutItemVisualSettingsHolder(
        LayoutItemVisualSettingsHolder: TLayoutItemVisualSettingsHolder
      ): Integer;

      function CreateLayoutItemFor(Control: TControl): TLayoutItem;

      function GetLayoutItemCount: Integer;
      
      procedure Initialize;

      procedure ApplyLayoutItemsVisualSettings;
      
    public

      destructor Destroy; override;
      constructor Create;

      procedure Execute; override;
      
      function AddLayoutItem(LayoutItem: TLayoutItem): Integer;
      
      procedure InsertLayoutItemBefore(LayoutItem: TLayoutItem; const LayoutItemIndex: Integer); overload;
      procedure InsertLayoutItemBefore(LayoutItem: TLayoutItem; const LayoutItemId: Variant); overload;
      procedure InsertLayoutItemAfter(LayoutItem: TLayoutItem; const LayoutItemIndex: Integer); overload;
      procedure InsertLayoutItemAfter(LayoutItem: TLayoutItem; const LayoutItemId: Variant); overload;

      function AddControl(Control: TControl): Integer;
      procedure InsertControlBefore(Control: TControl; const LayoutItemIndex: Integer); overload;
      procedure InsertControlBefore(Control: TControl; const ControlName: String); overload;
      procedure InsertControlAfter(Control: TControl; const LayoutItemIndex: Integer); overload;
      procedure InsertControlAfter(Control: TControl; const ControlName: String); overload;

      function AddLayoutManager(LayoutManager: TLayoutManager): Integer;
      procedure InsertLayoutManagerBefore(LayoutManager: TLayoutManager; const LayoutItemIndex: Integer); overload;
      procedure InsertLayoutManagerBefore(LayoutManager: TLayoutManager; const LayoutItemId: Variant); overload;
      procedure InsertLayoutManagerAfter(LayoutManager: TLayoutManager; const LayoutItemIndex: Integer); overload;
      procedure InsertLayoutManagerAfter(LayoutManager: TLayoutManager; const LayoutItemId: Variant); overload;

      procedure RemoveLayoutItem(LayoutItem: TLayoutItem); overload;
      procedure RemoveLayoutItem(const LayoutItemId: Variant); overload;
      procedure RemoveLayoutItemByIndex(const Index: Integer);
      procedure RemoveControl(Control: TControl);
      procedure RemoveLayoutManager(LayoutManager: TLayoutManager);

      function GetLayoutItemLocationById(const LayoutItemId: Variant): ILayoutItemLocation;
      
      function GetLayoutItemByIndex(Index: Integer): TLayoutItem;

      function FindVisualSettingsHolderFor(LayoutItem: TLayoutItem): TLayoutItemVisualSettingsHolder;
      function FindVisualSettingsHolderByLayoutItemId(const LayoutItemId: Variant): TLayoutItemVisualSettingsHolder;

      procedure ApplyLayout; virtual;
    
      property LayoutItemCount: Integer read GetLayoutItemCount;

      property LayoutItems[Index: Integer]: TLayoutItem
      read GetLayoutItemByIndex; default;

  end;

  TLayoutManagerBuilder = class abstract

    protected

      FLayoutManager: TLayoutManager;

      function CreateLayoutManager: TLayoutManager; virtual; abstract;

    public

      constructor Create; virtual;
      
      destructor Destroy; override;

      function AddControl(Control: TControl): TLayoutManagerBuilder; overload;
      function AddControls(Controls: array of TControl): TLayoutManagerBuilder; overload;

      function AddLayoutManager(LayoutManager: TLayoutManager): TLayoutManagerBuilder; overload;
      function AddLayoutManagers(LayoutManagers: array of TLayoutManager): TLayoutManagerBuilder; overload;

      function SetId(const Id: Variant): TLayoutManagerBuilder;
      
      function Build: TLayoutManager;
      function BuildAndDestroy: TLayoutManager;

  end;

implementation

uses

  AuxDebugFunctionsUnit,
  ControlLayoutItem;

{ TLayoutItemVisualSettingsHolder }

constructor TLayoutItemVisualSettingsHolder.Create;
begin

  inherited;
  
end;

destructor TLayoutItemVisualSettingsHolder.Destroy;
begin

  FreeAndNil(FLayoutItem);
  inherited;

end;

{ TLayoutItemVisualSettingsHoldersEnumerator }

constructor TLayoutItemVisualSettingsHoldersEnumerator.Create(
  LayoutItemVisualSettingsHolders: TLayoutItemVisualSettingsHolders);
begin

  inherited Create(LayoutItemVisualSettingsHolders);
  
end;

function TLayoutItemVisualSettingsHoldersEnumerator.GetCurrentLayoutItemVisualSettingsHolder: TLayoutItemVisualSettingsHolder;
begin
                    
  Result := TLayoutItemVisualSettingsHolder(GetCurrent);
  
end;

{ TLayoutItemVisualSettingsHolders }

function TLayoutItemVisualSettingsHolders.FindByLayoutItem(
  LayoutItem: TLayoutItem
): TLayoutItemVisualSettingsHolder;
var SearchLayoutItemVisualSettingsHolderIndex: Integer;
begin

  SearchLayoutItemVisualSettingsHolderIndex := IndexOfByLayoutItem(LayoutItem);

  if SearchLayoutItemVisualSettingsHolderIndex >= 0 then
    Result := Self[SearchLayoutItemVisualSettingsHolderIndex]

  else Result := nil;

end;

function TLayoutItemVisualSettingsHolders.FindByLayoutItemId(
  const LayoutItemId: Variant
): TLayoutItemVisualSettingsHolder;
begin

  for Result in Self do
    if Result.LayoutItem.Id = LayoutItemId then
      Exit;

  Result := nil;
  
end;

function TLayoutItemVisualSettingsHolders.First: TLayoutItemVisualSettingsHolder;
begin

  if not IsEmpty then
    Result := inherited First

  else Result := nil;
  
end;

function TLayoutItemVisualSettingsHolders.GetEnumerator: TLayoutItemVisualSettingsHoldersEnumerator;
begin

  Result := TLayoutItemVisualSettingsHoldersEnumerator.Create(Self);
  
end;

function TLayoutItemVisualSettingsHolders.
  GetLayoutItemVisualSettingsHolderByIndex(
    Index: Integer
  ): TLayoutItemVisualSettingsHolder;
begin

  Result := TLayoutItemVisualSettingsHolder(Get(Index));
  
end;

function TLayoutItemVisualSettingsHolders.IndexOfByLayoutItem(
  LayoutItem: TLayoutItem): Integer;
begin

  for Result := 0 to Count - 1 do
    if Self[Result].LayoutItem = LayoutItem then
      Exit;

  Result := -1;
  
end;

function TLayoutItemVisualSettingsHolders.IsEmpty: Boolean;
begin

  Result := Count = 0;
  
end;

function TLayoutItemVisualSettingsHolders.Last: TLayoutItemVisualSettingsHolder;
begin

  if not IsEmpty then
    Result := inherited Last

  else Result := nil;
  
end;

procedure TLayoutItemVisualSettingsHolders.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if (Action = lnDeleted) and Assigned(Ptr) then
    TLayoutItemVisualSettingsHolder(Ptr).Free;

end;

procedure TLayoutItemVisualSettingsHolders.RemoveByLayoutItem(
  LayoutItem: TLayoutItem
);
var I: Integer;
begin

  for I := 0 to Count - 1 do
    if Self[I].LayoutItem = LayoutItem then begin
    
      Delete(I);
      Exit;
      
    end;
    
end;

procedure TLayoutItemVisualSettingsHolders.RemoveByLayoutItemForControl(
  Control: TControl
);
var I: Integer;
begin

  for I := 0 to Count - 1 do
    if 

       (Self[I].LayoutItem is TControlLayoutItem) and
       ((Self[I].LayoutItem as TControlLayoutItem).Control = Control)

    then begin
    
      Delete(I);
      Exit;
      
    end;                                      
        
end;

procedure TLayoutItemVisualSettingsHolders.
  SetLayoutItemVisualSettingsHolderByIndex(
    Index: Integer;
    Value: TLayoutItemVisualSettingsHolder
  );
begin

  Put(Index, Value);
  
end;

{ TLayoutManager }

function TLayoutManager.AddControl(Control: TControl): Integer;
begin

  Result := AddLayoutItem(CreateLayoutItemFor(Control));

end;

function TLayoutManager.AddLayoutItem(LayoutItem: TLayoutItem): Integer;
begin
  
  LayoutItem.Left := LayoutItem.Left + Left;
  LayoutItem.Top := LayoutItem.Top + Top;

  Result :=

    GetIndexOfLayoutItemVisualSettingsHolder(
      CreateAndAddVisualSettingsHolderFor(LayoutItem)
    );
    
end;

function TLayoutManager.AddLayoutManager(
  LayoutManager: TLayoutManager): Integer;
begin

  Result := AddLayoutItem(LayoutManager as TLayoutItem);

end;

procedure TLayoutManager.ApplyLayout;
begin

  ApplyLayoutItemsVisualSettings;
  Execute;
    
end;

procedure TLayoutManager.ApplyLayoutItemsVisualSettings;
var
  LayoutItemVisualSettingsHolder: TLayoutItemVisualSettingsHolder;
begin

  for

      LayoutItemVisualSettingsHolder in
      FLayoutItemVisualSettingsHolders

  do begin

    if LayoutItemVisualSettingsHolder.LayoutItem is TLayoutManager then
      TLayoutManager(LayoutItemVisualSettingsHolder.LayoutItem).ApplyLayoutItemsVisualSettings;

    ApplyVisualSettingsForLayoutItem(LayoutItemVisualSettingsHolder);

  end;
  
end;

procedure TLayoutManager.Execute;
var
    I: Integer;
begin

  for I := 0 to LayoutItemCount - 1 do
    Self[I].Execute;

end;

constructor TLayoutManager.Create;
begin

  inherited;

  Initialize;
    
end;

function TLayoutManager.CreateAndAddVisualSettingsHolderFor(
  LayoutItem: TLayoutItem
): TLayoutItemVisualSettingsHolder;
begin

  Result := CreateLayoutItemVisualSettingsHolder(LayoutItem);

  Result.LayoutItem := LayoutItem;
  
  FLayoutItemVisualSettingsHolders.Add(Result);
  
end;

function TLayoutManager.CreateAndAddVisualSettingsHolderFor(
  Control: TControl): TLayoutItemVisualSettingsHolder;
begin

  Result := CreateAndAddVisualSettingsHolderFor(TControlLayoutItem.Create(Control));
  
end;

function TLayoutManager.CreateAndAddVisualSettingsHolderFor(
  LayoutManager: TLayoutManager): TLayoutItemVisualSettingsHolder;
begin

  Result := CreateAndAddVisualSettingsHolderFor(LayoutManager as TLayoutItem);
  
end;

function TLayoutManager.CreateLayoutItemFor(Control: TControl): TLayoutItem;
begin

  Result := TControlLayoutItem.Create(Control);
  
end;

function TLayoutManager.CreateLayoutItemVisualSettingsHolderList: TLayoutItemVisualSettingsHolders;
begin

  Result := TLayoutItemVisualSettingsHolders.Create;
  
end;

destructor TLayoutManager.Destroy;
begin

  FreeAndNil(FLayoutItemVisualSettingsHolders);
  inherited;

end;

function TLayoutManager.FindVisualSettingsHolderByLayoutItemId(
  const LayoutItemId: Variant
): TLayoutItemVisualSettingsHolder;
var
    I: Integer;
    InternalLayoutItem: TLayoutItem;
begin

  Result := FLayoutItemVisualSettingsHolders.FindByLayoutItemId(LayoutItemId);

  if Assigned(Result) then Exit;

  for I := 0 to LayoutItemCount - 1 do begin

    InternalLayoutItem := Self[I];

    if InternalLayoutItem is TLayoutManager then
      Result := TLayoutManager(InternalLayoutItem).FindVisualSettingsHolderByLayoutItemId(LayoutItemId);

    if Assigned(Result) then Exit;

  end;

  Result := nil;
  
end;

function TLayoutManager.FindVisualSettingsHolderFor(
  LayoutItem: TLayoutItem
): TLayoutItemVisualSettingsHolder;
var
    I: Integer;
    InternalLayoutItem: TLayoutItem;
begin

  Result := FLayoutItemVisualSettingsHolders.FindByLayoutItem(LayoutItem);

  if Assigned(Result) then Exit;

  for I := 0 to LayoutItemCount - 1 do begin

    InternalLayoutItem := Self[I];

    if InternalLayoutItem is TLayoutManager then
      Result := TLayoutManager(InternalLayoutItem).FindVisualSettingsHolderFor(LayoutItem);

    if Assigned(Result) then Exit;

  end;

  Result := nil;
  
end;

function TLayoutManager.GetLayoutItemByIndex(
  Index: Integer
): TLayoutItem;
begin

  if (Index < 0) or (Index >= FLayoutItemVisualSettingsHolders.Count) then
    Result := nil

  else Result := FLayoutItemVisualSettingsHolders[Index].LayoutItem;

end;

function TLayoutManager.GetLayoutItemCount: Integer;
begin

  Result := FLayoutItemVisualSettingsHolders.Count;
  
end;

function TLayoutManager.GetLayoutItemLocationById(
  const LayoutItemId: Variant
): ILayoutItemLocation;
var
    LayoutItem: TLayoutItem;
    I: Integer;
begin

  for I := 0 to LayoutItemCount - 1 do begin

    LayoutItem := Self[I];

    if LayoutItem.Id = LayoutItemId then
      Result := TLayoutItemLocation.Create(Self, I)

    else if LayoutItem is TLayoutManager then
      Result := TLayoutManager(LayoutItem).GetLayoutItemLocationById(LayoutItemId);

    if Assigned(Result) then Exit;
    
  end;

  Result := nil;
  
end;

function TLayoutManager.GetIndexOfLayoutItemVisualSettingsHolder(
  LayoutItemVisualSettingsHolder: TLayoutItemVisualSettingsHolder
): Integer;
begin

  Result :=
    FLayoutItemVisualSettingsHolders.IndexOf(
      LayoutItemVisualSettingsHolder
    );

end;

procedure TLayoutManager.Initialize;
begin

  FLayoutItemVisualSettingsHolders := 
    CreateLayoutItemVisualSettingsHolderList;
  
end;

procedure TLayoutManager.InsertControlBefore(
  Control: TControl;
  const LayoutItemIndex: Integer
);
var
    LayoutItem: TControlLayoutItem;
begin

  LayoutItem := TControlLayoutItem.Create(Control);

  try

    InsertLayoutItemBefore(LayoutItem, LayoutItemIndex);

  except

    FreeAndNil(LayoutItem);

    Raise;

  end;

end;

procedure TLayoutManager.InsertControlAfter(
  Control: TControl;
  const LayoutItemIndex: Integer
);
var
    LayoutItem: TControlLayoutItem;
begin

  LayoutItem := TControlLayoutItem.Create(Control);

  try

    InsertLayoutItemAfter(LayoutItem, LayoutItemIndex);
    
  except

    FreeAndNil(LayoutItem);

    Raise;

  end;

end;

procedure TLayoutManager.InsertControlAfter(Control: TControl;
  const ControlName: String
);
var
    LayoutItem: TControlLayoutItem;
begin

  LayoutItem := TControlLayoutItem.Create(Control);

  try

    InsertLayoutItemAfter(LayoutItem, ControlName);
    
  except

    FreeAndNil(LayoutItem);

    Raise;

  end;

end;

procedure TLayoutManager.InsertControlBefore(
  Control: TControl;
  const ControlName: String
);
var
  LayoutItem: TControlLayoutItem;
begin

  LayoutItem := TControlLayoutItem.Create(Control);

  try

    InsertLayoutItemBefore(LayoutItem, ControlName);

  except

    FreeAndNil(LayoutItem);

    Raise;

  end;
  
end;

procedure TLayoutManager.InsertLayoutManagerBefore(
  LayoutManager: TLayoutManager;
  const LayoutItemIndex: Integer
);
begin

  InsertLayoutItemBefore(LayoutManager, LayoutItemIndex);

end;

procedure TLayoutManager.InsertLayoutItemBefore(
  LayoutItem: TLayoutItem;
  const LayoutItemIndex: Integer
);
var
    VisualSettingsHolder: TLayoutItemVisualSettingsHolder;
begin

  LayoutItem.Left := LayoutItem.Left + Left;
  LayoutItem.Top := LayoutItem.Top + Top;
  
  VisualSettingsHolder := CreateLayoutItemVisualSettingsHolder(LayoutItem);

  VisualSettingsHolder.LayoutItem := LayoutItem;

  try

    FLayoutItemVisualSettingsHolders.Insert(LayoutItemIndex, VisualSettingsHolder);

  except

    VisualSettingsHolder.LayoutItem := nil;

    FreeAndNil(VisualSettingsHolder);

  end;

end;

procedure TLayoutManager.InsertLayoutItemAfter(LayoutItem: TLayoutItem;
  const LayoutItemId: Variant
);
var
    LayoutItemLocation: ILayoutItemLocation;
begin

  LayoutItemLocation := GetLayoutItemLocationById(LayoutItemId);

  LayoutItemLocation.LayoutManager.InsertLayoutItemAfter(LayoutItem, LayoutItemLocation.Position);

end;

procedure TLayoutManager.InsertLayoutItemAfter(
  LayoutItem: TLayoutItem;
  const LayoutItemIndex: Integer
);
begin

  InsertLayoutItemBefore(LayoutItem, LayoutItemIndex + 1);
  
end;

procedure TLayoutManager.InsertLayoutItemBefore(
  LayoutItem: TLayoutItem;
  const LayoutItemId: Variant
);
var
    LayoutItemLocation: ILayoutItemLocation;
begin

  LayoutItemLocation := GetLayoutItemLocationById(LayoutItemId);

  LayoutItemLocation.LayoutManager.InsertLayoutItemBefore(LayoutItem, LayoutItemLocation.Position);

end;

procedure TLayoutManager.InsertLayoutManagerAfter(LayoutManager: TLayoutManager;
  const LayoutItemId: Variant);
begin

  InsertLayoutItemAfter(LayoutManager, LayoutItemId);
  
end;

procedure TLayoutManager.InsertLayoutManagerAfter(LayoutManager: TLayoutManager;
  const LayoutItemIndex: Integer);
begin

  InsertLayoutItemAfter(LayoutManager, LayoutItemIndex);

end;

procedure TLayoutManager.InsertLayoutManagerBefore(
  LayoutManager: TLayoutManager;
  const LayoutItemId: Variant
);
begin

  InsertLayoutItemBefore(LayoutManager, LayoutItemId);
  
end;

procedure TLayoutManager.RemoveControl(Control: TControl);
begin

  FLayoutItemVisualSettingsHolders.RemoveByLayoutItemForControl(Control);
  
end;

procedure TLayoutManager.RemoveLayoutItem(LayoutItem: TLayoutItem);
begin

  FLayoutItemVisualSettingsHolders.RemoveByLayoutItem(LayoutItem);
  
end;

procedure TLayoutManager.RemoveLayoutItem(const LayoutItemId: Variant);
var
    LayoutItemLocation: ILayoutItemLocation;
begin

  LayoutItemLocation := GetLayoutItemLocationById(LayoutItemId);

  LayoutItemLocation.LayoutManager.RemoveLayoutItem(
    LayoutItemLocation.LayoutManager.GetLayoutItemByIndex(
      LayoutItemLocation.Position
    )
  );
  
end;

procedure TLayoutManager.RemoveLayoutItemByIndex(const Index: Integer);
begin

  FLayoutItemVisualSettingsHolders.Delete(Index);
  
end;

procedure TLayoutManager.RemoveLayoutManager(LayoutManager: TLayoutManager);
begin

  FLayoutItemVisualSettingsHolders.RemoveByLayoutItem(LayoutManager);
  
end;

{ TLayoutManagerBuilder }

function TLayoutManagerBuilder.AddControls(
  Controls: array of TControl
): TLayoutManagerBuilder;
var Control: TControl;
begin

  for Control in Controls do
    FLayoutManager.AddControl(Control);

  Result := Self;
    
end;

function TLayoutManagerBuilder.AddControl(Control: TControl): TLayoutManagerBuilder;
begin

  FLayoutManager.AddControl(Control);

  Result := Self;
  
end;

function TLayoutManagerBuilder.AddLayoutManagers(
  LayoutManagers: array of TLayoutManager
): TLayoutManagerBuilder;
var LayoutManager: TLayoutManager;
begin

  for LayoutManager in LayoutManagers do
    FLayoutManager.AddLayoutManager(LayoutManager);

  Result := Self;
    
end;

function TLayoutManagerBuilder.AddLayoutManager(
  LayoutManager: TLayoutManager
): TLayoutManagerBuilder;
begin

  FLayoutManager.AddLayoutManager(LayoutManager);

  Result := Self;
  
end;

function TLayoutManagerBuilder.Build: TLayoutManager;
begin

  Result := FLayoutManager;
  
end;

function TLayoutManagerBuilder.BuildAndDestroy: TLayoutManager;
begin

  Result := Build;

  FLayoutManager := nil;
  
  Destroy;
  
end;

constructor TLayoutManagerBuilder.Create;
begin

  inherited;

  FLayoutManager := CreateLayoutManager;
  
end;

destructor TLayoutManagerBuilder.Destroy;
begin

  inherited;

end;

function TLayoutManagerBuilder.SetId(const Id: Variant): TLayoutManagerBuilder;
begin

  FLayoutManager.Id := Id;

  Result := Self;
  
end;

{ TLayoutItemLocation }

constructor TLayoutItemLocation.Create(const LayoutManager: TLayoutManager;
  const Position: Integer);
begin

  inherited Create;

  FLayoutManager := LayoutManager;
  FPosition := Position;
  
end;

function TLayoutItemLocation.LayoutManager: TLayoutManager;
begin

  Result := FLayoutManager;

end;

function TLayoutItemLocation.Position: Integer;
begin

  Result := FPosition;
  
end;

end.
