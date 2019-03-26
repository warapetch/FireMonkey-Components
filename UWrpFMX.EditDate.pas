(*
unit UWrpFMX.EditDate;
for Multi-Devices , Fire Monkey
Create by Warapetch Ruangpornvisuthi
Create Date :: 6203-09 Multi-Devices 10.3.1
Ref >> http://docwiki.embarcadero.com/RADStudio/XE8/en/Tutorial:_Creating_LiveBindings-Enabled_Components
*)

unit UWrpFMX.EditDate;

interface

uses
  System.SysUtils, System.Classes,System.UITypes,
  System.Variants,FMX.Types,FMX.Edit,
  Data.DB,Data.Bind.Components ,
  Data.Bind.DBScope
  ;

type
  TWrpBeforePopupCalendarEvent = procedure (Sender : TObject;CalendarDate : TDate;var AllowPopup : Boolean) of Object;
  TWrpCloseUpCalendarEvent = procedure (ModalResult : TModalResult;SelectedDate : TDate) of Object;
  TWrpCalendarStyle        = (ctMobileStyle,ctWindowStyle);

  [ObservableMember('Value')]
  TWrpFMXEditDate = class(TEdit)
  private
    { Private declarations }
    FOnCloseUpCalendar: TWrpCloseUpCalendarEvent;
    FCalendarStyle: TWrpCalendarStyle;
    FOnBeforePopUpCalendar: TWrpBeforePopupCalendarEvent;
    FAutoPopupCalendar: Boolean;
    FDisplayFormat: String;
    FYearPlus: Integer;
    FCanEditText: Boolean;

    procedure ObserverToggle(const AObserver: IObserver; const Value: Boolean);
    procedure SetValue(const AValue: TDate);
    function GetAbout: String;
    function GetShowThaiDate(ADate: TDate): String;
    procedure DoOnDateEditClick(Sender: TObject);
    procedure SetCalendarStyle(const Value: TWrpCalendarStyle);
    procedure SetAutoPopupCalendar(const Value: Boolean);
    procedure SetDisplayFormat(const Value: String);
    procedure SetYearPlus(const Value: Integer);
    procedure SetCanEditText(const Value: Boolean);
    function CNV_TextThaiDateToDate(AThaiDateStr: String): TDate;

  protected
    { Protected declarations }
    FValue  : TDate;
    FEditOnClick   : TNotifyEvent;

    procedure DoExit;Override;

    { declaration is in System.Classes }
    function CanObserve(const ID: Integer): Boolean; override;
    { declaration is in System.Classes }
    procedure ObserverAdded(const ID: Integer; const Observer: IObserver); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); Override;
    destructor Destroy;Override;

    procedure PopupCalendar;
    procedure PopupCalendar_MobileStyle;
    procedure PopupCalendar_WindowStyle;

    property Value : TDate read FValue write SetValue;
  published
    { Published declarations }
    //New
    property About : String read GetAbout;
    property AutoPopupCalendar : Boolean read FAutoPopupCalendar write SetAutoPopupCalendar default True;
    property YearPlus : Integer  read FYearPlus write SetYearPlus default 543;
    property DisplayFormat : String read FDisplayFormat write SetDisplayFormat;
    property CalendarStyle : TWrpCalendarStyle read FCalendarStyle write SetCalendarStyle default TWrpCalendarStyle.ctMobileStyle;
    property CanEditText   : Boolean read FCanEditText write SetCanEditText default True;

    property OnBeforePopUpCalendar : TWrpBeforePopupCalendarEvent read FOnBeforePopUpCalendar write FOnBeforePopUpCalendar;
    property OnCloseUpCalendar : TWrpCloseUpCalendarEvent read FOnCloseUpCalendar write FOnCloseUpCalendar;

  end;

const FAbout : String = 'Warapetch Fmx Components'+#13#10+'By Warapetch Ruangpornvisuthi';

procedure Register;

implementation

uses UWrpFmx.DlgThaiCalendar ,  //Dialog Thai-Calendar
     UWrpFmx.DlgThaiDateEntry;  //Dialog Thai-Date-Entry

procedure Register;
begin
  RegisterComponents('Warapetch-FMX', [TWrpFMXEditDate]);
