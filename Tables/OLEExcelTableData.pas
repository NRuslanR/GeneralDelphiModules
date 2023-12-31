unit OLEExcelTableData;

interface

uses

  TableData,
  ComObj,
  SysUtils,
  Classes;

type

  TOLEExcelTableData = class (TInterfacedObject, ITableData)

    private

      const

        xlCellTypeLastCell = $0000000B;
        
    private

      FExcelFile: OleVariant;
      FSheetNumber: Integer;
      
      FCells: OleVariant;
      
      FRowCount: Integer;
      FColumnCount: Integer;

      function OpenExcelFile(const FilePath: String): OleVariant;
      procedure CloseExcelFile;

      procedure RefreshData(
        ExcelFile: OleVariant;
        const SheetNumber: Integer;
        var Cells: OleVariant;
        var RowCount: Integer;
        var ColumnCount: Integer
      );
      
    public

      constructor Create(
        const ExcelFilePath: string;
        const SheetNumber: Integer = 1
      );

      destructor Destroy; override;
      
    public

      procedure Refresh;

      procedure LoadFrom(
        const ExcelFilePath: String;
        const SheetNumber: Integer = 1
      );
      
      function RowCount: Integer;
      function ColumnCount: Integer;

      function GetCellValue(RowIndex, ColumnIndex: Integer): Variant;
      procedure SetCellValue(RowIndex, ColumnIndex: Integer; Value: Variant);

      property CellValues[RowIndex, ColumnIndex: Integer]: Variant
      read GetCellValue write SetCellValue; default;

  end;


implementation

uses

  Variants;
  
{ TOLEExcelTableData }

constructor TOLEExcelTableData.Create(
  const ExcelFilePath: string;
  const SheetNumber: Integer
);
var Sheet: OleVariant;
begin

  LoadFrom(ExcelFilePath, SheetNumber);

end;

function TOLEExcelTableData.OpenExcelFile(const FilePath: String): OleVariant;
begin

  try

    Result := CreateOleObject('Excel.Application');

  except

    on E: Exception do begin

      raise Exception.Create(
        '�� ������� ���������� � ���������� Excel'
      );

    end;

  end;

  Result.Visible := False;
  
  Result.WorkBooks.Open(FilePath);

end;


destructor TOLEExcelTableData.Destroy;
begin

  CloseExcelFile;

  inherited;

end;

procedure TOLEExcelTableData.CloseExcelFile;
begin

  if not VarIsEmpty(FExcelFile) then begin

    FExcelFile.Workbooks.Close;
    FExcelFile.Quit;

    FExcelFile := Unassigned;
    FCells := Unassigned;

  end;

end;

function TOLEExcelTableData.GetCellValue(RowIndex,
  ColumnIndex: Integer): Variant;
begin

  Result := FCells[RowIndex + 1, ColumnIndex + 1];
  
end;

procedure TOLEExcelTableData.LoadFrom(
  const ExcelFilePath: String;
  const SheetNumber: Integer
);
var ExcelFile: OleVariant;
begin

  ExcelFile := OpenExcelFile(ExcelFilePath);

  RefreshData(ExcelFile, SheetNumber, FCells, FRowCount, FColumnCount);

  FExcelFile := ExcelFile;
  
  FSheetNumber := SheetNumber;
  
end;

procedure TOLEExcelTableData.Refresh;
begin

  RefreshData(FExcelFile, FSheetNumber,  FCells, FRowCount, FColumnCount);
  
end;

procedure TOLEExcelTableData.RefreshData(
  ExcelFile: OleVariant;
  const SheetNumber: Integer;
  var Cells: OleVariant;
  var RowCount, ColumnCount: Integer
);
var
    Sheet: OleVariant;
    LocalCells: OleVariant;
    LocalRowCount, LocalColumnCount: Integer;
begin

  Sheet := ExcelFile.WorkBooks[1].WorkSheets[SheetNumber];

  LocalCells := Sheet.UsedRange.Value;

  LocalRowCount := Sheet.UsedRange.Rows.Count;
  LocalColumnCount := Sheet.UsedRange.Columns.Count;

  Cells := LocalCells;
  RowCount := LocalRowCount;
  ColumnCount := LocalColumnCount;

end;

function TOLEExcelTableData.RowCount: Integer;
begin

  Result := FRowCount;

end;

function TOLEExcelTableData.ColumnCount: Integer;
begin

  Result := FColumnCount;
  
end;

procedure TOLEExcelTableData.SetCellValue(RowIndex, ColumnIndex: Integer;
  Value: Variant);
begin

  FCells[RowIndex + 1, ColumnIndex + 1] := Value;
  
end;

end.
