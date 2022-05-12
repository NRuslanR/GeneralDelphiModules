unit PathBuilder;

interface

type

  IPathBuilder = interface

    function AddPartOfPath(const PartOfPath: String): IPathBuilder;
    function BuildPath: String;
    function ClearPath: IPathBuilder;
    function GetFileName(const FilePath: String): String;
    function GetFileExt(const FileName: String): String;

  end;

implementation

end.
