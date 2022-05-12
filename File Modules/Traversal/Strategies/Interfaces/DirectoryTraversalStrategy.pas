unit DirectoryTraversalStrategy;

interface

uses

  IGetSelfUnit,
  VariantListUnit,
  SearchFileInfo,
  SysUtils;
  
type

  TDirectoryTraversalStrategyException = class (Exception)

  end;

  IDirectoryTraversalStrategyOptions = interface

    function Recursive: Boolean; overload;
    function Recursive(const Value: Boolean): IDirectoryTraversalStrategyOptions; overload;

  end;

  TDirectoryTraversalStrategyOptions =
    class (TInterfacedObject, IDirectoryTraversalStrategyOptions)

      protected

        FRecursive: Boolean;

      public

         function Recursive: Boolean; overload;
         function Recursive(const Value: Boolean): IDirectoryTraversalStrategyOptions; overload;

    end;

  IDirectoryTraversalStrategy = interface

    procedure Start(const DirPath: String);
    procedure Done;
    
    function NextFileInfo: Boolean;
    function CurrentFileInfo: ISearchFileInfo;

    function GetOptions: IDirectoryTraversalStrategyOptions;
    procedure SetOptions(Options: IDirectoryTraversalStrategyOptions);
    
    property Options: IDirectoryTraversalStrategyOptions
    read GetOptions write SetOptions;
    
  end;
  
implementation

{ TDirectoryTraversalStrategyOptions }

function TDirectoryTraversalStrategyOptions.Recursive: Boolean;
begin

  Result := FRecursive;

end;

function TDirectoryTraversalStrategyOptions.Recursive(
  const Value: Boolean): IDirectoryTraversalStrategyOptions;
begin

  FRecursive := Value;

  Result := Self;

end;


end.
