unit AbstractRepositoryUnit;

interface

  uses Windows, Classes, DB, SysUtils, Variants, DomainObjectUnit,
       AbstractRepositoryCriteriaUnit, ConstRepositoryCriterionUnit,
       AbstractNegativeRepositoryCriterionUnit,
       ArithmeticRepositoryCriterionOperationsUnit,
       BoolLogicalNegativeRepositoryCriterionUnit,
       BoolLogicalRepositoryCriterionBindingsUnit,
       UnaryRepositoryCriterionUnit,
       BinaryRepositoryCriterionUnit,
       ContainsRepositoryCriterionOperationUnit,
       UnitingRepositoryCriterionUnit, DomainObjectListUnit;
  
  type

    TRepositoryOperation = (

      roSelectAll,
      roSelectSingle,
      roSelectGroup,
      roAdding,
      roChanging,
      roRemoving

    );

    TRepositoryError = class

      private

        FErrorMessage: String;
        FInformativeErrorMessage: String;
        FErrorData: Variant;

      public

        constructor Create; overload;
        constructor Create(const ErrorMessage,
          InformativeErrorMessage: String;
          ErrorData: Variant
        ); overload;

        property ErrorMessage: String read FErrorMessage write FErrorMessage;
        property InformativeErrorMessage: String read FInformativeErrorMessage write FInformativeErrorMessage;
        property ErrorData: Variant read FErrorData write FErrorData;

    end;

    TAbstractRepository = class;

    TRepositoryErrorCreator = class

      strict protected

        FAbstractRepository: TAbstractRepository;

        procedure OnErrorOccurredForSelectAll(
          RepositoryError: TRepositoryError
        ); virtual;

        procedure OnErrorOccurredForSelectSingle(
          RepositoryError: TRepositoryError
        ); virtual;

        procedure OnErrorOccurredForSelectGroup(
          RepositoryError: TRepositoryError
        ); virtual;

        procedure OnErrorOccurredForAdding(
          RepositoryError: TRepositoryError;
          ErrorDomainObject: TDomainObject
        ); virtual;

        procedure OnErrorOccurredForChanging(
          RepositoryError: TRepositoryError;
          ErrorDomainObject: TDomainObject
        ); virtual;

        procedure OnErrorOccurredForRemoving(
          RepositoryError: TRepositoryError;
          ErrorDomainObject: TDomainObject
        ); virtual;

        function CreateDefaultErrorFromException(
          const SourceException: Exception
        ): TRepositoryError; virtual;
        
      public

        constructor Create(AbstractRepository: TAbstractRepository);
        
        function CreateError(
          const ErrorMessage,
          InformativeErrorMessage: String;
          ErrorData: Variant
        ): TRepositoryError; virtual;

        function CreateErrorFromException(
          const SourceException: Exception;
          ExceptionalDomainObject: TDomainObject
        ): TRepositoryError; virtual;

    end;

    { refactor: �������� ������ �������� ����������� ������� ������������
      �� D:\Own-Common-Delphi-Libraries-master }

    IDomainObjectRepository = interface

    end;

    TAbstractRepository = class abstract (TInterfacedObject, IDomainObjectRepository)

      strict protected

        FLastOperation: TRepositoryOperation;
        FLastError: TRepositoryError;
        FRepositoryErrorCreator: TRepositoryErrorCreator;
        FDomainObjectInvariantsComplianceEnabled: Boolean;
        
        function CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator; virtual;

        procedure Initialize; virtual;
        
        constructor Create; overload;
        constructor Create(RepositoryErrorCreator: TRepositoryErrorCreator); overload;

        procedure ResetLastError;
        procedure SetLastError(LastError: TRepositoryError);
        procedure SetLastErrorFromException(
          const SourceException: Exception
        );
        procedure SetLastErrorFromExceptionalDomainObject(
          const SourceException: Exception;
          ExceptionalDomainObject: TDomainObject
        );

        procedure OnAfterFoundDomainObjectsByCriteria(DomainObjects: TDomainObjectList); virtual;
        procedure OnAfterLoadAllDomainObjects(DomainObjects: TDomainObjectList); virtual;
        procedure OnAfterFoundDomainObjectByIdentity(FoundDomainObject: TDomainObject); virtual;
        procedure OnAfterDomainObjectAdded(AddedDomainObject: TDomainObject); virtual;
        procedure OnAfterDomainObjectListAdded(AddedDomainObjectList: TDomainObjectList); virtual;
        procedure OnAfterDomainObjectUpdated(UpdatedDomainObject: TDomainObject); virtual;
        procedure OnAfterDomainObjectListUpdated(UpdatedDomainObjectList: TDomainObjectList); virtual;
        procedure OnAfterDomainObjectRemoved(RemovedDomainObject: TDomainObject); virtual;
        procedure OnAfterDomainObjectListRemoved(RemovedDomainObjectList: TDomainObjectList); virtual;

        function CreateDomainObject: TDomainObject; virtual; abstract;
        function CreateDomainObjectList: TDomainObjectList; virtual;
        
        function CreateAndFillDomainObjectFromDataHolder(
          DataHolder: TObject
        ): TDomainObject; 

        function CreateAndFillDomainObjectListFromDataHolder(
          DataHolder: TObject
        ): TDomainObjectList; virtual;

        procedure FillDomainObjectListFromDataHolder(
          DomainObjects: TDomainObjectList;
          DataHolder: TObject
        ); virtual; abstract;

        procedure FillDomainObjectFromDataHolder(
          DomainObject: TDomainObject;
          DataHolder: TObject
        ); virtual; abstract;

        function GetHasError: Boolean; virtual;
        function GetLastError: TRepositoryError; virtual;
        function GetLastOperation: TRepositoryOperation; virtual;

      public

        destructor Destroy; override;

        function GetContainsRepositoryCriterionOperationClass: TContainsRepositoryCriterionOperationClass; virtual;
        function GetNegativeRepositoryCriterionClass: TBoolNegativeRepositoryCriterionClass; virtual;
        function GetConstRepositoryCriterionClass: TConstRepositoryCriterionClass; virtual;
        function GetEqualityRepositoryCriterionOperationClass: TEqualityRepositoryCriterionOperationClass; virtual;
        function GetLessRepositoryCriterionOperationClass: TLessRepositoryCriterionOperationClass; virtual;
        function GetGreaterRepositoryCriterionOperationClass: TGreaterRepositoryCriterionOperationClass; virtual;
        function GetLessOrEqualRepositoryCriterionOperationClass: TLessOrEqualRepositoryCriterionOperationClass; virtual;
        function GetGreaterOrEqualRepositoryCriterionOperationClass: TGreaterOrEqualRepositoryCriterionOperationClass; virtual;
        function GetAndBindingRepositoryCriterionClass: TBoolAndBindingClass; virtual;
        function GetOrBindingRepositoryCriterionClass: TBoolOrBindingClass; virtual;
        function GetUnaryRepositoryCriterionClass: TUnaryRepositoryCriterionClass; virtual;
        function GetBinaryRepositoryCriterionClass: TBinaryRepositoryCriterionClass; virtual;
        function GetUnitingRepositoryCriterionClass: TUnitingRepositoryCriterionClass; virtual;

        function InternalFindDomainObjectByIdentity(Identity: Variant): TDomainObject; virtual; abstract;
        function InternalAdd(DomainObject: TDomainObject): Boolean; virtual; abstract;
        function InternalAddDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; virtual; abstract;
        function InternalUpdate(DomainObject: TDomainObject): Boolean; virtual; abstract;
        function InternalUpdateDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; virtual; abstract;
        function InternalRemove(DomainObject: TDomainObject): Boolean; virtual; abstract;
        function InternalRemoveDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; virtual; abstract;
        function InternalFindDomainObjectsByCriteria(Criteria: TAbstractRepositoryCriterion): TDomainObjectList; virtual; abstract;
        function InternalLoadAll: TDomainObjectList; virtual; abstract;

        function Add(DomainObject: TDomainObject): Boolean; virtual;
        function AddDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; virtual;
        function Update(DomainObject: TDomainObject): Boolean; virtual;
        function UpdateDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; virtual;
        function Remove(DomainObject: TDomainObject): Boolean; virtual;
        function RemoveDomainObjectList(DomainObjectList: TDomainObjectList): Boolean; virtual;
        function FindDomainObjectByIdentity(Identity: Variant): TDomainObject; virtual;
        function FindDomainObjectsByCriteria(Criteria: TAbstractRepositoryCriterion): TDomainObjectList; virtual;
        function LoadAll: TDomainObjectList; virtual;

        property HasError: Boolean read GetHasError;
        property LastError: TRepositoryError read GetLastError;
        property LastOperation: TRepositoryOperation read GetLastOperation;

        property RepositoryErrorCreator: TRepositoryErrorCreator
        read FRepositoryErrorCreator write FRepositoryErrorCreator;

        property DomainObjectInvariantsComplianceEnabled: Boolean
        read FDomainObjectInvariantsComplianceEnabled
        write FDomainObjectInvariantsComplianceEnabled;

        procedure ThrowExceptionWithInformativeMessageIfHasError;

    end;

    TAbstractDataSetRepository = class abstract(TAbstractRepository)

      protected

        FDataSet: TDataSet;

        constructor Create(DataSet: TDataSet); overload;
        constructor Create(DataSet: TDataSet; RepositoryErrorCreator: TRepositoryErrorCreator); overload;

        procedure InternalRefreshDataSet; virtual;

      public

        function LoadAll: TDomainObjectList; override;

        procedure RefreshDataSet; virtual;

        property DataSet: TDataSet read FDataSet write FDataSet;
        
    end;

