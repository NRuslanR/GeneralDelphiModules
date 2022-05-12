unit IPAdressEditBoxUnit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, RegExprValidateEditUnit;

type
  TIPAdressEditBox = class(TGroupBox)
  private
    { Private declarations }
  protected
    { Protected declarations }
    FIP1Edit: TRegExprValidateEdit;
    FIP2Edit: TRegExprValidateEdit;
    FIP3Edit: TRegExprValidateEdit;
    FIP4Edit: TRegExprValidateEdit;

    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;

    procedure InitPanel;
    procedure InitEdits;
    procedure UpdateSize;

    function GetIP1: string;
    function GetIP2: string;
    function GetIP3: string;
    function GetIP4: string;
    procedure SetIP1(const Value: string);
    procedure SetIP2(const Value: string);
    procedure SetIP3(const Value: string);
    procedure SetIP4(const Value: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure DestroyWindowHandle; override;

  published
    { Published declarations }
    property IP1Edit: TRegExprValidateEdit read FIP1Edit write FIP1Edit;
    property IP2Edit: TRegExprValidateEdit read FIP2Edit write FIP2Edit;
    property IP3Edit: TRegExprValidateEdit read FIP3Edit write FIP3Edit;
    property IP4Edit: TRegExprValidateEdit read FIP4Edit write FIP4Edit;

    property IP1: string read GetIP1 write SetIP1;
    property IP2: string read GetIP2 write SetIP2;
    property IP3: string read GetIP3 write SetIP3;
    property IP4: string read GetIP4 write SetIP4;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [TIPAdressEditBox]);
end;

{ TIPAdressEditBox }

constructor TIPAdressEditBox.Create(AOwner: TComponent);
begin
  inherited;
  InitEdits;
end;

procedure TIPAdressEditBox.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  InitPanel;

end;

procedure TIPAdressEditBox.DestroyWindowHandle;
begin
  inherited;

end;

function TIPAdressEditBox.GetIP1: string;
begin
  Result := FIP1Edit.Text;
end;

function TIPAdressEditBox.GetIP2: string;
begin
  Result := FIP2Edit.Text;
end;

function TIPAdressEditBox.GetIP3: string;
begin
  Result := FIP3Edit.Text;
end;

function TIPAdressEditBox.GetIP4: string;
begin
  Result := FIP4Edit.Text;
end;

procedure TIPAdressEditBox.InitEdits;
begin
  FIP1Edit := TRegExprValidateEdit.Create(Self);
  FIP1Edit.RegularExpression := '([0-9,]*)';
  FIP1Edit.Parent := Self;
  FIP1Edit.SetBounds(16, 15, 65, 22);

  lbl1 := TLabel.Create(Self);
  lbl1.Caption := '.';
  lbl1.Parent := Self;
  lbl1.SetBounds(83, 26, 5, 30);

  FIP2Edit := TRegExprValidateEdit.Create(Self);
  FIP2Edit.RegularExpression := '([0-9,]*)';
  FIP2Edit.Parent := Self;
  FIP2Edit.SetBounds(86, 15, 65, 22);

  lbl2 := TLabel.Create(Self);
  lbl2.Caption := '.';
  lbl2.Parent := Self;
  lbl2.SetBounds(153, 26, 5, 30);

  FIP3Edit := TRegExprValidateEdit.Create(Self);
  FIP3Edit.RegularExpression := '([0-9,]*)';
  FIP3Edit.Parent := Self;
  FIP3Edit.SetBounds(156, 15, 65, 22);

  lbl3 := TLabel.Create(Self);
  lbl3.Caption := '.';
  lbl3.Parent := Self;
  lbl3.SetBounds(223, 26, 5, 30);

  FIP4Edit := TRegExprValidateEdit.Create(Self);
  FIP4Edit.RegularExpression := '([0-9,]*)';
  FIP4Edit.Parent := Self;
  FIP4Edit.SetBounds(226, 15, 65, 22);
end;


procedure TIPAdressEditBox.InitPanel;
begin
  UpdateSize;
end;

procedure TIPAdressEditBox.SetIP1(const Value: string);
begin
  FIP1Edit.Text := Value;
end;

procedure TIPAdressEditBox.SetIP2(const Value: string);
begin
  FIP2Edit.Text := Value;
end;

procedure TIPAdressEditBox.SetIP3(const Value: string);
begin
  FIP3Edit.Text := Value;
end;

procedure TIPAdressEditBox.SetIP4(const Value: string);
begin
  FIP4Edit.Text := Value;
end;

procedure TIPAdressEditBox.UpdateSize;
begin
  Self.ClientWidth := FIP4Edit.Left + FIP4Edit.Width + FIP1Edit.Left;
  Self.ClientHeight := FIP1Edit.Top * 2 + FIP1Edit.Height;

end;

end.
