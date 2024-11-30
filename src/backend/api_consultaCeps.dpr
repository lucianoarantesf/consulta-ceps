program api_consultaCeps;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.GBSwagger,
  System.SysUtils,
  uProvider in 'src\provider\uProvider.pas',
  uServices in 'src\services\uServices.pas',
  uController in 'src\controllers\uController.pas',
  uModels.Cep in 'src\models\uModels.Cep.pas',
  uModels.Error in 'src\models\uModels.Error.pas';

begin
  THorse.Use(HorseSwagger);

  TController.registry;

  Swagger
    .Info
      .Title('Api Cep')
      .Description('Documentação Api consulta CEP')
      .Contact
        .Name('Luciano Arantes Filho')
        .Email('contato.lucianoarantes@gamil.com')
        .URL('https://github.com/lucianoarantesf')
      .&End
    .&End
    .BasePath('/')
    .Path('cep')
      .Tag('Cep')
      .GET('Consulta Cep')
        .AddParamQuery('cep','Cep').&End
        .AddResponse(200,'Listando os dados CEP').Schema(TCep).&End
        .AddResponse(500,'Listando os erros').Schema(TError).&End
      .&End
    .&End
    .&End;

  THorse.Listen(8082);

end.
