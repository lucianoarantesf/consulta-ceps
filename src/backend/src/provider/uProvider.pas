unit uProvider;

interface

uses
  System.SysUtils,
  FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client;

type
  TProvider = class
  private
    FConexao: TFDConnection;

    function GetConexao: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    property Conexao: TFDConnection read GetConexao;
  end;

implementation

{ TProvider }

constructor TProvider.Create;
begin
  FConexao := nil;
end;

destructor TProvider.Destroy;
begin
  if Assigned(FConexao) then
    FreeAndNil(FConexao);
  inherited;
end;

function TProvider.GetConexao: TFDConnection;
begin
  if not Assigned(FConexao) then
  begin
    FConexao := TFDConnection.Create(nil);
    try
      FConexao.DriverName := 'MySQL'; // Alterado para MySQL
      {$IFDEF DEBUG}
        FConexao.Params.Values['Server'] := 'localhost';
        FConexao.Params.Values['Database'] := 'dbsCeps'; // Nome do banco de dados no MySQL
      {$ELSE}
        FConexao.Params.Values['Server'] := GetEnvironmentVariable('DB_HOST');
        FConexao.Params.Values['Database'] := GetEnvironmentVariable('DB_NAME');
      {$ENDIF}
      FConexao.Params.Values['Port'] := '3306'; // A porta padrão do MySQL é 3306
      FConexao.Params.Values['User_Name'] := 'admin'; // Alterar para o nome do usuário do MySQL
      FConexao.Params.Values['Password'] := 'masterkey'; // Alterar para a senha do usuário do MySQL

      FConexao.Connected := True;
    except
      on E: Exception do
      begin
        FreeAndNil(FConexao);
        raise Exception.Create('Erro ao configurar a conexão: ' + E.Message);
      end;
    end;
  end;

  Result := FConexao;
end;

end.

