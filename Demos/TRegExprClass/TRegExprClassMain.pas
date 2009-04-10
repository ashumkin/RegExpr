unit TRegExprClassMain;

{

  Демо-пример использования TRegExpr

  Использование класса TRegExpr, т.е. самый правильный
  способ использования.

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmTRegExprClassMain = class(TForm)
    btnExtractEmails: TBitBtn;
    memExtractEmails: TMemo;
    lbxEMailesExtracted: TListBox;
    lblSearchPhoneIn: TLabel;
    memSearchPhoneIn: TMemo;
    Bevel1: TBevel;
    lblSubstituteTemplate: TLabel;
    memSubstituteTemplate: TMemo;
    btnSubstitutePhone: TBitBtn;
    memSubstitutePhoneRes: TMemo;
    procedure btnExtractEmailsClick(Sender: TObject);
    procedure btnSubstitutePhoneClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTRegExprClassMain: TfmTRegExprClassMain;

implementation

uses RegExpr;
{$R *.DFM}

// Эта простенькая функция извлечет все e-mail адреса из входной строки
// и поместит их в результирующую строку в формате CSV (comma separated values)
function ExtractEmails (const AInputString : string) : string;

// Обратите внимание, что если эта функция будет использоваться часто,
// то наша реализация далека от оптимальной.
// Правильнее тогда использовать заранее (при инициализации программы)
// созданный TRegExpr с уже откомпилированным выражением

 const
  EmailRE = '[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+';
 var
  r : TRegExpr;
 begin
  Result := '';

  r := TRegExpr.Create;
  // Создание объекта - не забывайте об этом, 10% писем ко мне
  // связаны с тем, что объект начинают использьвать, не создав его.

  try // гарантирует освобождение занятой объектом памяти
     r.Expression := EmailRE;
	// Присваиваем исходный текст регулярного выражения.
	// При первой же необходимости (например, при вызове метода Exec)
	// оно будет откомпилировано. Если в выражении есть ошибки, то 
	// будет вызвано исключение
     if r.Exec (AInputString) then
      REPEAT
       Result := Result + r.Match [0] + ',';
      UNTIL not r.ExecNext;
    finally r.Free;
   end;
 end;

procedure TfmTRegExprClassMain.btnExtractEmailsClick(Sender: TObject);
 begin
  lbxEMailesExtracted.Items.CommaText := ExtractEmails (memExtractEmails.Text);
 end;

// В этом примере мы извлечем телефонный номер из входной строки,
// разделим его на составляющие (код страны, код города, внутренний номер телефона).
// Затем подставим все это в шаблон.
function ParsePhone (const AInputString, ATemplate : string) : string;
 const
  IntPhoneRE = '(\+\d *)?(\(\d+\) *)?(\d+(-\d*)*)';
 var
  r : TRegExpr;
 begin
  r := TRegExpr.Create; 
  // Создание объекта - не забывайте об этом, 10% писем ко мне
  // связаны с тем, что объект начинают использьвать, не создав его.

  try // гарантирует освобождение занятой объектом памяти
     r.Expression := IntPhoneRE;
	// Присваиваем исходный текст регулярного выражения.
	// При первой же необходимости (например, при вызове метода Exec)
	// оно будет откомпилировано. Если в выражении есть ошибки, то 
	// будет вызвано исключение
     if r.Exec (AInputString)
      then Result := r.Substitute (ATemplate)
      else Result := '';
    finally r.Free;
   end;
 end;

procedure TfmTRegExprClassMain.btnSubstitutePhoneClick(Sender: TObject);
 begin
  memSubstitutePhoneRes.Text := ParsePhone (memSearchPhoneIn.Text, memSubstituteTemplate.Text);
 end;

end.
