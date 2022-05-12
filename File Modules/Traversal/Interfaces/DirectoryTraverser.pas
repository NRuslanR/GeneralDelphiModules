unit DirectoryTraverser;

interface

uses

  DirectoryTraverseEventHandlers,
  DirectoryTraversalStrategy,
  SearchFileInfo,
  Classes,
  SysUtils;

type

  TStandardDirectoryTraversalStrategy = (tsDepthFirst, tsBreadthFirst);

  TOnFileDiscoveredEventHandler =
    procedure (
      Sender: TObject;
      SearchFileInfo: ISearchFileInfo;
      var ContinueTraverse: Boolean
    ) of object;

  TOnFileDiscoveredFuncEventHandler =
    procedure (
      Sender: TObject;
      SearchFileInfo: ISearchFileInfo;
      var ContinueTraverse: Boolean
    );

  IDirectoryTraverserOptions = interface

    function Recursive: Boolean; overload;
    function Recursive(const Value: Boolean): IDirectoryTraverserOptions; overload;
    
    function IgnoreCurrentDirectory: Boolean; overload;
    function IgnoreCurrentDirectory(const Value: Boolean): IDirectoryTraverserOptions; overload;

    function IgnoreParentDirectory: Boolean; overload;
    function IgnoreParentDirectory(const Value: Boolean): IDirectoryTraverserOptions; overload;

    function AllowedFileExtensions: TStrings; overload;
    function AllowedFileExtensions(Value: TStrings): IDirectoryTraverserOptions; overload;
    function AllowedFileExtensions(Value: array of String): IDirectoryTraverserOptions; overload;

    function ContainsAllowedFileExtension(const FileExtension: String): Boolean;
    
    function IgnoredFileExtensions: TStrings; overload;
    function IgnoredFileExtensions(Value: TStrings): IDirectoryTraverserOptions; overload;
    function IgnoredFileExtensions(Value: array of String): IDirectoryTraverserOptions; overload;

    function ContainsIgnoredFileExtension(const FileExtension: String): Boolean;

  end;

  TDirectoryTraverserOptions = class (TInterfacedObject, IDirectoryTraverserOptions)

    protected

      FAllowedFileExtensions: TStrings;
      FIgnoredFileExtensions: TStrings;
      
      FIgnoreCurrentDirectory: Boolean;
      FIgnoreParentDirectory: Boolean;
      FRecursive: Boolean;
      
    public

      destructor Destroy; override;

      constructor Create;
      constructor CreateDefaultOptions;
      
      function Recursive: Boolean; overload;
      function Recursive(const Value: Boolean): IDirectoryTraverserOptions; overload;

      function IgnoreCurrentDirectory: Boolean; overload;
      function IgnoreCurrentDirectory(const Value: Boolean): IDirectoryTraverserOptions; overload;

      function IgnoreParentDirectory: Boolean; overload;
      function IgnoreParentDirectory(const Value: Boolean): IDirectoryTraverserOptions; overload;

      function AllowedFileExtensions: TStrings; overload;
      function AllowedFileExtensions(Value: TStrings): IDirectoryTraverserOptions; overload;
      function AllowedFileExtensions(Value: array of String): IDirectoryTraverserOptions; overload;

      function ContainsAllowedFileExtension(const FileExtension: String): Boolean;

      function IgnoredFileExtensions: TStrings; overload;
      function IgnoredFileExtensions(Value: TStrings): IDirectoryTraverserOptions; overload;
      function IgnoredFileExtensions(Value: array of String): IDirectoryTraverserOptions; overload;

      function ContainsIgnoredFileExtension(const FileExtension: String): Boolean;

  end;

  IDirectoryTraverser = interface
    ['{201FE3AB-E517-4BB7-BF37-B1FB563751B4}']

    function GetOptions: IDirectoryTraverserOptions;
    procedure SetOptions(Value: IDirectoryTraverserOptions);

    function GetEventHandler: IDirectoryTraverseEventHandler;
    procedure SetEventHandler(Value: IDirectoryTraverseEventHandler);
    
    function GetOnFileDiscoveredEventHandler: TOnFileDiscoveredEventHandler;
    procedure SetOnFileDiscoveredEventHandler(const Value: TOnFileDiscoveredEventHandler);

    function GetOnFileDiscoveredFuncEventHandler: TOnFileDiscoveredFuncEventHandler;
    procedure SetOnFileDiscoveredFuncEventHandler(const Value: TOnFileDiscoveredFuncEventHandler);
    
    function GetTraversalStrategy: IDirectoryTraversalStrategy;
    procedure SetTraversalStrategy(const Value: IDirectoryTraversalStrategy);

    procedure SetStandardTraversalStrategy(const Value: TStandardDirectoryTraversalStrategy);

    procedure Traverse(const BeginDirPath: String);

    property Options: IDirectoryTraverserOptions
    read GetOptions write SetOptions;
    
    property OnFileDiscoveredEventHandler: TOnFileDiscoveredEventHandler
    read GetOnFileDiscoveredEventHandler write SetOnFileDiscoveredEventHandler;

    property OnFileDiscoveredFuncEventHandler: TOnFileDiscoveredFuncEventHandler
    read GetOnFileDiscoveredFuncEventHandler write SetOnFileDiscoveredFuncEventHandler;

    property EventHandler: IDirectoryTraverseEventHandler
    read GetEventHandler write SetEventHandler;
    
    property StandardTraversalStrategy: TStandardDirectoryTraversalStrategy
    write SetStandardTraversalStrategy;

    property TraversalStrategy: IDirectoryTraversalStrategy
    read GetTraversalStrategy write SetTraversalStrategy;
    
  end;

