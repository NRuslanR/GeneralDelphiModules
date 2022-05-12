unit CompositePropertiesStorage;

interface

uses

  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  ICompositePropertiesStorage = interface;

  TCompositePropertiesStorageEnumerator = class 

    private

      FCompositeStorage: ICompositePropertiesStorage;
      FCurrentStorageIndex: Integer;
      
    protected

      function GetCurrentPropertiesStorage: IPropertiesStorage;

    public

      constructor Create(CompositeStorage: ICompositePropertiesStorage);

      function MoveNext: Boolean;

      property Current: IPropertiesStorage read GetCurrentPropertiesStorage;

  end;

  ICompositePropertiesStorage = interface (IPropertiesStorage)

    function GetActiveStorageIndex: Integer;
    procedure SetActiveStorageIndex(const Value: Integer);

    function GetActiveStorage: IPropertiesStorage;
    procedure SetActiveStorage(const Value: IPropertiesStorage);

    function GetPropertiesStorageByIndex(const Index: Integer): IPropertiesStorage;

    function GetStorageCount: Integer;

    function AddStorage(PropertiesStorage: IPropertiesStorage): Integer;

    procedure RemoveStorage(PropertiesStorage: IPropertiesStorage);
    function RemoveStorageByIndex(const Index: Integer): IPropertiesStorage;

    function GetEnumerator: TCompositePropertiesStorageEnumerator;
    
    property ActiveStorageIndex: Integer
    read GetActiveStorageIndex write SetActiveStorageIndex;

    property ActiveStorage: IPropertiesStorage
    read GetActiveStorage write SetActiveStorage;

    property Storages[Index: Integer]: IPropertiesStorage
    read GetPropertiesStorageByIndex; default;

    property StorageCount: Integer read GetStorageCount;

  end;

implementation

{ TCompositePropertiesStorageEnumerator }

constructor TCompositePropertiesStorageEnumerator.Create(
  CompositeStorage: ICompositePropertiesStorage);
begin

  inherited Create;

  FCompositeStorage := CompositeStorage;
  
end;

function TCompositePropertiesStorageEnumerator.GetCurrentPropertiesStorage: IPropertiesStorage;
begin

  Result := FCompositeStorage[FCurrentStorageIndex];
  
end;

function TCompositePropertiesStorageEnumerator.MoveNext: Boolean;
begin

  Result := FCurrentStorageIndex < FCompositeStorage.StorageCount - 1;

  if Result then Inc(FCurrentStorageIndex);
  
end;

end.
