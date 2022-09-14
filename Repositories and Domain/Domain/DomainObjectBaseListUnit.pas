unit DomainObjectBaseListUnit;

interface

uses

  SysUtils,
  Classes,
  IDomainObjectBaseUnit,
  DomainException,
  DomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  InvariantsCompilanceAssistant,
  ClonableUnit,
  EquatableUnit;

type

  TDomainObjectBaseList = class;

  TDomainObjectBaseComparator = class (TInterfacedObject, IDomainObjectBaseComparator)

    function Compare(
      FirstBaseDomainObject, SecondBaseDomainObject: TDomainObjectBase
    ): Integer; virtual; abstract;
    
  end;

  TDomainObjectBaseListEnumerator = class

    protected

      FCurrentIndex: Integer;
      FDomainObjectBaseList: TDomainObjectBaseList;
      
      function GetCurrentBaseDomainObject: TDomainObjectBase; virtual;

      constructor Create(DomainObjectBaseList: TDomainObjectBaseList);

    public

      function MoveNext: Boolean; virtual;
      
      property Current: TDomainObjectBase read GetCurrentBaseDomainObject;

  end;

  TDomainObjectBaseEntry = class

    BaseDomainObject: IDomainObjectBase;

    public

      destructor Destroy; override;
      constructor Create(BaseDomainObject: TDomainObjectBase);

  end;

  TDomainObjectBaseList = class (
                             TInterfacedObject,
                             IDomainObjectBaseList,
                             IClonable,
                             IEquatable
                            )

    private

      FInternalBaseDomainObjects: TList;

    protected

      FInvariantsComplianceAssistant: IInvariantsCompilanceAssistant;

      function GetInvariantsComplianceRequested: Boolean;
      procedure SetInvariantsComplianceRequested(const Value: Boolean);

    protected

      function GetBaseDomainObjectEntryByIndex(Index: Integer): TDomainObjectBaseEntry; virtual;
      
      function GetBaseDomainObjectByIndex(Index: Integer): TDomainObjectBase; virtual;

      procedure SetBaseDomainObjectByIndex(
        Index: Integer;
        const Value: TDomainObjectBase
      ); virtual;

      function FindEntryByBaseDomainObject(BaseDomainObject: TDomainObjectBase): TDomainObjectBaseEntry; virtual;

      function GetBaseDomainObjectCount: Integer; virtual;

      procedure DeleteBaseDomainObjectEntryByIndex(const Index: Integer); virtual;

      function InternalClone: TObject; virtual;

      procedure OrderByListComparator(
        ListComparator: TListSortCompare
      ); virtual;

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

      constructor Create; virtual;

      procedure InsertBaseDomainObject(
        const Index: Integer;
        BaseDomainObject: TDomainObjectBase
      ); virtual;

      function First: TDomainObjectBase; virtual;
      function Last: TDomainObjectBase; virtual;
      
      procedure AddBaseDomainObject(BaseDomainObject: TDomainObjectBase); virtual;
 
      destructor Destroy; override;

      function GetBaseDomainObjectsByPropertyValue(
        const PropertyName: String;
        const Value: Variant
      ): TDomainObjectBaseList;

      function ContainsByProperty(const PropertyName: String; const PropertyValue: Variant): Boolean;
      
      procedure Clear; virtual;

      function Exclude(DomainObjectBaseList: TDomainObjectBaseList): TDomainObjectBaseList;

      function IsEmpty: Boolean; virtual;
      function Contains(BaseDomainObject: TDomainObjectBase): Boolean; virtual;

      function GetSelf: TObject;
      
      procedure DeleteBaseDomainObject(BaseDomainObject: TDomainObjectBase); virtual;
      procedure DeleteBaseDomainObjectByEquivalence(BaseDomainObject: TDomainObjectBase); virtual;

      function GetEnumerator: TDomainObjectBaseListEnumerator; virtual;

      property Items[Index: Integer]: TDomainObjectBase
      read GetBaseDomainObjectByIndex
      write SetBaseDomainObjectByIndex; default;

      property Count: Integer read GetBaseDomainObjectCount;

      function Clone: TObject;
      function Equals(Equatable: TObject): Boolean; virtual;

    public

      property InvariantsComplianceRequested: Boolean
      read GetInvariantsComplianceRequested
      write SetInvariantsComplianceRequested;

  end;

  TDomainObjectBaseListClass = class of TDomainObjectBaseList;

implementation