implementation

uses

  AuxiliaryStringFunctions;
  
{ TDirectoryTraverserOptions }

function TDirectoryTraverserOptions.IgnoreCurrentDirectory: Boolean;
begin

  Result := FIgnoreCurrentDirectory;

end;

function TDirectoryTraverserOptions.AllowedFileExtensions(
  Value: array of String): IDirectoryTraverserOptions;
begin

  Result := AllowedFileExtensions(CreateStringListFrom(Value));

end;

function TDirectoryTraverserOptions.AllowedFileExtensions(
  Value: TStrings): IDirectoryTraverserOptions;
begin

  FreeAndNil(FAllowedFileExtensions);

  FAllowedFileExtensions := Value;

  Result := Self;

end;

function TDirectoryTraverserOptions.AllowedFileExtensions: TStrings;
begin

  Result := FAllowedFileExtensions;

end;

function TDirectoryTraverserOptions.ContainsAllowedFileExtension(
  const FileExtension: String): Boolean;
begin

  Result :=
    (FAllowedFileExtensions.Count = 0)
    or (FAllowedFileExtensions.IndexOf(FileExtension) <> -1);

end;

function TDirectoryTraverserOptions.ContainsIgnoredFileExtension(
  const FileExtension: String): Boolean;
begin

  Result := FIgnoredFileExtensions.IndexOf(FileExtension) <> -1;
  
end;

constructor TDirectoryTraverserOptions.Create;
begin

  inherited Create;

  FAllowedFileExtensions := TStringList.Create;
  FIgnoredFileExtensions := TStringList.Create;
  
end;

constructor TDirectoryTraverserOptions.CreateDefaultOptions;
begin

  Create;

  FRecursive := True;
  FIgnoreCurrentDirectory := True;
  FIgnoreParentDirectory := True;
  
end;

destructor TDirectoryTraverserOptions.Destroy;
begin

  FreeAndNil(FAllowedFileExtensions);
  FreeAndNil(FIgnoredFileExtensions);
  
  inherited;

end;

function TDirectoryTraverserOptions.IgnoreCurrentDirectory(
  const Value: Boolean): IDirectoryTraverserOptions;
begin

  FIgnoreCurrentDirectory := Value;

  Result := Self;
  
end;

function TDirectoryTraverserOptions.IgnoredFileExtensions(
  Value: array of String): IDirectoryTraverserOptions;
begin

  Result := IgnoredFileExtensions(CreateStringListFrom(Value));

end;

function TDirectoryTraverserOptions.IgnoredFileExtensions: TStrings;
begin

  Result := FIgnoredFileExtensions;

end;

function TDirectoryTraverserOptions.IgnoredFileExtensions(
  Value: TStrings): IDirectoryTraverserOptions;
begin

  FreeAndNil(FIgnoredFileExtensions);

  FIgnoredFileExtensions := Value;

  Result := Self;
  
end;

function TDirectoryTraverserOptions.IgnoreParentDirectory: Boolean;
begin

  Result := FIgnoreParentDirectory;

end;

function TDirectoryTraverserOptions.IgnoreParentDirectory(
  const Value: Boolean): IDirectoryTraverserOptions;
begin

  FIgnoreParentDirectory := Value;

  Result := Self;

end;

function TDirectoryTraverserOptions.Recursive: Boolean;
begin

  Result := FRecursive;

end;

function TDirectoryTraverserOptions.Recursive(
  const Value: Boolean): IDirectoryTraverserOptions;
begin

  FRecursive := Value;

  Result := Self;
  
end;

end.
