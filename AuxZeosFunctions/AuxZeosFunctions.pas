unit AuxZeosFunctions;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZConnection, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, ZSqlUpdate, Menus, Grids, DBGrids, FileCtrl, VariantListUnit;

type

  TCheckDataSetRecordFunc = function(DataSet: TZAbstractDataset): boolean;
  TDisableControlsOnFilter = (DisableDBControls, NotDisableDBControls);
  TQueryExecutionType = (ExecuteAsSelecting, ExecuteAsModification);
  TConnectionCreationMode = (CreateAsDisconnected, CreateAsSourceConnection);
  TQueryObjectCloneMode = (CloneConnectionToo, DontCloneConnection);

  TZDebugableQuery = class (TZQuery)

    public

      destructor Destroy; override;

  end;

  TZDebugableUpdateSQL = class (TZUpdateSQL)

    public

      destructor Destroy; override;

  end;

  TZDebugableConnection = class (TZConnection)

    public

      destructor Destroy; override;

  end;

procedure SetParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: array of string;
  param_values: array of Variant
); overload;

procedure SetParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: TStrings;
  param_values: TVariantList
); overload;

procedure SetNotZeroParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: array of string;
  param_values: array of Variant
); overload;

procedure SetNotZeroParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: TStrings;
  param_values: TVariantList
); overload;

function FormatDateTimeForDB(const DateTime: TDateTime): String;

function CloneQueryObjectFrom(
  SourceQueryObject: TZQuery;
  const QueryObjectCloneMode: TQueryObjectCloneMode = DontCloneConnection
): TZQuery;

function CreateConnection(

  const HostName: String;
  const Port: Integer;
  const Database: String;
  const User: String;
  const Password: String;
  const Protocol: String;
  const Active: Boolean = True;
  const Owner: TComponent = nil;
  const Properties: TStrings = nil

): TZConnection; overload;

function CreateConnection(

  const Connection: TZConnection;
  const ConnectionCreationMode: TConnectionCreationMode = CreateAsSourceConnection

): TZConnection; overload;

function CreateConnection(

  const Connection: TZConnection;
  const ConnectionName: string


): TZConnection; overload;

function CreateQueryObject(Connection: TZConnection; const Text: string = ''; Activated: boolean = false): TZQuery; overload;
function CreateQueryObject(
  Connection: TZConnection;
  const Text: string;
  param_names: array of string;
  param_values: array of Variant;
  Activated: boolean = false
): TZQuery; overload;
function CreateQueryObject(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  Activated: boolean = false
): TZQuery; overload;

function CreateQueryObjectIfNotAssigned(Other: TZQuery; Connection: TZConnection; const Text: string; Activated: boolean = false): TZQuery; overload;
function CreateQueryObjectIfNotAssigned(Other: TZQuery; Connection: TZConnection;
param_names: array of string; param_values: array of Variant;
const Text: string; Activated: boolean = false): TZQuery; overload;

procedure InitQuery(
  Query: TZQuery;
  const Text: String;
  param_names: array of string;
  param_values: array of variant
); overload;

function ExecuteQuery(
Query: TZQuery; const Text: string;
param_names: array of string; param_values: array of Variant;
QueryIsSelecting: boolean = true
): Integer; overload; overload;

function CreateAndExecuteQuery(
Connection: TZConnection;
const Text: string;
param_names: array of string; param_values: array of Variant;
QueryIsSelecting: boolean = true): TZQuery; overload;

function CreateAndExecuteQueryWithFree(
Connection: TZConnection;
const Text: string;
param_names: array of string; param_values: array of Variant;
QueryIsSelecting: boolean = true): Integer; overload;

function CreateAndExecuteQueryWithResults
(
  Connection: TZConnection;
  const Text: string;
  param_names: array of string;
  param_values: array of Variant;
  result_field_names: array of string
  
): Variant; overload;

function ExecuteQueryWithResults
(
  Query: TZQuery;
  const Text: string;
  param_names: array of string;
  param_values: array of Variant;
  result_field_names: array of string

): Variant; overload;

procedure InitQuery(
  Query: TZQuery;
  const Text: String;
  param_names: TStrings;
  param_values: TVariantList
); overload;

function ExecuteQuery(
  Query: TZQuery; const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  QueryIsSelecting: boolean = true
): Integer; overload;

function CreateAndExecuteQuery(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  QueryIsSelecting: boolean = true
): TZQuery; overload;

