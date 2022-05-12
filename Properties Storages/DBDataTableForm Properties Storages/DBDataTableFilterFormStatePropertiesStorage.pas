unit DBDataTableFilterFormStatePropertiesStorage;

interface

uses

  IObjectPropertiesStorageUnit,
  IPropertiesStorageUnit,
  StandardDefaultObjectPropertiesStorage,
  TableViewFilterFormUnit,
  SimpleDateRangePanelUnit,
  VariantTypeUnit,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TDBDataTableFilterFormStatePropertiesStorage = class (TStandardDefaultObjectPropertiesStorage)

    protected

      procedure InternalSaveObjectProperties(
        TargetObject: TObject;
        PropertiesStorage: IPropertiesStorage
      ); override;

      procedure InternalRestorePropertiesForObject(
        TargetObject: TObject;
        PropertiesStorage: IPropertiesStorage
      ); override;

    protected

      procedure SaveFilterStateProperties(
        FilterFormState: TTableViewFilterFormState;
        PropertiesStorage: IPropertiesStorage
      );

      procedure SaveFilterFieldValue(FilterValue: TObject); virtual;

      procedure RestoreFilterStateProperties(
        FilterFormState: TTableViewFilterFormState;
        PropertiesStorage: IPropertiesStorage
      );

      function RestoreFilterFieldValue(PropertiesStorage: IPropertiesStorage): TObject; virtual;

      procedure RaiseExceptionAboutNotFoundPropertyName(const PropertyName: String);
      
  end;

implementation

uses

  AuxiliaryStringFunctions,
  Cloneable,
  Variants;

{ TDBDataTableFilterFormStatePropertiesStorage }

procedure TDBDataTableFilterFormStatePropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  RestoreFilterStateProperties(TargetObject as TTableViewFilterFormState, PropertiesStorage);

end;

procedure TDBDataTableFilterFormStatePropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  SaveFilterStateProperties(TargetObject as TTableViewFilterFormState, PropertiesStorage);

end;

procedure TDBDataTableFilterFormStatePropertiesStorage.RestoreFilterStateProperties(
  FilterFormState: TTableViewFilterFormState;
  PropertiesStorage: IPropertiesStorage
);
var
    FilterPanelData: TFilterPanelData;
    SectionIds: TVariantList;
    SectionId: Variant;
begin

  if not Assigned(FilterFormState) then Exit;
  
  SectionIds := PropertiesStorage.GetSectionIds;

  try

    try

      for SectionId in SectionIds do begin

        FilterPanelData := nil;
        
        if not PropertiesStorage.IsPropertyExists(SectionId, 'Focused') then
          Continue;

        FilterPanelData := TFilterPanelData.Create;

        PropertiesStorage.GoToSection(SectionId);

        FilterPanelData.IsFilterFieldControlFocused :=
          PropertiesStorage.ReadValueForProperty(
            'Focused', varBoolean, False
          );

        FilterPanelData.IsFilterFieldSelected :=
          PropertiesStorage.ReadValueForProperty(
            'Selected', varBoolean, False
          );

        FilterPanelData.FilterFieldName := SectionId;

        FilterPanelData.ConditionExpressionIndex :=
          PropertiesStorage.ReadValueForProperty(
            'ConditionExpressionIndex', varInteger, 0
          );

        FilterPanelData.FilterValue := RestoreFilterFieldValue(PropertiesStorage) as TCloneable;

        FilterFormState.AddFilterPanelData(FilterPanelData);

      end;

      PropertiesStorage.GoToSection('FilterOptions');

      FilterFormState.UseInsensitiveTextFilter :=
        PropertiesStorage.ReadValueForProperty(
          'UseInsensitiveTextFilter', varBoolean, False
        );

      PropertiesStorage.GoToSection('FilterFormOptions');
      
      FilterFormState.ChooseAllFilterFields :=
        PropertiesStorage.ReadValueForProperty('ChooseAllFilterFields', varBoolean, False);

      FilterFormState.FilterActivated :=
        PropertiesStorage.ReadValueForProperty('FilterActivated', varBoolean, False);
        
    except

      FreeAndNil(FilterPanelData);

      Raise;

    end;
    
  finally

    FreeAndNil(SectionIds);

  end;

end;

function TDBDataTableFilterFormStatePropertiesStorage.RestoreFilterFieldValue(
  PropertiesStorage: IPropertiesStorage
): TObject;
var
    FilterValueType: String;
    FilterValueString: String;
    DateTimeRangeString: String;
    DateTimeRangePartStrings: TStrings;
    LeftDateTimeString, RightDateTimeString: String;
    LeftDateTime, RightDateTime: TDateTime;
