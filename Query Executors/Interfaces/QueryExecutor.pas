unit QueryExecutor;

interface

uses

  IGetSelfUnit,
  DataReader,
  VariantListUnit,
  NameValue,
  SysUtils,
  Classes;

type

  TQueryParam = class

    public

      ParamName: String;
      ParamValue: Variant;

      constructor Create;
      constructor CreateFrom(
        const ParamName: String;
        const ParamValue: Variant
      );

  end;

  TQueryParams = class;

  TQueryParamsEnumerator = class (TListEnumerator)

    private

      function GetCurrentQueryParam: TQueryParam;

    public

      constructor Create(QueryParamList: TQueryParams);

      property Current: TQueryParam
      read GetCurrentQueryParam;

  end;
  
  TQueryParams = class (TList)

    private

      function GetQueryParamByIndex(Index: Integer): TQueryParam;

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      constructor CreateFrom(
        NameValues: array of TNameValue;
        const NamePrefix: String = ''
      );

      function IsEmpty: Boolean;

      procedure SpliceParams(QueryParams: TQueryParams);
      function ExtractParam(const Index: Integer): TQueryParam; overload;
      function ExtractParam(const ParamName: String): TQueryParam; overload;
      
      function FetchParamNames: TStrings;
      function FetchParamValues: TVariantList;
      
      function Add(QueryParam: TQueryParam): Integer; overload;
      function Add(const ParamName: String; const ParamValue: Variant): Integer; overload;

      function AddFluently(QueryParam: TQueryParam): TQueryParams; overload;
      function AddFluently(const ParamName: String; const ParamValue: Variant): TQueryParams; overload;

      function FindQueryParamByName(const QueryParamName: string): TQueryParam;
      
      procedure RemoveByIndex(const Index: Integer);
      procedure RemoveByName(const ParamName: String);
      
      function GetEnumerator: TQueryParamsEnumerator;

      property Items[Index: Integer]: TQueryParam
      read GetQueryParamByIndex;

      property Items[const ParamName: String]: TQueryParam
      read FindQueryParamByName; default;
      
  end;

  TQueryExecutingError = class (Exception)

    private

      FCode: String;

    public

      constructor Create(const Msg: String); overload;
      constructor Create(const Code: String; const Msg: String); overload;
      constructor CreateFmt(const Msg: String; const Args: array of const); overload;
      constructor CreateFmt(const Code: String; const Msg: String; const Args: array of const); overload;

      property Code: String read FCode write FCode;
      
  end;
  
  TOnSelectionQuerySuccessedEventHandler =
    procedure (
      Sender: TObject;
      DataReader: IDataReader;
      RelatedState: TObject
    ) of object;

  TOnSelectionQueryFailedEventHandler =
    procedure (
      Sender: TObject;
      const Error: TQueryExecutingError;
      RelatedState: TObject
    ) of object;

  TOnModificationQuerySuccessedEventHandler =
    procedure (
      Sender: TObject;
      RowsAffected: Integer;
      RelatedState: TObject
    ) of object;

  TOnModificationQueryFailedEventHandler =
    procedure (
      Sender: TObject;
      const Error: TQueryExecutingError;
      RelatedState: TObject
    ) of object;

  IQueryExecutor = interface (IGetSelf)
  ['{C9A02B9B-175E-4162-8283-2F2D9C42C958}']
  
    function ExecuteSelectionQuery(
      const Query: String;
      Params: TQueryParams = nil
    ): IDataReader;

    procedure ExecuteSelectionQueryAsync(
      const Query: String;
      Params: TQueryParams = nil;
      RelatedState: TObject = nil;
      OnSelectionQuerySuccessedEventHandler: TOnSelectionQuerySuccessedEventHandler = nil;
      OnSelectionQueryFailedEventHandler: TOnSelectionQueryFailedEventHandler = nil
    );

    function ExecuteModificationQuery(
      const Query: String;
      Params: TQueryParams = nil
    ): Integer;
    
    procedure ExecuteModificationQueryAsync(
      const Query: String;
      Params: TQueryParams = nil;
      RelatedState: TObject = nil;
      OnModificationQuerySuccessedEventHandler: TOnModificationQuerySuccessedEventHandler = nil;
      OnModificationQueryFailedEventHandler: TOnModificationQueryFailedEventHandler = nil
    );

  end;
    
implementation

{ TQueryParams }

