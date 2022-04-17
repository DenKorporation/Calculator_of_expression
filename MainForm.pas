unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Parser,
  Calculation, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    editEnterExpression: TEdit;
    btnCalculate: TButton;
    lblHeadCalc: TLabel;
    lblAnswer: TLabel;
    PageCtrlMain: TPageControl;
    tabCalc: TTabSheet;
    tabGraph: TTabSheet;
    editEnterFunc: TEdit;
    btnDraw: TButton;
    lblY: TLabel;
    lblHeadGraph: TLabel;
    imgGraph: TImage;
    lblGraphAns: TLabel;
    Label1: TLabel;
    procedure btnCalculateClick(Sender: TObject);
    procedure btnDrawClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

Type TFunc = function (var treeNode:TExpression):Real;

procedure DrawGraph (calc: TFunc; exprTree:TExpression; xLow: real; xHigh: real; canv: TCanvas);
var
    x, y, step: real;
    max, min: real;
    sclX, sclY: real;
    xmid, ymid: integer;
begin
    sclX := (canv.ClipRect.Right) / (xHigh - xLow);
    step := 1 / sclX;
    xMid := canv.ClipRect.Right div 2;
    yMid := canv.ClipRect.Bottom div 2;
    x := xLow;
    setX(x);
    max := calc(exprTree);
    min := max;
    while x <= xHigh do
    begin
        setX(x);
        y := calc(exprTree);
        if y < min then
            min := y;
        if y > max then
            max := y;
        x := x + step;
    end;
    if max = min then
        sclY := sclX
    else
        sclY := canv.ClipRect.Bottom / (max - min);
    canv.Brush.Color := clBlack;
    canv.FillRect(Rect(0, 0, canv.ClipRect.Right, canv.ClipRect.Bottom));
    canv.Pen.Color := clYellow;
    canv.MoveTo(0, ymid);
    canv.LineTo(canv.ClipRect.Right, ymid);
    canv.MoveTo(xmid, 0);
    canv.LineTo(xmid, canv.ClipRect.Bottom);
    x := xLow;
    setX(x);
    y := calc(exprTree);
    canv.Pen.Color := clWhite;
    canv.MoveTo(xmid + round(sclX * x), ymid - round(sclY * y));
    while x <= xHigh do
    begin
        setX(x);
        y := calc(exprTree);
        canv.LineTo(xmid + round(sclX * x), ymid - round(sclY * y));
        x := x + step;
    end;
end;


procedure TfrmMain.btnCalculateClick(Sender: TObject);
var
    sExpr:String;
    exprTree:TExpression; //head contain result of calculating the expression
    isParsed:boolean;
    ans:String;
    PosOfError:Integer;
begin
    sExpr := Self.editEnterExpression.Text;
    exprTree := nil;
    if (sExpr <> '') then
    begin
        exprTree := parseExpression(sExpr, false, isParsed, posOfError);

        if isParsed then
        begin
            ans := FloatToStrf(calculate(exprTree), ffGeneral, 15, 5);
            lblAnswer.Caption := ans;
        end
        else
            lblAnswer.Caption := 'Incorrect expression '#13#10'Error in position:' + IntToStr(posOfError) + #13#10 +
                                'character: ' + sExpr[PosOfError];
    end else
        lblAnswer.Caption := 'empty string';
    exprTree.free;
end;

procedure TfrmMain.btnDrawClick(Sender: TObject);   //check this shit
var
    sExpr:String;
    exprTree:TExpression; //head contain result of calculating the expression
    isParsed:boolean;
    ans:String;
    PosOfError:Integer;
begin
    sExpr := Self.editEnterFunc.Text;
    exprTree := nil;
    if (sExpr <> '') then
    begin
        exprTree := parseExpression(sExpr, true, isParsed, posOfError);

        if isParsed then
        begin
            lblGraphAns.Caption := '';
            DrawGraph(calculate, exprTree, -10, 10, imgGraph.Canvas);
        end
        else
            lblGraphAns.Caption := 'Incorrect expression '#13#10'Error in position:' + IntToStr(posOfError) + #13#10 +
                                'character: ' + sExpr[PosOfError];
    end else
        lblGraphAns.Caption := 'empty string';
    exprTree.free;
end;

end.
