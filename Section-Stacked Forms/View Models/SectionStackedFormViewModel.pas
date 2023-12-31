unit SectionStackedFormViewModel;

interface

uses

  SectionSetHolder,
  SectionRecordViewModel,
  VariantListUnit,
  Controls,
  SysUtils,
  Classes;

type

  TSectionStackedFormViewModel = class

    private

      type

        TSectionControlMap = class

          private

            type

              TSectionControlItem = class

                SectionId: Variant;
                Control: TControl;

                constructor Create(
                  const SectionId: Variant;
                  Control: TControl
                );
                
              end;

          private

            FSectionControlItemList: TList;

            function GetSectionIds: TVariantList;

            function FindSectionControlItemBy(const SectionId: Variant): TSectionControlItem;
      
          public

            destructor Destroy; override;
            constructor Create;

            procedure AddSectionControlAssociation(
              const SectionId: Variant;
              Control: TControl
            );

            procedure ChangeControlOfSection(
              const SectionId: Variant;
              Control: TControl
            ); overload;
            
            procedure RemoveSectionControlAssociation(
              const SectionId: Variant
            );

            function GetControlOfSection(
              const SectionId: Variant
            ): TControl; overload;

            function IsSectionControlAssociationExists(
              const SectionId: Variant
            ): Boolean;

            function IsControlAssignedForSection(const SectionId: Variant): Boolean;
            
          public

            property SectionIds: TVariantList read GetSectionIds;
            
            property Controls[const SectionId: Variant]: TControl
            read GetControlOfSection write ChangeControlOfSection; default;
            
        end;

    private

      FSectionSetHolder: TSectionSetHolder;
      FSectionControlMap: TSectionControlMap;

      procedure SetSectionSetHolder(const Value: TSectionSetHolder);

    protected

      procedure SetCurrentSectionRecordFieldValuesFrom(
        SectionRecordViewModel: TSectionRecordViewModel
      );

      procedure InternalSetCurrentSectionRecordFieldValuesFrom(
        SectionRecordViewModel: TSectionRecordViewModel
      ); virtual;

      function GetSectionRecordViewModelClass: TSectionRecordViewModelClass; virtual;

      procedure FillSectionRecordViewModelFromCurrentRecord(
        SectionRecordViewModel: TSectionRecordViewModel
      ); virtual;
      
    public

      destructor Destroy; override;
      constructor Create;

      procedure AddSection(
        SectionRecordViewModel: TSectionRecordViewModel;
        Control: TControl = nil
      ); virtual;

      procedure ChangeSection(
        SectionRecordViewModel: TSectionRecordViewModel;
        Control: TControl = nil
      ); virtual;

      procedure ChangeControlOfSection(
        const SectionId: Variant;
        Control: TControl
      ); 

      procedure RemoveSection(
        const SectionId: Variant
      ); virtual;

      function GetControlOfSection(const SectionId: Variant): TControl;

      function GetSectionRecordViewModel(
        const SectionId: Variant
      ): TSectionRecordViewModel;

      function IsSectionExists(const SectionId: Variant): Boolean;
      function IsControlAssignedForSection(const SectionId: Variant): Boolean;
      
    public

      property SectionSetHolder: TSectionSetHolder
      read FSectionSetHolder write SetSectionSetHolder;

      property Controls[const SectionId: Variant]: TControl
      read GetControlOfSection write ChangeControlOfSection;

  end;

  TSectionStackedFormViewModelClass = class of TSectionStackedFormViewModel;
  
implementation

uses

  Variants,
  AuxCollectionFunctionsUnit;
  
{ TSectionStackedFormViewModel }

procedure TSectionStackedFormViewModel.AddSection(
  SectionRecordViewModel: TSectionRecordViewModel;
  Control: TControl
);
begin

  FSectionControlMap.AddSectionControlAssociation(
    SectionRecordViewModel.Id, Control
  );

  try

    try

      SectionSetHolder.DisableControls;

      SectionSetHolder.Append;

      SetCurrentSectionRecordFieldValuesFrom(SectionRecordViewModel);

    except

      on e: Exception do begin

        FSectionControlMap.RemoveSectionControlAssociation(
          SectionRecordViewModel.Id
        );

        raise;

      end;

    end;

  finally

    SectionSetHolder.EnableControls;
    
  end;
  
end;

procedure TSectionStackedFormViewModel.ChangeControlOfSection(
  const SectionId: Variant; Control: TControl);
begin

  FSectionControlMap[SectionId] := Control;
  
end;

procedure TSectionStackedFormViewModel.ChangeSection(
  SectionRecordViewModel: TSectionRecordViewModel;
  Control: TControl
);
var PreviousFocusedSectionRecordBookmark: Pointer;
    PreviousSectionControl: TControl;
