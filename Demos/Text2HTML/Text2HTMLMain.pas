unit Text2HTMLMain;

{

Очень простая утилита преобразования текста в HTML.
Использует модуль HyperLinksDecorator, основанный на TRegExpr.

Единственное назначение этой программы - продемонстрировать
использование TRegExpr.

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TfmText2HTMLMain = class(TForm)
    edSourceFileName: TEdit;
    lblSourceFileName: TLabel;
    lblDestFileName: TLabel;
    edDestFileName: TEdit;
    btnSourceFileName: TSpeedButton;
    btnDestFileName: TSpeedButton;
    btnConvert: TBitBtn;
    lblDestFileNameComment: TLabel;
    dlgSourceFile: TOpenDialog;
    pbrConvert: TProgressBar;
    procedure btnConvertClick(Sender: TObject);
    procedure btnSourceFileNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmText2HTMLMain: TfmText2HTMLMain;

implementation

uses HyperLinksDecorator;
{$R *.DFM}

procedure TfmText2HTMLMain.btnConvertClick(Sender: TObject);
 var
  SourceFileName, DestFileName : string;
  TheText : TStrings;
  i : integer;
 begin
  try
  btnConvert.Visible := False;
  pbrConvert.Position := 0;
  pbrConvert.Visible := True;
  Application.ProcessMessages;

  SourceFileName := Trim (edSourceFileName.Text);
  DestFileName := Trim (edDestFileName.Text);

  if (SourceFileName = '') or not FileExists (SourceFileName) then begin
    Application.MessageBox ('Source file unspecified or doesn''t exist.',
     'Error', mb_Ok or mb_IconHand);
    EXIT;
   end;

  if DestFileName = ''
   then DestFileName := ChangeFileExt (SourceFileName, '.htm');

  if FileExists (DestFileName) then begin
    if Application.MessageBox ('Destination file exists. Are You sure to overwrite?',
     'Error', mb_YesNo or mb_IconQuestion) <> IDYES
     then EXIT;
   end;

  TheText := TStringList.Create;
  try
     TheText.LoadFromFile (SourceFileName);

     pbrConvert.Max := TheText.Count * 3;

     // Ищем URLs и EMails и заменяем на гипер-ссылки
     TheText.Text := DecorateURLs (TheText.Text);
     pbrConvert.Position := TheText.Count;
     Application.ProcessMessages;
     TheText.Text := DecorateEMails (TheText.Text);
     pbrConvert.Position := TheText.Count * 2;
     Application.ProcessMessages;

     // Вставляем "жесткие" параграфы
     for i := 0 to TheText.Count - 1 do begin
       if Trim (TheText [i]) = ''
        then TheText [i] := '<P>';
       if i mod 10 = 0 then begin
         pbrConvert.Position := TheText.Count * 2 + i;
         Application.ProcessMessages;
        end;
      end;

     // Обрамляем тест общими html-тегами.
     TheText.Insert (0, '<head>');
     TheText.Insert (1, '<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">');
     TheText.Insert (2, '</head>');
     TheText.Insert (3, '<body>');
     TheText.Add ('</body>');
     TheText.Insert (0, '<html>');
     TheText.Add ('</html>');

     TheText.SaveToFile (DestFileName);

     pbrConvert.Visible := False;
     Application.ProcessMessages;

     Application.MessageBox ('File convertion finished.',
      'Done', mb_Ok or mb_IconInformation);

    finally TheText.Free;
   end;

  finally begin
    pbrConvert.Visible := False;
    btnConvert.Visible := True;
   end;
  end;
 end;

procedure TfmText2HTMLMain.btnSourceFileNameClick(Sender: TObject);
 begin
  if dlgSourceFile.Execute
   then edSourceFileName.Text := dlgSourceFile.FileName;
 end;

procedure TfmText2HTMLMain.FormCreate(Sender: TObject);
 begin
  edSourceFileName.Text := ExtractFilePath (Application.ExeName)
   + 'Example.txt';
  dlgSourceFile.FileName := edSourceFileName.Text;

  edDestFileName.Text := '';
 end;

end.
