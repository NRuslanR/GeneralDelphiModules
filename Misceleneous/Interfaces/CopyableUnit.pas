unit CopyableUnit;

interface

uses SysUtils, IGetSelfUnit;

type

  TInvariantsEnsuringType = (ieInvariantsEnsuringRequested, ieNotInvariantsEnsuring);

  ICopyable = interface(IGetSelf)
  ['{1DDD8321-9911-414E-A3A8-41FE25F31E2F}']

    procedure CopyFrom(
      Copyable: TObject;
      const InvariantsEnsuringType: TInvariantsEnsuringType = ieNotInvariantsEnsuring
    );

    procedure DeepCopyFrom(
      Copyable: TObject;
      const InvariantsEnsuringType: TInvariantsEnsuringType = ieNotInvariantsEnsuring
    ); 

  end;

implementation

end.