function CreateAndExecuteQueryWithFree(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  QueryIsSelecting: boolean = true
): Integer; overload;

function CreateAndExecuteQueryWithResults
(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  result_field_names: array of string
  
): Variant; overload;

function ExecuteQueryWithResults
(
  Query: TZQuery;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  result_field_names: array of String

): Variant; overload;

procedure SetFieldValues(DataSet: TZAbstractDataset;
  const fieldNames: array of string; const fieldValues: array of Variant;
    RecordCheckFunc: TCheckDataSetRecordFunc = nil);

procedure SetCurrentFieldValues(DataSet: TZAbstractDataset;
  const fieldNames: array of string; const fieldValues: array of Variant);

procedure FilterDataSet(
  dataSet: TDataSet;
  const Filter: string = '';
  const DisableControls: TDisableControlsOnFilter = DisableDBControls
);

procedure ArrayOfQueryParamsDataToList(
  ParamNames: array of String;
  ParamValues: array of Variant;
  out ParamNameList: TStrings;
  out ParamValueList: TVariantList
);

implementation

uses ZDbcIntfs, AuxDataSetFunctionsUnit, StrUtils;

procedure ArrayOfQueryParamsDataToList(
  ParamNames: array of String;
  ParamValues: array of Variant;
  out ParamNameList: TStrings;
  out ParamValueList: TVariantList
);
var I: Integer;
begin

  ParamNameList := nil;
  ParamValueList := nil;

  try

    ParamNameList := TStringList.Create;
    ParamValueList := TVariantList.Create;
    
    for I := Low(ParamNames) to High(ParamNames) do begin

      ParamNameList.Add(ParamNames[I]);
      ParamValueList.Add(ParamValues[I]);

    end;

  except

    on e: Exception do begin

      FreeAndNil(ParamNameList);
      FreeAndNil(ParamValueList);

      raise;
      
    end;

  end;
  
end;

function FormatDateTimeForDB(const DateTime: TDateTime): String;
begin

  Result := QuotedStr(FormatDateTime('yyyy-MM-dd', DateTime));

end;

function CloneQueryObjectFrom(
  SourceQueryObject: TZQuery;
  const QueryObjectCloneMode: TQueryObjectCloneMode = DontCloneConnection
): TZQuery;
begin

  Result := TZQuery.Create(nil);

  Result.SQL.Text := SourceQueryObject.SQL.Text;
  
  if QueryObjectCloneMode = CloneConnectionToo then begin

    Result.Connection :=
      CreateConnection(TZConnection(SourceQueryObject.Connection), CreateAsDisconnected);

    Result.InsertComponent(Result.Connection);

  end

  else Result.Connection := SourceQueryObject.Connection;

  SetFieldsToDataSetFromOther(
    Result,
    SourceQueryObject
  );

  Result.CachedUpdates := SourceQueryObject.CachedUpdates;

  if Assigned(SourceQueryObject.UpdateObject) then begin

    Result.UpdateObject := TZDebugableUpdateSQL.Create(Result);

    Result.InsertComponent(Result.UpdateObject);

  end;                                              

end;

function CreateConnection(

  const HostName: String;
  const Port: Integer;
  const Database: String;
  const User: String;
  const Password: String;
  const Protocol: String;
  const Active: Boolean = True;
  const Owner: TComponent = nil;
  const Properties: TStrings = nil

): TZConnection; overload;
var
    I: Integer;
    PropName: String;
    AppNameSettingExpression: String;
begin

  Result := TZConnection.Create(Owner);

  try

    Result.HostName := HostName;
    Result.Port := Port;
    Result.Database := Database;
    Result.User := User;
    Result.Password := Password;
    Result.Protocol := Protocol;

    if Assigned(Properties) then
      Result.Properties := Properties;
      
    Result.Connected := Active;

    if  Result.Connected and Assigned(Properties) then begin

      if ContainsStr(Result.Protocol, 'postgres') then begin

        for I := 0 to Properties.Count - 1 do begin

          PropName := Properties.Names[I];

          if not ContainsStr(PropName, 'application_name') then Continue;

          AppNameSettingExpression := 'SET ' + PropName + '=''' + Properties.Values[PropName] + ' (Cloned)''';

          Result.ExecuteDirect(AppNameSettingExpression);

          Break;

        end;
          
      end;

    end;


  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function CreateConnection(
  const Connection: TZConnection;
  const ConnectionName: string
): TZConnection;
var
  AppNameSettingExpression: String;
