unit uTokenBB.DTO;

interface

uses
  System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TTokenBBDTO = class
  private
    [JSONName('access_token')]
    FAccessToken: string;
    [JSONName('expires_in')]
    FExpiresIn: Integer;
    FScope: string;
    [JSONName('token_type')]
    FTokenType: string;
  published
    property AccessToken: string read FAccessToken write FAccessToken;
    property ExpiresIn: Integer read FExpiresIn write FExpiresIn;
    property Scope: string read FScope write FScope;
    property TokenType: string read FTokenType write FTokenType;
  end;

implementation

end.
