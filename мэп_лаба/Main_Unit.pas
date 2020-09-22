unit Main_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls,
  MapWorldToPixel;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    btDrawGraph: TButton;
    btsavedata: TBitBtn;
    btReadData: TBitBtn;
    Label1: TLabel;
    Curve_Length: TLabel;
    procedure btDrawGraphClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btReadDataClick(Sender: TObject);
    procedure btsavedataClick(Sender: TObject);
  private
    x, y, z : array of real;
    nPoints : integer;
    a,b : real; // �������� ��� ����������� �������
    yTop, yBottom, xLeft, xRight: real;
    Pantograph:  TSimplePantograph;

    procedure Calculate_Function;
    procedure Redraw_Picture(x, y, z: Array Of Real);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

procedure TForm1.Calculate_Function;
var
  i : integer;
begin
  SetLength(x, nPoints+1);
  SetLength(y, nPoints+1);
  for i := 0 to nPoints do
   begin
    // ��� ����� ���������!
      x[i] := a+(i-1)*(b-a)/(nPoints-1);
      //y[i] := sin(x[i]);
      //z[i] := cos(x[i]);
      y[i] := (1/cos(x[i]) + 1/cos(x[i]*x[i])*cos(x[i]*x[i])*cos(x[i]*x[i]) + 0.5*x[i])/Exp(2*x[i]*(-3));
      z[i] := (x[i]*x[i]-1)/ln(-x[i])/ln(10);
    end;
end;

function Curvelength(x, y : array of real) : real;
var
  i : integer;
  s : real;
begin
  s := 0;
  for i := low(x) to High(x)-2 do
      s := s+sqrt(sqr(x[i+1]-x[i])+sqr(y[i+1]-y[i]));
  result := s;
end;

function SaveFileNameDlg(var fName: string): boolean;
var
  SaveDialog : TSaveDialog;
  OldDir : String;
begin
// ������� ������
  SaveDialog := TSaveDialog.Create(Application);
  SaveDialog.DefaultExt := '*.txt';
  SaveDialog.Filter := '|txt (*.txt)|*.txt';
  SaveDialog.FilterIndex := 1;
  // � ����� �������� �� ���������?
  GetDir(0, OldDir);
  // ������� � ������� �������
  ChDir(ExtractFileDir(FName));
  SaveDialog.InitialDir := ExtractFileDir(FName);
  // ��� ����� ��� ������ �� ���������
  SaveDialog.FileName := 'Data_Out.txt';
  if SaveDialog.Execute then begin
    fName := SaveDialog.FileName;
    result := true;
  end
  else
    result := false;
  ChDir(OldDir);
  SaveDialog.Free;
end;

function OpenFileNameDlg(var fName: string): boolean;
var
  OpenDialog: TOpenDialog;
  OldDir: string;
begin
  OpenDialog := TOpenDialog.Create(Application);
  try
    OpenDialog.DefaultExt := '*.txt';
    OpenDialog.Filter := '��� ����� (*.*)|*.*|����� (*.txt)|*.txt|';
    OpenDialog.FilterIndex := 1;
    GetDir(0, OldDir);
    ChDir(ExtractFilePath(FName));
    OpenDialog.FileName := ExtractFilePath(FName)+'data.txt';
    if OpenDialog.Execute
    then begin
      fName := OpenDialog.FileName;
      result := true;
    end
    else result := false;
    ChDir(OldDir);
  finally
    OpenDialog.Free;
  end;
end;

procedure TForm1.btDrawGraphClick(Sender: TObject);
begin
  Redraw_Picture(x, y, z);
end;

procedure TForm1.btReadDataClick(Sender: TObject);
var
  Ok : boolean;
  OpenedFile: TextFile;
  DataTextName : string;
begin
  DataTextName := Application.ExeName; // ��� ����������� �������� ��������
  if OpenFileNameDlg(DataTextName)
  then   // ���� ������ ��� ����� ��� ������, ��
  begin
  {$I-}
    // ��������� ���� ��� ������
    AssignFile(OpenedFile, DataTextName);
    Reset(OpenedFile);
  {$I+}
    Ok := (IoResult = 0); // ��������?
    try
      if Ok then // ��������
        begin
          ReadLN(OpenedFile); // ������ ������ ������: ��������;
          ReadLN(OpenedFile, NPoints);
          ReadLN(OpenedFile, a, b);
        end
        else
          begin
            MessageDlg('���� �� ��������',  mtInformation, [mbOk], 0);
          end;
    finally
      if Ok then CloseFile(OpenedFile);
    end;
  end;
  Calculate_Function;
