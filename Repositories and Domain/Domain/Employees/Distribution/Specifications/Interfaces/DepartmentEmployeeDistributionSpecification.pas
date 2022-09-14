unit DepartmentEmployeeDistributionSpecification;

interface

uses

  Employee;

type

  IDepartmentEmployeeDistributionSpecification = interface
    ['{B1738369-5BD9-40BE-8C93-12A6B620321C}']
    
    function AreEmployeesBelongsToSameHeadKindredDepartment(
      Employees: TEmployees
    ): Boolean;
    
    function AreEmployeesBelongsToSameDepartment(
      Employees: TEmployees
    ): Boolean;

  end;
  
implementation

end.
