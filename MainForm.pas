unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Parser,
  Calculation, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    editEnterExpression: TEdit;
    btnCalculate: TButton;
    lblHead: TLabel;
    lblAnswer: TLabel;
    PageCtrlMain: TPageControl;
    tabCalc: TTabSheet;
    tabGraph: TTabSheet;
    procedure btnCalculateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCalculateClick(Sender: TObject);
var
    sExpr:String;
    exprTree:TExpression; //head contain result of calculating the expression
    isParsed:boolean;
    ans:String;
begin
    sExpr := Self.editEnterExpression.Text;
    exprTree := nil;
    if (sExpr <> '') then
    begin
        exprTree := parseExpression(sExpr, isParsed);
        if isParsed then
        begin
            ans := FloatToStrf(calculate(exprTree), ffGeneral, 15, 5);
            lblAnswer.Caption := ans;
        end
        else
            lblAnswer.Caption := 'Incorrect expression';
    end else
        lblAnswer.Caption := '';
    exprTree.free;
end;

end.
