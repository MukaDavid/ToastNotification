unit uToastNotification;

interface
uses
  Androidapi.JNI.Widget, System.UITypes;

type
  TToastLength = (ShortToast, LongToast);

  TToastLengthHelper = record helper for TToastLength
    function ToAndroidLength: integer;
  end;

  TToastNotification = class
  private
    FText: string;
    FDuration: TToastLength;
    FColor: TAlphaColor;
    FXOffset: Integer;
    FYOffset: Integer;
    FGravity: integer;
    FMinimumWidth: Integer;
    FMinimumHeight: Integer;
    FCustomText: Boolean;
    FTextColor: TAlphaColor;
    FTextSize: Single;
  public
    constructor Create;
    class procedure Show(pMsg: string; pDuration: TToastLength = ShortToast); overload;
    class procedure ShowCalendar(pDate: TDate; pDuration: TToastLength = ShortToast); overload;
    procedure Show; overload;
    property Text: string read FText write FText;
    property Duration: TToastLength read FDuration write FDuration;
    property Color: TAlphaColor read FColor write FColor;
    property Gravity: integer read FGravity write FGravity;
    property XOffset: Integer read FXOffset write FXOffset;
    property YOffset: Integer read FYOffset write FYOffset;
    property MinimumWidth: Integer read FMinimumWidth write FMinimumWidth;
    property MinimumHeight: Integer read FMinimumHeight write FMinimumHeight;
    property CustomText: Boolean read FCustomText write FCustomText;
    property TextColor: TAlphaColor read FTextColor write FTextColor;
    property TextSize: Single read FTextSize write FTextSize;
  end;


implementation
uses
  FMX.Helpers.Android, Androidapi.Helpers, Androidapi.JNI.JavaTypes, System.DateUtils,
  Androidapi.JNI.GraphicsContentViewText, FMX.Platform.UI.Android, System.Types, System.SysUtils;


{ TToastNotification }

class procedure TToastNotification.Show(pMsg: string; pDuration: TToastLength);
begin
  CallInUiThread(procedure
  begin
    TJToast.JavaClass.makeText(TAndroidHelper.Context,
                               StrToJCharSequence(pMsg),
                               pDuration.ToAndroidLength).show;
  end);
end;

constructor TToastNotification.Create;
begin
  FGravity := -1;
end;

procedure TToastNotification.Show;
begin
  CallInUiThread(procedure
  var
    lToast: JToast;
  begin
    lToast := TJToast.JavaClass.makeText(TAndroidHelper.Context,
                               StrToJCharSequence(FText),
                               FDuration.ToAndroidLength);


    lToast.getView.getBackground.setColorFilter(FColor, TJPorterDuff_Mode.JavaClass.SRC_IN);
    if FGravity <> -1 then
    begin
      var lPointFGravity := ConvertPointToPixel(TPointF.Create(FXOffset,FYOffset));
      lToast.setGravity(FGravity,Trunc(lPointFGravity.X),Trunc(lPointFGravity.Y));
    end;

    var lPointFTamanho := ConvertPointToPixel(TPointF.Create(FMinimumWidth,FMinimumHeight));
    lToast.getView.setMinimumWidth(Trunc(lPointFTamanho.X));
    lToast.getView.setMinimumHeight(Trunc(lPointFTamanho.Y));


    if FCustomText then
    begin
      var lResourceID := TAndroidHelper.Activity.getResources.getIdentifier(
                                   StringToJString('message'),
                                   StringToJString('id'),
                                   StringToJString('android'));

      if lResourceID <> 0 then
      begin
        var lText := TJTextView.wrap(lToast.getView.findViewById(lResourceID));
        lText.setTextColor(FTextColor);
        lText.setTextSize(FTextSize);
      end;
    end;

    lToast.show;
  end);
end;

class procedure TToastNotification.ShowCalendar(pDate: TDate; pDuration: TToastLength);
var
  lJView: JCalendarView;
begin
  lJView := TJCalendarView.JavaClass.init(TAndroidHelper.Context);
  lJView.setDate(DateTimeToUnix(pDate + 1) * MSecsPerSec);
  
  CallInUiThread(procedure
  var
    lToast: JToast;
  begin
    lToast := TJToast.JavaClass.init(TAndroidHelper.Context);
    lToast.setView(lJView);
    lToast.SetDuration(TJToast.JavaClass.LENGTH_LONG);
    lToast.show;
  end);
end;

{ TToastLengthHelper }

function TToastLengthHelper.ToAndroidLength: integer;
begin
  case self of
    ShortToast: result := TJToast.JavaClass.LENGTH_SHORT;
    LongToast: result := TJToast.JavaClass.LENGTH_LONG;
  end;
end;

end.
