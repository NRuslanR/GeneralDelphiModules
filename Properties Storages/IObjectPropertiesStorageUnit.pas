unit IObjectPropertiesStorageUnit;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IObjectPropertiesStorage = interface (IGetSelf)
    ['{06FDC7AB-7A89-47C9-875C-E4B77863F5B6}']

    procedure RestorePropertiesForObject(TargetObject: TObject);
    procedure SaveObjectProperties(TargetObject: TObject);

  end;

implementation

end.
