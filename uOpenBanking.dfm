object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 551
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    AlignWithMargins = True
    Left = 3
    Top = 370
    Width = 996
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    ResizeStyle = rsNone
  end
  object mmRetornoAPI: TMemo
    Left = 0
    Top = 376
    Width = 1002
    Height = 175
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object mmToken: TMemo
    Left = 0
    Top = 203
    Width = 1002
    Height = 164
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object pnCabecalho: TPanel
    Left = 0
    Top = 0
    Width = 1002
    Height = 203
    Align = alClient
    TabOrder = 2
    object Label1: TLabel
      Left = 432
      Top = 57
      Width = 84
      Height = 13
      Caption = 'CPF/CNPJ.........'
    end
    object lblAgencia: TLabel
      Left = 232
      Top = 57
      Width = 78
      Height = 13
      Caption = 'Ag'#234'ncia..........'
    end
    object lblConta: TLabel
      Left = 232
      Top = 84
      Width = 77
      Height = 13
      Caption = 'Conta............'
    end
    object Label2: TLabel
      Left = 160
      Top = 122
      Width = 154
      Height = 13
      Caption = 'Chave Desenvolvedor............'
    end
    object shpColor: TShape
      Left = 157
      Top = 139
      Width = 17
      Height = 22
      Shape = stCircle
    end
    object lbLegenda: TLabel
      Left = 186
      Top = 143
      Width = 3
      Height = 13
    end
    object bGerarToken: TButton
      Left = 16
      Top = 48
      Width = 113
      Height = 49
      Caption = 'Gerar Token'
      TabOrder = 0
      OnClick = bGerarTokenClick
    end
    object btnConsumirAPI: TButton
      Left = 15
      Top = 112
      Width = 113
      Height = 49
      Caption = 'Consumir API'
      TabOrder = 1
      OnClick = btnConsumirAPIClick
    end
    object edtAgencia: TEdit
      Left = 304
      Top = 49
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0551'
    end
    object edtConta: TEdit
      Left = 304
      Top = 76
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '1000'
    end
    object edtCpfCnpj: TEdit
      Left = 510
      Top = 49
      Width = 219
      Height = 21
      TabOrder = 4
      Text = '5887148012'
    end
    object edtChaveDesenvolvedor: TEdit
      Left = 304
      Top = 113
      Width = 425
      Height = 21
      TabOrder = 5
    end
  end
  object NetHTTPClient1: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    AllowCookies = True
    HandleRedirects = True
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharSet = 'utf-8, *;q=0.8'
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 928
    Top = 8
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 928
    Top = 56
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 928
    Top = 104
  end
end
