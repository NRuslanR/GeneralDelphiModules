unit DirectoryTraversarImpl;

interface

uses

  DirectoryTraverseEventHandlers,
  DirectoryTraverser,
  DirectoryTraversalStrategy,
  SearchFileInfo,
  SysUtils;

type

  TDirectoryTraverser = class (TInterfacedObject, IDirectoryTraverser)

    private

      FOptions: IDirectoryTraverserOptions;
      FTraversalStrategy: IDirectoryTraversalStrategy;
      
    private

      FEventHandler: IDirectoryTraverseEventHandler;
      FOnFileDiscoveredEventHandler: TOnFileDiscoveredEventHandler;
      FOnFileDiscoveredFuncEventHandler: TOnFileDiscoveredFuncEventHandler;

    protected

      function IsSatisfiedByOptions(FileInfo: ISearchFileInfo): Boolean;

    public

      constructor Create(
        StandardTraversalStrategy: TStandardDirectoryTraversalStrategy = tsBreadthFirst;
        Options: IDirectoryTraverserOptions = nil
      ); overload;

      constructor Create(
        TraversalStrategy: IDirectoryTraversalStrategy;
        Options: IDirectoryTraverserOptions = nil
      ); overload;

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

  AuxFileFunctions,
  DepthFirstDirectoryTraversalStrategy,
  BreadthFirstDirectoryTraversalStrategy;
  
{ TDirectoryTraverser }

constructor TDirectoryTraverser.Create(
  StandardTraversalStrategy: TStandardDirectoryTraversalStrategy = tsBreadthFirst;
  Options: IDirectoryTraverserOptions = nil
);
begin

  inherited Create;

  Self.StandardTraversalStrategy := StandardTraversalStrategy;
  Self.Options := Options;

end;

constructor TDirectoryTraverser.Create(
  TraversalStrategy: IDirectoryTraversalStrategy;
  Options: IDirectoryTraverserOptions = nil
);
begin

  inherited Create;

  Self.TraversalStrategy := TraversalStrategy;
  Self.Options := Options;
  
end;

function TDirectoryTraverser.GetEventHandler: IDirectoryTraverseEventHandler;
begin

  Result := FEventHandler;

end;

function TDirectoryTraverser.GetOnFileDiscoveredEventHandler: TOnFileDiscoveredEventHandler;
begin

  Result := FOnFileDiscoveredEventHandler;

end;

function TDirectoryTraverser.GetOnFileDiscoveredFuncEventHandler: TOnFileDiscoveredFuncEventHandler;
begin

  Result := FOnFileDiscoveredFuncEventHandler;
  
end;

function TDirectoryTraverser.GetOptions: IDirectoryTraverserOptions;
begin

  Result := FOptions;

end;

function TDirectoryTraverser.GetTraversalStrategy: IDirectoryTraversalStrategy;
begin

  Result := FTraversalStrategy;

end;

function TDirectoryTraverser.IsSatisfiedByOptions(
  FileInfo: ISearchFileInfo): Boolean;
begin

  Result :=
    not (
      (Options.IgnoreCurrentDirectory and IsCurrentDirectory(FileInfo.FileInfo))
      or
      (Options.IgnoreParentDirectory and IsParentDirectory(FileInfo.FileInfo))
      or
      Options.ContainsIgnoredFileExtension(ExtractFileExt(FileInfo.FileInfo.Name))
      or
      not Options.ContainsAllowedFileExtension(ExtractFileExt(FileInfo.FileInfo.Name))
    );
  
end;

procedure TDirectoryTraverser.SetEventHandler(
  Value: IDirectoryTraverseEventHandler);
begin

  FEventHandler := Value;

  if Assigned(FEventHandler) then begin

    FOnFileDiscoveredEventHandler := nil;
    FOnFileDiscoveredFuncEventHandler := nil;

  end;

end;

procedure TDirectoryTraverser.SetOnFileDiscoveredEventHandler(
  const Value: TOnFileDiscoveredEventHandler);
begin

  FOnFileDiscoveredEventHandler := Value;

  if Assigned(FOnFileDiscoveredEventHandler) then begin

    FEventHandler := nil;
    FOnFileDiscoveredFuncEventHandler := nil;

  end;

end;

procedure TDirectoryTraverser.SetOnFileDiscoveredFuncEventHandler(
  const Value: TOnFileDiscoveredFuncEventHandler);
begin

  FOnFileDiscoveredFuncEventHandler := Value;

  if Assigned(FOnFileDiscoveredFuncEventHandler) then begin

    FEventHandler := nil;
    FOnFileDiscoveredEventHandler := nil;

  end;

end;

procedure TDirectoryTraverser.SetOptions(Value: IDirectoryTraverserOptions);
begin

  FOptions := Value;

  if not Assigned(FOptions) then
    FOptions := TDirectoryTraverserOptions.CreateDefaultOptions;
  
end;

procedure TDirectoryTraverser.SetStandardTraversalStrategy(
  const Value: TStandardDirectoryTraversalStrategy);
begin

  case Value of

    tsDepthFirst:
      TraversalStrategy := TDepthFirstDirectoryTraversalStrategy.Create;

    tsBreadthFirst:
      TraversalStrategy := TBreadthFirstDirectoryTraversalStrategy.Create

    else begin

      Raise Exception.Create('The given standard traversal strategy not valid');

    end;

  end;

end;

procedure TDirectoryTraverser.SetTraversalStrategy(
  const Value: IDirectoryTraversalStrategy);
begin

  FTraversalStrategy := Value;

end;

procedure TDirectoryTraverser.Traverse(const BeginDirPath: String);
var
    ContinueTraverse: Boolean;
begin

  FTraversalStrategy.Options.Recursive(Options.Recursive);
  
  FTraversalStrategy.Start(BeginDirPath);

  ContinueTraverse := True;

  while FTraversalStrategy.NextFileInfo do begin

    if not IsSatisfiedByOptions(FTraversalStrategy.CurrentFileInfo) then
      Continue;
    
    if Assigned(OnFileDiscoveredEventHandler) then begin

      OnFileDiscoveredEventHandler(
        Self,
        FTraversalStrategy.CurrentFileInfo,
        ContinueTraverse
      );
      
    end

    else if Assigned(FOnFileDiscoveredFuncEventHandler) then begin

      OnFileDiscoveredFuncEventHandler(
        Self,
        FTraversalStrategy.CurrentFileInfo,
        ContinueTraverse
      );

    end;

    if Assigned(FEventHandler) then begin

      FEventHandler.OnFileDiscoveredEventHandler(
        Self,
        FTraversalStrategy.CurrentFileInfo,
        ContinueTraverse
      );

    end;

    if not ContinueTraverse then Break;
    

  end;

  FTraversalStrategy.Done;

end;

end.
