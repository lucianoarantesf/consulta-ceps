unit uRetornoCEP;

interface

type
  TRetornoCEP = class
  private
    FCep: string;
    FUf: string;
    FEndereco: string;
    FBairro: string;
    FCidade: string;
  public
    property Cep: string read FCep write FCep;
    property Uf: string read FUf write FUf;
    property Endereco: string read FEndereco write FEndereco;
    property Bairro: string read FBairro write FBairro;
    property Cidade: string read FCidade write FCidade;

    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils;

{ TRetornoCEP }

function TRetornoCEP.ToString: string;
begin
  Result := Format('CEP: %s, UF: %s, Endereço: %s, Bairro: %s, Cidade: %s',
    [FCep, FUf, FEndereco, FBairro, FCidade]);
end;

end.

