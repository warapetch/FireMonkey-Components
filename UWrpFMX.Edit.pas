(*
unit UWrpFMX.Edit;
for Multi-Devices , Fire Monkey
Create by Warapetch Ruangpornvisuthi
Create Date :: 6203-09 Multi-Devices 10.3.1
Ref >> http://docwiki.embarcadero.com/RADStudio/XE8/en/Tutorial:_Creating_LiveBindings-Enabled_Components
*)

unit UWrpFMX.Edit;

interface

uses
  System.SysUtils, System.Classes,System.UITypes,
  System.Variants,FMX.Types,FMX.Edit,
  Data.DB,Data.Bind.Components ,
  Data.Bind.DBScope
  ;

type
  TWrpValueType = (vtText,vtInteger,vtFloat,vtDate);

  [ObservableMember('Value')]
  TWrpFMXEdit = class(TEdit)
  private
    { Private declarations }
    FValueType: TWrpValueType;

    procedure ObserverToggle(const AObserver: IObserver; const Value: Boolean);
    procedure SetValueType(const AValue: TWrpValueType);
    procedure SetValue(const AValue: Variant);

    function Var2Text(AValue: Variant): String;
    function Str2Date(AValue: String): TDate;
    function Str2Float(AValue: String): Double;
    function Str2Int(AValue: String): Integer;
    function GetAbout: String;

  protected
    { Protected declarations }
    FValue  : Variant;

    function GetValue : Variant;
    //function GetVariantType(AValue : Variant) : Integer;
    procedure DoExit;Override;

    { declaration is in System.Classes }
    function CanObserve(const ID: Integer): Boolean; override;
    { declaration is in System.Classes }
    procedure ObserverAdded(const ID: Integer; const Observer: IObserver); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); Override;
    destructor Destroy;Override;

    function AsDate    : TDate;
    function AsInteger : Integer;
    function AsFloat   : Double;

    property Value : Variant read GetValue write SetValue;
  published
    { Published declarations }
    //New
    property About : String read GetAbout;
    property ValueType : TWrpValueType read FValueType write SetValueType;
  end;

const FAbout : String = 'Warapetch Fmx Components'+#13#10+'By Warapetch Ruangpornvisuthi';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Warapetch-FMX', [TWrpFMXEdit]);
end;

constructor TWrpFMXEdit.Create(AOwner: TComponent);
begin
  inherited;

  FValue   := '';
end;

destructor TWrpFMXEdit.Destroy;
begin
  inherited;
end;

procedure TWrpFMXEdit.DoExit;
begin
  inherited;

//  Fvalue := GetValue;

  TLinkObservers.ControlChanged(Self);
end;

function TWrpFMXEdit.GetAbout: String;
begin
     Result := FAbout;
end;

function TWrpFMXEdit.Str2Date(AValue : String) : TDate;
begin
   if AValue = '' then
      Result := 0
   else
   Result := StrToDate(AValue);
end;

function TWrpFMXEdit.Str2Int(AValue : String) : Integer;
begin
      if AValue = '' then
         Result := 0
      else
      begin
         AValue  := StringReplace(AValue,',','',[rfReplaceAll]);
         Result := StrToInt(AValue);
      end;
end;

function TWrpFMXEdit.Str2Float(AValue : String) : Double;
begin
      if AValue = '' then
         Result := 0
      else
      begin
         AValue := StringReplace(AValue,',','',[rfReplaceAll]);
         Result := StrToFloat(AValue);
      end;
end;

function TWrpFMXEdit.Var2Text(AValue : Variant) : String;
begin
     Result := AValue;
end;

