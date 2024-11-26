program api_consultaCeps;

{$APPTYPE CONSOLE}
{$R *.res}

uses Horse, System.SysUtils;

begin
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Get('/env',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(Format('Db Host: %s Db Port: %s',
        [GetEnvironmentVariable('DB_HOST'),
        GetEnvironmentVariable('DB_PORT')]));
    end);

  THorse.Listen(8082);

end.