implementation

{ TRepositoryErrorCreator }
constructor TRepositoryErrorCreator.Create(AbstractRepository: TAbstractRepository);
begin

  inherited Create;

  FAbstractRepository := AbstractRepository;

end;

function TRepositoryErrorCreator.CreateDefaultErrorFromException(
  const SourceException: Exception): TRepositoryError;
begin

  Result :=
    TRepositoryError.Create(
      SourceException.Message,
      SourceException.Message,
      ''
    );

end;

function TRepositoryErrorCreator.CreateError(const ErrorMessage,
  InformativeErrorMessage: String; ErrorData: Variant): TRepositoryError;
begin

  Result := TRepositoryError.Create(ErrorMessage, InformativeErrorMessage, ErrorData);

end;

function TRepositoryErrorCreator.CreateErrorFromException(
  const SourceException: Exception;
  ExceptionalDomainObject: TDomainObject
): TRepositoryError;
begin

  Result := CreateDefaultErrorFromException(SourceException);
  
  case FAbstractRepository.LastOperation of

    roSelectAll:
      OnErrorOccurredForSelectAll(Result);

    roSelectSingle:
      OnErrorOccurredForSelectSingle(Result);

    roSelectGroup:
      OnErrorOccurredForSelectGroup(Result);

    roAdding:
      OnErrorOccurredForAdding(Result, ExceptionalDomainObject);

    roChanging:
      OnErrorOccurredForChanging(Result, ExceptionalDomainObject);

    roRemoving:
      OnErrorOccurredForRemoving(Result, ExceptionalDomainObject);

  end;

