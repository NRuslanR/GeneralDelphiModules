unit CardFormViewModel;

interface

uses

  Disposable,
  ClonableUnit,
  CopyableUnit,
  SysUtils,
  Classes;

type

  TOnCardFormViewModelPropertyChangedEventHandler =
    procedure (
      Sender: TObject;
      const PropertyName: String;
      const PropertyValue: Variant
    ) of object;

  TPropertyValueEditType = (etTextEdit, etSelect);

  TCardFormViewModelProperty = class (TInterfacedObject, IClonable, IDisposable)

    private

      FOnCardFormViewModelPropertyChangedEventHandler:
        TOnCardFormViewModelPropertyChangedEventHandler;

      procedure RaiseOnCardFormViewModelPropertyChangedEventHandler(
        const PropertyName: String;
        const PropertyValue: Variant
      );

    protected

      FName: String;
      FRequired: Boolean;
      FReadOnly: Boolean;
      FDefaultValue: Variant;
      FConstraints: Variant;
      FEditType: TPropertyValueEditType;
      FValue: Variant;
      FVisible: Boolean;
      
      function AreValuesEquals(
        PropertyValue, AssignableValue: Variant
      ): Boolean; virtual;

      procedure AssignOtherValue(OtherValue: Variant); virtual;
      
      procedure SetValue(const Value: Variant); virtual;
 
      function CloneValue(Value: Variant): Variant; virtual;
      function CloneDefaultValue(Value: Variant): Variant; virtual;
      function CloneConstraints(Constraints: Variant): Variant; virtual;
      
    public

      constructor Create(const Name: String); virtual;

      property Name: String read FName write FName;
      property Value: Variant read FValue write SetValue;
      property Required: Boolean read FRequired write FRequired;
      property ReadOnly: Boolean read FReadOnly write FReadOnly;
      property DefaultValue: Variant read FDefaultValue write FDefaultValue;
      property Constraints: Variant read FConstraints write FConstraints;
      property EditType: TPropertyValueEditType read FEditType write FEditType;
      property Visible: Boolean read FVisible write FVisible;

      function ToString: String;
      
      function AsInteger: Integer;
      function AsString: String;
      function AsDouble: Double;
      function AsDateTime: TDateTime;
      function AsVariant: Variant;

      function IsAssigned: Boolean;
      
      property OnCardFormViewModelPropertyChangedEventHandler:
        TOnCardFormViewModelPropertyChangedEventHandler
      read FOnCardFormViewModelPropertyChangedEventHandler
      write FOnCardFormViewModelPropertyChangedEventHandler;
      
    public

      function Clone: TObject; virtual;
      procedure CopyFrom(OtherViewModelProperty: TCardFormViewModelProperty); virtual;
      function Equals(OtherViewModelProperty: TCardFormViewModelProperty): Boolean; virtual;
      
      function GetSelf: TObject;

  end;

  TCardIdProperty = class (TCardFormViewModelProperty)

    private

      FIsSurrogate: Boolean;

    protected
    
      function GetIsSurrogate: Boolean;
      procedure SetIsSurrogate(const Value: Boolean);

    public

      constructor Create(const Name: String); override;

      function Clone: TObject; override;
      procedure CopyFrom(OtherViewModelProperty: TCardFormViewModelProperty); override;
      function Equals(OtherViewModelProperty: TCardFormViewModelProperty): Boolean; override;
      
      property IsSurrogate: Boolean
      read GetIsSurrogate write SetIsSurrogate;
      
  end;

  TCardFormViewModelPropertyClass = class of TCardFormViewModelProperty;

  TCardFormViewModel = class abstract (TInterfacedObject, IDisposable, IClonable)

    private

      type

        TViewModelPropertyHolder = class

          strict private

            FViewModelProperty: TCardFormViewModelProperty;
            FDisposable: IDisposable;

            procedure SetViewModelProperty(const Value: TCardFormViewModelProperty);
            
          private

            destructor Destroy; override;

            constructor Create(ViewModelProperty: TCardFormViewModelProperty);

            property ViewModelProperty: TCardFormViewModelProperty
            read FViewModelProperty write SetViewModelProperty;
            
        end;

    private

      FPropertyList: TList;

    protected

      FId: TCardIdProperty;
      
      function GetId: TCardIdProperty;

      function CreateIdProperty: TCardIdProperty; virtual;
          
    private

      FOnCardFormViewModelPropertyChangedEventHandler:
        TOnCardFormViewModelPropertyChangedEventHandler;

      procedure RaiseOnCardFormViewModelPropertyChangedEventHandler(
        const PropertyName: String;
        const PropertyValue: Variant
      );

      procedure SetOnCardFormViewModelPropertyChangedEventHandler(
        const Value: TOnCardFormViewModelPropertyChangedEventHandler
      );

      function GetViewModelPropertyHolderByIndex(const Index: Integer):
        TViewModelPropertyHolder;

      function GetViewModelPropertyHolderByPropertyName(const Name: String):
        TViewModelPropertyHolder;
        
    public

      function IsPropertyExists(const Name: String): Boolean;

      function FindProperty(const Name: String): TCardFormViewModelProperty;

      function AddProperty(const Name: String): TCardFormViewModelProperty; overload;
      function AddProperty(const Name: String; const Value: Variant): TCardFormViewModelProperty; overload;
      procedure AddProperty(Prop: TCardFormViewModelProperty); overload;

      procedure RestoreProperties; virtual;

      procedure Clear;

    public

      constructor Create; virtual;

      destructor Destroy; override;

    public

      function Clone: TObject; virtual;
      procedure CopyFrom(OtherCardFormViewModel: TCardFormViewModel); virtual;
      function Equals(OtherCardFormViewModel: TCardFormViewModel): Boolean; virtual;
      
      function GetSelf: TObject;

    published

      property Id: TCardIdProperty read GetId;

      property OnCardFormViewModelPropertyChangedEventHandler:
        TOnCardFormViewModelPropertyChangedEventHandler

      read FOnCardFormViewModelPropertyChangedEventHandler
      write SetOnCardFormViewModelPropertyChangedEventHandler;

  end;

  TCardFormViewModelClass = class of TCardFormViewModel;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit,
  AuxCollectionFunctionsUnit;

