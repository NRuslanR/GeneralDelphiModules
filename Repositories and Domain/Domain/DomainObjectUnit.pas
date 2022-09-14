unit DomainObjectUnit;

interface

uses

  SysUtils,
  Classes,
  Windows,
  ClonableUnit,
  CopyableUnit,
  EquatableUnit,
  IDomainObjectUnit,
  DomainObjectBaseUnit;

  type

    TDomainObject = class abstract(TDomainObjectBase, IDomainObject)

      protected

        FIdentity: Variant;

        function GetIdentity: Variant; virtual;
        procedure SetIdentity(Identity: Variant); virtual;

      public

        destructor Destroy; override;

        constructor Create; overload; override;
        constructor Create(AIdentity: Variant); overload; virtual;

        procedure CopyFrom(
          Copyable: TObject;
          const InvariantsEnsuringType: TInvariantsEnsuringType = ieNotInvariantsEnsuring
        ); override;

        procedure DeepCopyFrom(
          Copyable: TObject;
          const InvariantsEnsuringType: TInvariantsEnsuringType = ieNotInvariantsEnsuring
        ); override;


        function Equals(Equatable: TObject): Boolean; override;
        function Clone: TObject; override;

        function IsSameAs(DomainObject: TDomainObject): Boolean; virtual;

        function IsIdentityAssigned: Boolean;

      published

        property Identity: Variant read GetIdentity write SetIdentity;

    end;

    TDomainObjectClass = class of TDomainObject;

implementation

uses

  Variants,
  VariantFunctions,
  AuxDebugFunctionsUnit;
  
{ TDomainObject }

constructor TDomainObject.Create;
begin

  inherited;

  FIdentity := Null;

end;

function TDomainObject.Clone: TObject;
begin

  Result := inherited Clone;

end;

procedure TDomainObject.CopyFrom(Copyable: TObject; const InvariantsEnsuringType: TInvariantsEnsuringType);
begin

  inherited CopyFrom(Copyable);

end;

constructor TDomainObject.Create(AIdentity: Variant);
begin

  inherited Create;

  FIdentity := AIdentity;
  
end;

procedure TDomainObject.DeepCopyFrom(Copyable: TObject; const InvariantsEnsuringType: TInvariantsEnsuringType);
begin

  inherited;

end;

destructor TDomainObject.Destroy;
begin

  inherited;

end;

function TDomainObject.Equals(Equatable: TObject): Boolean;
begin

  if not (Equatable is TDomainObject) then
    Result := False

  else begin

    Result := IsSameAs(Equatable as TDomainObject) //inherited Equals(Equatable);

  end;

end;


function TDomainObject.GetIdentity: Variant;
begin

  Result := FIdentity;

end;

function TDomainObject.IsIdentityAssigned: Boolean;
begin

  Result := not VarIsNullOrEmpty(Identity);

end;

function TDomainObject.IsSameAs(DomainObject: TDomainObject): Boolean;
begin

  Result :=
    Assigned(DomainObject)
    and IsIdentityAssigned
    and DomainObject.IsIdentityAssigned
    and (Identity = DomainObject.Identity);

end;

procedure TDomainObject.SetIdentity(Identity: Variant);
begin

  FIdentity := Identity;
  
end;

end.
