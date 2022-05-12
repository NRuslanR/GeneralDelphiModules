program PipeAndFilters;

{$APPTYPE CONSOLE}
{$M+}

uses
  SysUtils,
  Pipe in 'Pipe.pas',
  Filter in 'Filter.pas',
  AbstractPipe in 'AbstractPipe.pas',
  AbstractFilter in 'AbstractFilter.pas',
  ReadChannel in 'ReadChannel.pas',
  WriteChannel in 'WriteChannel.pas',
  AuxDebugFunctionsUnit,
  TypInfo,
  ReflectionServicesUnit in '..\..\Reflection\ReflectionServicesUnit.pas';

type

  TName = class

    private
    
      FLastName: String;
      FFirstName: String;

    published

      property FirstName: String
      read FFirstName write FFirstName;

      property LastName: String
      read FLastName write FLastName;
      
  end;

  TSon = class

    private

      FName: String;
      FAge: Integer;

    published

      property Name: String
      read FName write FName;

      property Age: Integer
      read FAge write FAge;
      
  end;

  TFather = class

    private

      FSon: TSon;

    published

      property Son: TSon
      read FSon write FSon;

  end;

  TGrandFather = class

    private

      FFather: TFather;

    published

      property Father: TFather
      read FFather write FFather;

  end;

var
    Name: TName;
    Son: TSon;
    Father: TFather;
    GrandFather: TGrandFather;
    ClassInfo: PTypeInfo;
begin

  Son := TSon.Create;
  Son.Name := 'Valery';
  Son.Age := 28;

  Father := TFather.Create;
  Father.Son := Son;

  GrandFather := TGrandFather.Create;
  GrandFather.Father := Father;

  ClassInfo := GrandFather.ClassInfo;

  DebugOutput(ClassInfo.Name);
  
  DebugOutput(TReflectionServices.GetObjectPropertyValue(GrandFather, 'Father.Son.Name'));
  DebugOutput(TReflectionServices.GetObjectPropertyValue(GrandFather, 'Father.Son.Age'));

  TReflectionServices.SetObjectPropertyValue(GrandFather, 'Father.Son.Name', 'Viktor');
  TReflectionServices.SetObjectPropertyValue(GrandFather, 'Father.Son.Age', 30);

  DebugOutput(TReflectionServices.GetObjectPropertyValue(GrandFather, 'Father.Son.Name'));
  DebugOutput(TReflectionServices.GetObjectPropertyValue(GrandFather, 'Father.Son.Age'));

  Readln;

end.
