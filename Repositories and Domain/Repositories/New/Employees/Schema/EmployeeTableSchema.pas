unit EmployeeTableSchema;

interface

uses

  SysUtils,
  EmployeeTableDef,
  EmployeeContactInfoTableDef,
  EmployeeReplacementTableDef,
  EmployeeRoleAssocTableDef,
  EmployeeWorkGroupTableDef,
  EmployeeWorkGroupAssocTableDef,
  RoleTableDef,
  Disposable;

type

  TEmployeeTableSchema = class

    private

      FFreeEmployeeTableDef: IDisposable;
      FFreeEmailTableDef: IDisposable;
      FFreeTelephoneTableDef: IDisposable;
      FFreeReplacementTableDef: IDisposable;
      FFreeRoleAssocTableDef: IDisposable;
      FFreeWorkGroupTableDef: IDisposable;
      FFreeWorkGroupAssocTableDef: IDisposable;
      FFreeRoleTableDef: IDisposable;

    private

      FEmployeeTableDef: TEmployeeTableDef;
      FEmailTableDef: TEmployeeEmailTableDef;
      FTelephoneTableDef: TEmployeeTelephoneTableDef;
      FReplacementTableDef: TEmployeeReplacementTableDef;
      FRoleAssocTableDef: TEmployeeRoleAssocTableDef;
      FWorkGroupTableDef: TEmployeeWorkGroupTableDef;
      FWorkGroupAssocTableDef: TEmployeeWorkGroupAssocTableDef;
      FRoleTableDef: TRoleTableDef;

      procedure SetEmailTableDef(const Value: TEmployeeEmailTableDef);

      procedure SetReplacementTableDef(
        const Value: TEmployeeReplacementTableDef);

      procedure SetRoleAssocTableDef(
        const Value: TEmployeeRoleAssocTableDef);

      procedure SetEmployeeTableDef(const Value: TEmployeeTableDef);

      procedure SetTelephoneTableDef(
        const Value: TEmployeeTelephoneTableDef);

      procedure SetWorkGroupAssocTableDef(
        const Value: TEmployeeWorkGroupAssocTableDef);

      procedure SetWorkGroupTableDef(
        const Value: TEmployeeWorkGroupTableDef);

      procedure SetRoleTableDef(const Value: TRoleTableDef);

    public

      property EmployeeTableDef: TEmployeeTableDef
      read FEmployeeTableDef write SetEmployeeTableDef;

      property EmailTableDef: TEmployeeEmailTableDef
      read FEmailTableDef write SetEmailTableDef;

      property TelephoneTableDef: TEmployeeTelephoneTableDef
      read FTelephoneTableDef write SetTelephoneTableDef;
      
      property ReplacementTableDef: TEmployeeReplacementTableDef
      read FReplacementTableDef write SetReplacementTableDef;
      
      property RoleAssocTableDef: TEmployeeRoleAssocTableDef
      read FRoleAssocTableDef write SetRoleAssocTableDef;

      property WorkGroupTableDef: TEmployeeWorkGroupTableDef
      read FWorkGroupTableDef write SetWorkGroupTableDef;

      property WorkGroupAssocTableDef: TEmployeeWorkGroupAssocTableDef
      read FWorkGroupAssocTableDef write SetWorkGroupAssocTableDef;
      
      property RoleTableDef: TRoleTableDef
      read FRoleTableDef write SetRoleTableDef;

  end;
  
implementation

{ TEmployeeTableSchema }

procedure TEmployeeTableSchema.SetEmailTableDef(
  const Value: TEmployeeEmailTableDef);
begin

  FEmailTableDef := Value;
  FFreeEmailTableDef := Value;
  
end;

procedure TEmployeeTableSchema.SetReplacementTableDef(
  const Value: TEmployeeReplacementTableDef);
begin

  FReplacementTableDef := Value;
  FFreeReplacementTableDef := Value;

end;

procedure TEmployeeTableSchema.SetRoleAssocTableDef(
  const Value: TEmployeeRoleAssocTableDef);
begin

  FRoleAssocTableDef := Value;
  FFreeRoleAssocTableDef := Value;

end;

procedure TEmployeeTableSchema.SetEmployeeTableDef(
  const Value: TEmployeeTableDef);
begin

  FEmployeeTableDef := Value;
  FFreeEmployeeTableDef := Value;
  
end;

procedure TEmployeeTableSchema.SetTelephoneTableDef(
  const Value: TEmployeeTelephoneTableDef);
begin

  FTelephoneTableDef := Value;
  FFreeTelephoneTableDef := Value;

end;

procedure TEmployeeTableSchema.SetWorkGroupAssocTableDef(
  const Value: TEmployeeWorkGroupAssocTableDef);
begin

  FWorkGroupAssocTableDef := Value;
  FFreeWorkGroupAssocTableDef := Value;

end;

procedure TEmployeeTableSchema.SetWorkGroupTableDef(
  const Value: TEmployeeWorkGroupTableDef);
begin

  FWorkGroupTableDef := Value;
  FFreeWorkGroupTableDef := Value;

end;

procedure TEmployeeTableSchema.SetRoleTableDef(const Value: TRoleTableDef);
begin

  FRoleTableDef := Value;
  FFreeRoleTableDef := Value;

end;

end.
