program Project1;

uses
  Vcl.Forms,
  uOpenBanking in 'uOpenBanking.pas' {Form1},
  uTokenBB.DTO in 'uTokenBB.DTO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
