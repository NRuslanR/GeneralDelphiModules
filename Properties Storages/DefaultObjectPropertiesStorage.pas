unit DefaultObjectPropertiesStorage;

interface

uses

  IGetSelfUnit,
  SysUtils;

type

  IDefaultObjectPropertiesStorage = interface (IGetSelf)
    ['{2044E377-F22F-4A42-BC18-7FCDAAA6A4AA}']

    procedure RestoreDefaultObjectProperties(TargetObject: TObject);
    procedure SaveDefaultObjectProperties(TargetObject: TObject);
    
  end;

  
implementation

end.
