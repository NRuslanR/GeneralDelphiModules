unit AbstractEmployeeIsSameAsOrReplacingForOthersSpecification;

interface

uses

  EmployeeIsSameAsOrReplacingForOthersSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification =
    class (
      TInterfacedObject,
      IEmployeeIsSameAsOrReplacingForOthersSpecification
    )

      protected

        type

          TReplacingRelationshipDefiningMethod =
            function (
              TargetEmployee: TEmployee;
              OtherEmployee: TEmployee
            ): Boolean of object;

      protected

        function CreateSpecificationResultInstance: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult; virtual;

        function InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
          TargetEmployee: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean; virtual;

        function InternalIsEmployeeSameAsOrReplacingForAnyOfEmployees(
          TargetEmployee: TEmployee;
          OtherEmployees: TEmployees
        ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult; virtual;

         function InternalAreAnyOfEmployeesSameAsOrReplacingForOtherEmployee(
          TargetEmployees: TEmployees;
          OtherEmployee: TEmployee
        ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult; virtual;

      protected

        function IsEmployeeHasReplacingRelationshipWithOtherEmployees(
          TargetEmployee: TEmployee;
          OtherEmployees: TEmployees;
          ReplacingRelationshipDefiningMethod: TReplacingRelationshipDefiningMethod
        ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;

        function IsOtherEmployeeSameAsOrReplacingForTargetEmployee(
          OtherEmployee: TEmployee;
          TargetEmployee: TEmployee
        ): Boolean;
        
      public

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

{ TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification }

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  AreAnyOfEmployeesSameAsOrReplacingForOtherEmployee(
    TargetEmployees: TEmployees;
    OtherEmployee: TEmployee
  ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
begin

  Result :=
    InternalAreAnyOfEmployeesSameAsOrReplacingForOtherEmployee(
      TargetEmployees, OtherEmployee
    );
    
end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.CreateSpecificationResultInstance: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
begin

  Result := TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.Create;
  
end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  InternalAreAnyOfEmployeesSameAsOrReplacingForOtherEmployee(
    TargetEmployees: TEmployees;
    OtherEmployee: TEmployee
  ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
begin

  Result :=
    IsEmployeeHasReplacingRelationshipWithOtherEmployees(
      OtherEmployee,
      TargetEmployees,
      IsOtherEmployeeSameAsOrReplacingForTargetEmployee
    );
    
end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  InternalIsEmployeeSameAsOrReplacingForAnyOfEmployees(
    TargetEmployee: TEmployee;
    OtherEmployees: TEmployees
  ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
begin

  Result :=
    IsEmployeeHasReplacingRelationshipWithOtherEmployees(
      TargetEmployee,
      OtherEmployees,
      IsEmployeeSameAsOrReplacingForOtherEmployee
    );

end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
  TargetEmployee, OtherEmployee: TEmployee): Boolean;
begin

  Result := TargetEmployee.IsSameAs(OtherEmployee);
  
end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  IsEmployeeHasReplacingRelationshipWithOtherEmployees(
    TargetEmployee: TEmployee; OtherEmployees: TEmployees;
    ReplacingRelationshipDefiningMethod: TReplacingRelationshipDefiningMethod
  ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
var OtherEmployee: TEmployee;
begin

  Result := CreateSpecificationResultInstance;

  try

    for OtherEmployee in OtherEmployees do begin

      if ReplacingRelationshipDefiningMethod(TargetEmployee, OtherEmployee)
      then begin

        Result.IsSatisfied := True;

        if not TargetEmployee.IsSameAs(OtherEmployee) then
          Result.AddReplaceableEmployee(OtherEmployee);
          
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;
      
  end;
  
end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  IsEmployeeSameAsOrReplacingForAnyOfEmployees(
    TargetEmployee: TEmployee;
    OtherEmployees: TEmployees
  ): TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
begin

  Result := InternalIsEmployeeSameAsOrReplacingForAnyOfEmployees(
              TargetEmployee, OtherEmployees
            );
            
end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  IsEmployeeSameAsOrReplacingForOtherEmployee(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
begin

  Result := InternalIsEmployeeSameAsOrReplacingForOtherEmployee(
              TargetEmployee, OtherEmployee
            );

end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  IsEmployeeSameAsOrReplacingForOtherEmployeeOrViceVersa(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
begin

  Result :=
    IsEmployeeSameAsOrReplacingForOtherEmployee(
      TargetEmployee, OtherEmployee
    )
    or
    IsEmployeeSameAsOrReplacingForOtherEmployee(
      OtherEmployee, TargetEmployee
    );

end;

function TAbstractEmployeeIsSameAsOrReplacingForOthersSpecification.
  IsOtherEmployeeSameAsOrReplacingForTargetEmployee(
    OtherEmployee, TargetEmployee: TEmployee
  ): Boolean;
begin

  Result :=
    IsEmployeeSameAsOrReplacingForOtherEmployee(
      OtherEmployee, TargetEmployee
    );
    
end;

end.
