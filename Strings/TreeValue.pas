unit TreeValue;

interface

uses

  SysUtils,
  Classes;

type

  ITreeValuePart = interface;
  
  TTreeValuePartEnumerator = class

    private

      FVariantPartIndex: Integer;
      
      function GetCurrentTreeValuePart: ITreeValuePart;
      
    public

      constructor Create(Part: ITreeValuePart);
      
      property Current: ITreeValuePart read GetCurrentTreeValuePart;
      
  end;
  
  ITreeValuePart = interface

    function GetId: Variant;
    function GetValue: Variant;
    function GetPartById(const PartId: Variant): ITreeValuePart;
    function GetPartByIndex(const PartIndex: Integer): ITreeValuePart;
    procedure SetValue(const Value: Variant);

    function ContainsPart(const PartId: Variant): Boolean;

    function ArePartsExists: Boolean;
    
    function GetEnumerator: TTreeValuePartEnumerator;

    property Id: Variant read GetId;
    property Value: Variant read GetValue write SetValue;
    property Count: Integer read GetCount;
    property Parts[Index: Integer]: ITreeValuePart read GetPartByIndex; default;

  end;
  
  ITreeValue = interface
    ['{A658F622-0541-408E-84AE-231663F12E9F}']

    procedure AddVariant(const VariantPartId: Variant; const Value: Variant): ITreeValuePart;

    function GetEnumerator: TTreeValuePartEnumerator;
    
    function ToVariant: Variant;
    
  end;

implementation

end.
