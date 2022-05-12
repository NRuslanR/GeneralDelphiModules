unit MemTableEhBuilder;

interface

uses

  AbstractDataSetBuilder,
  DB,
  SysUtils,
  MemTableEh,
  Classes;

type

  TMemTableEhBuilder = class (TAbstractDataSetBuilder)

    protected

      function CreateDataSet: TDataSet; override;
      procedure InitializeDataSet(DataSet: TDataSet); override;

    public

      function Build: TDataSet; override;

  end;
  
implementation

{ TMemTableEhBuilder }

function TMemTableEhBuilder.Build: TDataSet;
begin

  Result := inherited Build;

  TMemTableEh(Result).CreateDataSet;
  
end;

function TMemTableEhBuilder.CreateDataSet: TDataSet;
begin

  Result := TMemTableEh.Create(nil);

end;

procedure TMemTableEhBuilder.InitializeDataSet(DataSet: TDataSet);
begin

  inherited InitializeDataSet(DataSet);

end;

end.
