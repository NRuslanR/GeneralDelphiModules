unit EmployeeIsSameAsOrReplacingForOthersSpecification;

interface

uses

  Employee,
  Disposable,
  SysUtils,
  Classes;

type

  TEmployeeIsSameAsOrReplacingForOthersSpecificationResult =
    class (TInterfacedObject, IDisposable)

      private

        function GetReplaceableEmployeeCount: Integer;
        function GetIsReplaceableEmployeeCountMoreThanOne: Boolean;

      public

        IsSatisfied: Boolean;
        ReplaceableEmployees: TEmployees;

      public

        destructor Destroy; override;
        constructor Create;

        function FetchReplaceableEmployeeFullNames: TStrings;
        function FetchReplaceableEmployeeFullNamesString: String;
        procedure AddReplaceableEmployee(ReplaceableEmployee: TEmployee);

      published

        property ReplaceableEmployeeCount: Integer
        read GetReplaceableEmployeeCount;

        property IsReplaceableEmployeeCountMoreThanOne: Boolean
        read GetIsReplaceableEmployeeCountMoreThanOne;

  end;

  IEmployeeIsSameAsOrReplacingForOthersSpecification = interface
    ['{69E362C1-89E2-44E8-B197-B91D33D5757F}']

      function IsEmployeeSameAsOrReplacingForOtherEmployee(
        TargetEmployee: TEmployee;
        OtherEmployee: TEmployee
      ): Boolean;

      function IsEmployeeSameAsOrReplacingForOtherEmployeeOrViceVersa(
        TargetEmployee: TEmployee;
        OtherEmployee: TEmployee
      ): Boolean;

      function IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        TargetEmployee: TEmployee;
        OtherEmployees: TEmployees
      ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;

      function AreAnyOfEmployeesSameAsOrReplacingForOtherEmployee(
        TargetEmployees: TEmployees;
        OtherEmployee: TEmployee
      ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;

  end;

implementation

{ TEmployeeIsSameAsOrReplacingForOthersSpecificationResult }

procedure TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.AddReplaceableEmployee(
  ReplaceableEmployee: TEmployee);
begin

  if not Assigned(ReplaceableEmployees) then
    ReplaceableEmployees := TEmployees.Create;

  ReplaceableEmployees.AddDomainObject(ReplaceableEmployee);
  
end;

constructor TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.Create;
begin

  inherited;
  
end;

destructor TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.Destroy;
begin

  FreeAndNil(ReplaceableEmployees);
  inherited;

end;

function TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.FetchReplaceableEmployeeFullNames: TStrings;
var Employee: TEmployee;
begin

  if not Assigned(ReplaceableEmployees) then begin

    Result := nil;
    Exit;
    
  end;

  Result := TStringList.Create;
  
  for Employee in ReplaceableEmployees do begin

    Result.Add(Employee.FullName);

  end;

end;

function TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.FetchReplaceableEmployeeFullNamesString: String;
begin

  with FetchReplaceableEmployeeFullNames do
    try

      Result := CommaText;
      
    finally

      Free;

    end;

end;

function TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.GetIsReplaceableEmployeeCountMoreThanOne: Boolean;
begin

  Result := ReplaceableEmployeeCount > 1;
  
end;

function TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.GetReplaceableEmployeeCount: Integer;
begin

  if Assigned(ReplaceableEmployees) then
    Result := ReplaceableEmployees.Count

  else Result := 0;
  
end;

end.
