unit uModels.Cep;

interface

type
  TCepDetails = class
  private
    Fcep: String;
    Fuf: String;
    Fbairro: String;
    Fcidade: String;
    Flogradouro: String;
  public
    property cep: String read Fcep write Fcep;
    property uf: String read Fuf write Fuf;
    property bairro: String read Fbairro write Fbairro;
    property cidade: String read Fcidade write Fcidade;
    property logradouro: String read Flogradouro write Flogradouro;
  end;

  TCep = class
  private
    Fcep: TCepDetails;
  public
    property cep: TCepDetails read Fcep write Fcep;
  end;
implementation

end.