end;

constructor TWrpFMXEditDate.Create(AOwner: TComponent);
begin
  inherited;

  FValue  := 0;
  FYearPlus := 543; //Thai Year
  FDisplayFormat := 'dd/mm/yyyy';
  FAutoPopupCalendar := True;
  FCanEditText       := True;

  FEditOnClick := OnClick;       // Keep Original OnClick
  OnClick := DoOnDateEditClick; // Block Onclick Only Popup Calendar
end;

destructor TWrpFMXEditDate.Destroy;
begin
  inherited;
end;

procedure TWrpFMXEditDate.DoOnDateEditClick(Sender : TObject);
begin
     if FAutoPopupCalendar then
        PopupCalendar
     else
     begin
        if Assigned(FEditOnClick) then
           FEditOnClick(Self);
     end;
end;

procedure TWrpFMXEditDate.DoExit;
begin
  //Direct Edit Text
  if (FCanEditText) and (POS('/',Text) > 0) then
     begin
        Fvalue := CNV_TextThaiDateToDate(Text);
     end;

  inherited;

  Fvalue := Self.Value;
  TLinkObservers.ControlChanged(Self);
end;

function TWrpFMXEditDate.CNV_TextThaiDateToDate(AThaiDateStr : String) : TDate;
var sText,sDay,sMonth,sYear : String;
begin
     sText := AThaiDateStr;
     if (sText = '') then
        begin
           Result := 0;
           Exit;
        end;

     sDay  := Copy(sText,1,POS('/',sText)-1);
        Delete(sText,1,POS('/',sText));
     sMonth  := Copy(sText,1,POS('/',sText)-1);
        Delete(sText,1,POS('/',sText));
     sYear  := Trim(sText);
     sYear  := IntToStr(StrToInt(sYear)-FYearPlus);

     Try
        Result := StrToDate(sDay+'/'+sMonth+'/'+sYear);
     Except
        Result := 0;
     End;
end;

function TWrpFMXEditDate.GetAbout: String;
begin
     Result := FAbout;
end;

function TWrpFMXEditDate.GetShowThaiDate(ADate : TDate) : String;
var iYear,iMonth,iDay : Word;
    sDisplay : String;

    function GetDayMonthStr(AValue : String) : String;
    var sDay,sMonth : String;
    begin
        sDay := Copy(AValue,1,POS('/',Avalue)-1);
           Delete(AValue,1,POS('/',Avalue));
        sMonth := Copy(AValue,1,POS('/',Avalue)-1);

        Result := sDay+'/'+sMonth+'/';
    end;

begin
     DecodeDate(ADate,iYear,iMonth,iDay);
     sDisplay := FormatDateTime(FDisplayFormat,ADate);

     if ADate = 0 then
        Result := ''
     else
     begin
        if POS('/',sDisplay) > 0 then
           begin
              Result := GetDayMonthStr(sDisplay)+IntToStr(iYear+FYearPlus);
           end
        else
        Result := Copy(sDisplay,1,Length(sDisplay)-4)+IntToStr(iYear+FYearPlus);
     end;
end;

function TWrpFMXEditDate.CanObserve(const ID: Integer): Boolean;
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

procedure TWrpFMXEditDate.ObserverAdded(const ID: Integer;
  const Observer: IObserver);
begin
   if ID = TObserverMapping.EditLinkID then
      Observer.OnObserverToggle := ObserverToggle;
end;

procedure TWrpFMXEditDate.ObserverToggle(const AObserver: IObserver;
  const Value: Boolean);
var LEditLinkObserver: IEditLinkObserver;
begin
//follow by Enabled as Developer set !!
   if Value then
      begin
         if Supports(AObserver, IEditLinkObserver, LEditLinkObserver) then
            Enabled := not(LEditLinkObserver.IsReadOnly) and LEditLinkObserver.IsEditing;
      end
   else
   Enabled := True;
end;

procedure TWrpFMXEditDate.PopupCalendar;
begin
     if FCalendarStyle = ctWindowStyle then
        PopupCalendar_WindowStyle
     else
     PopupCalendar_MobileStyle;
end;

