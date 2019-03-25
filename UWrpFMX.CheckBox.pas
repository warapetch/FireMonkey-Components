(*
unit UWrpFmx.CheckBox;
for Multi-Devices , Fire Monkey
Create by Warapetch Ruangpornvisuthi
Create Date :: 6103-29 Win32
Change Date :: 6203-09 Multi-Devices 10.3.1
Ref >> http://docwiki.embarcadero.com/RADStudio/XE8/en/Tutorial:_Creating_LiveBindings-Enabled_Components
*)

unit UWrpFMX.CheckBox;

interface

uses
  System.SysUtils, System.Classes,System.UITypes,
  FMX.StdCtrls,System.Rtti,
  Data.DB,Data.Bind.Components ,
  Data.Bind.DBScope
  ;

type
  [ObservableMember('Value')]
  TWrpFMXCheckBox = class(TCheckBox)
  private
    { Private declarations }
    FIsFalseValue: String;
    FIsTrueValue: String;
    FOnChangeCurrent : TNotifyEvent;

    procedure ObserverToggle(const AObserver: IObserver; const Value: Boolean);
    procedure SetIsFalseValue(const Value: String);
    procedure SetIsTrueValue(const Value: String);
    procedure SetValue(const AValue: String);

    function GetAbout: String;
    function GetValue: String;

  protected
    { Protected declarations }
    FValue  : String;

    procedure DoOnChange(Sender : TObject);
    procedure DoExit;Override;

    { declaration is in System.Classes }
    function CanObserve(const ID: Integer): Boolean; override;
    { declaration is in System.Classes }
    procedure ObserverAdded(const ID: Integer; const Observer: IObserver); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); Override;
    destructor Destroy;Override;
    procedure Loaded;Override;

    property Value : String read GetValue write SetValue;
  published
    { Published declarations }
    //New
    property About : String read GetAbout;
    property IsTrueValue  : String read FIsTrueValue  write SetIsTrueValue  ;
    property IsFalseValue : String read FIsFalseValue write SetIsFalseValue ;
  end;

const FAbout : String = 'Warapetch Fmx Components'+#13#10+'By Warapetch Ruangpornvisuthi';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Warapetch-FMX', [TWrpFMXCheckBox]);
end;

constructor TWrpFMXCheckBox.Create(AOwner: TComponent);
begin
  inherited;

  FValue        := '';
  FIsTrueValue  := 'Y';
  FIsFalseValue := 'N';
end;

destructor TWrpFMXCheckBox.Destroy;
begin
  inherited;
end;

procedure TWrpFMXCheckBox.DoExit;
begin
  inherited;

  FValue := GetValue;

  //Update Data
  TLinkObservers.ControlChanged(Self);
end;

procedure TWrpFMXCheckBox.DoOnChange(Sender: TObject);
begin
   //This Event set By user Click ,or OnDataChange
   //GetData from IsChecked
   if IsChecked then
      FValue := FIsTrueValue
   else
   FValue := FIsFalseValue;

   //Update Data
   TLinkObservers.ControlChanged(Self);

  // Event OnChange if Developer Assign
  if Assigned(FOnChangeCurrent) then
     FOnChangeCurrent(Sender)
end;

function TWrpFMXCheckBox.GetAbout: String;
begin
     Result := FAbout;
end;

function TWrpFMXCheckBox.GetValue: String;
begin
   if IsChecked then
      Result := FIsTrueValue
   else
   Result := FIsFalseValue;

   FValue := Result;
end;

procedure TWrpFMXCheckBox.Loaded;
begin
  inherited;

  //Get OnChange if Developer Assign
  if Assigned(OnChange) then
     FOnChangeCurrent := OnChange;

  //Replace
  OnChange := DoOnChange;
end;

function TWrpFMXCheckBox.CanObserve(const ID: Integer): Boolean;
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

procedure TWrpFMXCheckBox.ObserverAdded(const ID: Integer;
  const Observer: IObserver);
begin
   if ID = TObserverMapping.EditLinkID then
      Observer.OnObserverToggle := ObserverToggle;
end;

procedure TWrpFMXCheckBox.ObserverToggle(const AObserver: IObserver;
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

procedure TWrpFMXCheckBox.SetIsFalseValue(const Value: String);
begin
  FIsFalseValue := Value;
end;

procedure TWrpFMXCheckBox.SetIsTrueValue(const Value: String);
begin
  FIsTrueValue := Value;
end;

procedure TWrpFMXCheckBox.SetValue(const AValue: String);
begin
   //This Event set by OnDataChange First Time Only !! (FValue == '')
  // if (FValue <> AValue) then
  //    begin
         //Set Value
         FValue := AValue;

         //Trigger OnChange
         IsChecked := (LowerCase(FValue) = LowerCase(FIsTrueValue));
  //    end;
end;

initialization
  RegisterObservableMember(TArray<TClass>.Create(TWrpFMXCheckBox), 'Value', 'DFM');
finalization
  UnregisterObservableMember(TArray<TClass>.Create(TWrpFMXCheckBox));

end.
