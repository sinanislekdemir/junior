unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, CheckLst,
  ExtCtrls, StdCtrls, ActnList, Menus;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    CheckListBox1: TCheckListBox;
    Edit1: TEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure SaveList(var filename: string);
    procedure LoadList(var filename: string);
  private

  public

  end;

var
  Form2: TForm2;
  indexFilename: string;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.SaveList(var filename: string);
var
  list: TStringList;
  i: Integer;
  line: string;
begin
     list := TStringList.Create;
     for i := 0 to CheckListBox1.Items.Count-1 do
     begin
          line := '';
          if CheckListBox1.Checked[i] then
             line += '+'
          else
             line += '-';
          line += CheckListBox1.Items[i];
          list.Add(line);
     end;
     list.SaveToFile(filename);
     list.Free;
end;

procedure TForm2.LoadList(var filename: string);
var
  list: TStringList;
  i: Integer;
begin
     list := TStringList.Create;
     list.LoadFromFile(filename);
     CheckListBox1.Clear;
     for i := 0 to list.Count-1 do
     begin
          CheckListBox1.Items.Add(RightStr(list[i], Length(list[i])-1));
          CheckListBox1.Checked[i] := LeftStr(list[i], 1) = '+';
     end;
     list.Free;
end;

procedure TForm2.MenuItem2Click(Sender: TObject);
var
  fname: string;
begin
  if SaveDialog1.Execute then
  begin
     fname := SaveDialog1.FileName;
    SaveList(fname);
  end
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: char);
var
  fname: string;
begin
  if key = #13 then
  begin
     CheckListBox1.Items.Add(Edit1.Text);
     Edit1.Text:='';
     SaveList(indexFilename);
  end;
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  fname: string;
begin
  SaveList(indexFilename);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  indexFilename := GetUserDir() + '/.coder-toolbox/todo.txt';
end;

procedure TForm2.FormShow(Sender: TObject);
var
  fname: string;
begin
  if FileExists(indexFilename) then
  begin
     LoadList(indexFilename);
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  fname: string;
begin
  CheckListBox1.Items.Add(Edit1.Text);
  Edit1.Text:= '';
  SaveList(indexFilename);
end;

procedure TForm2.MenuItem3Click(Sender: TObject);
var
  fname: string;
begin
  if OpenDialog1.Execute then
  begin
     fname := OpenDialog1.FileName;
     LoadList(fname);
  end;
end;

procedure TForm2.MenuItem5Click(Sender: TObject);
var
  i: Integer;
begin
  for i:= CheckListBox1.Items.Count-1 downto 0 do
  begin
       if CheckListBox1.Checked[i] then
          CheckListBox1.items.Delete(i);
  end;
end;

end.

