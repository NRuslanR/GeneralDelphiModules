unit DomainObjectListUnit;

interface

uses

  SysUtils,
  Classes,
  DomainObjectUnit,
  DomainException,
  IDomainObjectUnit,
  DomainObjectBaseListUnit,
  IDomainObjectListUnit,
  VariantListUnit,
  ClonableUnit,
  EquatableUnit;

type

  TDomainObjectList = class;

  TDomainObjectListEnumerator = class (TDomainObjectBaseListEnumerator)

    protected
      
      function GetCurrentDomainObject: TDomainObject;

      constructor Create(DomainObjectList: TDomainObjectList);

    public

      property Current: TDomainObject read GetCurrentDomainObject;

  end;

  TDomainObjectList = class (
                             TDomainObjectBaseList,
                             IDomainObjectList
                            )

    protected

      function GetDomainObjectByIndex(Index: Integer): TDomainObject; virtual;

      procedure SetDomainObjectByIndex(
        Index: Integer;
        const Value: TDomainObject
      ); virtual;

      procedure DeleteDomainObjectEntryByIndex(const Index: Integer); virtual;

      function FindEntryByDomainObject(DomainObject: TDomainObject): TDomainObjectBaseEntry; virtual;

      function GetDomainObjectCount: Integer; virtual;

    public

      destructor Destroy; override;
      constructor Create; override;

      procedure InsertDomainObject(
        const Index: Integer;
        DomainObject: TDomainObject
      ); virtual;

      function First: TDomainObject; virtual;
      function Last: TDomainObject; virtual;

      function CreateDomainObjectIdentityList: TVariantList; virtual;

      function GetIdentityAssignedDomainObjects: TDomainObjectList; virtual;
      function GetNotIdentityAssignedDomainObjects: TDomainObjectList; virtual;

      procedure PartitionByIdentityAssigning(
        var IdentityAssigneds: TDomainObjectList;
        var NotIdentityAssigneds: TDomainObjectList
      ); virtual;

      procedure AddDomainObject(DomainObject: TDomainObject); virtual;
      procedure AddDomainObjectList(DomainObjectList: TDomainObjectList); virtual;
      function ChangeDomainObject(SourceDomainObject: TDomainObject): TDomainObject;
      
      function Contains(DomainObject: TDomainObject): Boolean; virtual;
      function ContainsByIdentity(const Identity: Variant): Boolean; virtual;

      procedure DeleteDomainObject(DomainObject: TDomainObject); virtual;
      procedure DeleteDomainObjectByIdentity(const Identity: Variant); virtual;

      function GetByIdentityOrRaise(
        const Identity: Variant;
        const ErrorMessage: String = '';
        const DomainExceptionClass: TDomainExceptionClass = nil
      ): TDomainObject; virtual;

      function FindByIdentity(const Identity: Variant): TDomainObject; virtual;
      function FindByIdentities(const Identities: TVariantList): TDomainObjectList; virtual;
      function GetEnumerator: TDomainObjectListEnumerator; virtual;

      property Items[Index: Integer]: TDomainObject
      read GetDomainObjectByIndex
      write SetDomainObjectByIndex; default;

  end;

  TDomainObjectListClass = class of TDomainObjectList;

implementation

uses

  CopyableUnit,
  IDomainObjectBaseListUnit,
  VariantFunctions,
  Variants,
  AuxDebugFunctionsUnit;

{ TDomainObjectListEnumerator }

constructor TDomainObjectListEnumerator.Create(
  DomainObjectList: TDomainObjectList);
begin

  inherited Create(DomainObjectList);

end;

function TDomainObjectListEnumerator.GetCurrentDomainObject: TDomainObject;
begin

  Result := TDomainObject(GetCurrentBaseDomainObject);

end;

{ TDomainObjectList }

procedure TDomainObjectList.AddDomainObject(DomainObject: TDomainObject);
begin

  AddBaseDomainObject(DomainObject);
  
end;

procedure TDomainObjectList.AddDomainObjectList(
  DomainObjectList: TDomainObjectList
);
var
    DomainObject: TDomainObject;
begin

  for DomainObject in DomainObjectList do
    AddDomainObject(DomainObject);
    
end;

function TDomainObjectList.ChangeDomainObject(
  SourceDomainObject: TDomainObject): TDomainObject;
begin

  Result := GetByIdentityOrRaise(SourceDomainObject.Identity);

  Result.CopyFrom(SourceDomainObject, ieInvariantsEnsuringRequested);

end;

function TDomainObjectList.Contains(DomainObject: TDomainObject): Boolean;
begin

  Result := inherited Contains(DomainObject);
  
end;

function TDomainObjectList.ContainsByIdentity(const Identity: Variant): Boolean;
begin

  Result := Assigned(FindByIdentity(Identity));

end;

constructor TDomainObjectList.Create;
begin

  inherited;

end;

function TDomainObjectList.CreateDomainObjectIdentityList: TVariantList;
var DomainObject: TDomainObject;
begin

  Result := TVariantList.Create;

  try

    for DomainObject in Self do
      Result.Add(DomainObject.Identity);
      
  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