begin

  Result :=
    CreateConnection(
      Connection.HostName,
      Connection.Port,
      Connection.Database,
      Connection.User,
      Connection.Password,
      Connection.Protocol,
      true,
      Connection.Owner,
      Connection.Properties
    );

    AppNameSettingExpression := 'SET application_name =''' + ConnectionName + ' (Cloned)''';

    Result.ExecuteDirect(AppNameSettingExpression);

end;

function CreateConnection(
  const Connection: TZConnection;
  const ConnectionCreationMode: TConnectionCreationMode = CreateAsSourceConnection
): TZConnection; overload;
var MustMakeConnection: Boolean;
begin

  if ConnectionCreationMode = CreateAsSourceConnection then
    MustMakeConnection := Connection.Connected

  else MustMakeConnection := False;

  Result :=
    CreateConnection(
      Connection.HostName,
      Connection.Port,
      Connection.Database,
      Connection.User,
      Connection.Password,
      Connection.Protocol,
      MustMakeConnection,
      Connection.Owner,
      Connection.Properties
    );

end;

function CreateQueryObject(Connection: TZConnection; const text: string = ''; Activated: boolean = false): TZQuery;
begin
  result := TZQuery.Create(nil);
  result.Connection := Connection;
  result.SQL.Text := Text;
  result.ParamCheck := true;
  result.Active := Activated;
end;

function CreateQueryObject(Connection: TZConnection;
const Text: string;
param_names: array of string; param_values: array of Variant;
 Activated: boolean = false): TZQuery; overload;
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names,
    param_values,
    ParamNameList,
    ParamValueList
  );

  try

    Result :=
      CreateQueryObject(
        Connection, Text, ParamNameList, ParamValueList, Activated
      );
    
  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;

end;

function CreateQueryObject(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  Activated: boolean = false
): TZQuery; overload;
begin

  result := CreateQueryObject(Connection, Text, false);
  SetParamValues(result, param_names, param_values);
  result.Active := Activated;
  
end;

procedure InitQuery(Query: TZQuery; const Text: String;
  param_names: array of string; param_values: array of variant);
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );
  
  try

    InitQuery(Query, Text, ParamNameList, ParamValueList);
    
  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;
  
end;
// ��������� �������� ���������� ������ ������ dataSet
procedure  SetParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: array of string;
  param_values: array of Variant
);
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );

  try

    SetParamValues(dataSet, ParamNameList, ParamValueList);

  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;

end;

procedure  SetNotZeroParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: array of string;
  param_values: array of Variant
);
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );

  try

    SetNotZeroParamValues(dataSet, ParamNameList, ParamValueList);

  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;

end;

function CreateQueryObjectIfNotAssigned(Other: TZQuery; Connection: TZConnection; const Text: string; Activated: boolean = false): TZQuery;
begin

  if not Assigned(Other) then
    result := CreateQueryObject(Connection, Text, Activated)
  else result := Other;

end;

// ������� ������ � ��������� ����������� � ���������� ���
// � ������, ���� Other ����� nil
function CreateQueryObjectIfNotAssigned(Other: TZQuery; Connection: TZConnection;
param_names: array of string; param_values: array of Variant;
const Text: string; Activated: boolean = false): TZQuery; overload;
begin

  if not Assigned(Other) then
    result := CreateQueryObject(Connection, Text, param_names, param_values, Activated)
  else result := Other;

end;

// ��������� ������ � ��������� �����������
function ExecuteQuery(
  Query: TZQuery; const
  Text: string;
  param_names: array of string;
  param_values: array of Variant;
  QueryIsSelecting: boolean = true
): Integer;
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );
  
  try

    Result :=
      ExecuteQuery(
        Query,
        Text,
        ParamNameList,
        ParamValueList,
        QueryIsSelecting
      );

  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;

end;

// ������� ������ TZQuery, ��������� � ������� ���� ������
// � ���������� ������ ������ ����������� ����
function CreateAndExecuteQuery(
Connection: TZConnection;
const Text: string;
param_names: array of string; param_values: array of Variant;
QueryIsSelecting: boolean = true): TZQuery;
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );
  
  try

    Result :=
      CreateAndExecuteQuery(
        Connection,
        Text,
        ParamNameList,
        ParamValueList,
        QueryIsSelecting
      );
      
  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;

end;