function TQueryParams.Add(QueryParam: TQueryParam): Integer;
begin

  Result := inherited Add(QueryParam);
  
end;

function TQueryParams.Add(const ParamName: String;
  const ParamValue: Variant): Integer;
begin

  Result := Add(TQueryParam.CreateFrom(ParamName, ParamValue));

end;

function TQueryParams.AddFluently(const ParamName: String;
  const ParamValue: Variant): TQueryParams;
begin

  Add(ParamName, ParamValue);

  Result := Self;
  
end;

constructor TQueryParams.CreateFrom(
  NameValues: array of TNameValue;
  const NamePrefix: String
);
var
    NameValue: TNameValue;
begin

  inherited Create;

  for NameValue in NameValues do
    Add(NamePrefix + NameValue.Name, NameValue.Value);

end;

function TQueryParams.ExtractParam(const Index: Integer): TQueryParam;
begin

  Result := Self[Index];

  Extract(Result);

end;

function TQueryParams.ExtractParam(const ParamName: String): TQueryParam;
begin

  Result := Self[ParamName];

  Extract(Result);
  
end;

function TQueryParams.AddFluently(QueryParam: TQueryParam): TQueryParams;
begin

  Add(QueryParam);

  Result := Self;
  
end;

function TQueryParams.FetchParamNames: TStrings;
var QueryParam: TQueryParam;
begin

  if IsEmpty then begin

    Result := nil;
    Exit;
    
  end;

  Result := TStringList.Create;

  try

    for QueryParam in Self do
      Result.Add(QueryParam.ParamName);

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function TQueryParams.FetchParamValues: TVariantList;
var QueryParam: TQueryParam;
begin

  if IsEmpty then begin

    Result := nil;
    Exit;
    
  end;

  Result := TVariantList.Create;

  try

    for QueryParam in Self do
      Result.Add(QueryParam.ParamValue);

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;
end;

function TQueryParams.FindQueryParamByName(
  const QueryParamName: string): TQueryParam;
begin

  for Result in Self do
    if Result.ParamName = QueryParamName then
      Exit;

  Result := nil;
    
end;

function TQueryParams.GetEnumerator: TQueryParamsEnumerator;
begin

  Result := TQueryParamsEnumerator.Create(Self);
  
end;

function TQueryParams.GetQueryParamByIndex(Index: Integer): TQueryParam;
begin

  Result := TQueryParam(Get(Index));
  
end;

function TQueryParams.IsEmpty: Boolean;
begin

  Result := Count = 0;
  
end;

procedure TQueryParams.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
      TQueryParam(Ptr).Free;

end;

procedure TQueryParams.RemoveByIndex(const Index: Integer);
begin

  Delete(Index);
  
end;

procedure TQueryParams.RemoveByName(const ParamName: String);
var I: Integer;
    Param: TQueryParam;
begin

  for I := Count - 1 downto 0 do begin

    Param := Self[I];

    if Param.ParamName = ParamName then begin

      RemoveByIndex(I);
      Exit;
      
    end;

  end;

end;

procedure TQueryParams.SpliceParams(QueryParams: TQueryParams);
begin

  while not QueryParams.IsEmpty do
    Add(QueryParams.ExtractParam(0));
    
end;

{ TQueryParamsEnumerator }

constructor TQueryParamsEnumerator.Create(QueryParamList: TQueryParams);
begin

  inherited Create(QueryParamList);
  
end;

function TQueryParamsEnumerator.GetCurrentQueryParam: TQueryParam;
begin

  Result := TQueryParam(GetCurrent);
  
end;

{ TQueryParam }

constructor TQueryParam.Create;
begin

  inherited;

end;

constructor TQueryParam.CreateFrom(
  const ParamName: String;
  const ParamValue: Variant
);
begin

  Create;

  Self.ParamName := ParamName;
  Self.ParamValue := ParamValue;
  
end;

{ TQueryExecutingError }

constructor TQueryExecutingError.Create(const Code, Msg: String);
begin

  inherited Create(Msg);

  FCode := Code;
  
end;

constructor TQueryExecutingError.Create(const Msg: String);
begin

  inherited;

end;

constructor TQueryExecutingError.CreateFmt(
  const Code: String;
  const Msg: String;
  const Args: array of const
);
begin

  inherited CreateFmt(Msg, Args);

  FCode := Code;

end;

constructor TQueryExecutingError.CreateFmt(
  const Msg: String;
  const Args: array of const
);
begin

  inherited;
  
end;

end.
