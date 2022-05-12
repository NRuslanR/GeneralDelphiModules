unit DBTableReplicationOptions;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDBTableReplicationOptions = interface (IGetSelf)
    ['{1A6FE869-28BA-4290-AF6E-A152F1DA6642}']

    function GetCreateTargetTableIfNotExists: Boolean;
    procedure SetCreateTargetTableIfNotExists(const Value: Boolean);

    function GetReplicateSourceTableIntegrityConstraints: Boolean;
    procedure SetReplicateSourceTableIntegrityConstraints(const Value: Boolean);

    function GetChangeTargetTableColumnTypes: Boolean;
    procedure SetChangeTargetTableColumnTypes(const Value: Boolean);

    function GetAddNonExistentColumnsToTargetTable: Boolean;
    procedure SetAddNonExistentColumnsToTargetTable(const Value: Boolean);

    function GetTruncateTargetTable: Boolean;
    procedure SetTruncateTargetTable(const Value: Boolean);
    
    property CreateTargetTableIfNotExists: Boolean
    read GetCreateTargetTableIfNotExists
    write SetCreateTargetTableIfNotExists;

    property ReplicateSourceTableIntegrityConstraints: Boolean
    read GetReplicateSourceTableIntegrityConstraints
    write SetReplicateSourceTableIntegrityConstraints;
    
    property ChangeTargetTableColumnTypes: Boolean
    read GetChangeTargetTableColumnTypes
    write SetChangeTargetTableColumnTypes;
    
    property AddNonExistentColumnsToTargetTable: Boolean
    read GetAddNonExistentColumnsToTargetTable
    write SetAddNonExistentColumnsToTargetTable;

    property TruncateTargetTable: Boolean
    read GetTruncateTargetTable
    write SetTruncateTargetTable;

  end;

  IDBTableCompositeReplicationOptions = interface (IDBTableReplicationOptions)
    ['{C803443C-1BDD-4AB8-B099-9AB45AAF6AB8}']
    
    function GetReplicateReferencedTablesWithReferencingTableOptions: Boolean;
    procedure SetReplicateReferencedTablesWithReferencingTableOptions(
      const Value: Boolean
    );
    
    property ReplicateReferencedTablesWithReferencingTableOptions: Boolean
    read GetReplicateReferencedTablesWithReferencingTableOptions
    write SetReplicateReferencedTablesWithReferencingTableOptions;
    
  end;

  TDBTableReplicationOptions = class (TInterfacedObject, IDBTableReplicationOptions)

    private

      class var FDefaultOptions: IDBTableReplicationOptions;

    protected
    
      class function CreateDefaultOptionsInstance: IDBTableReplicationOptions; virtual;
      
    private

      FCreateTargetTableIfNotExists: Boolean;
      FReplicateSourceTableIntegrityConstraints: Boolean;
      FChangeTargetTableColumnTypes: Boolean;
      FAddNonExistentColumnsToTargetTable: Boolean;
      FTruncateTargetTable: Boolean;
      
    public

      function GetCreateTargetTableIfNotExists: Boolean;
      procedure SetCreateTargetTableIfNotExists(const Value: Boolean);

      function GetReplicateSourceTableIntegrityConstraints: Boolean;
      procedure SetReplicateSourceTableIntegrityConstraints(const Value: Boolean);

      function GetChangeTargetTableColumnTypes: Boolean;
      procedure SetChangeTargetTableColumnTypes(const Value: Boolean);

      function GetAddNonExistentColumnsToTargetTable: Boolean;
      procedure SetAddNonExistentColumnsToTargetTable(const Value: Boolean);

      function GetTruncateTargetTable: Boolean;
      procedure SetTruncateTargetTable(const Value: Boolean);

    public

      class function Default: IDBTableReplicationOptions; virtual;
      
    public

      constructor Create; virtual;

      function GetSelf: TObject;
      
      property CreateTargetTableIfNotExists: Boolean
      read GetCreateTargetTableIfNotExists
      write SetCreateTargetTableIfNotExists;

      property ReplicateSourceTableIntegrityConstraints: Boolean
      read GetReplicateSourceTableIntegrityConstraints
      write SetReplicateSourceTableIntegrityConstraints;

      property ChangeTargetTableColumnTypes: Boolean
      read GetChangeTargetTableColumnTypes
      write SetChangeTargetTableColumnTypes;

      property AddNonExistentColumnsToTargetTable: Boolean
      read GetAddNonExistentColumnsToTargetTable
      write SetAddNonExistentColumnsToTargetTable;

      property TruncateTargetTable: Boolean
      read GetTruncateTargetTable
      write SetTruncateTargetTable;

  end;

  TDBTableCompositeReplicationOptions =
    class (TDBTableReplicationOptions, IDBTableCompositeReplicationOptions)

      private

        FReplicateReferencedTablesWithReferencingTableOptions: Boolean;

      protected

        class function CreateDefaultOptionsInstance: IDBTableReplicationOptions; override;

      public

        class function Default: IDBTableReplicationOptions; override;
        
      public

        function GetReplicateReferencedTablesWithReferencingTableOptions: Boolean;
        procedure SetReplicateReferencedTablesWithReferencingTableOptions(
          const Value: Boolean
        );

      public

        property ReplicateReferencedTablesWithReferencingTableOptions: Boolean
        read GetReplicateReferencedTablesWithReferencingTableOptions
        write SetReplicateReferencedTablesWithReferencingTableOptions;

    end;
      
