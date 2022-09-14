unit ViewFieldOptions;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IViewFieldOptions = interface (IGetSelf)

    function InvalidHint: String; overload;
    function InvalidHint(const Value: String): IViewFieldOptions; overload;

    function ViewOnly: Boolean; overload;
    function ViewOnly(const Value: Boolean): IViewFieldOptions; overload;

  end;

  TViewFieldOptions = class (TInterfacedObject, IViewFieldOptions)

    private

      FInvalidHint: String;
      FViewOnly: Boolean;

    public

      function GetSelf: TObject;
      
      function InvalidHint: String; overload;
      function InvalidHint(const Value: String): IViewFieldOptions; overload;

      function ViewOnly: Boolean; overload;
      function ViewOnly(const Value: Boolean): IViewFieldOptions; overload;

  end;

  ITextFieldOptions = interface (IViewFieldOptions)

    function RegularExpression: String; overload;
    function RegularExpression(const Value: String): ITextFieldOptions; overload;

  end;

  TTextFieldOptions = class (TViewFieldOptions, ITextFieldOptions)

    private

      FRegularExpression: String;

    public

      function RegularExpression: String; overload;
      function RegularExpression(const Value: String): ITextFieldOptions; overload;

  end;

  ISelectionFieldOptions = interface (IViewFieldOptions)
  
  end;

  TSelectionFieldOptions = class (TViewFieldOptions, ISelectionFieldOptions)

    private


  end;

implementation

{ TViewFieldOptions }

function TViewFieldOptions.InvalidHint: String;
begin

  Result := FInvalidHint;

end;

function TViewFieldOptions.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TViewFieldOptions.InvalidHint(const Value: String): IViewFieldOptions;
begin

  FInvalidHint := Value;

  Result := Self;

end;

function TViewFieldOptions.ViewOnly: Boolean;
begin

  Result := FViewOnly;

end;

function TViewFieldOptions.ViewOnly(const Value: Boolean): IViewFieldOptions;
begin

  FViewOnly := Value;

  Result := Self;
  
end;

{ TTextFieldOptions }

function TTextFieldOptions.RegularExpression: String;
begin

  Result := FRegularExpression;

end;

function TTextFieldOptions.RegularExpression(
  const Value: String): ITextFieldOptions;
begin

  FRegularExpression := Value;
  
  Result := Self;

end;

end.
