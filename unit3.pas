unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynHighlighterPython, SynHighlighterPas,
  SynHighlighterCpp, SynHighlighterJava, SynHighlighterJScript,
  SynHighlighterPerl, SynHighlighterHTML, SynHighlighterXML, SynHighlighterDiff,
  synhighlighterunixshellscript, SynHighlighterCss, SynHighlighterPHP,
  SynHighlighterSQL, SynHighlighterTeX, SynHighlighterAny, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, ComCtrls, StdCtrls, ActnList,
  Menus, dateutils, sqldb;

type

  { TCodeSnippets }

  TCodeSnippets = class(TForm)
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    ActionList1: TActionList;
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Status: TLabel;
    SaveButton: TButton;
    ResetButton: TButton;
    Panel4: TPanel;
    Search: TEdit;
    SynAnySyn1: TSynAnySyn;
    SynSQLSyn1: TSynSQLSyn;
    SyntaxBox: TComboBox;
    SnippetName: TEdit;
    CodeList: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    SynCppSyn1: TSynCppSyn;
    SynCssSyn1: TSynCssSyn;
    SynDiffSyn1: TSynDiffSyn;
    CodeEditor: TSynEdit;
    SynHTMLSyn1: TSynHTMLSyn;
    SynJavaSyn1: TSynJavaSyn;
    SynJScriptSyn1: TSynJScriptSyn;
    SynPerlSyn1: TSynPerlSyn;
    SynPHPSyn1: TSynPHPSyn;
    SynPythonSyn1: TSynPythonSyn;
    SynUNIXShellScriptSyn1: TSynUNIXShellScriptSyn;
    SynXMLSyn1: TSynXMLSyn;
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure CodeEditorChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure CodeListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchEnter(Sender: TObject);
    procedure SearchKeyPress(Sender: TObject; var Key: char);
    procedure SyntaxBoxChange(Sender: TObject);
    procedure RefreshCodeList();
    procedure LoadCodeList(var filename: string);
    procedure SyntaxChange(var syntax: string);
  private

  public

  end;

var
  CodeSnippets: TCodeSnippets;
  indexFilename: string;

implementation

{$R *.lfm}

{ TCodeSnippets }
//Python
//HTML
//JavaScript
//Java
//C++
//Pascal
//Perl
//XML
//Diff
//Bash
//CSS
//Tex
//SQL
//php


procedure TCodeSnippets.SyntaxChange(var syntax: string);
begin
  case syntax of
    'Generic/Text': CodeEditor.Highlighter := SynAnySyn1;
    'Python': CodeEditor.Highlighter := SynPythonSyn1;
    'HTML': CodeEditor.Highlighter := SynHTMLSyn1;
    'JavaScript': CodeEditor.Highlighter := SynJScriptSyn1;
    'Java': CodeEditor.Highlighter := SynJavaSyn1;
    'C++': CodeEditor.Highlighter := SynCppSyn1;
    'Perl': CodeEditor.Highlighter := SynPerlSyn1;
    'XML': CodeEditor.Highlighter := SynXMLSyn1;
    'Diff': CodeEditor.Highlighter := SynDiffSyn1;
    'Bash': CodeEditor.Highlighter := SynUNIXShellScriptSyn1;
    'CSS': CodeEditor.Highlighter := SynCssSyn1;
    'SQL': CodeEditor.Highlighter := SynSQLSyn1;
    'php': CodeEditor.Highlighter := SynPHPSyn1;
  end;
end;

procedure TCodeSnippets.SyntaxBoxChange(Sender: TObject);
var
  s: string;
begin
  s := SyntaxBox.Caption;
  SyntaxChange(s);
end;

procedure TCodeSnippets.LoadCodeList(var filename: string);
var
  findex: TStringList;
  parts: TStringArray;
  i: integer;
begin
  CodeList.Items.Clear;
  findex := TStringList.Create;
  findex.LoadFromFile(filename);
  for i := 0 to findex.Count - 1 do
  begin
    parts := findex[i].Split('|');
    CodeList.Items.Add(parts[1]);
  end;
  findex.Free;
end;

procedure TCodeSnippets.FormCreate(Sender: TObject);
var
  dir: string;
