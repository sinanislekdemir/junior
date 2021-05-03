unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterDiff, Math, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Unit2, Unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  seconds: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button3Click(Sender: TObject);
begin
  CodeSnippets.Show();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  seconds := 60 * 25;
end;

procedure TForm1.FormDblClick(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  s_minutes, s_seconds: string;

begin
  seconds := seconds - 1;
  if seconds <= 0 then
  begin
    Timer1.Enabled := False;
    MessageDlg('Take a break now!', 'Take a break now!', mtInformation, [mbOK], '');
  end;
  s_minutes := IntToStr(floor(seconds / 60));
  s_seconds := IntToStr(seconds mod 60);
  Label1.Caption := s_minutes + ':' + s_seconds;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Button1Click(Sender: TObject);
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