procedure TWrpFMXEditDate.PopupCalendar_MobileStyle;
var bAllowPopup : Boolean;
begin
     bAllowPopup := True;

     // Event
     if Assigned(FOnBeforePopUpCalendar) then
        FOnBeforePopUpCalendar(Self,Self.Value,bAllowPopup);

     if bAllowPopup = False then Exit;

     FrmFmxDlgThaiDateEntry := TFrmFmxDlgThaiDateEntry.Create(NIL);
     FrmFmxDlgThaiDateEntry.CalendarDATE := Self.Value;
     if FrmFmxDlgThaiDateEntry.CalendarDATE = 0 then
        FrmFmxDlgThaiDateEntry.CalendarDATE := DATE;
     FrmFmxDlgThaiDateEntry.ShowModal(
           procedure (AResult : TModalResult) //uses System.UITypes
           begin
              if AResult = mrOK then
                 begin
                    Self.Value := FrmFmxDlgThaiDateEntry.CalendarDATE;
                    Self.Setfocus;
                 end;

              // CallBack
              if Assigned(FOnCloseUpCalendar) then
                 FOnCloseUpCalendar(AResult,Self.Value);

              FrmFmxDlgThaiDateEntry := NIL;

              {$IFDEF MSWINDOWS}
                 //FrmFmxDlgThaiDateEntry := NIL;
              {$ELSE}
                 //FrmFmxDlgThaiDateEntry.DisposeOf;
              {$ENDIF}
           end
           );
end;

procedure TWrpFMXEditDate.PopupCalendar_WindowStyle;
var bAllowPopup : Boolean;
begin
     bAllowPopup := True;
     // Event
     if Assigned(FOnBeforePopUpCalendar) then
        FOnBeforePopUpCalendar(Self,Self.Value,bAllowPopup);

     if bAllowPopup = False then Exit;

     FrmFmxDlgThaiCalendar := TFrmFmxDlgThaiCalendar.Create(NIL);
     FrmFmxDlgThaiCalendar.CalendarDATE := Self.Value;
     if FrmFmxDlgThaiCalendar.CalendarDATE = 0 then
        FrmFmxDlgThaiCalendar.CalendarDATE := DATE;
     FrmFmxDlgThaiCalendar.ShowModal(
           procedure (AResult : TModalResult) //uses System.UITypes
           begin
              if AResult = mrOK then
                 begin
                    Self.Value := FrmFmxDlgThaiCalendar.CalendarDATE;
                    Self.Setfocus;
                 end;

              // CallBack
              if Assigned(FOnCloseUpCalendar) then
                 FOnCloseUpCalendar(AResult,Self.Value);

              FrmFmxDlgThaiCalendar := NIL;

              {$IFDEF MSWINDOWS}
                 //FrmFmxDlgThaiCalendar := NIL;
              {$ELSE}
                 //FrmFmxDlgThaiCalendar.DisposeOf;
              {$ENDIF}
           end
           );
end;

procedure TWrpFMXEditDate.SetAutoPopupCalendar(const Value: Boolean);
begin
  FAutoPopupCalendar := Value;
end;

procedure TWrpFMXEditDate.SetCalendarStyle(const Value: TWrpCalendarStyle);
begin
  FCalendarStyle := Value;
end;

procedure TWrpFMXEditDate.SetCanEditText(const Value: Boolean);
begin
  FCanEditText := Value;
end;

procedure TWrpFMXEditDate.SetDisplayFormat(const Value: String);
begin
   FDisplayFormat := Value;

   //Change Display
   Text := GetShowThaiDate(FValue);
end;

procedure TWrpFMXEditDate.SetValue(const AValue: TDate);
begin
     FValue := AValue;

     //Set Text ,Trigger Change
     Text := GetShowThaiDate(FValue);

     TLinkObservers.ControlChanged(Self);
end;

procedure TWrpFMXEditDate.SetYearPlus(const Value: Integer);
begin
  FYearPlus := Value;
end;

initialization
  RegisterObservableMember(TArray<TClass>.Create(TWrpFMXEditDate), 'Value', 'DFM');
finalization
  UnregisterObservableMember(TArray<TClass>.Create(TWrpFMXEditDate));

end.