{function TWrpFMXEdit.GetVariantType(AValue : Variant) : Integer;
var typeString : String;
begin
     Result := VarType(AValue) and VarTypeMask;

    case Result of
    varEmpty     : typeString := 'varEmpty';     //0
    varNull      : typeString := 'varNull';      //1
    varSmallInt  : typeString := 'varSmallInt';  //2
    varInteger   : typeString := 'varInteger';   //3
    varSingle    : typeString := 'varSingle';    //4
    varDouble    : typeString := 'varDouble';    //5 // asDATE
    varCurrency  : typeString := 'varCurrency';  //6
    varDate      : typeString := 'varDate';      //7
    varOleStr    : typeString := 'varOleStr';    //8
    varDispatch  : typeString := 'varDispatch';  //9
    varError     : typeString := 'varError';     //10
    varBoolean   : typeString := 'varBoolean';   //11
    varVariant   : typeString := 'varVariant';   //12
    varUnknown   : typeString := 'varUnknown';   //13
    varByte      : typeString := 'varByte';      //17
    varWord      : typeString := 'varWord';      //18
    varLongWord  : typeString := 'varLongWord';  //19
    varInt64     : typeString := 'varInt64';     //20
    varStrArg    : typeString := 'varStrArg';    //72
    varString    : typeString := 'varString';    //256,258
    varAny       : typeString := 'varAny';       //257
    varTypeMask  : typeString := 'varTypeMask';  //4095
  end;

end;}

function TWrpFMXEdit.GetValue : Variant;
begin
   Result := StringReplace(Text,',','',[rfReplaceAll]); //Remove ","
   case FValueType of
      vtText    : Result := Text;
      vtInteger : Result := Str2Int(Text);
      vtFloat   : Result := Str2Float(Text);
      vtDate    : Result := Str2Date(Text);
   end;
end;

function TWrpFMXEdit.AsDate: TDate;
begin
     if Text = '' then
     Result := 0
     else
     Result := Str2Date(Text);
end;

function TWrpFMXEdit.AsFloat: Double;
begin
     Result := Str2Float(Text);
end;

function TWrpFMXEdit.AsInteger: Integer;
begin
     Result := Str2Int(Text);
end;

function TWrpFMXEdit.CanObserve(const ID: Integer): Boolean;
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

procedure TWrpFMXEdit.ObserverAdded(const ID: Integer;
  const Observer: IObserver);
begin
   if ID = TObserverMapping.EditLinkID then
      Observer.OnObserverToggle := ObserverToggle;
end;

procedure TWrpFMXEdit.ObserverToggle(const AObserver: IObserver;
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

procedure TWrpFMXEdit.SetValue(const AValue: Variant);
begin
     // Value is DATE
   {  if (GetVariantType(AValue) = varDate)  or
        (
        (GetVariantType(AValue) = varDouble) or  //Double as Date
        (FValueType = vtDate)  //set ValueType as Date
        ) then
        FValue := AValue
     else  }
     FValue := AValue;
     //---------------------------------------

     //Set Text ,Trigger Change
     Text := Var2Text(FValue);

     TLinkObservers.ControlChanged(Self);
end;

procedure TWrpFMXEdit.SetValueType(const AValue: TWrpValueType);
begin
   FValueType := AValue;

   // Lock Entry Data
   //---------------------------------------
   case FValueType of
     vtText    : begin
                    FilterChar := '';
                    KeyboardType := TVirtualkeyboardType.Default;
                 end;
     vtInteger : begin
                    FilterChar := '0123456789,';
                    KeyboardType := TVirtualkeyboardType.NumberPad;
                 end;
     vtFloat   : begin
                    FilterChar := '0123456789,.';
                    KeyboardType := TVirtualkeyboardType.NumberPad;
                 end;
     vtDate    : begin
                    MaxLength  := 10;
                    FilterChar := '0123456789/';
                    KeyboardType := TVirtualkeyboardType.NumberPad;
                 end;
   end;
end;

initialization
  RegisterObservableMember(TArray<TClass>.Create(TWrpFMXEdit), 'Value', 'DFM');
finalization
  UnregisterObservableMember(TArray<TClass>.Create(TWrpFMXEdit));

end.
