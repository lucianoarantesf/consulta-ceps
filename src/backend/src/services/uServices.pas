unit UServices;

interface

uses
  System.SysUtils, DataSet.Serialize, System.JSON,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  uProvider;

type
  TServices = class
  private
    FProvider: TProvider; // Classe de conexão com o banco de dados
  public
    constructor Create;
    destructor Destroy; override;

    function BuscarCep(const aCep: string = ''): TJsonObject;
  end;

implementation

{ TServices }

constructor TServices.Create;
begin
  FProvider := TProvider.Create;
end;

destructor TServices.Destroy;
begin
  if Assigned(FProvider) then
    FreeAndNil(FProvider);
  inherited;
end;

function TServices.BuscarCep(const aCep: string): TJsonObject;
var
  LQuery: TFDQuery;
begin

  try
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FProvider.Conexao;

      LQuery.SQL.Clear;
      LQuery.SQL.Add('SELECT cep,                              ');
      LQuery.SQL.Add('       uf,                               ');
      LQuery.SQL.Add('       descricao_bairro AS bairro,       ');
      LQuery.SQL.Add('       descricao_cidade as cidade,       ');
      LQuery.SQL.Add('       descricao_sem_numero as logradouro');
      LQuery.SQL.Add('FROM logradouro                          ');
      LQuery.SQL.Add('WHERE 1 = 1                              ');

      if not aCep.IsEmpty then
      begin
        LQuery.SQL.Add('AND cep = :cep');
        LQuery.ParamByName('cep').AsString := aCep;
      end;

      LQuery.Open;

      Result := LQuery.ToJSONObject;
    finally
      FreeAndNil(LQuery);
    end;
  except
    on E: Exception do
    begin
      if Assigned(LQuery) then
        FreeAndNil(LQuery);
      raise Exception.Create('Erro ao buscar CEP -> ' + E.Message);
    end;
  end;
end;

end.
