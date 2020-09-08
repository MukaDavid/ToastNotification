program AppToastNotification;

uses
  System.StartUpCopy,
  FMX.Forms,
  FToastNotification in 'FToastNotification.pas' {frmToastNotification},
  uToastNotification in 'uToastNotification.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmToastNotification, frmToastNotification);
  Application.Run;
end.
