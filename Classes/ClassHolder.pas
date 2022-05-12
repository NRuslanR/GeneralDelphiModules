unit ClassHolder;

interface

uses

  SysUtils,
  VariantTypeUnit,
  Classes;

type

  IClassHolder = interface
    ['{3E5F0F14-3E78-4A40-A6D5-0B26646EDBCC}']

  end;

  TClassHolder = class (TInterfacedObject, IClassHolder)

    private

      FVariantHolder: TVariant;
      
      function GetClassValue: TClass;
      procedure SetClassValue(const Value: TClass);

    public

      destructor Destroy; override;

      constructor Create; overload;
      constructor Create(ClassValue: TClass); overload;

      property ClassValue: TClass read GetClassValue write SetClassValue;
      
  end;
  
implementation

uses

  VariantFunctions;
  
{ TClassHolder }

constructor TClassHolder.Create;
begin

  inherited;

  FVariantHolder := TVariant.Create;
  
end;

constructor TClassHolder.Create(ClassValue: TClass);
begin

  Create;

  Self.ClassValue := ClassValue;

end;

destructor TClassHolder.Destroy;
begin

  FreeAndNil(FVariantHolder);
  
  inherited;

end;

function TClassHolder.GetClassValue: TClass;
begin

  Result := VariantToClass(FVariantHolder.Value);

end;

procedure TClassHolder.SetClassValue(const Value: TClass);
begin

  FVariantHolder.Value := ClassToVariant(Value);
  
end;

end.