{ TCardFormViewModel }

function TCardFormViewModel.AddProperty(const Name: String;
  const Value: Variant): TCardFormViewModelProperty;
begin

  Result := AddProperty(Name);

  Result.Value := Value;

end;

procedure TCardFormViewModel.AddProperty(Prop: TCardFormViewModelProperty);
begin

  FPropertyList.Add(TViewModelPropertyHolder.Create(Prop));

end;

procedure TCardFormViewModel.Clear;
begin

  FreeListItems(FPropertyList);

end;

function TCardFormViewModel.Clone: TObject;
var I: Integer;
    ClonedViewModel: TCardFormViewModel;
    ViewModelPropertyHolder: TViewModelPropertyHolder;
    ViewModelProperty: TCardFormViewModelProperty;
    ClonedViewModelProperty: TCardFormViewModelProperty;
    ClonedViewModelPropertyHolder: TViewModelPropertyHolder;
    Free: IDisposable;
begin

  Result := TCardFormViewModelClass(ClassType).Create;

  ClonedViewModel := Result as TCardFormViewModel;

  try

    for I := 0 to FPropertyList.Count - 1 do begin

      ViewModelPropertyHolder := GetViewModelPropertyHolderByIndex(I);

      ViewModelProperty := ViewModelPropertyHolder.ViewModelProperty;

      ClonedViewModelProperty :=
        TCardFormViewModelProperty(ViewModelProperty.Clone);

      Free := ClonedViewModelProperty;
        
      if ClonedViewModel.IsPropertyExists(ClonedViewModelProperty.Name)
      then begin

        ClonedViewModelPropertyHolder :=
          ClonedViewModel
            .GetViewModelPropertyHolderByPropertyName(
              ClonedViewModelProperty.Name
            );

        ClonedViewModelPropertyHolder
          .ViewModelProperty := ClonedViewModelProperty;

      end

      else ClonedViewModel.AddProperty(ClonedViewModelProperty);

    end;

    ClonedViewModel.RestoreProperties;
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

procedure TCardFormViewModel.CopyFrom(
  OtherCardFormViewModel: TCardFormViewModel);
var I: Integer;
    ViewModelPropertyHolder: TViewModelPropertyHolder;
    ViewModelProperty: TCardFormViewModelProperty;
