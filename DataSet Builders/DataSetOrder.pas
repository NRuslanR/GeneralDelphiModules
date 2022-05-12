unit DataSetOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridLevel, cxClasses, cxGridCustomView, cxGrid;

type
  TForm1 = class(TForm)
    ClientDataSet1: TClientDataSet;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DataSource1: TDataSource;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    DepartmentNameColumnGrid1DBTableView1Column2: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses

  ClientDataSetBuilder;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin

  ClientDataSet1 :=
    TClientDataSet(
      TClientDataSetBuilder
        .Create
          .AddField('surname', ftString, 55)
          .AddField('name', ftString, 66)
            .Build

    );

  ClientDataSet1.IndexDefs.Add('dsds', 'dsds;dsds;dsds', []);


  ClientDataSet1.IndexFieldNames := 'surname;name';

  with ClientDataSet1.IndexDefs.AddIndexDef do begin

    Fields := 'surname;name';
    DescFields := 'name';
    Options := [];
    Name := 'surname_idx';

  end;

  ClientDataSet1.IndexName := 'surname_idx';

  ClientDataSet1.Open;
  
  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('surname').AsString := 'Норотников';
  ClientDataSet1.FieldByName('name').AsString := 'Василий';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('surname').AsString := 'Багаутдинов';
  ClientDataSet1.FieldByName('name').AsString := 'Арслан';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('surname').AsString := 'Багаутдинов';
  ClientDataSet1.FieldByName('name').AsString := 'Хиталий';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('surname').AsString := 'Багаутдинов';
  ClientDataSet1.FieldByName('name').AsString := 'Гаауауау';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('surname').AsString := 'Багаутдинов';
  ClientDataSet1.FieldByName('name').AsString := 'ЕЕЕауауау';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('surname').AsString := '1Бгаутдинов';
  ClientDataSet1.FieldByName('name').AsString := 'Крслан';
  ClientDataSet1.Post;

  DataSource1.DataSet := ClientDataSet1;

end;

end.