begin

  PreviousSectionControl := FSectionControlMap[SectionRecordViewModel.Id];

  FSectionControlMap[SectionRecordViewModel.Id] := Control;

  try

    try

      SectionSetHolder.DisableControls;

      if SectionSetHolder.SectionIdFieldValue <> SectionRecordViewModel.Id
      then begin

        PreviousFocusedSectionRecordBookmark := SectionSetHolder.GetBookmark;

        SectionSetHolder.Locate(
          SectionSetHolder.SectionIdFieldName, SectionRecordViewModel.Id, []
        );

      end

      else PreviousFocusedSectionRecordBookmark := nil;

      SetCurrentSectionRecordFieldValuesFrom(SectionRecordViewModel);
      
    except

      on e: Exception do begin

        FSectionControlMap[SectionRecordViewModel.Id] := PreviousSectionControl;

        raise;
        
      end;

    end;
    
  finally

    try

      SectionSetHolder.GotoBookmarkAndFree(PreviousFocusedSectionRecordBookmark);

    finally

      SectionSetHolder.EnableControls;
      
    end;

  end;

end;

constructor TSectionStackedFormViewModel.Create;
begin

  inherited;

  FSectionControlMap := TSectionControlMap.Create;
  
end;

destructor TSectionStackedFormViewModel.Destroy;
begin

  FreeAndNil(FSectionSetHolder);
  FreeAndNil(FSectionControlMap);
  
  inherited;
  
end;

procedure TSectionStackedFormViewModel.FillSectionRecordViewModelFromCurrentRecord(
  SectionRecordViewModel: TSectionRecordViewModel);
begin

  SectionRecordViewModel.Id := SectionSetHolder.SectionIdFieldValue;
  SectionRecordViewModel.ParentId := SectionSetHolder.ParentIdSectionFieldValue;
  SectionRecordViewModel.Name := SectionSetHolder.SectionNameFieldValue;
  SectionRecordViewModel.MustBeContent := SectionSetHolder.MustBeContentFieldValue;
  
end;

function TSectionStackedFormViewModel.GetControlOfSection(
  const SectionId: Variant): TControl;
begin

  Result := FSectionControlMap[SectionId];
  
end;

function TSectionStackedFormViewModel.GetSectionRecordViewModel(
  const SectionId: Variant): TSectionRecordViewModel;
var PreviousFocusedSectionRecordBookmark: Pointer;
begin

  try

    SectionSetHolder.DisableControls;

    if SectionSetHolder.SectionIdFieldValue <> SectionId then begin

      PreviousFocusedSectionRecordBookmark := SectionSetHolder.GetBookmark;

      SectionSetHolder.Locate(
        SectionSetHolder.SectionIdFieldName, SectionId, []
      );

    end

    else PreviousFocusedSectionRecordBookmark := nil;

    Result := GetSectionRecordViewModelClass.Create;

    try

      FillSectionRecordViewModelFromCurrentRecord(Result);
      
    except

      on e: Exception do begin

        FreeAndNil(Result);

        raise;

      end;

    end;

  finally

    try

      SectionSetHolder.GotoBookmarkAndFree(PreviousFocusedSectionRecordBookmark);

    finally

      SectionSetHolder.EnableControls;
      
    end;

  end;

end;

function TSectionStackedFormViewModel.GetSectionRecordViewModelClass: TSectionRecordViewModelClass;
begin

  Result := TSectionRecordViewModel;
  
end;

procedure TSectionStackedFormViewModel.RemoveSection(const SectionId: Variant);
var PreviousFocusedSectionRecordBookmark: Pointer;
    PreviousSectionControl: TControl;
begin

  PreviousSectionControl := FSectionControlMap[SectionId];

  FSectionControlMap.RemoveSectionControlAssociation(SectionId);
  
  try

    try

      SectionSetHolder.DisableControls;

      if SectionSetHolder.SectionIdFieldValue <> SectionId then begin

        PreviousFocusedSectionRecordBookmark := SectionSetHolder.GetBookmark;

        SectionSetHolder.Locate(
          SectionSetHolder.SectionIdFieldName, SectionId, []
        );
        
      end

      else PreviousFocusedSectionRecordBookmark := nil;

      SectionSetHolder.Delete;
      
    except

      on e: Exception do begin

        FSectionControlMap.AddSectionControlAssociation(
          SectionId, PreviousSectionControl
        );

        raise;
        
      end;

    end;

  finally

    try

      SectionSetHolder.GotoBookmarkAndFree(PreviousFocusedSectionRecordBookmark);

    finally

      SectionSetHolder.EnableControls;
      
    end;

  end;

end;

procedure TSectionStackedFormViewModel.
  SetCurrentSectionRecordFieldValuesFrom(
    SectionRecordViewModel: TSectionRecordViewModel
  );
begin

  if not SectionSetHolder.IsInEditOrAppend then
    SectionSetHolder.Edit;

  InternalSetCurrentSectionRecordFieldValuesFrom(SectionRecordViewModel);

  SectionSetHolder.Post;
  
end;

