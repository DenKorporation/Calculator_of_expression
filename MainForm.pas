unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Parser,
  Calculation, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs;

type
  TfrmMain = class(TForm)
    btnCalculate: TButton;
    lblHeadCalc: TLabel;
    lblAnswer: TLabel;
    PageCtrlMain: TPageControl;
    tabCalc: TTabSheet;
    tabGraph: TTabSheet;
    btnDraw: TButton;
    lblY: TLabel;
    lblHeadGraph: TLabel;
    lblGraphAns: TLabel;
    TabFileEnter: TTabSheet;
    btnChooseFile: TButton;
    btnNextExpr: TButton;
    btnToCalc: TButton;
    lblState: TLabel;
    btnToGraph: TButton;
    OpenTextFileDialog: TOpenTextFileDialog;
    btnGraphUp: TButton;
    btnGraphDown: TButton;
    btnGraphLeft: TButton;
    btnGraphRight: TButton;
    btnIncScale: TButton;
    btnDecScale: TButton;
    imgGraph: TPaintBox;
    editEnterExpression: TEdit;
    editEnterFunc: TEdit;
    lblDown3: TLabel;
    lblDown4: TLabel;
    lblDown2: TLabel;
    lblUp2: TLabel;
    lblUp3: TLabel;
    lblUp4: TLabel;
    lblDown5: TLabel;
    lblUp5: TLabel;
    lblDown1: TLabel;
    lblUp1: TLabel;
    procedure btnCalculateClick(Sender: TObject);
    procedure btnDrawClick(Sender: TObject);
    procedure btnChooseFileClick(Sender: TObject);
    procedure mainCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseEvent(Sender: TObject; var Action: TCloseAction);
    procedure mainCreate(Sender: TObject);
    procedure btnNextExprClick(Sender: TObject);
    procedure btnToCalcClick(Sender: TObject);
    procedure btnToGraphClick(Sender: TObject);
    procedure btnGraphLeftClick(Sender: TObject);
    procedure btnGraphRightClick(Sender: TObject);
    procedure btnGraphUpClick(Sender: TObject);
    procedure btnGraphDownClick(Sender: TObject);
    procedure btnDecScaleClick(Sender: TObject);
    procedure btnIncScaleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
    frmMain: TfrmMain;
    ExprFile: Text;
    fileIsOpened, exprIsRead: boolean;
    sclX, sclY: real;
    mGraphCalculator: TCalculator;
    gScale, gStep: Real;
    gMinX, gMaxX, gOffsetY: Real;

implementation

{$R *.dfm}

procedure DrawGraph (var mCalc:TCalculator; canv: TCanvas);
var
    xLow, xHigh: Real;
    y, step: real;
    xprev, yprev: real;
    max, min: real;
    xmid, ymid: real;
    ErrorMessage: String;
    isCalculate: boolean;
    tempStr: String;
begin
        xLow := gMinX;
        xHigh := gMaxX;
    sclX := (canv.ClipRect.Right) / (xHigh - xLow);//1 is sclX pixels
    sclY := sclX;
    step := 1 / sclX;

    xMid := canv.ClipRect.Right / 2;
    yMid := canv.ClipRect.Bottom / 2;

    canv.Brush.Color := clBlack;
    canv.FillRect(Rect(0, 0, canv.ClipRect.Right, canv.ClipRect.Bottom));
    canv.Pen.Color := clGray;

    canv.MoveTo(0, Round(ymid));
    canv.LineTo(canv.ClipRect.Right, Round(ymid));

    canv.MoveTo(0, Round(ymid / 2));
    canv.LineTo(canv.ClipRect.Right, Round(ymid / 2));

    canv.MoveTo(0, Round(3 * ymid / 2));
    canv.LineTo(canv.ClipRect.Right, Round(3 * ymid / 2));

    canv.MoveTo(Round(xmid), 0);
    canv.LineTo(Round(xmid), canv.ClipRect.Bottom);

    canv.MoveTo(round(xmid / 2), 0);
    canv.LineTo(Round(xmid / 2), canv.ClipRect.Bottom);

    canv.MoveTo(round(3 * xmid / 2), 0);
    canv.LineTo(Round(3 * xmid / 2), canv.ClipRect.Bottom);

    with frmMain do
    begin
        tempStr := FloatToStrf(xLow, ffGeneral, 10, 5);
        lblUp1.Caption := tempStr;
        lblDown1.Caption := tempStr;

        tempStr := FloatToStrf(xLow + (xmid / 2 * step), ffGeneral, 10, 5);
        lblUp2.Caption := tempStr;
        lblDown2.Caption := tempStr;

        tempStr := FloatToStrf(xLow + (xmid * step), ffGeneral, 10, 5);
        lblUp3.Caption := tempStr;
        lblDown3.Caption := tempStr;

        tempStr := FloatToStrf(xLow + (3 * xmid / 2 * step), ffGeneral, 10, 5);
        lblUp4.Caption := tempStr;
        lblDown4.Caption := tempStr;

        tempStr := FloatToStrf(xHigh, ffGeneral, 10, 5);
        lblUp5.Caption := tempStr;
        lblDown5.Caption := tempStr;
    end;

    //Axises
    canv.Pen.Color := clWhite;

    canv.MoveTo(0, Round(yMid + gOffSetY * SclY));
    canv.LineTo(canv.ClipRect.right, Round(yMid + gOffSetY * SclY));

    canv.MoveTo(Round(-xLow * sclX), 0);
    canv.LineTo(Round(-xLow * sclX), canv.clipRect.Bottom);


    canv.Pen.Color := clYellow;

    xPrev := xLow;
    mCalc.x := xPrev;
    yPrev := mCalc.calculate(errorMessage);
    isCalculate := length(ErrorMessage) = 0;

    mCalc.x := xLow + step;
    while mCalc.x <= xHigh do
    begin
        y := mCalc.calculate(errorMessage);
        if length(ErrorMessage) = 0  then
        begin
            if isCalculate then
            begin
                //draw
                canv.moveTo(Round((xPrev - xLow) * SclX), Round(ymid -(yPrev - gOffSetY) * SclY));
                canv.LineTo(Round((mCalc.x - xLow) * SclX), Round(ymid -(y - gOffSetY) * SclY));
            end;
            isCalculate := true;
        end else
            isCalculate := false;

        yPrev := y;
        xPrev := mCalc.x;

        mCalc.x := mCalc.x + step;
    end;


