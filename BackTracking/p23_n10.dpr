program p23_n10;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {Form1},
  URoads in 'URoads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