procedure TSectionStackedFormViewModel.InternalSetCurrentSectionRecordFieldValuesFrom(
  SectionRecordViewModel: TSectionRecordViewModel);
begin

  SectionSetHolder.SectionIdFieldValue := SectionRecordViewModel.Id;
  SectionSetHolder.ParentIdSectionFieldValue := SectionRecordViewModel.ParentId;
  SectionSetHolder.SectionNameFieldValue := SectionRecordViewModel.Name;
  SectionSetHolder.MustBeContentFieldValue := SectionRecordViewModel.MustBeContent;
  
end;

function TSectionStackedFormViewModel.IsControlAssignedForSection(
  const SectionId: Variant): Boolean;
begin

  Result := FSectionControlMap.IsControlAssignedForSection(SectionId);
  
end;

function TSectionStackedFormViewModel.IsSectionExists(
  const SectionId: Variant): Boolean;
begin

  Result := FSectionControlMap.IsSectionControlAssociationExists(SectionId);
  
end;

procedure TSectionStackedFormViewModel.SetSectionSetHolder(
  const Value: TSectionSetHolder);
begin

  if FSectionSetHolder = Value then
    Exit;

  FreeAndNil(FSectionSetHolder);
                       
  FSectionSetHolder := Value;

end;

{ TSectionStackedFormViewModel.TSectionControlMap.TSectionControlItem }

constructor TSectionStackedFormViewModel.TSectionControlMap.TSectionControlItem.Create(
  const SectionId: Variant; Control: TControl);
begin

  inherited Create;

  Self.SectionId := SectionId;
  Self.Control := Control;
  
end;

{ TSectionStackedFormViewModel.TSectionControlMap }

procedure TSectionStackedFormViewModel.TSectionControlMap.AddSectionControlAssociation(
  const SectionId: Variant; Control: TControl);
begin

  if VarIsNull(SectionId) then
    raise Exception.Create('Section id can not be bull');
  
  if IsSectionControlAssociationExists(SectionId) then begin

    raise Exception.CreateFmt(
      'Section "%s" is already exists',
      [VarToStr(SectionId)]
    );
    
  end;

  FSectionControlItemList.Add(TSectionControlItem.Create(SectionId, Control));
  
end;

procedure TSectionStackedFormViewModel.TSectionControlMap.ChangeControlOfSection(
  const SectionId: Variant; Control: TControl);
var SectionControlItem: TSectionControlItem;
begin

  SectionControlItem := FindSectionControlItemBy(SectionId);

  if not Assigned(SectionControlItem) then begin

    raise Exception.CreateFmt(
      'Section "%s" is absent',
      [VarToStr(SectionId)]
    );
    
  end;

  SectionControlItem.Control := Control;
  
end;

constructor TSectionStackedFormViewModel.TSectionControlMap.Create;
begin

  inherited Create;

  FSectionControlItemList := TList.Create;
  
end;

destructor TSectionStackedFormViewModel.TSectionControlMap.Destroy;
begin

  FreeListWithItems(FSectionControlItemList);
  inherited;

end;

function TSectionStackedFormViewModel.TSectionControlMap.FindSectionControlItemBy(
  const SectionId: Variant): TSectionControlItem;
var SectionControlItemPointer: Pointer;
begin

  for SectionControlItemPointer in FSectionControlItemList do begin

    Result := TSectionControlItem(SectionControlItemPointer);

    if Result.SectionId = SectionId then Exit;

  end;

  Result := nil;

end;

function TSectionStackedFormViewModel.TSectionControlMap.GetControlOfSection(
  const SectionId: Variant): TControl;
var SectionControlItem: TSectionControlItem;
begin

  SectionControlItem := FindSectionControlItemBy(SectionId);

  if Assigned(SectionControlItem) then
    Result := SectionControlItem.Control

  else Result := nil;
  
end;

function TSectionStackedFormViewModel.TSectionControlMap.GetSectionIds: TVariantList;
var SectionControlItemPointer: Pointer;
begin

  Result := TVariantList.Create;

  try

    for SectionControlItemPointer in FSectionControlItemList do
      Result.Add(TSectionControlItem(SectionControlItemPointer).SectionId);

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function TSectionStackedFormViewModel.TSectionControlMap.IsControlAssignedForSection(
  const SectionId: Variant): Boolean;
begin

  Result := Assigned(FindSectionControlItemBy(SectionId).Control);
  
end;

function TSectionStackedFormViewModel.TSectionControlMap.IsSectionControlAssociationExists(
  const SectionId: Variant): Boolean;
begin

  Result := Assigned(FindSectionControlItemBy(SectionId));
  
end;

procedure TSectionStackedFormViewModel.TSectionControlMap.RemoveSectionControlAssociation(
  const SectionId: Variant);
var SectionControlItem: TSectionControlItem;
begin

  SectionControlItem := FindSectionControlItemBy(SectionId);

  FSectionControlItemList.Remove(SectionControlItem);

  SectionControlItem.Free;
  
end;

end.