end;

procedure TRepositoryErrorCreator.OnErrorOccurredForAdding(
  RepositoryError: TRepositoryError; ErrorDomainObject: TDomainObject);
begin

end;

procedure TRepositoryErrorCreator.OnErrorOccurredForChanging(
  RepositoryError: TRepositoryError; ErrorDomainObject: TDomainObject);
begin

end;

procedure TRepositoryErrorCreator.OnErrorOccurredForRemoving(
  RepositoryError: TRepositoryError; ErrorDomainObject: TDomainObject);
begin

end;

procedure TRepositoryErrorCreator.OnErrorOccurredForSelectAll(
  RepositoryError: TRepositoryError);
begin

end;

procedure TRepositoryErrorCreator.OnErrorOccurredForSelectGroup(
  RepositoryError: TRepositoryError);
begin

end;

procedure TRepositoryErrorCreator.OnErrorOccurredForSelectSingle(
  RepositoryError: TRepositoryError);
begin

end;

{ TRepositoryError }

constructor TRepositoryError.Create;
begin

  inherited;
  
end;

constructor TRepositoryError.Create(const ErrorMessage,
  InformativeErrorMessage: String; ErrorData: Variant);
begin

  inherited Create;

  FErrorMessage := ErrorMessage;
  FInformativeErrorMessage := InformativeErrorMessage;
  FErrorData := ErrorData;

