unit uMain;

interface

uses
  LoggerPro, TelegAPI.Bot, TelegAPI.Types,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    TelegramBot1: TTelegramBot;
    procedure FormCreate(Sender: TObject);
    procedure TelegramBot1Error(const Sender: TObject; const Code: Integer; const Message: string);
    procedure TelegramBot1Update(const Sender: TObject; const Update: TTelegaUpdate);
  private
    { Private declarations }
    FLog: ILogWriter;
  public
    { Public declarations }
    function Log: ILogWriter;
  end;

var
  Form2: TForm2;

implementation

uses
  XSuperObject,
  LoggerPro.FMXMemoAppender;
{$R *.fmx}
{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
  FLog := BuildLogWriter([TFMXMemoLogAppender.Create(Memo1)]);
  TelegramBot1.Token := {$I telegaToken.inc};
  TelegramBot1.IsReceiving := True;
end;

function TForm2.Log: ILogWriter;
begin
  Result := FLog;
end;

procedure TForm2.TelegramBot1Error(const Sender: TObject; const Code: Integer;
  const Message: string);
begin
  Log.Error(Message, Code.ToString);
end;

procedure TForm2.TelegramBot1Update(const Sender: TObject; const Update: TTelegaUpdate);
var
  Msg: String;
  Reply: String;
  ReplyMark: TTelegaReplyKeyboardMarkup;
  Key: TTelegaKeyboardButton;
begin
  Log.Info(Update.Message.Text, Update.Message.From.Username);
  Msg := Update.Message.Text.ToLower;
  if Msg.Contains('format') then
  Begin
    Reply := '<b>bold</b>, <strong>bold</strong>' + #13#10 + '<i>italic</i>, <em>italic</em>' +
      #13#10 + '<a href="codmasters.ru">inline URL</a>' + #13#10 +
      '<code>inline fixed-width code</code>' + #13#10 +
      '<pre>pre-formatted fixed-width code block</pre>';
    TelegramBot1.sendTextMessage(Update.Message.Chat.ID, Reply, TTelegaParseMode.Html)
  End;

  if Msg.Contains('key') then
  Begin
    ReplyMark := TTelegaReplyKeyboardMarkup.Create;
    try
      Key := TTelegaKeyboardButton.Create;
      Key.Text := 'Text';
      ReplyMark.KeyBoard := [[Key, Key], [Key, Key, Key]];

      Reply := '<b>bold</b>, <strong>bold</strong>' + #13#10 + '<i>italic</i>, <em>italic</em>' +
        #13#10 + '<a href="codmasters.ru">inline URL</a>' + #13#10 +
        '<code>inline fixed-width code</code>' + #13#10 +
        '<pre>pre-formatted fixed-width code block</pre>';
      TelegramBot1.sendTextMessage(Update.Message.Chat.ID, Reply, TTelegaParseMode.Html, False,
        False, 0, ReplyMark);
    finally
      ReplyMark.Free;
    end;
  End;
end;

end.