//    mCalc.x := gMinX;
//
//    max := 0;
//    min := max;
//
//    while mCalc.x <= gMaxX do
//    begin
//        y := mCalc.calculate(ErrorMessage);
//        if length(ErrorMessage) = 0 then
//        begin
//            if y < min then
//                min := y;
//            if y > max then
//                max := y;
//        end;
//        mCalc.x := mCalc.x + step;
//    end;
//
//    sclY := sclX;
////    if max = min then
////        sclY := sclX
////    else
////        sclY := canv.ClipRect.Bottom / (max - min);
//
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
begin
    sExpr := Self.editEnterFunc.Text;
    exprTree := nil;
    if (sExpr <> '') then
    begin
        exprTree := parseExpression(sExpr, true, isParsed, posOfError);

        if isParsed then
        begin
            gScale := 1.0;
            gMinX := -10;
            gMaxX := 10;
            gStep := 2;
            gOffsetY := 0;
            mGraphCalculator.Free;
            mGraphCalculator := TCalculator.Create;
            mGraphCalculator.exprTree := exprTree;

            lblGraphAns.Caption := '';

            DrawGraph(mGraphCalculator, imgGraph.Canvas);

            btnGraphUp.Enabled := true;
            btnGraphUp.Visible := true;

            btnGraphDown.Enabled := true;
            btnGraphDown.Visible := true;

            btnGraphLeft.Enabled := true;
            btnGraphLeft.Visible := true;

            btnGraphRight.Enabled := true;
            btnGraphRight.Visible := true;

            btnIncScale.Enabled := true;
            btnIncScale.Visible := true;

            btnDecScale.Enabled := true;
            btnDecScale.Visible := true;
        end else
            lblGraphAns.Caption := 'Incorrect expression '#13#10'Error in position:' + IntToStr(posOfError) + #13#10 +
                                'character: ' + sExpr[PosOfError];
    end else
        lblGraphAns.Caption := 'empty string';
    //exprTree.free;
end;


procedure TfrmMain.btnGraphLeftClick(Sender: TObject);
begin
    gMinX := gMinX - gStep * gScale;
    gMaxX := gMaxX - gStep * gScale;
    DrawGraph(mGraphCalculator, imgGraph.Canvas);
end;

procedure TfrmMain.btnGraphRightClick(Sender: TObject);
begin
    gMinX := gMinX + gStep * gScale;
    gMaxX := gMaxX + gStep * gScale;
    DrawGraph(mGraphCalculator, imgGraph.Canvas);
end;

procedure TfrmMain.btnGraphDownClick(Sender: TObject);
begin
    gOffsetY := gOffSetY - gStep * gScale;
    DrawGraph(mGraphCalculator, imgGraph.Canvas);
end;


procedure TfrmMain.btnGraphUpClick(Sender: TObject);
begin
    gOffsetY := gOffSetY + gStep * gScale;
    DrawGraph(mGraphCalculator, imgGraph.Canvas);
end;

procedure TfrmMain.btnIncScaleClick(Sender: TObject);
var
    temp: Real;
begin
    gScale := gScale * 1.1;

    temp := (gMaxX - gMinX) * 0.1 / 2;
    gMaxX := gMaxX - temp;
    gMinX := gMinX + temp;
    DrawGraph(mGraphCalculator, imgGraph.Canvas);
end;

procedure TfrmMain.btnDecScaleClick(Sender: TObject);
var
    temp: Real;
begin
    gScale := gScale / 1.1;

    temp := (gMaxX - gMinX) * 0.1 / 2;
    gMaxX := gMaxX + temp;
    gMinX := gMinX - temp;
    DrawGraph(mGraphCalculator, imgGraph.Canvas);
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

    mGraphCalculator.Free;

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
    gScale := 1.0;
    gMinX := -10;
    gMaxX := 10;
    gStep := 2;
    gOffsetY := 0;

    editEnterExpression.Text := 'Enter your expresion';
    editEnterFunc.Text := 'Enter your function';
end;

end.
