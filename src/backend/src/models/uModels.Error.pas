unit uModels.Error;

interface

type
  TError = class
  private
    Fstatus : Integer;
    Fresult : String;

  public
   property status : integer read Fstatus write Fstatus;
   property result : String read Fresult write Fresult;
  end;

implementation

end.