end;

{ TAbstractRepository }

constructor TAbstractRepository.Create;
begin

  inherited;

  Initialize;
  
  FRepositoryErrorCreator := CreateDefaultRepositoryErrorCreator;

end;

function TAbstractRepository.AddDomainObjectList(
  DomainObjectList: TDomainObjectList): Boolean;
begin

  FLastOperation := roAdding;

  try

    Result := InternalAddDomainObjectList(DomainObjectList);

    ResetLastError;

    OnAfterDomainObjectListAdded(DomainObjectList);

  except

    on e: Exception do begin

      SetLastErrorFromException(e);

      Result := False;
      
    end;

  end;
  
end;

constructor TAbstractRepository.Create(
  RepositoryErrorCreator: TRepositoryErrorCreator);
begin

  inherited Create;

  Initialize;

  FRepositoryErrorCreator := RepositoryErrorCreator;

end;

function TAbstractRepository.CreateDefaultRepositoryErrorCreator: TRepositoryErrorCreator;
begin

  Result := TRepositoryErrorCreator.Create(Self);
  
end;

function TAbstractRepository.CreateDomainObjectList: TDomainObjectList;
begin

  Result := TDomainObjectList.Create;
  
end;

function TAbstractRepository.CreateAndFillDomainObjectFromDataHolder(
  DataHolder: TObject
): TDomainObject;
begin

  Result := CreateDomainObject;

  Result.InvariantsComplianceRequested :=
    DomainObjectInvariantsComplianceEnabled;

  FillDomainObjectFromDataHolder(Result, DataHolder);

  Result.InvariantsComplianceRequested := True;
  
end;

function TAbstractRepository.CreateAndFillDomainObjectListFromDataHolder(
  DataHolder: TObject
): TDomainObjectList;
begin

  Result := CreateDomainObjectList;

  FillDomainObjectListFromDataHolder(Result, DataHolder);

end;

destructor TAbstractRepository.Destroy;
begin

  inherited;
  
end;

function TAbstractRepository.LoadAll: TDomainObjectList;
begin

  Result := nil;
  FLastOperation := roSelectAll;

  try

    Result := InternalLoadAll;

    ResetLastError;

    OnAfterLoadAllDomainObjects(Result);

  except

    on e: Exception do
      SetLastErrorFromException(e);

  end;

end;

function TAbstractRepository.FindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion): TDomainObjectList;
begin

  Result := nil;
  FLastOperation := roSelectGroup;

  try

    Result := InternalFindDomainObjectsByCriteria(Criteria);

    ResetLastError;

    OnAfterFoundDomainObjectsByCriteria(Result);

  except

    on e: Exception do
      SetLastErrorFromException(e);

  end;

end;

function TAbstractRepository.FindDomainObjectByIdentity(
  Identity: Variant): TDomainObject;
begin

  Result := nil;
  FLastOperation := roSelectSingle;

  try

    Result := InternalFindDomainObjectByIdentity(Identity);

    ResetLastError;

    OnAfterFoundDomainObjectByIdentity(Result);

  except

    on e: Exception do
      SetLastErrorFromException(e);

  end;

end;

function TAbstractRepository.Add(DomainObject: TDomainObject): Boolean;
begin

  FLastOperation := roAdding;

  try

    Result := InternalAdd(DomainObject);

    ResetLastError;

    OnAfterDomainObjectAdded(DomainObject);

  except

    on e: Exception do begin

      SetLastErrorFromExceptionalDomainObject(e, DomainObject);

      Result := False;

    end;

  end;

end;

