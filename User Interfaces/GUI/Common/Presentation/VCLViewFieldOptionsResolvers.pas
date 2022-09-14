unit VCLViewFieldOptionsResolvers;

interface

uses

  ViewFieldOptions,
  RegExprValidateEditUnit,
  RegExprValidateMemoUnit,
  Forms,
  StdCtrls,
  Controls,
  SysUtils,
  Classes;

type

  TVCLTextFieldOptionsResolver = class

    public

      class function GetEditViewFieldOptions(
        Edit: TRegExprValidateEdit
      ): ITextFieldOptions; static;

      class procedure ChangeEditByViewFieldOptions(
        Edit: TRegExprValidateEdit;
        Options: ITextFieldOptions
      ); static;

    public

      class function GetMemoViewFieldOptions(
        Memo: TRegExprValidateMemo
      ): ITextFieldOptions; static;

      class procedure ChangeMemoByViewFieldOptions(
        Memo: TRegExprValidateMemo;
        Options: ITextFieldOptions
      ); static;


  end;

  TVCLSelectionFieldOptionsResolver = class

    public

      class function GetComboBoxSelectionFieldOptions(
        ComboBox: TComboBox
      ): TSelectionFieldOptions;

      class procedure ChangeComboBoxBySelectionFieldOptions(
        ComboBox: TComboBox;
        Options: TSelectionFieldOptions
      );

  end;


implementation

{ TVCLTextFieldOptionsResolver }

class procedure TVCLTextFieldOptionsResolver.ChangeEditByViewFieldOptions(
  Edit: TRegExprValidateEdit; Options: ITextFieldOptions);
begin

  with Options do begin

    Edit.RegularExpression := RegularExpression;
    Edit.InvalidHint := InvalidHint;
    Edit.ReadOnly := ViewOnly;

  end;

end;

class function TVCLTextFieldOptionsResolver.GetEditViewFieldOptions(
  Edit: TRegExprValidateEdit): ITextFieldOptions;
begin

  Result :=
    TTextFieldOptions(
      TTextFieldOptions
        .Create
          .RegularExpression(Edit.RegularExpression)
          .InvalidHint(Edit.InvalidHint)
          .ViewOnly(Edit.ReadOnly)
          .Self
    );

end;

class procedure TVCLTextFieldOptionsResolver.ChangeMemoByViewFieldOptions(
  Memo: TRegExprValidateMemo; Options: ITextFieldOptions);
begin

  with Options do begin

    Memo.RegularExpression := RegularExpression;
    Memo.InvalidHint := InvalidHint;
    Memo.ReadOnly := ViewOnly;
    
  end;

end;

class function TVCLTextFieldOptionsResolver.GetMemoViewFieldOptions(
  Memo: TRegExprValidateMemo): ITextFieldOptions;
begin

  Result :=
    TTextFieldOptions(
      TTextFieldOptions
        .Create
          .RegularExpression(Memo.RegularExpression)
          .InvalidHint(Memo.InvalidHint)
          .ViewOnly(Memo.ReadOnly)
          .Self
    );

end;

{ TVCLSelectionFieldOptionsResolver }

class procedure TVCLSelectionFieldOptionsResolver.ChangeComboBoxBySelectionFieldOptions(
  ComboBox: TComboBox; Options: TSelectionFieldOptions);
begin

  with Options, ComboBox do begin

    if ViewOnly then
      Style := csSimple

    else Style := csDropDownList;

  end;

end;

class function TVCLSelectionFieldOptionsResolver.GetComboBoxSelectionFieldOptions(
  ComboBox: TComboBox): TSelectionFieldOptions;
begin

  Result :=
    TSelectionFieldOptions(
      TSelectionFieldOptions
        .Create
          .ViewOnly(ComboBox.Style = csSimple)
          .Self
    );
    
end;

end.