// ������� ������ TZQuery, ��������� � ������� ����
// ������ � ���������� ������, ���������� ���
// ������ ������
function CreateAndExecuteQueryWithFree(
Connection: TZConnection;
const Text: string;
param_names: array of string; param_values: array of Variant;
QueryIsSelecting: boolean = true): Integer;
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );

  try

    Result :=
      CreateAndExecuteQueryWithFree(
        Connection,
        Text,
        ParamNameList,
        ParamValueList,
        QueryIsSelecting
      );

  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;

end;

{ ������ � ��������� ������ Text �� ���������� Connection
  � ��������� ����������� param_names � �� ����������
  param_values � ���������� �������� �������� �����
  result_field_names ������ ������ ������� ������� � ���� �������� ���� Variant,
  ��������������� ����� ������ ���������� ��������. ���� � �������
  �� �������� �� ����� ������, ����� ��������� �������� varNull
}
function CreateAndExecuteQueryWithResults
(
  Connection: TZConnection;
  const Text: string;
  param_names: array of string;
  param_values: array of Variant;
  result_field_names: array of string

): Variant;
var ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );
  
  try
  
    Result :=
    CreateAndExecuteQueryWithResults(
      Connection,
      Text,
      ParamNameList,
      ParamValueList,
      result_field_names
    );
    
  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);

  end;

end;

function ExecuteQueryWithResults(
  Query: TZQuery;
  const Text: String;
  param_names: array of string;
  param_values: array of Variant;
  result_field_names: array of String
): Variant;
var I: Integer;
    ParamNameList: TStrings;
    ParamValueList: TVariantList;
begin

  ArrayOfQueryParamsDataToList(
    param_names, param_values,
    ParamNameList, ParamValueList
  );

  try

    Result :=
      ExecuteQueryWithResults(
        Query,
        Text,
        ParamNameList,
        ParamValueList,
        result_field_names
      );

  finally

    FreeAndNil(ParamNameList);
    FreeAndNil(ParamValueList);
    
  end;

end;

procedure FilterDataSet(
  dataSet: TDataSet;
  const Filter: string = '';
  const DisableControls: TDisableControlsOnFilter = DisableDBControls
);
begin

  try

    if DisableControls = DisableDBControls then
    dataSet.DisableControls;

    dataSet.Filtered := false;
    dataSet.Filter := Filter;

    if Filter = '' then
      dataSet.Filtered := False

    else dataSet.Filtered := true;

    if DisableControls = DisableDBControls then
      dataSet.EnableControls;

  finally

  end;

end;

// ��������� �������� fieldValues ���������������
// ����� filedNames ������ ������ ��� �����, ���������������
// ������� RecordCheckFunc. ���� RecordCheckFunc = nil,
// �������� �������� ����� ������ ������ ��� ���� �������
procedure SetFieldValues(DataSet: TZAbstractDataset;
  const fieldNames: array of string; const fieldValues: array of Variant;
    RecordCheckFunc: TCheckDataSetRecordFunc = nil);
begin

  DataSet.DisableControls;
  DataSet.First;

  while not DataSet.Eof do begin
    if (@RecordCheckFunc <> nil) and (not RecordCheckFunc(DataSet)) then begin
      DataSet.Next;
      Continue;
    end;

    SetCurrentFieldValues(DataSet, fieldNames, fieldValues);
    DataSet.Next;
  end;

  DataSet.EnableControls;
  DataSet.First;

end;

procedure SetCurrentFieldValues(DataSet: TZAbstractDataset;
  const fieldNames: array of string; const fieldValues: array of Variant);
var i, endFieldIndex: integer;
begin

  if DataSet.IsEmpty then
    Exit;

  endFieldIndex := Length(fieldNames) - 1;

  DataSet.Edit;

  for i := 0 to endFieldIndex do
    DataSet.FieldByName(fieldNames[i]).Value := fieldValues[i];

  DataSet.Post;

end;

{ TZDebugableQuery }

destructor TZDebugableQuery.Destroy;
begin

  //DebugOutput(String(Self.ClassName) + ' is destroying');

  inherited;

  //DebugOutput(String(Self.ClassName) + ' has destroyed');

end;

{ TZDebugableConnection }

destructor TZDebugableConnection.Destroy;
begin

  //DebugOutput(String(Self.ClassName) + ' is destroying');

  inherited;

  //DebugOutput(String(Self.ClassName) + ' has destroyed');

end;

{ TZDebugableUpdateSQL }

