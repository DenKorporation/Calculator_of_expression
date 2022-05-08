unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Parser,
  Calculation, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs;

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
    TabFileEnter: TTabSheet;
    btnChooseFile: TButton;
    btnNextExpr: TButton;
    btnToCalc: TButton;
    lblState: TLabel;
    btnToGraph: TButton;
    OpenTextFileDialog: TOpenTextFileDialog;
    procedure btnCalculateClick(Sender: TObject);
    procedure btnDrawClick(Sender: TObject);
    procedure btnChooseFileClick(Sender: TObject);
    procedure mainCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseEvent(Sender: TObject; var Action: TCloseAction);
    procedure mainCreate(Sender: TObject);
    procedure btnNextExprClick(Sender: TObject);
    procedure btnToCalcClick(Sender: TObject);
    procedure btnToGraphClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  ExprFile: Text;
  fileIsOpened, exprIsRead: boolean;

implementation

{$R *.dfm}

procedure DrawGraph (mCalc:TCalculator; xLow: real; xHigh: real; canv: TCanvas);
var
    y, step: real;
    xprev, yprev: real;
    max, min: real;
    sclX, sclY: real;
    xmid, ymid: integer;
    ErrorMessage: String;
    isCalculate: boolean;

begin
    sclX := (canv.ClipRect.Right) / (xHigh - xLow);
    step := 1 / sclX;
    xMid := canv.ClipRect.Right div 2;
    yMid := canv.ClipRect.Bottom div 2;

    mCalc.x := xLow;

    max := 0;
    min := max;

    while mCalc.x <= xHigh do
    begin
        y := mCalc.calculate(ErrorMessage);
        if length(ErrorMessage) = 0 then
        begin
            if y < min then
                min := y;
            if y > max then
                max := y;
        end;
        mCalc.x := mCalc.x + step;
    end;

    sclY := sclX;
//    if max = min then
//        sclY := sclX
//    else
//        sclY := canv.ClipRect.Bottom / (max - min);

    canv.Brush.Color := clBlack;
    canv.FillRect(Rect(0, 0, canv.ClipRect.Right, canv.ClipRect.Bottom));
    canv.Pen.Color := clYellow;
    canv.MoveTo(0, ymid);
    canv.LineTo(canv.ClipRect.Right, ymid);
    canv.MoveTo(xmid, 0);
    canv.LineTo(xmid, canv.ClipRect.Bottom);


    canv.Pen.Color := clWhite;
    //canv.MoveTo(xmid + round(sclX * x), ymid - round(sclY * y));

    xPrev := xLow;
    mCalc.x := xPrev;
    yPrev := mCalc.calculate(errorMessage);
    isCalculate := length(ErrorMessage) = 0;

    mCalc.x := xLow + step;
    while mCalc.x <= xHigh do
    begin
        y := mCalc.calculate(errorMessage);
        //canv.LineTo(xmid + round(sclX * mCalc.x), ymid - round(sclY * y));
        if length(ErrorMessage) = 0  then
        begin
            if isCalculate then
            begin
                //draw
                //canv.Ellipse(xmid + round(sclX * mCalc.x) - 1, ymid - round(sclY * y) - 1,
                //xmid + round(sclX * mCalc.x) + 1, ymid - round(sclY * y) + 1);
                canv.MoveTo(xmid + round(sclX * xPrev), ymid - round(sclY * yPrev));
                canv.LineTo(xmid + round(sclX * mCalc.x), ymid - round(sclY * y));
            end;
            isCalculate := true;
        end else
            isCalculate := false;


        yPrev := y;
        xPrev := mCalc.x;

        mCalc.x := mCalc.x + step;
    end;
end;


procedure TfrmMain.btnCalculateClick(Sender: TObject);
var
    sExpr:String;
    exprTree:TExpression; //head contain result of calculating the expression
    isParsed:boolean;
    ans, errorMessage:String;
    PosOfError:Integer;
    mCalculator: TCalculator;
