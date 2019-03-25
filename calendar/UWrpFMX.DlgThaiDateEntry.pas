(*
unit UWrpFmx.DlgThaiDateEntry;
for Multi-Devices , Fire Monkey
Create by Warapetch Ruangpornvisuthi
Create Date :: 19/2/2562
*)
unit UWrpFMX.DlgThaiDateEntry;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, //System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.Calendar,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.TabControl;

type
  TFrmFmxDlgThaiDateEntry = class(TForm)
    btnSetCancel: TButton;
    btnSetOK: TButton;
    btnSetToday: TButton;
    edDay: TEdit;
    edMonth: TEdit;
    edSelect_Year: TEdit;
    edYear: TEdit;
    LayoutBGCalendar: TLayout;
    lbCapYear: TLabel;
    pnBGCalendar: TPanel;
    pnBOTCalendar: TPanel;
    pnTOPDateEdit: TPanel;
    scColumnM1: TStringColumn;
    scColumnM2: TStringColumn;
    sgCalendar_Days: TStringGrid;
    sgCalendar_Months: TStringGrid;
    stCOL1: TStringColumn;
    stCOL2: TStringColumn;
    stCOL3: TStringColumn;
    stCOL4: TStringColumn;
    stCOL5: TStringColumn;
    stCOL6: TStringColumn;
    stCOL7: TStringColumn;
    StyleBook1: TStyleBook;
    TabControlMain: TTabControl;
    TabItemDays: TTabItem;
    TabItemMonths: TTabItem;
    TabItemYear: TTabItem;

    procedure btnSetCancelClick(Sender: TObject);
    procedure btnSetOKClick(Sender: TObject);
    procedure btnSetTodayClick(Sender: TObject);
    procedure edDayClick(Sender: TObject);
    procedure edMonthClick(Sender: TObject);
    procedure edSelect_YearChange(Sender: TObject);
    procedure edSelect_YearExit(Sender: TObject);
    procedure edYearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sgCalendar_DaysCellClick(const Column: TColumn; const Row: Integer);
    procedure sgCalendar_DaysSelectCell(Sender: TObject; const ACol,ARow: Integer; var CanSelect: Boolean);
    procedure sgCalendar_MonthsCellClick(const Column: TColumn;const Row: Integer);

  private
    { Private declarations }
    FCalendarDATE: TDate;
    procedure DisplayDateinControl(ADate: TDate);
    procedure DrawCalendar_Days;
    procedure DrawCalendar_Months;
    procedure SearchColRowByDay(ADay: String; var Col, Row: Integer);
    procedure SearchColRowByMonth(AMonthName : String; var Col, Row: Integer);
    procedure SetCalendarDate(const Value: TDate);

    function GetThaiDate(ADate: TDate): String;Overload;
    function SearchMonthByColRow(Col,Row : Integer) : Integer;

  public
    { Public declarations }
    function GetThaiDate : String; Overload;
    property CalendarDATE : TDate read FCalendarDATE write SetCalendarDATE;
  end;

var
  FrmFmxDlgThaiDateEntry : TFrmFmxDlgThaiDateEntry;

implementation

{$R *.fmx}
uses System.DateUtils;

function TFrmFmxDlgThaiDateEntry.GetThaiDate(ADate : TDate) : String;
var iYear,iMonth,iDay : Word;
begin
     DecodeDate(ADate,iYear,iMonth,iDay);
     if ADate = 0 then
        Result := ''
     else
     Result := IntToStr(iDay)+'/'+IntToStr(iMonth)+'/'+IntToStr(iYear+543);
end;

function TFrmFmxDlgThaiDateEntry.GetThaiDate : String;
begin
     Result := GetThaiDate(FCalendarDATE);
end;

procedure TFrmFmxDlgThaiDateEntry.DisplayDateinControl(ADate : TDate);
var iYear,iMonth,iDay : Word;
    Col,Row : Integer;