uses

  Variants,
  AuxCollectionFunctionsUnit,
  ReflectionServicesUnit,
  AuxDebugFunctionsUnit;

{ TDomainObjectBaseListEnumerator }

constructor TDomainObjectBaseListEnumerator.Create(
  DomainObjectBaseList: TDomainObjectBaseList);
begin

  inherited Create;

  FDomainObjectBaseList := DomainObjectBaseList;
  FCurrentIndex := -1;

end;

function TDomainObjectBaseListEnumerator.GetCurrentBaseDomainObject: TDomainObjectBase;
begin

  Result := FDomainObjectBaseList[FCurrentIndex];

end;

function TDomainObjectBaseListEnumerator.MoveNext: Boolean;
begin

  Result := FCurrentIndex < FDomainObjectBaseList.Count - 1;

  if Result then
    Inc(FCurrentIndex);

end;

{ TDomainObjectBaseList }

procedure TDomainObjectBaseList.AddBaseDomainObject(BaseDomainObject: TDomainObjectBase);
begin

  if FindEntryByBaseDomainObject(BaseDomainObject) = nil then
    FInternalBaseDomainObjects.Add(TDomainObjectBaseEntry.Create(BaseDomainObject));
  
end;

procedure TDomainObjectBaseList.Clear;
begin
                    {
  while not IsEmpty do
    DeleteBaseDomainObjectEntryByIndex(0);
                     }
  FreeListItems(FInternalBaseDomainObjects);

end;

function TDomainObjectBaseList.Clone: TObject;
begin

  Result := InternalClone;
  
end;

function TDomainObjectBaseList.Contains(BaseDomainObject: TDomainObjectBase): Boolean;
begin

  Result := Assigned(FindEntryByBaseDomainObject(BaseDomainObject));
  
end;

function TDomainObjectBaseList.ContainsByProperty(const PropertyName: String;
  const PropertyValue: Variant): Boolean;
var
    BaseDomainObjects: IDomainObjectBaseList;
begin

  BaseDomainObjects := GetBaseDomainObjectsByPropertyValue(PropertyName, PropertyValue);

  Result := Assigned(BaseDomainObjects) and not TDomainObjectBaseList(BaseDomainObjects).IsEmpty;

end;

constructor TDomainObjectBaseList.Create;
begin

  inherited;

  FInternalBaseDomainObjects := TList.Create;
              
end;

procedure TDomainObjectBaseList.DeleteBaseDomainObject(BaseDomainObject: TDomainObjectBase);
var I: Integer;
begin

  for I := 0 to Count - 1 do
    if Self[I] = BaseDomainObject then begin

      DeleteBaseDomainObjectEntryByIndex(I);
      Exit;

    end;

end;

procedure TDomainObjectBaseList.DeleteBaseDomainObjectByEquivalence(
  BaseDomainObject: TDomainObjectBase);
var Entry: TDomainObjectBaseEntry;
begin

  Entry := FindEntryByBaseDomainObject(BaseDomainObject);

  if Assigned(Entry) then
    Entry.Destroy;
    
end;

procedure TDomainObjectBaseList.DeleteBaseDomainObjectEntryByIndex(
  const Index: Integer);
var DomainObjectEntry: TDomainObjectBaseEntry;
begin

  DomainObjectEntry := TDomainObjectBaseEntry(FInternalBaseDomainObjects[Index]);

  FInternalBaseDomainObjects.Delete(Index);

  DomainObjectEntry.Free;

end;

destructor TDomainObjectBaseList.Destroy;
begin

  FreeListWithItems(FInternalBaseDomainObjects);

  inherited;

end;

function TDomainObjectBaseList.Equals(Equatable: TObject): Boolean;
var OtherDomainObjectBaseList: TDomainObjectBaseList;
    I: Integer;
begin

  if not Assigned(Equatable)
     or not (Equatable is TDomainObjectBaseList)
  then begin

    Result := False;
    Exit;

  end;

  OtherDomainObjectBaseList := TDomainObjectBaseList(Equatable);
  
  if Count <> OtherDomainObjectBaseList.Count then begin

    Result := False;
    Exit;

  end;

  for I := 0 to Count - 1 do
    if not Self[I].Equals(OtherDomainObjectBaseList[I])
    then begin

      Result := False;
      Exit;

    end;

  Result := True;
  
end;

