unit ObjectCreators;

interface

uses

  SysUtils,
  IGetSelfUnit,
  TypeObjectRegistry,
  Classes;

type

  IObjectCreationContext = interface (IGetSelf)
    ['{0B6D08DD-1CC0-4798-9A31-68B0EB6DAB7C}']

  end;

  TObjectCreationContext = class (TInterfacedObject, IObjectCreationContext)

    public

      function GetSelf: TObject;

  end;

  TObjectCreationContextClass = class of TObjectCreationContext;

  TDefaultObjectCreationContext = class (TObjectCreationContext)

  end;

  IObjectCreator = interface (IGetSelf)
    ['{8FE161E5-915A-4CFB-B910-1EEE6C83D2F3}']

    function CreateObject(CreationContext: IObjectCreationContext): TObject;

  end;

  IObjectCreators = interface

    procedure RegisterObjectCreator(
      ObjectClass: TClass;
      Creator: IObjectCreator;
      CreationContextClass: TObjectCreationContextClass = nil
    );

    function UnRegisterObjectCreator(
      ObjectClass: TClass;
      CreationContextClass: TObjectCreationContextClass = nil
    ): IObjectCreator;

    function GetObjectCreator(
      ObjectClass: TClass;
      CreationContextClass: TObjectCreationContextClass = nil
    ): IObjectCreator;

    procedure Clear;

    function CreateObject(
      ObjectClass: TClass;
      CreationContext: IObjectCreationContext = nil
    ): TObject;

  end;

  TObjectCreators = class (TInterfacedObject, IObjectCreators)

    private

      FObjectCreatorsRegistry: TTypeObjectRegistry;
      
    private

      class var FInstance: IObjectCreators;

      class function GetInstance: IObjectCreators; static;
      
    public

      destructor Destroy; override;
      
      constructor Create;
      
      procedure RegisterObjectCreator(
        ObjectClass: TClass;
        Creator: IObjectCreator;
        CreationContextClass: TObjectCreationContextClass = nil
      );

      function UnRegisterObjectCreator(
        ObjectClass: TClass;
        CreationContextClass: TObjectCreationContextClass = nil
      ): IObjectCreator;

      function GetObjectCreator(
        ObjectClass: TClass;
        CreationContextClass: TObjectCreationContextClass = nil
      ): IObjectCreator;

      procedure Clear;

      function CreateObject(
        ObjectClass: TClass;
        CreationContext: IObjectCreationContext = nil
      ): TObject;

    public

      class property Instance: IObjectCreators read GetInstance;

  end;
  
implementation

{ TObjectCreationContext }

function TObjectCreationContext.GetSelf: TObject;
begin

  Result := Self;
  
end;

{ TObjectCreators }

procedure TObjectCreators.Clear;
begin

  FObjectCreatorsRegistry.Clear;
  
end;

constructor TObjectCreators.Create;
begin

  inherited;

  FObjectCreatorsRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(
      ltoFreeRegisteredObjectsOnDestroy
    );
  
end;

function TObjectCreators.CreateObject(
  ObjectClass: TClass;
  CreationContext: IObjectCreationContext
): TObject;
var
    ObjectCreator: IObjectCreator;
begin

  ObjectCreator :=
    GetObjectCreator(
      ObjectClass,
      TObjectCreationContextClass(CreationContext.Self.ClassType)
    );

  Result := ObjectCreator.CreateObject(CreationContext);

end;

destructor TObjectCreators.Destroy;
begin

  FreeAndNil(FInstance);
  
  inherited;

end;

class function TObjectCreators.GetInstance: IObjectCreators;
begin

  if not Assigned(FInstance) then
    FInstance := TObjectCreators.Create;

  Result := FInstance;

end;

function TObjectCreators.GetObjectCreator(
  ObjectClass: TClass;
  CreationContextClass: TObjectCreationContextClass
): IObjectCreator;
var
    ObjectCreatorRegistry: TTypeObjectRegistry;
begin

  ObjectCreatorRegistry :=
    TTypeObjectRegistry(FObjectCreatorsRegistry.GetObject(ObjectClass));

  Result :=
    IObjectCreator(
      ObjectCreatorRegistry.GetInterface(CreationContextClass)
    );
    
end;

procedure TObjectCreators.RegisterObjectCreator(
  ObjectClass: TClass;
  Creator: IObjectCreator;
  CreationContextClass: TObjectCreationContextClass
);
begin


end;

function TObjectCreators.UnRegisterObjectCreator(
  ObjectClass: TClass;
  CreationContextClass: TObjectCreationContextClass
): IObjectCreator;
begin

end;

end.
