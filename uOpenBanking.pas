unit uOpenBanking;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, REST.Types,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Authenticator.OAuth, System.Classes,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  uTokenBB.DTO, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP;

type
  TForm1 = class(TForm)
    NetHTTPClient1: TNetHTTPClient;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    mmRetornoAPI: TMemo;
    mmToken: TMemo;
    Splitter1: TSplitter;
    pnCabecalho: TPanel;
    bGerarToken: TButton;
    btnConsumirAPI: TButton;
    edtAgencia: TEdit;
    edtConta: TEdit;
    edtCpfCnpj: TEdit;
    Label1: TLabel;
    lblAgencia: TLabel;
    lblConta: TLabel;
    Label2: TLabel;
    edtChaveDesenvolvedor: TEdit;
    shpColor: TShape;
    lbLegenda: TLabel;
    procedure bGerarTokenClick(Sender: TObject);
    procedure btnConsumirAPIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FcAccessToken: String;
    FToken: TTokenBBDTO;
    function GerarBasic: String;
    procedure GerarToken;
    function MontarGrantType: String;
    function MontarScope: String;
    procedure SetarParametros(AcURL: String);
    procedure AlimentarMemoToken(AcURL: String; FResponse: IHTTPResponse);
    procedure AlimentarVariaveisJSON(AcJSON: String);
    function RetornarValorTagJSON(AcJSON, AcTag: String): String;
    procedure ConsumirAPI;
    function MontarAgenciaConta: String;
    function MontarGwDevAppKey: String;
    function MontarCpfCnpj: String;
    function GerarBearer: String;
    procedure DefinirLegenda(AnStatusCode: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  BASE_URL_OAUTH = 'https://oauth.hm.bb.com.br/oauth/token?';
  BASE_URL_OAUTH_SANDBOX = 'https://oauth.sandbox.bb.com.br/oauth/token?';

  BASE_URL_COBRANCA = 'https://api.hm.bb.com.br/cobrancas/v2/boletos?';
  BASE_URL_COBRANCA_SANDBOX = 'https://api.sandbox.bb.com.br/cobrancas/v2/boletos?';

  BASE_URL_VALIDACAOCONTA = 'https://api.hm.bb.com.br/validacao-contas/v1/contas';
  BASE_URL_VALIDACAOCONTA_SANDBOX = 'https://api.sandbox.bb.com.br/validacao-contas/v1/contas';

  CLIENT_ID = 'eyJpZCI6ImU5YzA4OTAtYjcxZi00MzY4LTgxNTEtOTU1NTdjIiwiY29kaWdvUHVibGljYWRvciI6MCwiY29kaWdvU29mdHdhcmUiOjQ1MzU0LCJzZXF1ZW5jaWFsSW5zdGFsYWNhbyI6MX0';
  CLIENT_SECRET = 'eyJpZCI6IjBiMTA5ODQtYjk5OC00OTZkLTk3MDAtNmI3MyIsImNvZGlnb1B1YmxpY2Fkb3IiOjAsImNvZGlnb1NvZnR3YXJlIjo0NTM1NCwic2VxdWVuY2lhbEluc3RhbGFjYW8iOjEsInNlcXVlbmNpYWxDcmVkZW5jaWFsIjoxLCJhbWJpZW50ZSI6ImhvbW9sb2dhY2FvIiwiaWF0IjoxNjY0NjY4Njg3Mzg3fQ';

implementation

uses
  System.NetEncoding,
  IDUri,
  System.Generics.Collections,
  System.JSON,
  REST.JSON,
  System.JSON.Readers,
  System.JSON.Builders,
  System.JSON.Types;

{$R *.dfm}

procedure TForm1.bGerarTokenClick(Sender: TObject);
begin
  mmToken.Clear;
  GerarToken;
end;

procedure TForm1.btnConsumirAPIClick(Sender: TObject);
begin
  mmRetornoAPI.Clear;
  ConsumirAPI;
end;

function TForm1.GerarBearer: String;
begin
  Result  := Format('Bearer %s', [FToken.AccessToken]);
end;

function TForm1.MontarCpfCnpj: String;
begin
  Result := 'cpfCnpj=' + edtCpfCnpj.Text;
end;

function TForm1.MontarGwDevAppKey: String;
begin
  Result := 'gw-dev-app-key=' + edtChaveDesenvolvedor.Text;
end;

function TForm1.MontarAgenciaConta: String;
begin
  Result := '/' + edtAgencia.Text + '-' + edtConta.Text;
end;

procedure TForm1.ConsumirAPI;
var
  cURL: String;
  LBodyStream: TStringStream;
  LHeaders: TList<TNetHeader>;
  FResponse: IHTTPResponse;
begin
  cURL := Format('%s%s%s?%s&%s',
            [BASE_URL_VALIDACAOCONTA,
             MontarAgenciaConta,
             '/situacao',
             MontarGwDevAppKey,
             MontarCpfCnpj]);

  NetHTTPClient1.ContentType := 'application/json';

  LBodyStream := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  LHeaders := TList<TNetHeader>.Create;
  LHeaders.Add(TNetHeader.Create('accept', 'application/json'));
  LHeaders.Add(TNetHeader.Create('Authorization', GerarBearer));

  FResponse := NetHTTPClient1.Get(cURL, LBodyStream, LHeaders.ToArray);

  mmRetornoAPI.Lines.Add(cURL);
  mmRetornoAPI.Lines.Add('');
  mmRetornoAPI.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);

  DefinirLegenda(FResponse.StatusCode);