begin

  for I := 0 to OtherCardFormViewModel.FPropertyList.Count - 1 do begin

    ViewModelPropertyHolder :=
      TViewModelPropertyHolder(OtherCardFormViewModel.FPropertyList[I]);

    ViewModelProperty := ViewModelPropertyHolder.ViewModelProperty;

    if Assigned(FOnCardFormViewModelPropertyChangedEventHandler)
    then begin

      ViewModelProperty.OnCardFormViewModelPropertyChangedEventHandler :=
        FOnCardFormViewModelPropertyChangedEventHandler;
        
    end;
    
    if IsPropertyExists(ViewModelProperty.Name)
    then begin

      GetViewModelPropertyHolderByPropertyName(
        ViewModelProperty.Name
      )
        .ViewModelProperty := ViewModelProperty;
        
    end

    else AddProperty(ViewModelProperty);

  end;

  RestoreProperties;

end;

constructor TCardFormViewModel.Create;
begin

  inherited;

  FPropertyList := TList.Create;

  FId := CreateIdProperty;

  AddProperty(FId);
  
end;

function TCardFormViewModel.CreateIdProperty: TCardIdProperty;
begin

  Result := TCardIdProperty.Create('Id');

  try

    Result.Value := Null;
    Result.IsSurrogate := True;
    Result.Visible := False;
    
  except

    FreeAndNil(Result);

    Raise;


  end;

end;

function TCardFormViewModel.AddProperty(
  const Name: String): TCardFormViewModelProperty;
begin

  if Trim(Name) = '' then
    Raise Exception.Create('Property''s name must not be empty !');

  if IsPropertyExists(Name) then begin

    Raise Exception.CreateFmt(
      'Property "%s" is already exists !',
      [Name]
    );

  end;

  Result := TCardFormViewModelProperty.Create(Name);

  try

    Result.OnCardFormViewModelPropertyChangedEventHandler :=
      FOnCardFormViewModelPropertyChangedEventHandler;
    
    AddProperty(Result);

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;

    end;

  end;

end;

destructor TCardFormViewModel.Destroy;
begin

  FreeListWithItems(FPropertyList);

  inherited;

end;

function TCardFormViewModel.Equals(
  OtherCardFormViewModel: TCardFormViewModel
): Boolean;
var I: Integer;
    ViewModelProperty: TCardFormViewModelProperty;
    OtherViewModelProperty: TCardFormViewModelProperty;
begin

  if not OtherCardFormViewModel.ClassType.InheritsFrom(ClassType) then begin

    Result := False;
    Exit;

  end;

  for I := 0 to FPropertyList.Count - 1 do begin

    ViewModelProperty :=
      GetViewModelPropertyHolderByIndex(I).ViewModelProperty;

    OtherViewModelProperty :=
      OtherCardFormViewModel.FindProperty(ViewModelProperty.Name);

    if not ViewModelProperty.Equals(OtherViewModelProperty) then begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;
  
end;

function TCardFormViewModel.FindProperty(
  const Name: String): TCardFormViewModelProperty;
var Holder: TViewModelPropertyHolder;
begin

  Holder := GetViewModelPropertyHolderByPropertyName(Name);

  if Assigned(Holder) then
    Result := Holder.ViewModelProperty

  else Result := nil;

end;

function TCardFormViewModel.GetId: TCardIdProperty;
begin

  Result := FId;
  
end;

function TCardFormViewModel.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TCardFormViewModel.GetViewModelPropertyHolderByIndex(
  const Index: Integer): TViewModelPropertyHolder;
begin

  Result := TViewModelPropertyHolder(FPropertyList[Index]);

end;

function TCardFormViewModel.GetViewModelPropertyHolderByPropertyName(
  const Name: String): TViewModelPropertyHolder;
var I: Integer;
begin

  for I := 0 to FPropertyList.Count - 1 do begin

    Result := TViewModelPropertyHolder(FPropertyList[I]);

    if Result.ViewModelProperty.Name = Name then
      Exit;

  end;

  Result := nil;

end;

function TCardFormViewModel.IsPropertyExists(const Name: String): Boolean;
begin

  Result := Assigned(FindProperty(Name));

end;

procedure TCardFormViewModel.RaiseOnCardFormViewModelPropertyChangedEventHandler(
  const PropertyName: String; const PropertyValue: Variant);
begin

  if Assigned(FOnCardFormViewModelPropertyChangedEventHandler)
  then begin

    FOnCardFormViewModelPropertyChangedEventHandler(
      Self, PropertyName, PropertyValue
    );

  end;
  
end;

