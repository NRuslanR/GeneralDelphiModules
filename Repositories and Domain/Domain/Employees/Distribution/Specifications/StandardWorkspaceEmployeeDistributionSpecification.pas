unit StandardWorkspaceEmployeeDistributionSpecification;

interface

uses

  WorkspaceEmployeeDistributionSpecification,
  Employee,
  EmployeeFinder,
  SysUtils,
  Classes;

type

  TStandardWorkspaceEmployeeDistributionSpecification =
    class (TInterfacedObject, IWorkspaceEmployeeDistributionSpecification)

      protected

        FEmployeeFinder: IEmployeeFinder;
        
      public

        constructor Create(EmployeeFinder: IEmployeeFinder);
        
        function IsEmployeeWorkspaceIncludesOtherEmployee(
          TargetEmployee: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean; virtual;

        function IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
          TargetEmployee: TEmployee;
          OtherEmployees: TEmployees
        ): Boolean; virtual;
      
    end;

implementation

uses

  IDomainObjectListUnit;
  
{ TStandardWorkspaceEmployeeDistributionSpecification }

constructor TStandardWorkspaceEmployeeDistributionSpecification.Create(
  EmployeeFinder: IEmployeeFinder);
begin

  inherited Create;

  FEmployeeFinder := EmployeeFinder;
  
end;

function TStandardWorkspaceEmployeeDistributionSpecification.
  IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
    TargetEmployee: TEmployee;
    OtherEmployees: TEmployees
  ): Boolean;
var OtherEmployee: TEmployee;
begin

  for OtherEmployee in OtherEmployees do begin

    if IsEmployeeWorkspaceIncludesOtherEmployee(TargetEmployee, OtherEmployee)
    then begin

      Result := True;
      Exit;

    end;

  end;

  Result := False;
  
end;

function TStandardWorkspaceEmployeeDistributionSpecification.
  IsEmployeeWorkspaceIncludesOtherEmployee(
    TargetEmployee, OtherEmployee: TEmployee
  ): Boolean;
var TopLevelEmployees: TEmployees;
    FreeTopLevelEmployees: IDomainObjectList;
begin

  if TargetEmployee.IsSameAs(OtherEmployee) then begin

    Result := True;
    Exit;

  end;
  
  if TargetEmployee.IsOrdinaryEmployee then begin

    Result := False;
    Exit;
    
  end;

  TopLevelEmployees :=
    FEmployeeFinder.
      FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
        OtherEmployee.Identity
      );

  FreeTopLevelEmployees := TopLevelEmployees;

  if TargetEmployee.IsLeader then begin

    Result :=
        Assigned(TopLevelEmployees)
        and TopLevelEmployees.Contains(TargetEmployee);

  end

  else begin

    Result :=
      (
       TargetEmployee.IsSubLeaderForTopLevelEmployee
       or TargetEmployee.IsSecretaryForTopLevelEmployee
      )
      and (
        (
          Assigned(TopLevelEmployees)
          and TopLevelEmployees.Contains(TargetEmployee.TopLevelEmployee)
        )
        or TargetEmployee.TopLevelEmployee.IsSameAs(OtherEmployee)
      );

  end;

end;


end.
