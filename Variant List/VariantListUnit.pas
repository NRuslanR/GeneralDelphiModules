unit VariantListUnit;

interface

uses

  Disposable,
  ClonableUnit,
  VariantFunctions,
  SysUtils,
  Classes;

type

  TVariantList = class;

  TVariantListEnumerator = class (TListEnumerator)

    protected

      function GetCurrentVariant: Variant;

      constructor Create(VariantList: TVariantList);

    public

      property Current: Variant read GetCurrentVariant;
      
  end;

  TVariantArray = array of Variant;

  TVariantList = class (TList)

    strict protected

      function GetVariantByIndex(Index: Integer): Variant;
      
      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      destructor Destroy; override;
      
      constructor Create;
      constructor CreateFrom(
        Variants: array of Variant
      ); overload;
      
      constructor CreateFrom(Variants: Variant); overload;
      constructor CreateFrom(Other: TVariantList); overload;

      function IsEmpty: Boolean;
      
      function GetEnumerator: TVariantListEnumerator;

      function First: Variant;
      function Last: Variant;
      
      function IndexOf(Value: Variant): Integer;
      function Add(Value: Variant): Integer; overload;
      function AddClass(Value: TClass): Integer;
      function AddObject(Instance: TObject): Integer;
      function AddInterface(Value: IInterface): Integer;
      function Add(ValueList: TVariantList): Integer; overload;
      procedure Remove(Value: Variant); overload;
      procedure RemoveInterface(Value: IInterface);
      procedure Remove(ValueList: TVariantList); overload;
      function ExtractFirst: Variant;
      function ExtractLast: Variant;
      function Contains(Value: Variant): Boolean; overload;
      function ContainsAll(Value: TVariantList): Boolean; overload;
      function ContainsAnyOf(Value: TVariantList): Boolean; overload;
      
      function Clone: TVariantList;
      function Equals(ValueList: TVariantList): Boolean;

      function ToVariantArray: TVariantArray;
      
      property Items[Index: Integer]: Variant read GetVariantByIndex; default;

  end;

implementation

uses

  Variants,
  VariantTypeUnit;

{ TVariantListEnumerator }

constructor TVariantListEnumerator.Create(VariantList: TVariantList);
begin

  inherited Create(VariantList);

end;

function TVariantListEnumerator.GetCurrentVariant: Variant;
begin

  Result :=  TVariant(GetCurrent).Value;
  
end;

{ TVariantList }

function TVariantList.Add(Value: Variant): Integer;
var
    VariantWrapper: TVariant;
begin

  VariantWrapper := nil;

  try

    VariantWrapper := TVariant.Create(Value);

    Result := inherited Add(VariantWrapper);

  except

    FreeAndNil(VariantWrapper);

    Raise;
    
  end;

end;

function TVariantList.Add(ValueList: TVariantList): Integer;
var Value: Variant;
    Index: Integer;
begin

  Result := -1;

  for Value in ValueList do begin

    Index := Add(Value);

    if Result = -1 then Result := Index;
    
  end;

end;

function TVariantList.AddClass(Value: TClass): Integer;
begin

  Result := Add(ClassToVariant(Value));

end;

function TVariantList.AddInterface(Value: IInterface): Integer;
var
    VariantWrapper: TVariant;
begin

  VariantWrapper := TVariant.Create(Value);

  Result := inherited Add(VariantWrapper);

end;

function TVariantList.AddObject(Instance: TObject): Integer;
begin

  Result := Add(ObjectToVariant(Instance));

end;

function TVariantList.Clone: TVariantList;
var VariantItem: Variant;
    ClonedVariantList: TVariantList;
begin

  Result := TVariantList.Create;

  ClonedVariantList := Result as TVariantList;

  try

    for VariantItem in Self do
      ClonedVariantList.Add(VariantItem);

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;
  
end;

function TVariantList.ContainsAll(Value: TVariantList): Boolean;
var VariantItem: Variant;
begin

  for VariantItem in Value do
    if not Contains(VariantItem) then begin

      Result := False;
      Exit;

    end;

  Result := True;
    