begin
     DecodeDate(ADate,iYear,iMonth,iDay);

     edDay.Text   := IntToStr(iDay);
     edMonth.Text := FormatSettings.LongMonthNames[iMonth] ;
     edMonth.Tag  := iMonth;
     edYear.Text  := IntToStr(iYear+543);

     //Highlight Day
     SearchColRowByDay(edDay.Text,Col,Row);
     sgCalendar_Days.SelectCell(Col,Row);
     //Highlight Month
     SearchColRowByMonth(edMonth.Text,Col,Row);
     sgCalendar_Months.SelectCell(Col,Row);
end;

procedure TFrmFmxDlgThaiDateEntry.btnSetCancelClick(Sender: TObject);
begin
     {$IFDEF MSWINDOWS}
      Close;
     {$ENDIF}

     ModalResult := mrCancel;

     {$IFNDEF MSWINDOWS}
      Close;
     {$ENDIF}
end;

procedure TFrmFmxDlgThaiDateEntry.btnSetOKClick(Sender: TObject);
begin
     FCalendarDate := StrToDate( edDay.Text+'/'+IntToStr(edMonth.Tag)+'/'+IntToStr(StrToInt(edYear.Text)-543) );

     {$IFDEF MSWINDOWS}
      Close;
     {$ENDIF}

     ModalResult := mrOK;

     {$IFNDEF MSWINDOWS}
      Close;
     {$ENDIF}
end;

procedure TFrmFmxDlgThaiDateEntry.btnSetTodayClick(Sender: TObject);
begin
     FCalendarDATE := DATE;
     edSelect_Year.Text := IntToStr(StrToInt(FormatDateTime('YYYY',DATE))+543);

     DisplayDateinControl(FCalendarDATE);
end;

procedure TFrmFmxDlgThaiDateEntry.edDayClick(Sender: TObject);
var Col,Row : Integer;
begin
     TabControlMain.TabIndex := 0;
     TabControlMain.Visible := True;
     sgCalendar_Days.SetFocus;

     SearchColRowByDay(edDay.Text,Col,Row);
     sgCalendar_Days.SelectCell(Col,Row);
end;

procedure TFrmFmxDlgThaiDateEntry.edMonthClick(Sender: TObject);
var Col,Row : Integer;
begin
     TabControlMain.TabIndex := 1;
     TabControlMain.Visible := True;
     sgCalendar_Days.SetFocus;

     //Highlight Month
     SearchColRowByMonth(edMonth.Text,Col,Row);
     sgCalendar_Months.SelectCell(Col,Row);
end;

procedure TFrmFmxDlgThaiDateEntry.edSelect_YearChange(Sender: TObject);
begin
     edYear.Text := edSelect_Year.Text;
end;

procedure TFrmFmxDlgThaiDateEntry.edSelect_YearExit(Sender: TObject);
begin
     edYear.Text := edSelect_Year.Text;
end;

procedure TFrmFmxDlgThaiDateEntry.edYearClick(Sender: TObject);
begin
     TabControlMain.TabIndex := 2;
     TabControlMain.Visible := True;
     edSelect_Year.Text := edYear.Text;
     edSelect_Year.SetFocus;
end;

procedure TFrmFmxDlgThaiDateEntry.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Action := TCloseAction.caFree;
end;

procedure TFrmFmxDlgThaiDateEntry.DrawCalendar_Days;
var iLoop,Col,Row : Integer;
begin
     //Clear
     for Col := 0 to 6 do
        begin
           for Row := 0 to 4 do
               sgCalendar_Days.Cells[Col,Row] := '';
        end;

     //Draw Calendar
     Col := 0;
     Row := 0;
     for iLoop := 1 to 31 do
       begin
          sgCalendar_Days.Cells[Col,Row] := Inttostr(iLoop);

          Col := Col +1 ;
          if Col > 6 then
             begin
                Col := 0;
                Row := Row+1;
             end;
       end;
end;

