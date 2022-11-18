unit Department;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  Classes;

type

  TDepartment = class (TDomainObject)

    private

      FTopLevelDepartmentId: Variant;
      FCode: String;
      FShortName: String;
      FFullName: String;

    public

      constructor Create; overload;

    public

      class function TopLevelDepartmentIdPropName: String; static;
      class function CodePropName: String; static;
      class function ShortNamePropName: String; static;
      class function FullNamePropName: String; static;

    published

      property TopLevelDepartmentId: Variant
      read FTopLevelDepartmentId write FTopLevelDepartmentId;
      
      property Code: String read FCode write FCode;
      property ShortName: String read FShortName write FShortName;
      property FullName: String read FFullName write FFullName;
      
  end;

  TDepartments = class;

  TDepartmentsEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentDepartment: TDepartment;

    public

      constructor Create(Departments: TDepartments);

      property Current: TDepartment read GetCurrentDepartment;

  end;

  TDepartments = class (TDomainObjectList)

    private

      function GetDepartmentByIndex(Index: Integer): TDepartment;
      procedure SetDepartmentByIndex(Index: Integer; Department: TDepartment);

    public

      function GetEnumerator: TDepartmentsEnumerator;

      function FindDepartmentByIdentity(const DepartmentIdentity: Variant): TDepartment;
      
      property Items[Index: Integer]: TDepartment
      read GetDepartmentByIndex write SetDepartmentByIndex;

  end;

implementation

{ TDepartment }

constructor TDepartment.Create;
begin

  inherited;
  
end;

class function TDepartment.CodePropName: String;
begin

  Result := 'Code';

end;

class function TDepartment.FullNamePropName: String;
begin

  Result := 'FullName';

end;

class function TDepartment.ShortNamePropName: String;
begin

  Result := 'ShortName';

end;

class function TDepartment.TopLevelDepartmentIdPropName: String;
begin

  Result := 'TopLevelDepartmentId';
  
end;

{ TDepartmentsEnumerator }

constructor TDepartmentsEnumerator.Create(Departments: TDepartments);
begin

  inherited Create(Departments);

end;

function TDepartmentsEnumerator.GetCurrentDepartment: TDepartment;
begin

  Result := GetCurrentDomainObject as TDepartment;
  
end;

{ TDepartments }

function TDepartments.FindDepartmentByIdentity(
  const DepartmentIdentity: Variant): TDepartment;
begin

  Result := FindByIdentity(DepartmentIdentity) as TDepartment;

end;

function TDepartments.GetDepartmentByIndex(Index: Integer): TDepartment;
begin

  Result := GetDomainObjectByIndex(Index) as TDepartment;
  
end;

function TDepartments.GetEnumerator: TDepartmentsEnumerator;
begin

  Result := TDepartmentsEnumerator.Create(Self);

end;

procedure TDepartments.SetDepartmentByIndex(Index: Integer;
  Department: TDepartment);
begin

  SetDomainObjectByIndex(Index, Department);
  
end;

end.