begin
    sExpr := Self.editEnterExpression.Text;
    exprTree := nil;
    if (sExpr <> '') then
    begin
        exprTree := parseExpression(sExpr, false, isParsed, posOfError);

        if isParsed then
        begin
            mCalculator := TCalculator.Create;
            mCalculator.exprTree := exprTree;

            ans := FloatToStrf(mCalculator.calculate(errorMessage), ffGeneral, 15, 5);
            if(Length(errorMessage) <> 0) then
                ans := errorMessage;
            lblAnswer.Caption := ans;
            mCalculator.Free;
        end
        else
            lblAnswer.Caption := 'Incorrect expression '#13#10'Error in position:' + IntToStr(posOfError) + #13#10 +
                                'character: ' + sExpr[PosOfError];
    end else
        lblAnswer.Caption := 'empty string';
    exprTree.free;
end;

procedure TfrmMain.btnChooseFileClick(Sender: TObject);
begin
    if OpenTextFileDialog.Execute then
    begin
        if fileIsOpened then
        begin
            CloseFile(ExprFile);
            fileIsOpened := false;
        end;
        AssignFile(ExprFile,OpenTextFileDialog.FileName);
        Reset(ExprFile);
        FileIsOpened := true;
        exprIsRead := false;
        lblState.Caption := 'File is opened';
    end;
end;

procedure TfrmMain.btnDrawClick(Sender: TObject);   //check this shit
var
    sExpr:String;
    exprTree:TExpression; //head contain result of calculating the expression
    isParsed:boolean;
    ans:String;
    PosOfError:Integer;
    mCalculator: TCalculator;
begin
    sExpr := Self.editEnterFunc.Text;
    exprTree := nil;
    if (sExpr <> '') then
    begin
        exprTree := parseExpression(sExpr, true, isParsed, posOfError);

        if isParsed then
        begin
            mCalculator := TCalculator.Create;
            mCalculator.exprTree := exprTree;

            lblGraphAns.Caption := '';

            DrawGraph(mCalculator, -10, 10, imgGraph.Canvas);
            mCalculator.Free;
        end
        else
            lblGraphAns.Caption := 'Incorrect expression '#13#10'Error in position:' + IntToStr(posOfError) + #13#10 +
                                'character: ' + sExpr[PosOfError];
    end else
        lblGraphAns.Caption := 'empty string';
    exprTree.free;
end;


procedure TfrmMain.btnNextExprClick(Sender: TObject);
var
    temp: String;
begin
    if not EoF(ExprFile) then
    begin
        while EoLn(ExprFile) do
            Readln(ExprFile, temp);

        exprIsRead := true;
        Readln(ExprFile, temp);
        lblState.Caption := temp;
    end else
        ShowMessage('end of file');
end;

procedure TfrmMain.btnToCalcClick(Sender: TObject);
begin
    PageCtrlMain.ActivePage := tabCalc;
    if ExprIsRead then
    begin
        editEnterExpression.Text := lblState.Caption;
        frmMain.btnCalculateClick(btnCalculate);
    end;
end;

procedure TfrmMain.btnToGraphClick(Sender: TObject);
begin
    PageCtrlMain.ActivePage := tabGraph;
    if ExprIsRead then
    begin
        editEnterFunc.Text := lblState.Caption;
        frmMain.btnDrawClick(btnDraw);
    end;
end;

procedure TfrmMain.CloseEvent(Sender: TObject; var Action: TCloseAction);
begin

    if fileIsOpened then
        CloseFile(ExprFile);

    Action := caFree;
end;

procedure TfrmMain.mainCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := MessageDlg ('Хотите выйти?',mtConfirmation,[mbYes,mbNo],0) = mrYes
end;

procedure TfrmMain.mainCreate(Sender: TObject);
begin
    fileIsOpened := false;
    exprIsRead := false;
end;

end.
