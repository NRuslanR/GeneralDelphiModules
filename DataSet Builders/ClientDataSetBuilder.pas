unit ClientDataSetBuilder;

interface

uses

  AbstractDataSetBuilder,
  DB,
  SysUtils,
  DBClient,
  Classes;

type

  TClientDataSetBuilder = class (TAbstractDataSetBuilder)

    protected

      function CreateDataSet: TDataSet; override;
      procedure InitializeDataSet(DataSet: TDataSet); override;

    protected

      procedure CopyDataSetData(Target, Source: TDataSet); override;

    public

      function Build: TDataSet; override;

  end;
  
implementation

{ TClientDataSetBuilder }

function TClientDataSetBuilder.Build: TDataSet;
begin

  Result := inherited Build;

  TClientDataSet(Result).CreateDataSet;
  
end;

procedure TClientDataSetBuilder.CopyDataSetData(Target, Source: TDataSet);
begin

  TClientDataSet(Target).Data := TClientDataSet(Source).Data;

end;

function TClientDataSetBuilder.CreateDataSet: TDataSet;
begin

  Result := TClientDataSet.Create(nil);

end;

procedure TClientDataSetBuilder.InitializeDataSet(DataSet: TDataSet);
var ClientDataSet: TClientDataSet;
begin

  inherited;

end;

end.
