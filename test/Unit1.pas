unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.Controls, Data.Bind.GenData, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.ObjectScope, UWrpFMX.EditDate, FMX.Layouts, Fmx.Bind.Navigator,
  FMX.ListView, UWrpFMX.Edit, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ListBox, UWrpFMX.ComboBox, UWrpFMX.CheckBox;

type
  TForm1 = class(TForm)
    WrpFMXComboBox1: TWrpFMXComboBox;
    Label1: TLabel;
    Button1: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit1: TEdit;
    WrpFMXEdit1: TWrpFMXEdit;
    PrototypeBindSource1: TPrototypeBindSource;
    ListView1: TListView;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    NavigatorPrototypeBindSource1: TBindNavigator;
    LinkPropertyToFieldValue: TLinkPropertyToField;
    WrpFMXEditDate2: TWrpFMXEditDate;
    WrpFMXEditDate3: TWrpFMXEditDate;
    WrpFMXEditDate4: TWrpFMXEditDate;
    WrpFMXEditDate1: TWrpFMXEditDate;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField7: TLinkControlToField;
    Button2: TButton;
    WrpFMXEditDate5: TWrpFMXEditDate;
    LinkControlToField8: TLinkControlToField;
    WrpFMXEditDate6: TWrpFMXEditDate;
    Label2: TLabel;
    Label3: TLabel;
    WrpFMXCheckBox1: TWrpFMXCheckBox;
    LinkControlToField9: TLinkControlToField;
    Edit4: TEdit;
    Button3: TButton;
    WrpFMXEditDate7: TWrpFMXEditDate;
    LinkControlToField10: TLinkControlToField;
    procedure WrpFMXComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure WrpFMXCheckBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
     WrpFMXComboBox1.value := Edit1.Text
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     WrpFMXEditDate1.Enabled := True;
     WrpFMXEditDate2.Enabled := True;
     WrpFMXEditDate3.Enabled := True;
     WrpFMXEditDate4.Enabled := True;
     WrpFMXEditDate5.Enabled := True;
     WrpFMXEditDate6.Enabled := True;
     WrpFMXEditDate7.Enabled := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     WrpFMXEditDate4.DisplayFormat := Edit4.Text;
end;

procedure TForm1.WrpFMXCheckBox1Change(Sender: TObject);
begin
     WrpFMXComboBox1.Value := WrpFMXCheckBox1.Value;
end;

procedure TForm1.WrpFMXComboBox1Change(Sender: TObject);
begin
     Label1.Text := WrpFMXComboBox1.Value;
     Edit1.Text  := WrpFMXComboBox1.Value;
     WrpFMXCheckBox1.Value := WrpFMXComboBox1.Value;
end;

end.