end;

procedure TForm1.DefinirLegenda(AnStatusCode: Integer);
begin
  case AnStatusCode of
    0:
    begin
      shpColor.Brush.Color := clWhite;
      lbLegenda.Caption    := '';
    end;
    200..226:
    begin
      shpColor.Brush.Color := clGreen;
      lbLegenda.Caption    := AnStatusCode.ToString + ' - Success';
    end;
    300..308:
    begin
      shpColor.Brush.Color := clYellow;
      lbLegenda.Caption    := AnStatusCode.ToString + ' - Redirection';
    end;
    400..499:
    begin
      shpColor.Brush.Color := clRed;
      lbLegenda.Caption    := AnStatusCode.ToString + ' - Client Error';
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DefinirLegenda(0);
end;

procedure TForm1.GerarToken;
var
  cURL: String;
  LBodyStream: TStringStream;
  LHeaders: TList<TNetHeader>;
  FResponse: IHTTPResponse;
begin
  DefinirLegenda(0);

  cURL := BASE_URL_OAUTH + MontarGrantType + MontarScope;

  LBodyStream := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  LHeaders := TList<TNetHeader>.Create;
  LHeaders.Add(TNetHeader.Create('Authorization', GerarBasic));

  SetarParametros(cURL);
  FResponse := NetHTTPClient1.Post(cURL, LBodyStream, nil, LHeaders.ToArray);

  AlimentarMemoToken(cURL, FResponse);
end;

function TForm1.RetornarValorTagJSON(AcJSON, AcTag: String): String;
var
  LJSONObject: TJSONObject;
  LStringReader: TStringReader;
  LJsonTextReader: TJsonTextReader;
  LIterator: TjsonIterator;
begin
  Result := EmptyStr;

  LStringReader := TStringReader.Create(AcJSON);
  LJsonTextReader := TJsonTextReader.Create(LStringReader);
  LIterator := TJSONIterator.Create(LJsonTextReader);

  while LJsonTextReader.read do
    case LJsonTextReader.TokenType of
      TJsonToken.PropertyName:
      mmToken.Lines.Add(LJsonTextReader.Value.AsString);
    TJsonToken.String:
      mmToken.Lines[mmToken.Lines.Count-1] := mmToken.Lines[mmToken.Lines.Count-1] + ': ' +LJsonTextReader.Value.AsString;
  end;
end;

procedure TForm1.AlimentarVariaveisJSON(AcJSON: String);
begin
  FcAccessToken := RetornarValorTagJSON(AcJSON, 'access_token');
end;

procedure TForm1.AlimentarMemoToken(AcURL: String;
  FResponse: IHTTPResponse);
begin
  mmToken.Lines.Add(AcURL);
  mmToken.Lines.Add('');
  case FResponse.StatusCode of
    200:
    begin
      mmToken.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);
      mmToken.Lines.Add('');
      FToken := TJson.JsonToObject<TTokenBBDTO>(FResponse.ContentAsString(TEncoding.UTF8));
      AlimentarVariaveisJSON(FResponse.ContentAsString(TEncoding.UTF8));
    end;
    400:
    begin
      mmToken.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);
      mmToken.Lines.Add(FResponse.ContentAsString(TEncoding.UTF8));
    end;
    401:
    begin
      mmToken.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);
      mmToken.Lines.Add(FResponse.ContentAsString(TEncoding.UTF8));
    end;
  end;
end;

procedure TForm1.SetarParametros(AcURL: String);
begin
  NetHTTPClient1.ContentType := 'application/x-www-form-urlencoded';
end;

function TForm1.MontarGrantType: String;
begin
  Result := TNetEncoding.URL.EncodeQuery('grant_type=client_credentials');
end;

function TForm1.MontarScope: String;
begin
  Result := TNetEncoding.URL.EncodeQuery('&validacao-contas.info');
end;


function TForm1.GerarBasic: String;
var
  Encoder : TBase64Encoding;
const
  ClientID = 'eyJpZCI6ImU5YzA4OTAtYjcxZi00MzY4LTgxNTEtOTU1NTdjIiwiY29kaWdvUHVibGljYWRvciI6MCwiY29kaWdvU29mdHdhcmUiOjQ1MzU0LCJzZXF1ZW5jaWFsSW5zdGFsYWNhbyI6MX0';
  ClientSecret = 'eyJpZCI6IjBiMTA5ODQtYjk5OC00OTZkLTk3MDAtNmI3MyIsImNvZGlnb1B1YmxpY2Fkb3IiOjAsImNvZGlnb1NvZnR3YXJlIjo0NTM1NCwic2VxdWVuY2lhbEluc3RhbGFjYW8iOjEsInNlcXVlbmNpYWxDcmVkZW5jaWFsIjoxLCJhbWJpZW50ZSI6ImhvbW9sb2dhY2FvIiwiaWF0IjoxNjY0NjY4Njg3Mzg3fQ';
begin
  Encoder := TBase64Encoding.Create(0);
  Result := Format('Basic %s', [Encoder.Encode(Format('%s:%s', [ClientID, ClientSecret]))]);
end;

end.