function TAbstractRepository.Update(DomainObject: TDomainObject): Boolean;
begin

  FLastOperation := roChanging;

  try

    Result := InternalUpdate(DomainObject);

    ResetLastError;

    OnAfterDomainObjectUpdated(DomainObject);

  except

    on e: Exception do begin

      SetLastErrorFromExceptionalDomainObject(e, DomainObject);

      Result := False;

    end;

  end;

end;

function TAbstractRepository.UpdateDomainObjectList(
  DomainObjectList: TDomainObjectList
): Boolean;
begin

  FLastOperation := roChanging;

  try

    Result := InternalUpdateDomainObjectList(DomainObjectList);

    ResetLastError;

    OnAfterDomainObjectListUpdated(DomainObjectList);

  except

    on e: Exception do begin

      SetLastErrorFromException(e);

      Result := False;
      
    end;

  end;

end;

function TAbstractRepository.Remove(DomainObject: TDomainObject): Boolean;
begin

  FLastOperation := roRemoving;

  try

    Result := InternalRemove(DomainObject);

    ResetLastError;

    OnAfterDomainObjectRemoved(DomainObject);

  except

    on e: Exception do begin

      SetLastErrorFromExceptionalDomainObject(e, DomainObject);

      Result := False;
      
    end;

  end;
  
end;

function TAbstractRepository.RemoveDomainObjectList(
  DomainObjectList: TDomainObjectList): Boolean;
begin

  FLastOperation := roRemoving;

  try

    Result := InternalRemoveDomainObjectList(DomainObjectList);

    ResetLastError;

    OnAfterDomainObjectListRemoved(DomainObjectList);
    
  except

    on e: Exception do begin

      SetLastErrorFromException(e);

      Result := False;

    end;

  end;
  
end;

function TAbstractRepository.GetAndBindingRepositoryCriterionClass: TBoolAndBindingClass;
begin

  Result := TBoolAndBinding;

end;

function TAbstractRepository.GetBinaryRepositoryCriterionClass: TBinaryRepositoryCriterionClass;
begin

  Result := TBinaryRepositoryCriterion;

end;

function TAbstractRepository.GetConstRepositoryCriterionClass: TConstRepositoryCriterionClass;
begin

  Result := TConstRepositoryCriterion;

end;

function TAbstractRepository.GetContainsRepositoryCriterionOperationClass: TContainsRepositoryCriterionOperationClass;
begin

  Result := TContainsRepositoryCriterionOperation;

end;

function TAbstractRepository.GetEqualityRepositoryCriterionOperationClass: TEqualityRepositoryCriterionOperationClass;
begin

  Result := TEqualityRepositoryCriterionOperation;

end;

function TAbstractRepository.GetGreaterOrEqualRepositoryCriterionOperationClass: TGreaterOrEqualRepositoryCriterionOperationClass;
begin

  Result := TGreaterOrEqualRepositoryCriterionOperation;

end;

function TAbstractRepository.GetGreaterRepositoryCriterionOperationClass: TGreaterRepositoryCriterionOperationClass;
begin

  Result := TGreaterRepositoryCriterionOperation;

end;

function TAbstractRepository.GetHasError: Boolean;
begin

  Result := Assigned(FLastError);
  
end;

function TAbstractRepository.GetLastError: TRepositoryError;
begin

  Result := FLastError;

end;

function TAbstractRepository.GetLastOperation: TRepositoryOperation;
begin

  Result := FLastOperation;
  
end;

function TAbstractRepository.GetLessOrEqualRepositoryCriterionOperationClass: TLessOrEqualRepositoryCriterionOperationClass;
begin

  Result := TLessOrEqualRepositoryCriterionOperation;

end;

function TAbstractRepository.GetLessRepositoryCriterionOperationClass: TLessRepositoryCriterionOperationClass;
begin

  Result := TLessRepositoryCriterionOperation;

end;

function TAbstractRepository.GetNegativeRepositoryCriterionClass: TBoolNegativeRepositoryCriterionClass;
begin

  Result := TBoolNegativeRepositoryCriterion;

end;

