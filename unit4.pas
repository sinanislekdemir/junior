unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DateTimePicker;

type

  { TForm1 }

  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    blockers: TMemo;
    today: TMemo;
    yesterday: TMemo;
    scrumdate: TDateTimePicker;
    Label1: TLabel;
    Panel1: TPanel;
    procedure blockersExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure scrumdateChange(Sender: TObject);
    procedure todayChange(Sender: TObject);
    procedure todayExit(Sender: TObject);
    procedure yesterdayChange(Sender: TObject);
    procedure saveTheDay();
    procedure yesterdayExit(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  indexPath: string;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  scrumdate.Date := Now;

  indexPath := GetUserDir() + '/.coder-toolbox/scrum/';
  if not DirectoryExists(indexPath) then
    MkDir(indexPath);
  scrumdate.OnChange(Sender);
end;

procedure TForm1.scrumdateChange(Sender: TObject);
var
  fname: string;
  rec: TStringList;
begin
  fname := indexPath + IntToStr(DateTimeToTimeStamp(scrumdate.Date).Date) + '.day';
  if FileExists(fname) then
  begin
    rec := TStringList.Create;
    rec.LineBreak := '5812@1@';
    rec.LoadFromFile(fname);
    yesterday.Lines.Text := rec[0];
    today.Lines.Text := rec[1];
    blockers.Lines.Text := rec[2];
    rec.Free;
  end
  else
  begin
    yesterday.Lines.Text := '';
    today.Lines.Text := '';
    blockers.Lines.Text := '';
  end;
end;

procedure TForm1.blockersExit(Sender: TObject);
begin
  saveTheDay();
end;

procedure TForm1.todayChange(Sender: TObject);
begin

end;

procedure TForm1.todayExit(Sender: TObject);
begin
  saveTheDay();
end;


procedure TForm1.saveTheDay();
var
  fname: string;
  rec: TStringList;
begin
  rec := TStringList.Create;
  rec.LineBreak := '5812@1@';
  rec.Add(yesterday.Lines.Text);
  rec.Add(today.Lines.Text);
  rec.add(blockers.Lines.Text);
  fname := indexPath + IntToStr(DateTimeToTimeStamp(scrumdate.Date).Date) + '.day';
  rec.SaveToFile(fname);
  rec.Free;
end;

procedure TForm1.yesterdayExit(Sender: TObject);
begin
  saveTheDay();
end;


procedure TForm1.yesterdayChange(Sender: TObject);
begin
  saveTheDay();
end;

end.

