unit uController;

interface

uses
  System.SysUtils, System.JSON, System.StrUtils,
  DB, FireDAC.Comp.Client,
  Horse, DataSet.Serialize,
  UServices;

type
  TController = class
    class procedure registry;
  private
  public
  end;

implementation

{ TController }

// metodo anonimo onde contem a requisição horse
procedure GetCep(Req: THorseRequest; Res: THorseResponse);
var
  FService: TServices;
  lJsonResponse, lJsonResponseErro: TJsonObject;
begin

  try
    FService := TServices.Create;
    lJsonResponse := TJsonObject.Create;
    try
      lJsonResponse.AddPair('cep', FService.BuscarCep(Req.Query.Field('cep').AsString));

      Res.ContentType('application/json; charset=utf-8')
         .Send(lJsonResponse.ToJSON)
         .Status(200);
    finally
      if assigned(lJsonResponse) then
        FreeAndNil(lJsonResponse);

      FService.Destroy;

    end;
  except
    on e: exception do
    begin
      lJsonResponseErro := TJsonObject.Create;

      lJsonResponseErro.AddPair('status', 500);
      lJsonResponseErro.AddPair('result', e.Message);

      Res.ContentType('application/json; charset=utf-8')
         .Send(lJsonResponseErro.ToJSON)
         .Status(lJsonResponseErro.GetValue<integer>('status'));

      if assigned(lJsonResponseErro) then
        FreeAndNil(lJsonResponseErro);
    end;
  end;
end;

procedure GetEnv(Req: THorseRequest; Res: THorseResponse);
var
  lJsonResponse, lJsonResponseErro: TJsonObject;
begin

  try
    lJsonResponse := TJsonObject.Create;
    try

      lJsonResponse.AddPair('DB_HOST', GetEnvironmentVariable('DB_HOST'));
      lJsonResponse.AddPair('DB_NAME', GetEnvironmentVariable('DB_NAME'));
      lJsonResponse.AddPair('DB_PORT', GetEnvironmentVariable('DB_PORT'));
      lJsonResponse.AddPair('DB_USER', GetEnvironmentVariable('DB_USER'));
      lJsonResponse.AddPair('DB_PASSWORD', GetEnvironmentVariable('DB_PASSWORD'));

      Res.ContentType('application/json; charset=utf-8')
        .Send(lJsonResponse.ToJSON).status(200);
    finally
      if assigned(lJsonResponse) then
        FreeAndNil(lJsonResponse);
    end;
  except
    on e: exception do
    begin
      lJsonResponseErro := TJsonObject.Create;
      lJsonResponseErro.AddPair('status', 500);
      lJsonResponseErro.AddPair('result', e.Message);

      Res.ContentType('application/json; charset=utf-8')
        .Send(lJsonResponseErro.ToJSON)
        .status(lJsonResponseErro.GetValue<integer>('status'));

      lJsonResponseErro.Free;
    end;
  end;
end;

class procedure TController.registry;
begin
  THorse.Get('/cep', GetCep);
  THorse.Get('/env', GetEnv);
end;

end.
