unit EmployeeIsSameAsOrDeputySpecification;

interface

uses

  Employee;

type

  IEmployeeIsSameAsOrDeputySpecification = interface
    ['{07EC1867-C14A-4459-8643-B7BAA540781D}']

    function IsEmployeeSameAsOrDeputyForOther(
      TargetEmployee: TEmployee;
      OtherEmployee: TEmployee
    ): Boolean;

    function IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
      TargetEmployee: TEmployee;
      OtherEmployee: TEmployee
    ): Boolean;

  end;
  
implementation

end.
