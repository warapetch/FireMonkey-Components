(*
unit UWrpFmx.DlgThaiCalendar;
for Multi-Devices , Fire Monkey
Create by Warapetch Ruangpornvisuthi
Create Date :: 19/2/2562
*)
unit UWrpFMX.DlgThaiCalendar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, //System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.Calendar,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox;

type
  TFrmFmxDlgThaiCalendar = class(TForm)
    btnMonth_Next: TButton;
    btnMonth_Prev: TButton;
    btnSetCancel: TButton;
    btnSetOK: TButton;
    btnSetToday: TButton;
    btnYear_Next: TButton;
    btnYear_Prev: TButton;
    edDateSelect: TEdit;
    lbCalendar_MONTH: TLabel;
    lbCalendar_YEAR: TLabel;
    lbDateSelect: TLabel;
    LayoutBGCalendar: TLayout;
    pnBOTCalendar: TPanel;
    pnBOTDateEdit: TPanel;
    pnTOPCalendar: TPanel;
    sgCalendar: TStringGrid;
    stCOL1: TStringColumn;
    stCOL2: TStringColumn;
    stCOL3: TStringColumn;
    stCOL4: TStringColumn;
    stCOL5: TStringColumn;
    stCOL6: TStringColumn;
    stCOL7: TStringColumn;
    pnBGCalendar: TPanel;
    StyleBook1: TStyleBook;

    procedure btnMonth_NextClick(Sender: TObject);
    procedure btnMonth_PrevClick(Sender: TObject);
    procedure btnSetCancelClick(Sender: TObject);
    procedure btnSetOKClick(Sender: TObject);
    procedure btnSetTodayClick(Sender: TObject);
    procedure btnYear_NextClick(Sender: TObject);
    procedure btnYear_PrevClick(Sender: TObject);
    procedure edDateSelectKeyDown(Sender: TObject; var Key: Word;
              var KeyChar: Char; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sgCalendarCellClick(const Column: TColumn; const Row: Integer);
    procedure sgCalendarCellDblClick(const Column: TColumn; const Row: Integer);
    procedure sgCalendarSelectCell(Sender: TObject; const ACol, ARow: Integer;var CanSelect: Boolean);
    procedure edDateSelectExit(Sender: TObject);

  private
    { Private declarations }
    CalendarDAY   ,
    CalendarMONTH ,
    CalendarYEAR : Integer;
    FCalendarDATE: TDate;
    procedure DrawCalendar(Value: TDate);
    procedure SetCalendarDMY(iDay,iMonth,iYear : Integer);
    procedure SetCalendarDate(Value: TDate);
    procedure SearchColRowByDate(ADate: TDate; var Col, Row: Integer);
    function IsToday(iDay: Integer): Boolean;
    function DisplayThaiDate(ADate: TDate): String;
    function CNV_ThaiDateStrToDate(AThaiDateStr: String): TDate;
  public
    { Public declarations }
    property CalendarDATE : TDate read FCalendarDATE write SetCalendarDATE;
  end;

var
  FrmFmxDlgThaiCalendar : TFrmFmxDlgThaiCalendar;

implementation

{$R *.fmx}
uses System.DateUtils;

function TFrmFmxDlgThaiCalendar.DisplayThaiDate(ADate : TDate) : String;
var iYear,iMonth,iDay : Word;
begin
     DecodeDate(ADate,iYear,iMonth,iDay);
     Result := IntToStr(iDay)+'/'+IntToStr(iMonth)+'/'+IntToStr(iYear+543);
end;

function TFrmFmxDlgThaiCalendar.CNV_ThaiDateStrToDate(AThaiDateStr : String) : TDate;
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
     sYear  := IntToStr(StrToInt(sYear)-543);

     Result := StrToDate(sDay+'/'+sMonth+'/'+sYear);
end;

procedure TFrmFmxDlgThaiCalendar.SetCalendarDMY(iDay,iMonth,iYear : Integer);
begin
     CalendarMONTH := iMonth;
     CalendarYEAR  := iYear;
     CalendarDAY   := iDay;
     FCalendarDATE  := EncodeDate(iYear,iMonth,iDay);

     lbCalendar_MONTH.Text := FormatSettings.LongMonthNames[iMonth];
     lbCalendar_YEAR.Text  := IntToStr(iYear+543);

     edDateSelect.Text := DisplayThaiDate(FCalendarDATE);

     DrawCalendar(FCalendarDATE);
end;

procedure TFrmFmxDlgThaiCalendar.SetCalendarDate(Value : TDate);
var iYear,iMonth,iDay : word;
    Col,Row : Integer;
begin
     DecodeDate(Value,iYear,iMonth,iDay);
     CalendarMONTH := iMonth;
     CalendarYEAR  := iYear;
     CalendarDAY   := iDay;
     FCalendarDATE  := Value;

     lbCalendar_MONTH.Text := FormatSettings.LongMonthNames[iMonth];
     lbCalendar_YEAR.Text  := IntToStr(iYear+543);

     edDateSelect.Text := DisplayThaiDate(Value);

     DrawCalendar(Value);

     SearchColRowByDate(Value,Col,Row);

     sgCalendar.SelectCell(Col,Row);
end;

procedure TFrmFmxDlgThaiCalendar.SearchColRowByDate(ADate : TDate;var Col,Row : Integer);
var sDay : String;
    iMonth,iYear ,
    iCol,iRow : Integer;
begin
     Col := 0;
     Row := 0;

     sDay  := FormatDateTime('D',ADate);
    iMonth := StrToInt(FormatDateTime('M',ADate));
    iYear  := StrToInt(FormatDateTime('YYYY',ADate));

    if (iMonth = CalendarMONTH) and (iYear = CalendarYEAR) then
       begin
         for iCol := 0 to 6 do
            begin
               for iRow := 0 to 5 do
                   begin
                      if sgCalendar.Cells[iCol,iRow] = sDay then
                         begin
                            Col := iCol;
                            Row := iRow;
                            Break;
                         end;
                   end;
            end;
       end;
end;

procedure TFrmFmxDlgThaiCalendar.btnMonth_NextClick(Sender: TObject);
begin
     if CalendarMONTH = 12 then
        begin
           CalendarMONTH := 1;
           CalendarYEAR  := CalendarYEAR+1;
        end
     else
     CalendarMONTH := CalendarMONTH+1;

     SetCalendarDMY(CalendarDAY,CalendarMONTH,CalendarYEAR);
end;

procedure TFrmFmxDlgThaiCalendar.btnMonth_PrevClick(Sender: TObject);
begin
     if CalendarMONTH = 12 then
        begin
           CalendarMONTH := 1;
           CalendarYEAR  := CalendarYEAR-1;
        end
     else
     CalendarMONTH := CalendarMONTH-1;

     SetCalendarDMY(CalendarDAY,CalendarMONTH,CalendarYEAR);
end;

procedure TFrmFmxDlgThaiCalendar.btnSetCancelClick(Sender: TObject);
begin
     {$IFDEF MSWINDOWS}
      Close;
     {$ENDIF}

     ModalResult := mrCancel;

     {$IFNDEF MSWINDOWS}
      Close;
     {$ENDIF}
end;

procedure TFrmFmxDlgThaiCalendar.btnSetOKClick(Sender: TObject);
begin
     {$IFDEF MSWINDOWS}
      Close;
     {$ENDIF}

     ModalResult := mrOK;

     {$IFNDEF MSWINDOWS}
      Close;
     {$ENDIF}
end;

procedure TFrmFmxDlgThaiCalendar.btnSetTodayClick(Sender: TObject);
begin
     SetCalendarDate(DATE);
end;

procedure TFrmFmxDlgThaiCalendar.btnYear_NextClick(Sender: TObject);
begin
     CalendarYEAR  := CalendarYEAR+1;
     SetCalendarDMY(CalendarDAY,CalendarMONTH,CalendarYEAR);
end;

procedure TFrmFmxDlgThaiCalendar.btnYear_PrevClick(Sender: TObject);
begin
     CalendarYEAR  := CalendarYEAR-1;
     SetCalendarDMY(CalendarDAY,CalendarMONTH,CalendarYEAR);
end;

procedure TFrmFmxDlgThaiCalendar.DrawCalendar(Value : TDate);
var dFirstOfMonth,dEndOfMonth : TDate;
    iLoop,iDayofWeek,iQtyDays ,Col,Row : integer;
begin
     dFirstOfMonth := StartOfTheMonth(Value);
     iDayofWeek    := DayOfWeek(dFirstOfMonth);

     //Note :: 1-sun,2-Mon,3-Tue,4-Wed,5-Thu,6-Fri,7-Sat
     if iDayofWeek = 1 then
        iDayofWeek := iDayofWeek+7;
     iDayofWeek := iDayofWeek - 2; //Start at Monday and -1 (Index)

     dEndOfMonth   := EndOfTheMonth(Value);
     iQtyDays      := StrToInt(formatDateTime('D',dEndOfMonth));

     //Clear
     for Col := 0 to 6 do
        begin
           for Row := 0 to 5 do
               sgCalendar.Cells[Col,Row] := '';
        end;

     //Draw Calendar
     Col := iDayofWeek;
     Row := 0;
     for iLoop := 1 to iQtyDays do
       begin
          sgCalendar.Cells[Col,Row] := Inttostr(iLoop);

          Col := Col +1 ;
          if Col > 6 then
             begin
                Col := 0;
                Row := Row+1;
             end;
       end;
end;

procedure TFrmFmxDlgThaiCalendar.edDateSelectExit(Sender: TObject);
begin
     SetCalendarDate( CNV_ThaiDateStrToDate(edDateSelect.Text) );
end;

procedure TFrmFmxDlgThaiCalendar.edDateSelectKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
     if not CharInSet(KeyChar,['/', '0'..'9']) then
        begin
           KeyChar := #0;
        end;

     if (Key = 13) and (Length(edDateSelect.Text) >= 8) then
        begin
           SetCalendarDate( CNV_ThaiDateStrToDate(edDateSelect.Text) );

           btnSetOKClick(edDateSelect);
        end;
end;

procedure TFrmFmxDlgThaiCalendar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Action := TCloseAction.caFree;
end;

procedure TFrmFmxDlgThaiCalendar.FormShow(Sender: TObject);
begin
     {$IFDEF ANDROID}
     edDateSelect.Enabled := False;
     {$ENDIF}

     if FCalendarDATE = 0 then
        CalendarDATE := DATE;
end;

function TFrmFmxDlgThaiCalendar.IsToday(iDay : Integer) : Boolean;
begin
     Result := False;
     if (iDay > 0) and (CalendarMONTH > 0) and (CalendarYEAR > 0)  then
        Result := Date = StrToDate(
                         IntToStr(iDay)+'/'+IntToStr(CalendarMONTH)+'/'+IntToStr(CalendarYEAR));
end;

procedure TFrmFmxDlgThaiCalendar.sgCalendarCellClick(const Column: TColumn; const Row: Integer);
begin
     if sgCalendar.Cells[Column.Index,Row] <> '' then
        SetCalendarDMY(StrToInt(sgCalendar.Cells[Column.Index,Row]),
                       CalendarMONTH,CalendarYEAR );
end;

procedure TFrmFmxDlgThaiCalendar.sgCalendarCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
     if sgCalendar.Cells[Column.Index,Row] <> '' then
        begin
           SetCalendarDMY(StrToInt(sgCalendar.Cells[Column.Index,Row]),
                          CalendarMONTH,CalendarYEAR );
           btnSetOKClick(Self);
        end;
end;

procedure TFrmFmxDlgThaiCalendar.sgCalendarSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
     CanSelect := (sgCalendar.Cells[ACol,ARow] <> '');
end;

end.
