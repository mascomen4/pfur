program Work_TextFile;

uses
  Forms,
  Main_Unit in 'Main_Unit.pas' {Form1},
  MapWorldToPixel in 'MapWorldToPixel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