function TDomainObjectBaseList.Exclude(
  DomainObjectBaseList: TDomainObjectBaseList
): TDomainObjectBaseList;
var
    DomainObjectBase: TDomainObjectBase;
begin

  Result := TDomainObjectBaseListClass(ClassType).Create;

  try

    for DomainObjectBase in Self do begin

      if not DomainObjectBaseList.Contains(DomainObjectBase) then
        Result.AddBaseDomainObject(DomainObjectBase);
        
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDomainObjectBaseList.FindEntryByBaseDomainObject(
  BaseDomainObject: TDomainObjectBase
): TDomainObjectBaseEntry;
var I: Integer;
    CurrentBaseDomainObject: TDomainObjectBase;
begin

  for I := 0 to Count - 1 do begin

    Result := TDomainObjectBaseEntry(FInternalBaseDomainObjects[I]);

    CurrentBaseDomainObject := Result.BaseDomainObject.Self as TDomainObjectBase;

    if CurrentBaseDomainObject.Equals(BaseDomainObject) then Exit;
    
  end;

  Result := nil;

end;

function TDomainObjectBaseList.First: TDomainObjectBase;
begin

  Result :=
    TDomainObjectBase(
      TDomainObjectBaseEntry(
        FInternalBaseDomainObjects.First
      ).BaseDomainObject.Self
    );
  
end;

function TDomainObjectBaseList.GetBaseDomainObjectByIndex(
  Index: Integer): TDomainObjectBase;
var Entry: TDomainObjectBaseEntry;
begin

  Entry := GetBaseDomainObjectEntryByIndex(Index);

  if Assigned(Entry) then
    Result := Entry.BaseDomainObject.Self as TDomainObjectBase

  else Result := nil;
  
end;

function TDomainObjectBaseList.GetBaseDomainObjectCount: Integer;
begin

  Result := FInternalBaseDomainObjects.Count;
  
end;

function TDomainObjectBaseList.GetBaseDomainObjectEntryByIndex(
  Index: Integer): TDomainObjectBaseEntry;
begin

  Result := TDomainObjectBaseEntry(FInternalBaseDomainObjects[Index]);
  
end;

function TDomainObjectBaseList.GetBaseDomainObjectsByPropertyValue(
  const PropertyName: String;
  const Value: Variant
): TDomainObjectBaseList;
var
    BaseDomainObject: TDomainObjectBase;
begin

  Result := TDomainObjectBaseListClass(ClassType).Create;

  try

    for BaseDomainObject in Self do begin
      if
        TReflectionServices
          .GetObjectPropertyValue(BaseDomainObject, PropertyName) = Value
      then
        Result.AddBaseDomainObject(BaseDomainObject);
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDomainObjectBaseList.GetEnumerator: TDomainObjectBaseListEnumerator;
begin

  Result := TDomainObjectBaseListEnumerator.Create(Self);
  
end;

function TDomainObjectBaseList.GetInvariantsComplianceRequested: Boolean;
begin

  Result := FInvariantsComplianceAssistant.InvariantsComplianceRequested;

end;

function TDomainObjectBaseList.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDomainObjectBaseList.InsertBaseDomainObject(
  const Index: Integer;
  BaseDomainObject: TDomainObjectBase
);
var Entry: TDomainObjectBaseEntry;
    I: Integer;
    FoundDomainObjectEntryIndex: Integer;
    DomainObjectEntry: TDomainObjectBaseEntry;
    CurrentBaseDomainObject: TDomainObjectBase;
begin

  FoundDomainObjectEntryIndex := -1;
  
  for I := 0 to FInternalBaseDomainObjects.Count - 1 do begin

    Entry := TDomainObjectBaseEntry(FInternalBaseDomainObjects[I]);

    CurrentBaseDomainObject := Entry.BaseDomainObject.Self as TDomainObjectBase;

    if CurrentBaseDomainObject.Equals(BaseDomainObject) then
    begin

      FoundDomainObjectEntryIndex := I;
      Break;
      
    end;

  end;

  if FoundDomainObjectEntryIndex <> -1 then begin

    DomainObjectEntry :=
      TDomainObjectBaseEntry(
        FInternalBaseDomainObjects[FoundDomainObjectEntryIndex]
      );
      
    FInternalBaseDomainObjects.Delete(FoundDomainObjectEntryIndex);

  end

  else DomainObjectEntry := TDomainObjectBaseEntry.Create(BaseDomainObject);

  FInternalBaseDomainObjects.Insert(Index, DomainObjectEntry);
  