destructor TZDebugableUpdateSQL.Destroy;
begin

  //DebugOutput(String(Self.ClassName) + ' is destroying');

  inherited;

  //DebugOutput(String(Self.ClassName) + ' has destroyed');
  
end;

procedure InitQuery(
  Query: TZQuery;
  const Text: String;
  param_names: TStrings;
  param_values: TVariantList
); overload;
begin

  if Trim(Text) <> '' then
    Query.SQL.Text := Text;
    
  SetParamValues(Query, param_names, param_values);
  
end;

procedure SetParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: TStrings;
  param_values: TVariantList
); overload;
var i: Integer;
    param_count: Integer;
begin

  if not Assigned(param_names) or not Assigned(param_values) then
    Exit;
  
  if param_names.Count <> param_values.Count then exit;

  for i := 0 to param_names.Count - 1 do begin

    with dataSet.ParamByName(param_names[i]) do begin

      if VarIsNull(param_values[i]) then
        Clear

      else Value := param_values[i];
      
    end;

  end;
  
end;

procedure SetNotZeroParamValues(
  dataSet: TZAbstractRODataSet;
  param_names: TStrings;
  param_values: TVariantList
); overload;
var i: Integer;
    param_count: Integer;
begin

  if not Assigned(param_names) or not Assigned(param_values) then
    Exit;
  
  if param_names.Count <> param_values.Count then exit;

  for i := 0 to param_names.Count - 1 do begin

    with dataSet.ParamByName(param_names[i]) do begin

      if VarIsNull(param_values[i]) then
        Clear
      else if VarIsStr(param_values[i]) then
        if param_values[i] = '' then
          Clear
        else Value := param_values[i]
      else if VarIsNumeric(param_values[i]) then
      begin
        if VarIsType(param_values[i], varBoolean) then
          Value := param_values[i]
        else
        if param_values[i] = 0 then
          Clear
        else Value := param_values[i]
      end
      else Value := param_values[i];

    end;

  end;
  
end;

function ExecuteQuery(
  Query: TZQuery; const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  QueryIsSelecting: boolean = true
): Integer; overload;
var i: Integer;
    aux: Boolean;
begin

  Result := 0;

  InitQuery(Query, Text, param_names, param_values);

  if QueryIsSelecting then begin

    Query.Close;
    Query.Open;

    Result := Query.RecordCount;
  end

  else begin
    Query.ExecSQL;
    Result := Query.RowsAffected;
  end;

end;

function CreateAndExecuteQuery(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  QueryIsSelecting: boolean = true
): TZQuery; overload;
begin

  Result := CreateQueryObject(Connection, '');
  
  try

    ExecuteQuery(Result, Text, param_names, param_values, QueryIsSelecting);

  except

    on e: Exception do begin

      try

        FreeAndNil(Result);
        
      except

        on NestedE: EZSQLThrowable do begin

        end;

      end;
      
      raise;

    end;

  end;
  
end;

function CreateAndExecuteQueryWithFree(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  QueryIsSelecting: boolean = true
): Integer; overload;
var query: TZQuery;
begin

  query :=
    CreateAndExecuteQuery(
      Connection, Text, param_names,
      param_values, QueryIsSelecting
    );

  if QueryIsSelecting then
    Result := query.RecordCount

  else Result := query.RowsAffected;
  
  FreeAndNil(query);

end;

function CreateAndExecuteQueryWithResults
(
  Connection: TZConnection;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  result_field_names: array of string
  
): Variant; overload;
var Query: TZQuery;
begin

  Query := nil;
  
  try
  
    Query := CreateQueryObject(Connection, '');
    Result := ExecuteQueryWithResults(Query, Text, param_names, param_values, result_field_names);

  finally

    FreeAndNil(Query);

  end;
  
end;

function ExecuteQueryWithResults
(
  Query: TZQuery;
  const Text: string;
  param_names: TStrings;
  param_values: TVariantList;
  result_field_names: array of String

): Variant; overload;
var I: Integer;
begin

  try

    ExecuteQuery(Query, Text, param_names, param_values);

    if Query.IsEmpty then begin

      Result := Null;
      Exit;

    end;

    Query.First;

    Result := VarArrayCreate([0, High(result_field_names)], varVariant);

    for I := 0 to High(result_field_names) do begin

      Result[I] := Query.FieldByName(result_field_names[I]).AsVariant;

    end;

  finally

  end;

end;

end.
