unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TFPrincipal = class(TForm)
    mmResultado: TMemo;
    GroupBox1: TGroupBox;
    mskEditCep: TMaskEdit;
    lblTtCep: TLabel;
    btnConsultar: TButton;
    GroupBox2: TGroupBox;
    mskEditCepInicial: TMaskEdit;
    lblTtCepInicial: TLabel;
    mskEditCepFinal: TMaskEdit;
    lblTtCepFinal: TLabel;
    GroupBox3: TGroupBox;
    imgLogo: TImage;
    mskEditIntervalo: TMaskEdit;
    lblTituloIntervalo1: TLabel;
    lblTituloIntervalo2: TLabel;
    GroupBox4: TGroupBox;
    btnIniciar: TButton;
    Timer: TTimer;
    procedure btnConsultarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIniciarClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FcepInicial : String;
    FcepFinal : String;
    Fintervalo : integer;
    FConsultaEmExecucao: Boolean;
    procedure ConsultarCEP(aCEP: String = '');
    procedure ConsultarFaixaDeCEPs(const aCEPInicial, aCEPFinal: String);
  public
    { Public declarations }
    property cepInicial : String read FcepInicial write FcepInicial;
    property cepFinal : String read FcepFinal write FcepFinal;
    property intervalo : integer read Fintervalo write Fintervalo;
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

uses
  uConsultaCEP, uRetornoCEP;


procedure TFPrincipal.ConsultarCEP(aCEP: String);
var
  ConsultaCEP: TConsultaCEP;
  RetornoCEP: TRetornoCEP;
begin
  try
    TThread.CreateAnonymousThread(
      procedure
      begin

        ConsultaCEP := TConsultaCEP.Create;
        try

          RetornoCEP := ConsultaCEP.ConsultarCEP(aCEP);
          try
            TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                mmResultado.Lines.Text := RetornoCEP.ToString;
              end);
          finally
            RetornoCEP.Free;
          end;
        finally
          ConsultaCEP.Free;
        end;

      end).start();

  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFPrincipal.ConsultarFaixaDeCEPs(const aCEPInicial, aCEPFinal: String);
var
  CepInicial, CepFinal, CepAtual: Integer;
  ConsultaCEP: TConsultaCEP;
  RetornoCEP: TRetornoCEP;
begin
  if FConsultaEmExecucao then
  begin
    ShowMessage('Já existe uma consulta de faixa em andamento.');
    Exit;
  end;

  FConsultaEmExecucao := True;

  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        CepInicial := StrToInt(aCEPInicial);
        CepFinal := StrToInt(aCEPFinal);

        ConsultaCEP := TConsultaCEP.Create;
        try
          CepAtual := CepInicial;
          while (CepAtual <= CepFinal) and not TThread.CheckTerminated do
          begin
            try
              RetornoCEP := ConsultaCEP.ConsultarCEP(FormatFloat('00000000', CepAtual));
              try
                TThread.Synchronize(nil,
                  procedure
                  begin
                    mmResultado.Lines.Add(RetornoCEP.ToString);
                  end);
              finally
                RetornoCEP.Free;
              end;

              Sleep(500);
            except
              on E: Exception do
              begin
                TThread.Synchronize(nil,
                  procedure
                  begin
                    mmResultado.Lines.Add(Format('Erro ao consultar %s: %s',  [FormatFloat('00000-000', CepAtual), E.Message]));
                  end);
              end;
            end;
            Inc(CepAtual);
          end;
        finally
          ConsultaCEP.Free;
        end;

      finally
        TThread.Synchronize(nil,
          procedure
          begin
            FConsultaEmExecucao := False;
            mmResultado.Lines.Add('Consulta de faixa de CEPs finalizada.');
          end);
      end;
    end).start;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  mskEditCep.SetFocus;
  fcepInicial := '';
  fcepFinal   := '';
  Fintervalo  := 0;
  Timer.Enabled := False;
  Timer.Interval := 60000;

end;

procedure TFPrincipal.TimerTimer(Sender: TObject);
begin
  if FConsultaEmExecucao then
  begin
    ShowMessage('A consulta automática está aguardando a execução anterior finalizar.');
    Exit;
  end;

  mmResultado.Lines.Clear;
  mmResultado.Lines.Add('Iniciando consulta automática...');
  ConsultarFaixaDeCEPs(FcepInicial, FcepFinal);
end;

procedure TFPrincipal.btnConsultarClick(Sender: TObject);
begin
  ConsultarCEP(StringReplace(mskEditCep.Text, '-', '',
    [rfReplaceAll, rfIgnoreCase]));
end;

procedure TFPrincipal.btnIniciarClick(Sender: TObject);
begin
  try
    fcepInicial := StringReplace(mskEditCepInicial.Text, '-', '',  [rfReplaceAll]);
    fcepFinal   := StringReplace(mskEditCepFinal.Text, '-', '', [rfReplaceAll]);
    Fintervalo  := StrToIntDef(mskEditIntervalo.Text,0) * 60000;

    if btnIniciar.Tag = 0 then
    begin
      if Fintervalo = 0 then
       raise Exception.Create('O Intervalo deve ser maior que Zero para iniciar.');

      btnIniciar.Caption := 'Parar';
      btnIniciar.Tag := 1;

      Timer.Interval := Fintervalo;
      Timer.Enabled := True;
    end
    else
    begin
      btnIniciar.Caption := 'Iniciar';
      btnIniciar.Tag := 0;

      Timer.Interval := 0;
      Timer.Enabled := False;
    end;



  except
   on e:Exception do
   ShowMessage(e.Message);
  end;
end;

end.