procedure TCardFormViewModel.RestoreProperties;
begin

  FId := TCardIdProperty(FindProperty('Id'));
  
end;

procedure TCardFormViewModel.SetOnCardFormViewModelPropertyChangedEventHandler(
  const Value: TOnCardFormViewModelPropertyChangedEventHandler);
var I: Integer;
    ViewModelPropertyHolder: TViewModelPropertyHolder;
    ViewModelProperty: TCardFormViewModelProperty;
begin

  FOnCardFormViewModelPropertyChangedEventHandler := Value;

  for I := 0 to FPropertyList.Count - 1 do begin

    ViewModelPropertyHolder := GetViewModelPropertyHolderByIndex(I);

    ViewModelProperty := ViewModelPropertyHolder.ViewModelProperty;

    ViewModelProperty
      .OnCardFormViewModelPropertyChangedEventHandler :=
        FOnCardFormViewModelPropertyChangedEventHandler;

  end;

end;

{ TCardFormViewModelProperty }

function TCardFormViewModelProperty.AreValuesEquals(PropertyValue,
  AssignableValue: Variant): Boolean;
begin

  Result := PropertyValue = AssignableValue;
  
end;

function TCardFormViewModelProperty.AsDateTime: TDateTime;
begin

  if VarIsNull(Value) then
    Result := 0

  else if not VarIsType(Value, varDate) then begin

    raise Exception.CreateFmt(
      'Программная ошибка. ' +
      'Значение свойства "%s" ' +
      'модели представления ' +
      'не относится к типу TDateTime',
      [Name]
    );

  end;

  Result := Value;
  
end;

function TCardFormViewModelProperty.AsDouble: Double;
begin

  if VarIsNull(Value) then
    Result := 0

  else if not VarIsType(Value, varDouble) then begin

    raise Exception.CreateFmt(
      'Программная ошибка. ' +
      'Значение свойства "%s" ' +
      'модели представления ' +
      'не относится к типу Double',
      [Name]
    );

  end;

  Result := Value;
  
end;

function TCardFormViewModelProperty.AsInteger: Integer;
begin

  if VarIsNull(Value) then
    Result := 0

  else if not VarIsType(Value, varInteger) then begin

    raise Exception.CreateFmt(
      'Программная ошибка. ' +
      'Значение свойства "%s" ' +
      'модели представления ' +
      'не относится к типу Integer',
      [Name]
    );

  end;

  Result := Value;
  
end;

procedure TCardFormViewModelProperty.AssignOtherValue(OtherValue: Variant);
begin

  FValue := OtherValue;
  
end;

function TCardFormViewModelProperty.AsString: String;
begin

  if VarIsNull(Value) then
    Result := ''

  else if not VarIsType(Value, varDate) then begin

    raise Exception.CreateFmt(
      'Программная ошибка. ' +
      'Значение свойства "%s" ' +
      'модели представления ' +
      'не относится к типу String',
      [Name]
    );

  end;

  Result := Value;
  
end;

function TCardFormViewModelProperty.AsVariant: Variant;
begin

  Result := Value;
  
end;

function TCardFormViewModelProperty.Clone: TObject;
var ClonedProperty: TCardFormViewModelProperty;
begin

  Result := TCardFormViewModelPropertyClass(ClassType).Create(Name);

  ClonedProperty := Result as TCardFormViewModelProperty;
  
  try

    ClonedProperty.Name := Name;
    ClonedProperty.Value := CloneValue(Value);
    ClonedProperty.Required := Required;
    ClonedProperty.ReadOnly := ReadOnly;
    ClonedProperty.DefaultValue := CloneDefaultValue(DefaultValue);
    ClonedProperty.Constraints := CloneConstraints(Constraints);
    ClonedProperty.EditType := EditType;
    ClonedProperty.Visible := Visible;
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TCardFormViewModelProperty.CloneConstraints(
  Constraints: Variant): Variant;
begin

  Result := Constraints;

end;

function TCardFormViewModelProperty.CloneDefaultValue(Value: Variant): Variant;
begin

  Result := Value;
  
end;

function TCardFormViewModelProperty.CloneValue(Value: Variant): Variant;
begin

  Result := Value;
  
end;

procedure TCardFormViewModelProperty.CopyFrom(
  OtherViewModelProperty: TCardFormViewModelProperty);
