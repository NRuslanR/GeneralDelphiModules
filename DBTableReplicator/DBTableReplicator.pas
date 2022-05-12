unit DBTableReplicator;

interface

uses

  DBTableReplicationRequest;

type

  IDBTableReplicator = interface
    ['{C60289AF-CE1E-4630-99DA-EE0AC13425DA}']

    procedure Replicate(ReplicationRequests: TDBTableReplicationRequests);

  end;

implementation

end.
