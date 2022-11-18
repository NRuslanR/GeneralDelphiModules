unit StandardDepartmentEmployeeDistributionSpecification;

interface

uses

  DepartmentEmployeeDistributionSpecification,
  DepartmentFinder,
  Employee,
  Department,
  SysUtils,
  Classes;

type

  TStandardDepartmentEmployeeDistributionSpecification =
    class (TInterfacedObject, IDepartmentEmployeeDistributionSpecification)

      protected

        FDepartmentFinder: IDepartmentFinder;
        
      public

        constructor Create(DepartmentFinder: IDepartmentFinder);
        
        function AreEmployeesBelongsToSameHeadKindredDepartment(
          Employees: TEmployees
        ): Boolean; virtual;

        function AreEmployeesBelongsToSameDepartment(
          Employees: TEmployees
        ): Boolean; virtual;

    end;

implementation

uses

  IDomainObjectUnit,
  Variants;

function TStandardDepartmentEmployeeDistributionSpecification.
  AreEmployeesBelongsToSameDepartment(
    Employees: TEmployees
  ): Boolean;
var Employee: TEmployee;
    PreviousDepartmentId: Variant;
begin

  PreviousDepartmentId := Null;

  for Employee in Employees do begin

    if VarIsNull(PreviousDepartmentId) then begin

      PreviousDepartmentId := Employee.DepartmentIdentity;
      
    end

    else if PreviousDepartmentId <> Employee.DepartmentIdentity then begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;

end;

function TStandardDepartmentEmployeeDistributionSpecification.
  AreEmployeesBelongsToSameHeadKindredDepartment(
    Employees: TEmployees
  ): Boolean;
var Employee: TEmployee;
    PreviousHeadKindredDepartmentId: Variant;
    HeadEmployeeDepartment: TDepartment;
    FreeDepartment: IDomainObject;
begin

  PreviousHeadKindredDepartmentId := Null;
  HeadEmployeeDepartment := nil;

  if AreEmployeesBelongsToSameDepartment(Employees) then begin

    Result := True;
    Exit;
    
  end;

  for Employee in Employees do begin

    HeadEmployeeDepartment :=
      FDepartmentFinder.FindHeadKindredDepartmentForInnerDepartment(
        Employee.DepartmentIdentity
      );

    FreeDepartment := HeadEmployeeDepartment;
    
    if VarIsNull(PreviousHeadKindredDepartmentId) then begin

      PreviousHeadKindredDepartmentId := HeadEmployeeDepartment.Identity;

    end

    else if HeadEmployeeDepartment.Identity <> PreviousHeadKindredDepartmentId
    then begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;

end;

constructor TStandardDepartmentEmployeeDistributionSpecification.Create(
  DepartmentFinder: IDepartmentFinder
);
begin

  inherited Create;

  FDepartmentFinder := DepartmentFinder;

end;

end.
