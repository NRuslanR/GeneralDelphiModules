unit SectionStackedFormStyle;

interface

uses

  UIStandardControlStyle,
  Graphics,
  Forms,
  Controls,
  SysUtils;

type

  TSectionStackedFormStyle = class (TUIFormStyle)

    private

      FSectionItemColor: Variant;
      FSectionItemTextColor: Variant;
      FSectionContentSplitterColor: Variant;
      FSectionContentSplitterThickness: Variant;
      
    public

      constructor Create; override;

      procedure Apply(Control: TWinControl); override;

      function SectionItemColor: Variant; overload;
      function SectionItemColor(const Color: TColor): TSectionStackedFormStyle; overload;

      function SectionItemTextColor: Variant; overload;
      function SectionItemTextColor(const Color: TColor): TSectionStackedFormStyle; overload;

      function SectionContentSplitterThickness: Variant; overload;
      function SectionContentSplitterThickness(const Value: Integer): TSectionStackedFormStyle; overload;

      function SectionContentSplitterColor: Variant; overload;
      function SectionContentSplitterColor(const Value: TColor): TSectionStackedFormStyle; overload;
      
  end;

implementation

uses

  Variants,
  unSectionStackedForm;

{ TSectionStackedFormStyle }

procedure TSectionStackedFormStyle.Apply(Control: TWinControl);
var
    SectionStackedForm: TSectionStackedForm;
begin

  inherited;

  SectionStackedForm := Control as TSectionStackedForm;

  if not VarIsNull(FSectionItemColor) then
    SectionStackedForm.SectionItemColor := SectionItemColor;

  if not VarIsNull(FSectionItemTextColor) then
    SectionStackedForm.SectionItemTextColor := SectionItemTextColor;

  if not VarIsNull(FSectionContentSplitterColor) then
    SectionStackedForm.SectionContentSplitterColor := FSectionContentSplitterColor;

  if not VarIsNull(FSectionContentSplitterThickness) then
    SectionStackedForm.SectionContentSplitterThickness := FSectionContentSplitterThickness;
    
end;

constructor TSectionStackedFormStyle.Create;
begin

  inherited;

  FSectionItemColor := Null;
  FSectionItemTextColor := Null;
  FSectionContentSplitterColor := Null;
  FSectionContentSplitterThickness := Null;

end;

function TSectionStackedFormStyle.SectionContentSplitterColor(
  const Value: TColor): TSectionStackedFormStyle;
begin

  FSectionContentSplitterColor := Value;

  Result := Self;

end;

function TSectionStackedFormStyle.SectionContentSplitterColor: Variant;
begin

  Result := FSectionContentSplitterColor;
  
end;

function TSectionStackedFormStyle.SectionContentSplitterThickness(
  const Value: Integer): TSectionStackedFormStyle;
begin

  FSectionContentSplitterThickness := Value;

  Result := Self;
  
end;

function TSectionStackedFormStyle.SectionContentSplitterThickness: Variant;
begin

  Result := FSectionContentSplitterThickness;

end;

function TSectionStackedFormStyle.SectionItemColor(
  const Color: TColor): TSectionStackedFormStyle;
begin

  FSectionItemColor := Color;

  Result := Self;
  
end;

function TSectionStackedFormStyle.SectionItemColor: Variant;
begin

  Result := FSectionItemColor;

end;

function TSectionStackedFormStyle.SectionItemTextColor(
  const Color: TColor): TSectionStackedFormStyle;
begin

  FSectionItemTextColor := Color;

  Result := Self;
  
end;

function TSectionStackedFormStyle.SectionItemTextColor: Variant;
begin

  Result := FSectionItemTextColor;

end;

end.