begin

  Name := OtherViewModelProperty.FName;
  Value := OtherViewModelProperty.Value;
  Required := OtherViewModelProperty.Required;
  ReadOnly := OtherViewModelProperty.ReadOnly;
  DefaultValue := OtherViewModelProperty.DefaultValue;
  Constraints := OtherViewModelProperty.Constraints;
  EditType := OtherViewModelProperty.EditType;
  Visible := OtherViewModelProperty.Visible;
  
end;

constructor TCardFormViewModelProperty.Create(const Name: String);
begin

  inherited Create;

  FName := Name;
  FValue := Null;
  FDefaultValue := Null;
  FConstraints := Null;
  FVisible := True;
  FEditType := etTextEdit;
  FRequired := True;

end;

function TCardFormViewModelProperty.Equals(
  OtherViewModelProperty: TCardFormViewModelProperty): Boolean;
begin

  Result :=
    (Name = OtherViewModelProperty.Name) and
    (Value = OtherViewModelProperty.Value) and
    (Required = OtherViewModelProperty.Required) and
    (ReadOnly = OtherViewModelProperty.ReadOnly) and
    (DefaultValue = OtherViewModelProperty.DefaultValue) and
    (Constraints = OtherViewModelProperty.Constraints) and
    (EditType = OtherViewModelProperty.EditType) and
    (Visible = OtherViewModelProperty.Visible);
    
end;

function TCardFormViewModelProperty.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TCardFormViewModelProperty.IsAssigned: Boolean;
begin

  Result := not VarIsNull(Value);
  
end;

procedure TCardFormViewModelProperty.
  RaiseOnCardFormViewModelPropertyChangedEventHandler(
    const PropertyName: String;
    const PropertyValue: Variant
  );
begin

  if Assigned(FOnCardFormViewModelPropertyChangedEventHandler) then begin

    FOnCardFormViewModelPropertyChangedEventHandler(
      Self, PropertyName, PropertyValue
    );

  end;

end;

procedure TCardFormViewModelProperty.SetValue(const Value: Variant);
begin

  if not AreValuesEquals(FValue, Value)
  then begin

    AssignOtherValue(Value);

    RaiseOnCardFormViewModelPropertyChangedEventHandler(
      Name, FValue
    );

  end

end;

function TCardFormViewModelProperty.ToString: String;
begin

  Result := VarToStr(Value);
  
end;

{ TCardIdProperty }

function TCardIdProperty.Clone: TObject;
var IdProperty: TCardIdProperty;
begin

  IdProperty := TCardIdProperty(inherited Clone);

  IdProperty.FIsSurrogate := FIsSurrogate;
  
  Result := IdProperty;

end;

procedure TCardIdProperty.CopyFrom(
  OtherViewModelProperty: TCardFormViewModelProperty);
var Other: TCardIdProperty;
begin

  if not (OtherViewModelProperty is TCardIdProperty) then
    Exit;

  inherited;

  Other := TCardIdProperty(OtherViewModelProperty);

  FIsSurrogate := Other.FIsSurrogate;

end;

constructor TCardIdProperty.Create(const Name: String);
begin

  inherited;

end;

function TCardIdProperty.Equals(
  OtherViewModelProperty: TCardFormViewModelProperty): Boolean;
begin

  Result :=
    (OtherViewModelProperty is TCardIdProperty) and
    inherited Equals(OtherViewModelProperty) and
    (IsSurrogate = TCardIdProperty(OtherViewModelProperty).IsSurrogate);
    
end;

function TCardIdProperty.GetIsSurrogate: Boolean;
begin

  Result := FIsSurrogate;

end;

procedure TCardIdProperty.SetIsSurrogate(const Value: Boolean);
begin

  FIsSurrogate := Value;

  FReadOnly := Value;
  
end;

{ TCardFormViewModel.TViewModelPropertyHolder }

constructor TCardFormViewModel.TViewModelPropertyHolder.Create(
  ViewModelProperty: TCardFormViewModelProperty);
begin

  inherited Create;

  Self.ViewModelProperty := ViewModelProperty;
  
end;

destructor TCardFormViewModel.TViewModelPropertyHolder.Destroy;
begin

  inherited;

end;

procedure TCardFormViewModel.TViewModelPropertyHolder.SetViewModelProperty(
  const Value: TCardFormViewModelProperty);
begin

  if FViewModelProperty = Value then
    Exit;

  FViewModelProperty := Value;
  FDisposable := Value;
  
end;

end.
