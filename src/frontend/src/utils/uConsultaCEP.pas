unit uConsultaCEP;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  RESTRequest4D,
  URetornoCEP;

type
  TConsultaCEP = class
  private
    FBaseURL: string;
    FTimeout: Integer;
  public
    constructor Create;
    function ConsultarCEP(const ACep: string): TRetornoCEP;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

implementation

{ TConsultaCEP }

constructor TConsultaCEP.Create;
begin
  FBaseURL := 'http://localhost:8082/cep'; // Substituir pela URL correta da API
  FTimeout := 5000; // Timeout padrão em milissegundos
end;

function TConsultaCEP.ConsultarCEP(const aCep: string): TRetornoCEP;
var
  LResponse: IResponse;
  Response: string;
  JsonResponse: TJSONObject;
begin
  if ACep.IsEmpty or (Length(ACep) <> 8) then
    raise Exception.Create('CEP inválido. Por favor, insira um CEP no formato correto.');


    try

      LResponse := TRequest.New.BaseURL(FBaseURL).Resource('?cep='+aCep)
                  .ContentType('application/json')
                  .AcceptEncoding('gzip')
                  .Timeout(FTimeout)
                  .Get;
      JsonResponse := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LResponse.Content),0) AS TJSONObject;

      if not Assigned(JsonResponse) then
        raise Exception.Create('Erro ao processar o retorno da API.');

      Result := TRetornoCEP.Create;
      try
        Result.Cep := JsonResponse.GetValue<string>('cep.cep','');
        Result.Uf := JsonResponse.GetValue<string>('cep.uf','');
        Result.Endereco := JsonResponse.GetValue<string>('cep.logradouro','');
        Result.Bairro := JsonResponse.GetValue<string>('cep.bairro','');
        Result.Cidade := JsonResponse.GetValue<string>('cep.cidade','');
      except
        Result.Free;
        raise;
      end;

    except
      on E: Exception do
        raise Exception.Create('Erro inesperado: ' + E.Message);
    end;

end;

end.

