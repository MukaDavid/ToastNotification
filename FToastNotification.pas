unit FToastNotification;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  FMX.Objects, uToastNotification, Androidapi.JNI.GraphicsContentViewText,
  FMX.DateTimeCtrls, FMX.EditBox, FMX.SpinBox, FMX.ListBox, FMX.Colors;

type
  TfrmToastNotification = class(TForm)
    Layout1: TLayout;
    edtText: TEdit;
    btnShowToastCalendar: TButton;
    Layout2: TLayout;
    btnShowToast: TButton;
    btnShowToastColor: TButton;
    ColorComboBox: TColorComboBox;
    SpinBoxTextSize: TSpinBox;
    Layout3: TLayout;
    ColorComboBoxText: TColorComboBox;
    cbxCustomFont: TCheckBox;
    Label1: TLabel;
    dteCalendar: TDateEdit;
    procedure btnShowToastClick(Sender: TObject);
    procedure btnShowToastColorClick(Sender: TObject);
    procedure btnShowToastCalendarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmToastNotification: TfrmToastNotification;

implementation

{$R *.fmx}


procedure TfrmToastNotification.btnShowToastCalendarClick(Sender: TObject);
begin
  TToastNotification.ShowCalendar(dteCalendar.Date, TToastLength.LongToast);
end;

procedure TfrmToastNotification.btnShowToastClick(Sender: TObject);
begin
  TToastNotification.Show(edtText.Text);
end;

procedure TfrmToastNotification.btnShowToastColorClick(Sender: TObject);
var
  lToastNotification : TToastNotification;
begin
  lToastNotification := TToastNotification.Create;
  try
    lToastNotification.Text := edtText.Text;
    lToastNotification.Duration := TToastLength.LongToast;
    lToastNotification.Color := ColorComboBox.Color;
    lToastNotification.Gravity := TJGravity.JavaClass.AXIS_CLIP or TJGravity.JavaClass.TOP;
    lToastNotification.XOffset := 0;
    lToastNotification.YOffset := 200;
    lToastNotification.MinimumWidth  := 300;
    lToastNotification.MinimumHeight := 150;
    lToastNotification.CustomText := cbxCustomFont.IsChecked;
    lToastNotification.TextColor := ColorComboBoxText.Color;
    lToastNotification.TextSize := SpinBoxTextSize.Value;

    lToastNotification.Show;
  finally
    lToastNotification.Free;
  end;
end;

end.