end;

function TVariantList.Contains(Value: Variant): Boolean;
begin

  Result := IndexOf(Value) <> -1;

end;

constructor TVariantList.Create;
begin

  inherited;
  
end;

constructor TVariantList.CreateFrom(Variants: Variant);
var I, Low, High: Integer;
begin

  Create;
  
  if not VarIsArray(Variants) then
    Add(Variants)

  else begin

    Low := VarArrayLowBound(Variants, 1);
    High := VarArrayHighBound(Variants, 1);

    for I := Low to High do
      Add(Variants[I]);
      
  end;
  
end;

constructor TVariantList.CreateFrom(Variants: array of Variant);
var VariantValue:Variant;
begin

  Create;

  for VariantValue in Variants do
    Add(VariantValue);
    
end;

function TVariantList.Equals(ValueList: TVariantList): Boolean;
var I: Integer;
begin

  if Assigned(ValueList) and (ValueList.Count = Count) then begin

    for I := 0 to Count - 1 do
      if Self[I] <> ValueList[I] then begin

        Result := False;

        Exit;

      end;

    Result := True;
      
  end

  else Result := False;

end;

function TVariantList.ExtractFirst: Variant;
begin

  Result := Self[0];

  Delete(0);

end;

function TVariantList.ExtractLast: Variant;
begin

  Result := Self[Count - 1];

  Delete(Count - 1);
  
end;

function TVariantList.First: Variant;
begin

  Result := TVariant(inherited First).Value;

end;

function TVariantList.GetEnumerator: TVariantListEnumerator;
begin

  Result := TVariantListEnumerator.Create(Self);
  
end;

function TVariantList.GetVariantByIndex(Index: Integer): Variant;
begin

  Result := TVariant(Get(Index)).Value;
  
end;

function TVariantList.IndexOf(Value: Variant): Integer;
var
    ValueTypeIsRef: Boolean;
    CurrentValue: Variant;
begin
  
  ValueTypeIsRef := VarType(Value) = varByRef;

  for Result := 0 to Count - 1 do begin

    CurrentValue := Self[Result];

    if (VarType(CurrentValue) = varByRef) and ValueTypeIsRef then begin

      if TVarData(CurrentValue).VPointer = TVarData(Value).VPointer then
        Exit;

    end

    else if CurrentValue = Value then
      Exit;

  end;

  Result := -1;
  
end;

function TVariantList.IsEmpty: Boolean;
begin

  Result := Count = 0;
  
end;

function TVariantList.Last: Variant;
begin

  Result := TVariant(inherited Last).Value;

end;

procedure TVariantList.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    TVariant(Ptr).Free;

end;

procedure TVariantList.Remove(ValueList: TVariantList);
var Value: Variant;
begin

  for Value in ValueList do
    Remove(Value);

end;

procedure TVariantList.RemoveInterface(Value: IInterface);
begin

  Remove(InterfaceToVariant(Value));

end;

function TVariantList.ToVariantArray: TVariantArray;
var

    I: Integer;
begin

  SetLength(Result, Count);

  for I := 0 to Count - 1 do
    Result[I] := Self[I];
    
end;

procedure TVariantList.Remove(Value: Variant);
var ValueIndex: Integer;
begin

  ValueIndex := IndexOf(Value);

  if ValueIndex >= 0 then
    Delete(ValueIndex);
  
end;

function TVariantList.ContainsAnyOf(Value: TVariantList): Boolean;
var VariantItem: Variant;
begin

  for VariantItem in Value do
    if Value.Contains(VariantItem) then begin

      Result := True;
      Exit;
      
    end;

  Result := False;
    
end;

constructor TVariantList.CreateFrom(Other: TVariantList);
var
    VariantValue: Variant;
begin

  Create;

  for VariantValue in Other do
    Add(VariantValue);

end;

destructor TVariantList.Destroy;
begin

  inherited;

end;

end.
