unit DataSetTypes;

interface

uses

  SysUtils;

type

  {$IF CompilerVersion >= 21.0}

    {$LEGACYIFEND ON}

    TRecordBookmark = TBookmark;

  {$ELSE}

    TRecordBookmark = Pointer;

  {$IFEND}

implementation

end.