begin
  indexFilename := GetUserDir() + '/.coder-toolbox/index.txt';
  dir := GetUserDir + '/.coder-toolbox';
  if not DirectoryExists(dir) then
    CreateDir(dir);

  if FileExists(indexFilename) then
    LoadCodeList(indexFilename);
end;

procedure TCodeSnippets.CodeListClick(Sender: TObject);
var
  findex: TStringList;
  i: integer;
  parts: TStringArray;
begin
  findex := TStringList.Create;
  if not FileExists(indexFilename) then
    findex.SaveToFile(indexFilename);
  findex.LoadFromFile(indexFilename);
  for i := 0 to findex.Count - 1 do
  begin
    parts := findex[i].Split('|');
    if parts[1] = CodeList.GetSelectedText then
    begin
      CodeEditor.Lines.LoadFromFile(parts[2]);
      SyntaxChange(parts[0]);
      SnippetName.Text := parts[1];
      SyntaxBox.Text := parts[0];
    end;
  end;
  findex.Free;
end;

procedure TCodeSnippets.SaveButtonClick(Sender: TObject);
var
  findex: TStringList;
  i: integer;
  parts: TStringArray;
  fname: string;
begin
  findex := TStringList.Create;
  if not FileExists(indexFilename) then
    findex.SaveToFile(indexFilename);
  findex.LoadFromFile(indexFilename);
  for i := 0 to findex.Count - 1 do
  begin
    parts := findex[i].Split('|');
    if parts[1] = SnippetName.Text then
    begin
      parts[0] := SyntaxBox.Caption;
      CodeEditor.Lines.SaveToFile(parts[2]);
      Exit;
    end;
  end;
  fname := GetUserDir + './.coder-toolbox/' + IntToStr(DateTimeToUnix(Now()));
  findex.Add(SyntaxBox.Caption + '|' + SnippetName.Text + '|' + fname);
  CodeEditor.Lines.SaveToFile(fname);
  findex.SaveToFile(indexFilename);
  findex.Free;
  LoadCodeList(fname);
  fname := indexFilename;
  LoadCodeList(fname);
  Status.Caption := 'Saved...';
end;

procedure TCodeSnippets.Action1Execute(Sender: TObject);
begin
  ResetButton.Click;
end;

procedure TCodeSnippets.Action2Execute(Sender: TObject);
begin
  SaveButton.Click;
end;

procedure TCodeSnippets.Action3Execute(Sender: TObject);
begin
  Search.SetFocus;
end;

procedure TCodeSnippets.CodeEditorChange(Sender: TObject);
begin
  Status.Caption := ':';
end;

procedure TCodeSnippets.MenuItem1Click(Sender: TObject);
var
  findex: TStringList;
  i: integer;
  parts: TStringArray;
begin
  findex := TStringList.Create;
  findex.LoadFromFile(indexFilename);
  for i := findex.Count - 1 downto 0 do
  begin
    parts := findex[i].Split('|');
    if parts[1] = CodeList.GetSelectedText then
    begin
      findex.Delete(i);
      DeleteFile(parts[2]);
      findex.SaveToFile(indexFilename);
      findex.Free;
      LoadCodeList(indexFilename);

      Status.Caption := 'Deleted...';
      Exit;
    end;
  end;
  findex.Free;
end;

procedure TCodeSnippets.ResetButtonClick(Sender: TObject);
begin
  SnippetName.Text := '';
  SnippetName.SetFocus;
  CodeEditor.Lines.Clear;
  Status.Caption := 'New...';
end;

procedure TCodeSnippets.FormDestroy(Sender: TObject);
begin

end;

procedure TCodeSnippets.SearchEnter(Sender: TObject);
begin
  Search.Text := '';
end;

procedure TCodeSnippets.SearchKeyPress(Sender: TObject; var Key: char);
var
  i: integer;
begin
  if Length(Search.Text) = 0 then
  begin
    LoadCodeList(indexFilename);
    exit;
  end;
  for i := CodeList.Items.Count - 1 downto 0 do
  begin
    if Pos(Search.Text, CodeList.Items[i]) = 0 then
    begin
      CodeList.Items.Delete(i);
    end;
  end;
end;

procedure TCodeSnippets.RefreshCodeList();
var
  dir: string;
begin
  dir := GetUserDir + '/.coder-toolbox';

end;

end.
