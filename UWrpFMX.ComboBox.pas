(*
unit UWrpFmx.ComboBox;
for Multi-Devices , Fire Monkey
Create by Warapetch Ruangpornvisuthi
Create Date :: 6103-29 Win32
Change Date :: 6203-09 Multi-Devices 10.3.1
Ref >> http://docwiki.embarcadero.com/RADStudio/XE8/en/Tutorial:_Creating_LiveBindings-Enabled_Components
*)

unit UWrpFMX.ComboBox;

interface

uses
  System.SysUtils, System.Classes,System.UITypes,
  FMX.Types, FMX.Controls, FMX.ListBox ,
  Data.DB,Data.Bind.Components ,
  Data.Bind.DBScope
  ;

type
  [ObservableMember('Value')]
  TWrpFMXComboBox = class(TComboBox)
  private
    { Private declarations }
    FValues: TStringlist;
    FText : String;
    function GetText : String;
    procedure SetValue(const AValue: String);
    procedure SetValues(const AValue: TStringlist);
    procedure ObserverToggle(const AObserver: IObserver; const Value: Boolean);
    function GetAbout: String;
    function GetFieldData(Dataset: TDataset; FieldName: String): String;
    function GetValue: String;
  protected
    { Protected declarations }
    FValue  : String;

    procedure DoChange;Override;
    procedure DoExit; override;

    { declaration is in System.Classes }
    function CanObserve(const ID: Integer): Boolean; override;
    { declaration is in System.Classes }
    procedure ObserverAdded(const ID: Integer; const Observer: IObserver); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); Override;
    destructor Destroy;Override;
    procedure Loaded;Override;

    // Load Data to Items and Values
    procedure LoadDataFromDB(ALookupDataset: TDataset;AKeyFieldName,AListFieldNames : String;AutoCloseDataset : Boolean = False);
    procedure LoadDataFromFile(AFileName : String);

    property Value : String read GetValue write SetValue;
    property Text  : String read GetText;
  published
    { Published declarations }
    //New
    property About : String read GetAbout;
    property Values : TStringlist read FValues    write SetValues;
  end;

const FAbout : String = 'Warapetch Fmx Components'+#13#10+'By Warapetch Ruangpornvisuthi';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Warapetch-FMX', [TWrpFMXComboBox]);
end;

constructor TWrpFMXComboBox.Create(AOwner: TComponent);
begin
  inherited;

  FValue   := '';
  FValues  := TStringList.Create(True);
end;

destructor TWrpFMXComboBox.Destroy;
begin
  FreeAndNil(FValues);

  inherited;
end;

procedure TWrpFMXComboBox.DoChange;
begin
  inherited;

  // Note :: on User Change
  if (Self.ItemIndex > -1) then
     begin
        FValue := FValues.Strings[Self.ItemIndex];

        TLinkObservers.ControlChanged(Self);
     end;
end;

procedure TWrpFMXComboBox.DoExit;
begin
  inherited;

  FValue := GetValue;

  TLinkObservers.ControlChanged(Self);
end;

function TWrpFMXComboBox.GetAbout: String;
begin
     Result := FAbout;
end;

function TWrpFMXComboBox.GetFieldData(Dataset : TDataset;FieldName : String) : String;
var FieldNameS ,
    FieldName1 ,
    Values  : String;

        function GetData(AFieldName : String) : String;
        begin
           Result := AFieldName;
           if Dataset.FindField(AFieldName) <> NIL then
              Result := Dataset.FieldbyName(AFieldName).asString
        end;

begin
        if POS(';',FieldName) > 0 then
           begin
              FieldNameS := FieldName;
              Repeat
                  if POS(';',FieldNameS) > 0 then
                     begin
                        FieldName1 := Copy(FieldNameS,1,POS(';',FieldNameS)-1);
                                  Delete(FieldNameS,1,POS(';',FieldNameS));
                        if Values = '' then
                           Values := GetData(FieldName1)
                        else
                        Values := Values+GetData(FieldName1);
                     end;

              Until POS(';',FieldNameS) = 0;

              if FieldNameS <> '' then
                 Values := Values+GetData(FieldNameS);
           end
        else
        Values := GetData(FieldName);

        Result := Values;
end;

procedure TWrpFMXComboBox.LoadDataFromDB(ALookupDataset: TDataset; AKeyFieldName,
  AListFieldNames: String;AutoCloseDataset : Boolean = False);