function TAbstractRepository.GetOrBindingRepositoryCriterionClass: TBoolOrBindingClass;
begin

  Result := TBoolOrBinding;
  
end;

function TAbstractRepository.GetUnaryRepositoryCriterionClass: TUnaryRepositoryCriterionClass;
begin

  Result := TUnaryRepositoryCriterion;
  
end;

function TAbstractRepository.GetUnitingRepositoryCriterionClass: TUnitingRepositoryCriterionClass;
begin

  Result := TUnitingRepositoryCriterion;

end;

procedure TAbstractRepository.Initialize;
begin

  DomainObjectInvariantsComplianceEnabled := True;
  
end;

procedure TAbstractRepository.OnAfterDomainObjectAdded(
  AddedDomainObject: TDomainObject);
begin

end;

procedure TAbstractRepository.OnAfterDomainObjectListAdded(
  AddedDomainObjectList: TDomainObjectList);
begin

end;

procedure TAbstractRepository.OnAfterDomainObjectListRemoved(
  RemovedDomainObjectList: TDomainObjectList
);
begin

end;

procedure TAbstractRepository.OnAfterDomainObjectListUpdated(
  UpdatedDomainObjectList: TDomainObjectList);
begin

end;

procedure TAbstractRepository.OnAfterDomainObjectRemoved(
  RemovedDomainObject: TDomainObject);
begin

end;

procedure TAbstractRepository.OnAfterDomainObjectUpdated(
  UpdatedDomainObject: TDomainObject);
begin

end;

procedure TAbstractRepository.OnAfterFoundDomainObjectByIdentity(
  FoundDomainObject: TDomainObject);
begin

end;

procedure TAbstractRepository.OnAfterFoundDomainObjectsByCriteria(
  DomainObjects: TDomainObjectList);
begin

end;

procedure TAbstractRepository.OnAfterLoadAllDomainObjects(
  DomainObjects: TDomainObjectList
);
begin

end;

procedure TAbstractRepository.ResetLastError;
begin

  SetLastError(nil);
  
end;

procedure TAbstractRepository.SetLastError(LastError: TRepositoryError);
begin

  FreeAndNil(FLastError);

  FLastError := LastError;

end;

procedure TAbstractRepository.SetLastErrorFromException(
  const SourceException: Exception
);
begin

  SetLastErrorFromExceptionalDomainObject(SourceException, nil);
  
end;

procedure TAbstractRepository.SetLastErrorFromExceptionalDomainObject(
  const SourceException: Exception; ExceptionalDomainObject: TDomainObject);
begin

  SetLastError(
    FRepositoryErrorCreator.CreateErrorFromException(
      SourceException, ExceptionalDomainObject
    )
  );

end;

procedure TAbstractRepository.ThrowExceptionWithInformativeMessageIfHasError;
begin

  if HasError and (LastError.InformativeErrorMessage <> '') then begin
  
    raise Exception.Create(
      LastError.InformativeErrorMessage
    );

  end;

end;

{ TAbstractDataSetRepository }

constructor TAbstractDataSetRepository.Create(DataSet: TDataSet);
begin

  inherited Create;

  FDataSet := DataSet;

end;

constructor TAbstractDataSetRepository.Create(DataSet: TDataSet;
  RepositoryErrorCreator: TRepositoryErrorCreator);
begin

  inherited Create(RepositoryErrorCreator);

  FDataSet := DataSet;
  
end;

procedure TAbstractDataSetRepository.RefreshDataSet;
begin

  FLastOperation := roSelectAll;
  
  try

    InternalRefreshDataSet;

    ResetLastError;

  except

    on e: Exception do begin

      SetLastErrorFromException(e);
      
    end;

  end;

end;

procedure TAbstractDataSetRepository.InternalRefreshDataSet;
begin

  FDataSet.Close;
  FDataSet.Open;

end;

function TAbstractDataSetRepository.LoadAll: TDomainObjectList;
begin

  raise Exception.Create(
            Format(
                'Not implemented %s.%s',
                [ClassName, 'LoadAll']
            )
        );
  
end;

end.
