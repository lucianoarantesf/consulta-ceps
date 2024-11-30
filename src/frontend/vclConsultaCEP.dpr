program vclConsultaCEP;

uses
  Vcl.Forms,
  uPrincipal in 'src\forms\uPrincipal.pas' {FPrincipal},
  uConsultaCEP in 'src\utils\uConsultaCEP.pas',
  uRetornoCEP in 'src\utils\uRetornoCEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