end;

function TDomainObjectBaseList.InternalClone: TObject;
var BaseDomainObject: TDomainObjectBase;
    CloneeDomainObjectBaseList: TDomainObjectBaseList;
begin

  Result := TDomainObjectBaseListClass(ClassType).Create;

  CloneeDomainObjectBaseList := Result as TDomainObjectBaseList;
  
  for BaseDomainObject in Self do begin

    CloneeDomainObjectBaseList.AddBaseDomainObject(
      BaseDomainObject.Clone as TDomainObjectBase
    );

  end;

end;

function TDomainObjectBaseList.IsEmpty: Boolean;
begin

  Result := Count = 0;
  
end;

function TDomainObjectBaseList.Last: TDomainObjectBase;
begin

  Result :=
    TDomainObjectBase(
      TDomainObjectBaseEntry(
        FInternalBaseDomainObjects.Last
      ).BaseDomainObject.Self
    );
  
end;

procedure TDomainObjectBaseList.OrderByListComparator(
  ListComparator: TListSortCompare);
begin

  FInternalBaseDomainObjects.Sort(ListComparator);
  
end;

procedure TDomainObjectBaseList.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean; ExceptionType: TDomainExceptionClass;
  const Msg: String);
begin

  FInvariantsComplianceAssistant
    .RaiseConditionalExceptionIfInvariantsComplianceRequested(
      Condition, ExceptionType, Msg
    );

end;

procedure TDomainObjectBaseList.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean; const Msg: String);
begin

  FInvariantsComplianceAssistant
    .RaiseConditionalExceptionIfInvariantsComplianceRequested(
      Condition, Msg
    );

end;

procedure TDomainObjectBaseList.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean; ExceptionType: TDomainExceptionClass;
  const Msg: String; const Args: array of const);
begin

  FInvariantsComplianceAssistant
    .RaiseConditionalExceptionIfInvariantsComplianceRequested(
      Condition, ExceptionType, Msg, Args
    );
    
end;

procedure TDomainObjectBaseList.RaiseConditionalExceptionIfInvariantsComplianceRequested(
  const Condition: Boolean; const Msg: String; const Args: array of const);
begin

  FInvariantsComplianceAssistant
    .RaiseConditionalExceptionIfInvariantsComplianceRequested(
      Condition, Msg, Args
    );

end;

procedure TDomainObjectBaseList.RaiseExceptionIfInvariantsComplianceRequested(
  ExceptionType: TDomainExceptionClass; const Msg: String);
begin

  FInvariantsComplianceAssistant.RaiseExceptionIfInvariantsComplianceRequested(
    ExceptionType, Msg
  );
  
end;

procedure TDomainObjectBaseList.RaiseExceptionIfInvariantsComplianceRequested(
  const Msg: String);
begin

  FInvariantsComplianceAssistant
    .RaiseExceptionIfInvariantsComplianceRequested(Msg);

end;

procedure TDomainObjectBaseList.RaiseExceptionIfInvariantsComplianceRequested(
  ExceptionType: TDomainExceptionClass; const Msg: String;
  const Args: array of const);
begin

  FInvariantsComplianceAssistant
    .RaiseExceptionIfInvariantsComplianceRequested(
      ExceptionType, Msg, Args
    );

end;

procedure TDomainObjectBaseList.RaiseExceptionIfInvariantsComplianceRequested(
  const Msg: String; const Args: array of const);
begin

  FInvariantsComplianceAssistant
    .RaiseExceptionIfInvariantsComplianceRequested(
      Msg, Args
    );

end;

procedure TDomainObjectBaseList.SetBaseDomainObjectByIndex(
  Index: Integer;
  const Value: TDomainObjectBase
);
var Entry: TDomainObjectBaseEntry;
begin

  Entry := TDomainObjectBaseEntry(FInternalBaseDomainObjects[Index]);

  if Assigned(Entry) then
    Entry.BaseDomainObject := Value;

end;

procedure TDomainObjectBaseList.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  FInvariantsComplianceAssistant.InvariantsComplianceRequested := Value;
  
end;

{ TDomainObjectBaseList.TDomainObjectBaseEntry }

constructor TDomainObjectBaseEntry.Create(
  BaseDomainObject: TDomainObjectBase);
begin

  Self.BaseDomainObject := BaseDomainObject;

end;

destructor TDomainObjectBaseEntry.Destroy;
begin

  inherited;

end;

end.
