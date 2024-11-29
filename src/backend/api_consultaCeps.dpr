program api_consultaCeps;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  System.SysUtils,
  uProvider in 'src\provider\uProvider.pas',
  uServices in 'src\services\uServices.pas',
  uController in 'src\controllers\uController.pas';

begin

  TController.registry;

  THorse.Listen(8082);

end.