procedure TDomainObjectList.DeleteDomainObject(DomainObject: TDomainObject);
var I: Integer;
begin

  DeleteBaseDomainObject(DomainObject);

end;

procedure TDomainObjectList.DeleteDomainObjectByIdentity(
  const Identity: Variant);
var DomainObject: TDomainObject;
begin

  DomainObject := FindByIdentity(Identity);

  if Assigned(DomainObject) then
    DeleteDomainObject(DomainObject);

end;

procedure TDomainObjectList.DeleteDomainObjectEntryByIndex(
  const Index: Integer);
begin

  DeleteBaseDomainObjectEntryByIndex(Index);
  
end;

destructor TDomainObjectList.Destroy;
begin

  inherited;

end;

function TDomainObjectList.FindByIdentities(
  const Identities: TVariantList): TDomainObjectList;
var
    DomainObject: TDomainObject;
begin

  if not Assigned(Identities) then begin

    Result := nil;

    Exit;
    
  end;

  Result := nil;

  try

    for DomainObject in Self do
      if Identities.Contains(DomainObject.Identity) then begin

        if not Assigned(Result) then
          Result := TDomainObjectListClass(ClassType).Create;
          
        Result.AddDomainObject(DomainObject);

      end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDomainObjectList.FindByIdentity(const Identity: Variant): TDomainObject;
var Entry: TDomainObjectBaseEntry;
    I: Integer;
begin

  for I := 0 to Count - 1 do begin

    Entry := GetBaseDomainObjectEntryByIndex(I);

    if (Entry.BaseDomainObject.Self as TDomainObject).Identity = Identity then begin

      Result := Entry.BaseDomainObject.Self as TDomainObject;
      Exit;

    end;

  end;

  Result := nil;

end;

function TDomainObjectList.FindEntryByDomainObject(
  DomainObject: TDomainObject
): TDomainObjectBaseEntry;
begin

  Result := TDomainObjectBaseEntry(inherited FindEntryByBaseDomainObject(DomainObject));

end;

function TDomainObjectList.First: TDomainObject;
begin

  Result := TDomainObject(inherited First);
  
end;

function TDomainObjectList.GetByIdentityOrRaise(
  const Identity: Variant;
  const ErrorMessage: String;
  const DomainExceptionClass: TDomainExceptionClass
): TDomainObject;
var
    ExceptionClass: TDomainExceptionClass;
begin

  Result := FindByIdentity(Identity);

  if Assigned(Result) then Exit;
  
  Raise
    TDomainExceptionClass(
      VarIfThen(
        Assigned(DomainExceptionClass),
        DomainExceptionClass,
        TDomainObjectNotFoundException
      )
    )
    .Create(
      VarIfThen(
        Trim(ErrorMessage) <> '',
        ErrorMessage,
        'Объект предметной области не найден'
      )
    );

end;

function TDomainObjectList.GetDomainObjectByIndex(
  Index: Integer): TDomainObject;
begin

  Result := TDomainObject(inherited GetBaseDomainObjectByIndex(Index));

end;

function TDomainObjectList.GetDomainObjectCount: Integer;
begin

  Result := GetBaseDomainObjectCount;
  
end;

function TDomainObjectList.GetEnumerator: TDomainObjectListEnumerator;
begin

  Result := TDomainObjectListEnumerator.Create(Self);
  
end;

function TDomainObjectList.GetIdentityAssignedDomainObjects: TDomainObjectList;
var
    IdentityAssigneds, Placeholder: TDomainObjectList;
    Free: IDomainObjectList;
begin

  PartitionByIdentityAssigning(IdentityAssigneds, Placeholder);

  Free := Placeholder;
  
end;

function TDomainObjectList.GetNotIdentityAssignedDomainObjects: TDomainObjectList;
var
    Placeholder: TDomainObjectList;
    Free: IDomainObjectList;
begin

  PartitionByIdentityAssigning(Placeholder, Result);

  Free := Placeholder;

end;

procedure TDomainObjectList.InsertDomainObject(
  const Index: Integer;
  DomainObject: TDomainObject
);
begin

  InsertBaseDomainObject(Index, DomainObject);
  
end;

function TDomainObjectList.Last: TDomainObject;
begin

  Result := TDomainObject(inherited Last);
  
end;

procedure TDomainObjectList.PartitionByIdentityAssigning(
  var IdentityAssigneds: TDomainObjectList;
  var NotIdentityAssigneds: TDomainObjectList
);
var
    DomainObject: TDomainObject;
begin

  IdentityAssigneds := TDomainObjectListClass(ClassType).Create;
  NotIdentityAssigneds := TDomainObjectListClass(ClassType).Create;

  try

    for DomainObject in Self do begin

      if DomainObject.IsIdentityAssigned then
        IdentityAssigneds.AddDomainObject(DomainObject)

      else NotIdentityAssigneds.AddDomainObject(DomainObject);
      
    end;

  except

    FreeAndNil(IdentityAssigneds);
    FreeAndNil(NotIdentityAssigneds);

    Raise;

  end;
  
end;

procedure TDomainObjectList.SetDomainObjectByIndex(
  Index: Integer;
  const Value: TDomainObject
);
begin

  SetBaseDomainObjectByIndex(Index, Value);

end;

end.
