unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterDiff, Math, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, Unit2, Unit3, unit4,
  fphttpclient;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    minutes: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure minutesChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;
  seconds: integer;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.Button3Click(Sender: TObject);
begin
  CodeSnippets.Show();
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  Form1.Show();
end;

procedure TMainForm.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then
    FormStyle := fsSystemStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  mainDir: string;
begin
  seconds := 60 * 25;
  mainDir := GetUserDir() + '/.coder-toolbox';
  if not DirectoryExists(mainDir) then
    MkDir(mainDir);
end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin

end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
begin
  Button2.Click;
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
  button3.Click;
end;

procedure TMainForm.MenuItem3Click(Sender: TObject);
begin
  Button4.Click;
end;

procedure TMainForm.minutesChange(Sender: TObject);
var
  s_minutes, s_seconds: string;
begin
  if minutes.Text = '' then
    exit;
  seconds := 60 * StrToInt(minutes.Text);
  s_minutes := IntToStr(floor(seconds / 60));
  s_seconds := IntToStr(seconds mod 60);
  if (seconds mod 60) < 10 then
    s_seconds := '0' + s_seconds;
  Label1.Caption := s_minutes + ':' + s_seconds;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  s_minutes, s_seconds: string;

begin
  seconds := seconds - 1;
  if seconds <= 0 then
  begin
    Timer1.Enabled := False;
    MessageDlg('Take a break now!', 'Take a break now!', mtInformation, [mbOK], '');
    seconds := 60 * StrToInt(minutes.Text);
    Button1.Caption := 'Start';
  end;
  s_minutes := IntToStr(floor(seconds / 60));
  s_seconds := IntToStr(seconds mod 60);
  if (seconds mod 60) < 10 then
    s_seconds := '0' + s_seconds;
  Label1.Caption := s_minutes + ':' + s_seconds;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if Timer1.Enabled then
  begin
    Timer1.Enabled := False;
    Button1.Caption := 'Start';
  end
  else
  begin
    Timer1.Enabled := True;
    Button1.Caption := 'Pause';
  end;
end;

end.