begin

  FilterValueType := PropertiesStorage.ReadValueForProperty('FilterValueType', varString, '');

  if FilterValueType = '' then
    RaiseExceptionAboutNotFoundPropertyName('FilterValueType');

  FilterValueString := PropertiesStorage.ReadValueForProperty('FilterValue', varString, '');

  if (FilterValueString = '')
      and not PropertiesStorage.IsPropertyExists(PropertiesStorage.GetCurrentSection, 'FilterValue')

  then RaiseExceptionAboutNotFoundPropertyName('FilterValue');

  if FilterValueType = 'DateTimeRange' then begin

    DateTimeRangePartStrings := SplitStringByDelimiter(FilterValueString, '|');

    try

      LeftDateTimeString := DateTimeRangePartStrings[0];
      RightDateTimeString := DateTimeRangePartStrings[1];

      LeftDateTime := StrToDateTime(LeftDateTimeString);
      RightDateTime := StrToDateTime(RightDateTimeString);
      
      Result := TDateTimeRange.Create(LeftDateTime, RightDateTime);

    finally

      FreeAndNil(DateTimeRangePartStrings);

    end;

  end

  else begin

    Result :=
      TVariant.Create(
        VarAsType(
          FilterValueString,
          StrToInt(FilterValueType)
        )
      );

  end;

end;

procedure TDBDataTableFilterFormStatePropertiesStorage.
  RaiseExceptionAboutNotFoundPropertyName(const PropertyName: String);
begin

  raise Exception.Create('Ќе найдено название сохран€емого свойства ' + PropertyName);

end;

procedure TDBDataTableFilterFormStatePropertiesStorage.SaveFilterStateProperties(
  FilterFormState: TTableViewFilterFormState;
  PropertiesStorage: IPropertiesStorage
);
var
    FilterPanelData: TFilterPanelData;
begin

  if not Assigned(FilterFormState) then Exit;
  
  for FilterPanelData in FilterFormState.FilterPanelDataList do begin

    PropertiesStorage.GoToSection(FilterPanelData.FilterFieldName);

    PropertiesStorage.WriteValueForProperty(
      'Focused', FilterPanelData.IsFilterFieldControlFocused
    );

    PropertiesStorage.WriteValueForProperty(
      'Selected', FilterPanelData.IsFilterFieldSelected
    );

    PropertiesStorage.WriteValueForProperty(
      'ConditionExpressionIndex', FilterPanelData.ConditionExpressionIndex
    );

    SaveFilterFieldValue(FilterPanelData.FilterValue);
    
  end;

  PropertiesStorage.GoToSection('FilterOptions');

  PropertiesStorage.WriteValueForProperty(
    'UseInsensitiveTextFilter', FilterFormState.UseInsensitiveTextFilter
  );

  PropertiesStorage.GoToSection('FilterFormOptions');

  PropertiesStorage.WriteValueForProperty(
    'ChooseAllFilterFields', FilterFormState.ChooseAllFilterFields
  );

  PropertiesStorage.WriteValueForProperty(
    'FilterActivated', FilterFormState.FilterActivated
  );

end;

procedure TDBDataTableFilterFormStatePropertiesStorage.SaveFilterFieldValue(
  FilterValue: TObject
);
var
    FilterValueKeyName: String;
    FilterValueTypeKeyValue: String;
    FilterValueVariant: Variant;
    DateTimeRange: TDateTimeRange;
    DateTimeRangeKeyValue: String;
begin

  if not ((FilterValue is TDateTimeRange) or (FilterValue is TVariant)) then
    Exit;

  FilterValueKeyName := 'FilterValue';

  if FilterValue is TVariant then begin

    FilterValueVariant := (FilterValue as TVariant).Value;

    FPropertiesStorage.WriteValueForProperty(
      FilterValueKeyName, FilterValueVariant
    );

    FilterValueTypeKeyValue := IntToStr(VarType(FilterValueVariant));

  end

  else begin

    DateTimeRange := FilterValue as TDateTimeRange;

    DateTimeRangeKeyValue :=
      DateTimeToStr(DateTimeRange.LeftDateTIme) + '|' +
      DateTimeToStr(DateTimeRange.RightDateTime);
      
    FPropertiesStorage.WriteValueForProperty(
      FilterValueKeyName, DateTimeRangeKeyValue
    );

    FilterValueTypeKeyValue := 'DateTimeRange';
    
  end;

  FPropertiesStorage.WriteValueForProperty(
    'FilterValueType', FilterValueTypeKeyValue
  );

end;

end.