end;

procedure TForm1.btsavedataClick(Sender: TObject);
var
  Ok : boolean;
  i : integer;
  SaveFile: TextFile;
  DataTextName : string;

begin
  DataTextName := Application.ExeName; // ��� ����������� �������� ��������
  if SaveFileNameDlg(DataTextName)
  then   // ���� ������ ��� ����� ��� ������, ��
  begin
  {$I-}
    // ��������� ���� ��� ������
    AssignFile(SaveFile, DataTextName);
    Rewrite(SaveFile);
  {$I+}
    Ok := (IoResult = 0); // ��������?
    try
      if Ok then // ��������
        begin
          WriteLN(SaveFile, '������ ������� ');
          WriteLN(SaveFile, '����� ����� ', #9, NPoints:2, #9);
          for i:=0 to NPoints-1 do
          begin
            WriteLN(SaveFile, x[i]:12:5, #9, y[i]:12:5, #9, z[i]:12:5, #9);
          end;
        end
        else
          begin
            MessageDlg('���� �� ��������',  mtInformation, [mbOk], 0);
          end;
    finally
      if Ok then CloseFile(SaveFile);
    end;

  end;
end;

procedure TForm1.Redraw_Picture(x, y, z: Array Of Real);
Var
  Bitmap :  TBitmap;
  i : integer;
  // ����������� ��� ��������� �������� ������ ��������
  // ������ �� Bitmap'e
begin
  xLeft:= a-1;
  xRight := b+1;
  yTop := 1;
  yBottom:= -1.0;
  Bitmap := TBitmap.Create;
  Bitmap.Width  := Image1.Width;
  Bitmap.Height := Image1.Height;
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Canvas.Brush.Color := clGray;
  Bitmap.Canvas.FillRect(Rect(0,0,Bitmap.Width,Bitmap.Height));
  // ��������� ������������ ����� ����� ������� � ������ ������ ������ ������ �
  // ����� ������� � ������ ������ ������ ��������� ���������

  Pantograph := TSimplePantograph.Create(Bitmap.Canvas,
                                         Rect(0,0,Bitmap.Width-1,Bitmap.Height-1),
                                         RealRect(xLeft, yTop, xRight, yBottom) );
  Bitmap.Canvas.Pen.Width := 2;
  Bitmap.Canvas.Pen.style := psSolid;
  Bitmap.Canvas.Pen.Color := clYellow;
  // DrawAxis
  Pantograph.MoveTo(xLeft, 0);
  Pantograph.LineTo(xRight, 0);
  Pantograph.MoveTo(0, yBottom);
  Pantograph.LineTo(0, yTop);
  Bitmap.Canvas.Pen.style := psSolid;
  Bitmap.Canvas.Pen.Width := 2;
  Bitmap.Canvas.Pen.Color := clBlue;
  for i:=0 to NPoints-1 do  //������ �������
    If   i = 0 then Pantograph.MoveTo(x[0],y[0])
               else Pantograph.LineTo(x[i],y[i]);

  Bitmap.Canvas.Pen.Width := 1;
  Bitmap.Canvas.Pen.Color := clRed;
  for i := 0 to NPoints - 1 do // ������ �������
    If i = 0 then
      Pantograph.MoveTo(x[0], z[0])
    else
      Pantograph.LineTo(x[i], z[i]);
  Image1.Picture.Graphic := Bitmap;
  Bitmap.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
  nPoints := 20;
  a := -1;
  b := -0.05; // �������� ��� ����������� �������
  SetLength(x, nPoints+1);
  SetLength(y, nPoints+1);
  SetLength(z, nPoints + 1);
  for i := 0 to nPoints do
    begin
      x[i] := a+(i)*(b-a)/(nPoints-1);
      // � ��� ���������!
      //y[i] := sin(x[i]);
      //z[i] := cos(x[i]);
      y[i] := (1/cos(x[i]) + 1/cos(x[i]*x[i])*cos(x[i]*x[i])*cos(x[i]*x[i]) + 0.5*x[i])/Exp(2*x[i]*(-3));
      if i = 0 then
        continue
      else
        z[i] := (x[i]*x[i]-1)/ln((-1)*x[i])/ln(10);
    end;
  Curve_Length.Caption := FloatToStr(CurveLength(x, y));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  x := nil;
  y := nil;
  z := nil;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Redraw_Picture(x, y, z);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Redraw_Picture(x, y, z);
end;

end.
