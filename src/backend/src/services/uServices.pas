unit UServices;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, uProvider, DB;

type
  TServices = class
  private
    FProvider: TProvider; // Classe de conexão com o banco de dados
  public
    constructor Create;
    destructor Destroy; override;

    function BuscarCep(const aCep: string): TDataSet;
  end;

implementation

{ TServices }

constructor TServices.Create;
begin
  FProvider := TProvider.Create; // Instancia a classe de conexão
end;

destructor TServices.Destroy;
begin
  if Assigned(FProvider) then
    FreeAndNil(FProvider); // Libera a memória corretamente
  inherited;
end;

function TServices.BuscarCep(const aCep: string): TDataSet;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil); // Criação da query
  try
    LQuery.Connection := FProvider.Conexao; // Usa a property Conexao da classe TProvider
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

    LQuery.Open; // Executa a consulta

    // Retorna o dataset resultante
    Result := LQuery;
  except
    on E: Exception do
    begin
      FreeAndNil(LQuery); // Libera a memória em caso de exceção
      raise Exception.Create('Erro ao buscar CEP: ' + E.Message);
    end;
  end;
end;

end.