procedure TFrmFmxDlgThaiDateEntry.SearchColRowByDay(ADay: String;var Col,Row : Integer);
var iCol,iRow : Integer;
begin
     Col := 0;
     Row := 0;

     for iCol := 0 to 6 do
         begin
            for iRow := 0 to 5 do
                begin
                   if sgCalendar_Days.Cells[iCol,iRow] = ADay then
                      begin
                         Col := iCol;
                         Row := iRow;
                         Break;
                      end;
                end;
         end;
end;

procedure TFrmFmxDlgThaiDateEntry.SearchColRowByMonth(AMonthName: String;
  var Col, Row: Integer);

var iCol,iRow : Integer;
begin
     Col := 0;
     Row := 0;

     for iCol := 0 to 1 do
         begin
            for iRow := 0 to 5 do
                begin
                   if sgCalendar_Months.Cells[iCol,iRow] = AMonthName then
                      begin
                         Col := iCol;
                         Row := iRow;
                         Break;
                      end;
                end;
         end;
end;

function TFrmFmxDlgThaiDateEntry.SearchMonthByColRow(Col, Row : Integer): Integer;
{ String 2 Col
00	01
10	11
20	21
30	31
40	41
50	51
}
begin
     if Col = 0 then
        Case Row of
          0 : Result := 1;
          1 : Result := 3;
          2 : Result := 5;
          3 : Result := 7;
          4 : Result := 9;
          5 : Result := 11;
        End
     else
         Case Row of
          0 : Result := 2;
          1 : Result := 4;
          2 : Result := 6;
          3 : Result := 8;
          4 : Result := 10;
          5 : Result := 12;
        End;
end;

procedure TFrmFmxDlgThaiDateEntry.DrawCalendar_Months;
begin
     sgCalendar_Months.Cells[0,0] := FormatSettings.LongMonthNames[1];
     sgCalendar_Months.Cells[0,1] := FormatSettings.LongMonthNames[3];
     sgCalendar_Months.Cells[0,2] := FormatSettings.LongMonthNames[5];
     sgCalendar_Months.Cells[0,3] := FormatSettings.LongMonthNames[7];
     sgCalendar_Months.Cells[0,4] := FormatSettings.LongMonthNames[9];
     sgCalendar_Months.Cells[0,5] := FormatSettings.LongMonthNames[11];

     sgCalendar_Months.Cells[1,0] := FormatSettings.LongMonthNames[2];
     sgCalendar_Months.Cells[1,1] := FormatSettings.LongMonthNames[4];
     sgCalendar_Months.Cells[1,2] := FormatSettings.LongMonthNames[6];
     sgCalendar_Months.Cells[1,3] := FormatSettings.LongMonthNames[8];
     sgCalendar_Months.Cells[1,4] := FormatSettings.LongMonthNames[10];
     sgCalendar_Months.Cells[1,5] := FormatSettings.LongMonthNames[12];

end;

procedure TFrmFmxDlgThaiDateEntry.FormShow(Sender: TObject);
begin
     DrawCalendar_Days;
     DrawCalendar_Months;

     DisplayDateinControl(FCalendarDate);
end;

procedure TFrmFmxDlgThaiDateEntry.SetCalendarDate(const Value: TDate);
begin
  FCalendarDate := Value;
end;

procedure TFrmFmxDlgThaiDateEntry.sgCalendar_DaysCellClick(const Column: TColumn;
  const Row: Integer);
begin
     edDay.Text := sgCalendar_Days.Cells[Column.Index,sgCalendar_Days.Row];
end;

procedure TFrmFmxDlgThaiDateEntry.sgCalendar_DaysSelectCell(Sender: TObject;
  const ACol, ARow: Integer; var CanSelect: Boolean);
begin
     CanSelect := (sgCalendar_Days.Cells[ACol, ARow] <> '');
end;

procedure TFrmFmxDlgThaiDateEntry.sgCalendar_MonthsCellClick(
  const Column: TColumn; const Row: Integer);
var iMonth : Integer;
begin
     iMonth := SearchMonthByColRow(Column.Index,sgCalendar_Months.Row);
     edMonth.Text := FormatSettings.LongMonthNames[iMonth] ;
     edMonth.Tag  := iMonth;
end;

end.
