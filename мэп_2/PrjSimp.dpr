program PrjSimp;

uses
  Vcl.Forms,
  Main_Unit in 'Main_Unit.pas' {Form2},
  utypes in 'utypes.pas',
  usimplex in 'usimplex.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