//Note Format :: Field-Code,Field-Name  [Option FieldName2+ >> +';']
//EQ : LoadDataFromDB(BindSourceDB1,'PROD_CODE','PROD_DESC')
//EQ : LoadDataFromDB(BindSourceDB1,'PROD_CODE','PROD_DESC; ;PROD_CODE;')
//Items = List of PROD_CODE
//Value = List of PROD_DESC               >> StillWater
//Value = List of PROD_DESC+" "+PROD_CODE >> StillWater WATER01
var DescValues : String;
begin
        Self.Items.BeginUpdate;
        Self.Items.Clear;
        Self.Values.Clear;

        ALookupDataset.First;
        While NOT ALookupDataset.Eof do
           begin                                         //FieldName1; ;FieldName2
              DescValues := GetFieldData(ALookupDataset,AListFieldNames);

              Self.Items.Add(DescValues);
              Self.Values.Add(ALookupDataset.FieldbyName(AKeyFieldName).asString);

              ALookupDataset.Next;
           end;

        Self.Items.EndUpdate;

        //Close Dataset !!
        if AutoCloseDataset then
           ALookupDataset.Close;
end;

procedure TWrpFMXComboBox.LoadDataFromFile(AFileName: String);
//Note Format :: Item=Display
var tmpSTL : TStringList;
    I: Integer;
    sItem,sDesc : String;

    function GetStringValue(AValue : String; var AItem,ADesc : String) : Boolean;
    //Note Format :: Item=Display
    begin
       AItem := '';
       ADesc := '';
       Result := False;
       if Trim(AValue) = '' then Exit;

       AItem := Trim(Copy(AValue,1,POS(';',AValue)-1));
       ADesc := Trim(Copy(AValue,POS(';',AValue)+1,255));
    end;

begin
     if FileExists(AFileName) then
        begin
           tmpSTL := TStringList.Create;
           tmpSTL.LoadFromFile(AFileName,TEncoding.UTF8);

           Self.Items.BeginUpdate;
           Self.Items.Clear;
           Self.Values.Clear;

           for I := 0 to tmpSTL.Count-1 do
              begin
                 if GetStringValue(tmpSTL[I],sItem,sDesc) then
                    begin
                       Self.Items.Add(sItem);
                       Self.Values.Add(sDesc);
                    end;
              end;

           Self.EndUpdate;
           FreeAndNil(tmpSTL);
        end;
end;

procedure TWrpFMXComboBox.Loaded;
begin
  inherited;

  // Initialize //
  if (FValue = '') and (ItemIndex > -1) then
      begin
         FValue := Self.Values[ItemIndex]
      end;
end;

function TWrpFMXComboBox.GetText: String;
var Index : Integer;
begin
     Index := FValues.IndexOf(FValue);

     Result := Self.Items[Index];
end;

function TWrpFMXComboBox.GetValue: String;
begin
     if ItemIndex = -1 then
        Result := ''
     else
     Result := Self.Values[ItemIndex];
end;

function TWrpFMXComboBox.CanObserve(const ID: Integer): Boolean;
begin
   case ID of
    { EditLinkID is the observer that is used for control-to-field links }
    TObserverMapping.EditLinkID     ,
    TObserverMapping.ControlValueID :
      Result := True;
  else
    Result := False;
  end;
end;

procedure TWrpFMXComboBox.ObserverAdded(const ID: Integer;
  const Observer: IObserver);
begin
   if ID = TObserverMapping.EditLinkID then
      Observer.OnObserverToggle := ObserverToggle;
end;

procedure TWrpFMXComboBox.ObserverToggle(const AObserver: IObserver;
  const Value: Boolean);
var LEditLinkObserver: IEditLinkObserver;
begin
//follow by Enabled as Developer set !!
   if Value then
      begin
         if Supports(AObserver, IEditLinkObserver, LEditLinkObserver) then
            Enabled := not(LEditLinkObserver.IsReadOnly) and LEditLinkObserver.IsEditing;
      end
   //else
   //Enabled := True;
end;

procedure TWrpFMXComboBox.SetValue(const AValue: String);
begin
     //All Change ,Include empty
     FValue := AValue;

     //Set ItemIndex
     ItemIndex := Values.IndexOf(Fvalue);
     TLinkObservers.ControlChanged(Self);
end;

procedure TWrpFMXComboBox.SetValues(const AValue: TStringlist);
begin
  FValues.Assign(AValue);
end;

initialization
  RegisterObservableMember(TArray<TClass>.Create(TWrpFMXComboBox), 'Value', 'DFM');
finalization
  UnregisterObservableMember(TArray<TClass>.Create(TWrpFMXComboBox));

end.
