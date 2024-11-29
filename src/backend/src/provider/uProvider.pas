unit uProvider;

interface

uses
  System.SysUtils,
{$IFDEF MSWINDOWS}
  FireDAC.Phys.MySQLDef,
{$ELSE}
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
{$ENDIF}
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys,
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
      FConexao.Connected := False;
      FConexao.DriverName := 'MySQL';

      {$IFDEF MSWINDOWS}
        FConexao.Params.Values['Server']       := 'localhost';
        FConexao.Params.Values['Database']     := 'dbsCeps';
        FConexao.Params.Values['Port']         := '3306';
        FConexao.Params.Values['User_Name']    := 'admin';
        FConexao.Params.Values['Password']     := 'masterkey';
        FConexao.Params.Values['CharacterSet'] := 'utf8mb4';
      {$ELSE}
        FConexao.Params.Values['Server']    := GetEnvironmentVariable('DB_HOST');
        FConexao.Params.Values['Database']  := GetEnvironmentVariable('DB_NAME');
        FConexao.Params.Values['Port']      := GetEnvironmentVariable('DB_PORT');
        FConexao.Params.Values['User_Name'] := GetEnvironmentVariable('DB_USER');
        FConexao.Params.Values['Password']  := GetEnvironmentVariable('DB_PASSWORD');
        FConexao.Params.Values['CharacterSet'] := 'utf8mb4';
        FConexao.Params.Values['Protocol']     := 'TCPIP';
      {$ENDIF}
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
