unit PadegImports;

interface

function GetFIOPadegAS(
  pLastName, pFirstName, pMiddleName: PChar;
  nPadeg: LongInt;
  pResult: PChar;
  var nLen: LongInt
): Integer; stdcall; external 'Padeg.dll' name 'GetFIOPadegAS';

function GetAppointmentPadeg(
  pAppointment: PChar;
  nPadeg: LongInt;
  pResult: PChar;
  var nLen: LongInt
): Integer; stdcall; external 'Padeg.dll' name 'GetAppointmentPadeg';

implementation

end.
