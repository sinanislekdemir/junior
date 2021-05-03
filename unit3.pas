unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynHighlighterPython, SynHighlighterPas,
  SynHighlighterCpp, SynHighlighterJava, SynHighlighterJScript,
  SynHighlighterPerl, SynHighlighterHTML, SynHighlighterXML, SynHighlighterDiff,
  synhighlighterunixshellscript, SynHighlighterCss, SynHighlighterPHP,
  SynHighlighterSQL, SynHighlighterTeX, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, PairSplitter, ComCtrls, StdCtrls, dateutils;

type

  { TCodeSnippets }

  TCodeSnippets = class(TForm)
    Button1: TButton;
    Panel4: TPanel;
    Search: TEdit;
    SynSQLSyn1: TSynSQLSyn;
    SyntaxBox: TComboBox;
    Edit1: TEdit;
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
    SynPasSyn1: TSynPasSyn;
    SynPerlSyn1: TSynPerlSyn;
    SynPHPSyn1: TSynPHPSyn;
    SynPythonSyn1: TSynPythonSyn;
    SynTeXSyn1: TSynTeXSyn;
    SynUNIXShellScriptSyn1: TSynUNIXShellScriptSyn;
    SynXMLSyn1: TSynXMLSyn;
    procedure Button1Click(Sender: TObject);
    procedure CodeListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SyntaxBoxChange(Sender: TObject);
    procedure RefreshCodeList();
    procedure LoadCodeList(var filename: string);
    procedure SyntaxChange(var syntax: string);
  private

  public

  end;

var
  CodeSnippets: TCodeSnippets;

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
    'Python': CodeEditor.Highlighter := SynPythonSyn1;
    'HTML': CodeEditor.Highlighter := SynHTMLSyn1;
    'JavaScript': CodeEditor.Highlighter := SynJScriptSyn1;
    'Java': CodeEditor.Highlighter := SynJavaSyn1;
    'C++': CodeEditor.Highlighter := SynCppSyn1;
    'Pascal': CodeEditor.Highlighter := SynPasSyn1;
    'Perl': CodeEditor.Highlighter := SynPerlSyn1;
    'XML': CodeEditor.Highlighter := SynXMLSyn1;
    'Diff': CodeEditor.Highlighter := SynDiffSyn1;
    'Bash': CodeEditor.Highlighter := SynUNIXShellScriptSyn1;
    'CSS': CodeEditor.Highlighter := SynCssSyn1;
    'Tex': CodeEditor.Highlighter := SynTeXSyn1;
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
  fname: string;
begin
  dir := GetUserDir + '/.coder-toolbox';
  if not DirectoryExists(dir) then
    CreateDir(dir);
  fname := dir + '/index.txt';
  if FileExists(fname) then
    LoadCodeList(fname);
end;

procedure TCodeSnippets.CodeListClick(Sender: TObject);
var
  findex: TStringList;
  i: integer;
  parts: TStringArray;
begin
  findex := TStringList.Create;
  if not FileExists(GetUserDir + '/.coder-toolbox/index.txt') then
    findex.SaveToFile(GetUserDir + '/.coder-toolbox/index.txt');
  findex.LoadFromFile(GetUserDir + '/.coder-toolbox/index.txt');
  for i := 0 to findex.Count - 1 do
  begin
    parts := findex[i].Split('|');
    if parts[1] = CodeList.GetSelectedText then
    begin
      CodeEditor.Lines.LoadFromFile(parts[2]);
      SyntaxChange(parts[0]);
      Edit1.Text := parts[1];
    end;
  end;
  findex.Free;
end;

procedure TCodeSnippets.Button1Click(Sender: TObject);
var
  findex: TStringList;
  i: integer;
  parts: TStringArray;
  fname: string;
begin
  findex := TStringList.Create;

  if not FileExists(GetUserDir + '/.coder-toolbox/index.txt') then
    findex.SaveToFile(GetUserDir + '/.coder-toolbox/index.txt');
  findex.LoadFromFile(GetUserDir + '/.coder-toolbox/index.txt');
  for i := 0 to findex.Count - 1 do
  begin
    parts := findex[i].Split('|');
    if parts[1] = Edit1.Text then
    begin
      parts[0] := SyntaxBox.Caption;
      CodeEditor.Lines.SaveToFile(parts[2]);
      Exit;
    end;
  end;
  fname := GetUserDir + './.coder-toolbox/' + IntToStr(DateTimeToUnix(Now()));
  findex.Add(SyntaxBox.Caption + '|' + Edit1.Text + '|' + fname);
  CodeEditor.Lines.SaveToFile(fname);
  findex.SaveToFile(GetUserDir + '/.coder-toolbox/index.txt');
  findex.Free;
end;

procedure TCodeSnippets.FormDestroy(Sender: TObject);
begin

end;

procedure TCodeSnippets.RefreshCodeList();
var
  dir: string;
begin
  dir := GetUserDir + '/.coder-toolbox';

end;

end.

