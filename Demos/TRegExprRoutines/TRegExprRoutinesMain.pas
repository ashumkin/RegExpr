unit TRegExprRoutinesMain;

{
  Демо-пример использования TRegExpr

  Использование глобальных процедур
  Это самый простой способ, но и самый неэффективный

   -=- Добавить RegExpr.pas в список файлов Вашего проекта (или просто
    поместить этот файл в каталог файлов Вашего проекта):
      Delphi Main Menu -> Project -> Add to project..
   -=- Добавить 'RegExpr' в оператор 'uses' модуля, где Вы будете 
    использовать процедуры TRegExpr:
      Delphi Main Menu -> File -> Use Unit..
   -=- Теперь можно просто вызывать процедуры, например ExecRegExpr 
    (полный список процедур имеется в разделе 'Интерфейс TRegExpr'
    документации по TRegExpr).

}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfmTRegExprRoutines = class(TForm)
    grpSearchOrValidate: TGroupBox;
    lblPhone: TLabel;
    edPhone: TComboBox;
    lblValidatePhoneRes: TLabel;
    btnValidatePhone: TBitBtn;
    edTextWithPhone: TComboBox;
    lblTextWithPhone: TLabel;
    lblSearchPhoneRes: TLabel;
    btnSearchPhone: TBitBtn;
    grpReplace: TGroupBox;
    lblSearchIn: TLabel;
    memSearchIn: TMemo;
    lblReplaceWith: TLabel;
    btnReplace: TBitBtn;
    edReplaceWith: TEdit;
    lblSearchFor: TLabel;
    edSearchFor: TEdit;
    memReplaceRes: TMemo;
    procedure btnSearchPhoneClick(Sender: TObject);
    procedure btnValidatePhoneClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTRegExprRoutines: TfmTRegExprRoutines;

implementation

uses RegExpr;

{$R *.DFM}

procedure TfmTRegExprRoutines.btnSearchPhoneClick(Sender: TObject);
 begin
  if ExecRegExpr ('\d{3}-(\d{2}-\d{2}|\d{4})', edTextWithPhone.Text) then begin
     // Это регулярное выражение просто проверяет,
     // существует ли корректный номер телефона в строке edTextWithPhone
     lblSearchPhoneRes.Font.Color := clBlue;
     lblSearchPhoneRes.Caption := 'Phone number found';
     lblSearchPhoneRes.Visible := True;
    end
   else begin // Error in test
     lblSearchPhoneRes.Font.Color := clRed;
     lblSearchPhoneRes.Caption := 'There is no phone number in the Phone field';
     lblSearchPhoneRes.Visible := True;
     edPhone.SetFocus;
    end;
 end;

procedure TfmTRegExprRoutines.btnValidatePhoneClick(Sender: TObject);
 begin
  if ExecRegExpr ('^\s*\d{3}-(\d{2}-\d{2}|\d{4})\s*$', edPhone.Text) then begin
     // Это регулярное выражение проверяет, является ли строка В ЦЕЛОМ
     // Корректным телефонным номером. Обратите внимание на 
     // использование \s* в начале и в конце. Самая распространенная
     // ошибка пользователей - случайный ввод пробелов. Эти пробелы
     // потом не видны пользователю и он начинает названивать в
     // службу тех.поддержки - "ничего не работает".
     // Разумно избавить тех.поддержку от этих звонков, поэтому мы
     // просто игнорирует пробелы.
     lblValidatePhoneRes.Font.Color := clBlue;
     lblValidatePhoneRes.Caption := 'Phone number is Ok';
     lblValidatePhoneRes.Visible := True;
    end
   else begin // Error in test
     lblValidatePhoneRes.Font.Color := clRed;
     lblValidatePhoneRes.Caption := 'Error in the Phone field';
     lblValidatePhoneRes.Visible := True;
     edPhone.SetFocus;
    end;
 end;

procedure TfmTRegExprRoutines.btnReplaceClick(Sender: TObject);
 begin
  memReplaceRes.Text := ReplaceRegExpr (edSearchFor.Text, memSearchIn.Text, edReplaceWith.Text);
 end;

end.
