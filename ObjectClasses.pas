unit ObjectClasses;

interface

uses

  SysUtils,
  Classes;

type

  TClasses = class;

  TClassesEnumerator = class (TListEnumerator)

    private

      function GetCurrentObjectClass: TClass;
      
    public

      constructor Create(ObjectClasses: TClasses);

      property Current: TClass read GetCurrentObjectClass;

  end;

  TClasses = class (TList)

    private

      function GetObjectClassByIndex(Index: Integer): TClass;
      procedure SetObjectClassByIndex(Index: Integer; const Value: TClass);
      
    public

      function Add(ObjectClass: TClass): Integer;
      function Remove(ObjectClass: TClass): Integer;
      function IndexOf(ObjectClass: TClass): Integer;

      function GetEnumerator: TClassesEnumerator;

      property Items[Index: Integer]: TClass
      read GetObjectClassByIndex write SetObjectClassByIndex; default;
      
  end;

implementation

{ TClassesEnumerator }

constructor TClassesEnumerator.Create(ObjectClasses: TClasses);
begin

  inherited Create(ObjectClasses);

end;

function TClassesEnumerator.GetCurrentObjectClass: TClass;
begin

  Result := TClass(GetCurrent);

end;

{ TClasses }

function TClasses.Add(ObjectClass: TClass): Integer;
begin

  Result := inherited Add(ObjectClass);

end;

function TClasses.GetEnumerator: TClassesEnumerator;
begin

  Result := TClassesEnumerator.Create(Self);

end;

function TClasses.GetObjectClassByIndex(Index: Integer): TClass;
begin

  Result := TClass(Get(Index));

end;

function TClasses.IndexOf(ObjectClass: TClass): Integer;
begin

  Result := inherited IndexOf(ObjectClass);

end;

function TClasses.Remove(ObjectClass: TClass): Integer;
begin

  Result := inherited Remove(ObjectClass);

end;

procedure TClasses.SetObjectClassByIndex(Index: Integer; const Value: TClass);
begin

  Put(Index, Value);

end;

end.