implementation

type

  TDBTableReplicationDefaultOptions = class (TDBTableReplicationOptions)

    public

      constructor Create; override;

  end;

  TDBTableCompositeReplicationDefaultOptions =
    class (TDBTableCompositeReplicationOptions)

      public

        constructor Create; override;

    end;
  
{ TDBTableReplicationOptions }

constructor TDBTableReplicationOptions.Create;
begin

  inherited;
  
end;

class function TDBTableReplicationOptions.
  CreateDefaultOptionsInstance: IDBTableReplicationOptions;
begin

  Result := TDBTableReplicationDefaultOptions.Create;

end;

class function TDBTableReplicationOptions.Default: IDBTableReplicationOptions;
begin

  if not Assigned(FDefaultOptions) then
    FDefaultOptions := CreateDefaultOptionsInstance;

  Result := FDefaultOptions;
  
end;

function TDBTableReplicationOptions.GetAddNonExistentColumnsToTargetTable: Boolean;
begin

  Result := FAddNonExistentColumnsToTargetTable;

end;

function TDBTableReplicationOptions.GetChangeTargetTableColumnTypes: Boolean;
begin

  Result := FChangeTargetTableColumnTypes;

end;

function TDBTableReplicationOptions.GetCreateTargetTableIfNotExists: Boolean;
begin

  Result := FCreateTargetTableIfNotExists;

end;

function TDBTableReplicationOptions.GetReplicateSourceTableIntegrityConstraints: Boolean;
begin

  Result := FReplicateSourceTableIntegrityConstraints;
  
end;

function TDBTableReplicationOptions.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDBTableReplicationOptions.GetTruncateTargetTable: Boolean;
begin

  Result := FTruncateTargetTable;
  
end;

procedure TDBTableReplicationOptions.SetAddNonExistentColumnsToTargetTable(
  const Value: Boolean);
begin

  FAddNonExistentColumnsToTargetTable := Value;

end;

procedure TDBTableReplicationOptions.SetChangeTargetTableColumnTypes(
  const Value: Boolean);
begin

  FChangeTargetTableColumnTypes := Value;
  
end;

procedure TDBTableReplicationOptions.SetCreateTargetTableIfNotExists(
  const Value: Boolean);
begin

  FCreateTargetTableIfNotExists := Value;

end;

procedure TDBTableReplicationOptions.SetReplicateSourceTableIntegrityConstraints(
  const Value: Boolean);
begin

  FReplicateSourceTableIntegrityConstraints := Value;

end;

procedure TDBTableReplicationOptions.SetTruncateTargetTable(
  const Value: Boolean);
begin

  FTruncateTargetTable := Value;
  
end;

{ TDBTableReplicationDefaultOptions }

constructor TDBTableReplicationDefaultOptions.Create;
begin

  inherited;

  CreateTargetTableIfNotExists := True;
  ReplicateSourceTableIntegrityConstraints := True;
  ChangeTargetTableColumnTypes := True;
  AddNonExistentColumnsToTargetTable := True;
  TruncateTargetTable := True;
  
end;

{ TDBTableCompositeReplicationOptions }

class function TDBTableCompositeReplicationOptions.
  CreateDefaultOptionsInstance: IDBTableReplicationOptions;
begin

  Result := TDBTableCompositeReplicationDefaultOptions.Create;
  
end;

class function TDBTableCompositeReplicationOptions.Default: IDBTableReplicationOptions;
begin

  Result := CreateDefaultOptionsInstance;
  
end;

function TDBTableCompositeReplicationOptions.
  GetReplicateReferencedTablesWithReferencingTableOptions: Boolean;
begin

  Result := FReplicateReferencedTablesWithReferencingTableOptions;
  
end;

procedure TDBTableCompositeReplicationOptions.
  SetReplicateReferencedTablesWithReferencingTableOptions(
    const Value: Boolean
  );
begin

  FReplicateReferencedTablesWithReferencingTableOptions := Value;

end;

{ TDBTableCompositeReplicationDefaultOptions }

constructor TDBTableCompositeReplicationDefaultOptions.Create;
begin

  inherited;

  ReplicateReferencedTablesWithReferencingTableOptions := True;
  
end;

end.
