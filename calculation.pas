unit calculation;

interface
uses
    System.SysUtils, System.Math,
    Parser;

function calculate(var treeNode:TExpression):Real;

procedure setX (value: Real);

implementation

var
    x: Real;

function calculate(var treeNode:TExpression):Real;//add checking of calculation
var                                               //and issue(raise/monitor) errors
    left, right:Real;
Begin
    with treeNode do
    begin
        if  not(curLexem in [lNum, lVar, lUPlus, lUMinus, lLg,
                lLn, lSin, lCos, lTan, lCtg, lSqrt]) then
        begin
            left := calculate(pLeft);  //guess that always exists left and right branchs
            right := calculate(pRight);
            case curLexem of
                lAdd: value := left + right;
                lSub: value := left - right;
                lMul: value := left * right;
                lDiv: value := left / right;
                lPow: value := Power(left, right);
            end;
        end else if curLexem in [lUPlus, lUMinus, lLg, lLn, lSin, lCos, lTan, lCtg, lSqrt] then
        begin
            left := calculate(pLeft);
            case curLexem of
                lUPlus:     value := left;
                lUMinus:    value := -left;
                lLg:        value := Log10(left);
                lLn:        value := LogN(exp(1), left);
                lSin:       value := Sin(left);
                lCos:       value := Cos(left);
                lTan:       value := Tan(left);
                lCtg:       value := Cotan(left);
                lSqrt:      value := Sqrt(left);
            end;
        end else if curLexem = lVar then
            value := x;

        result := value;
    end;
End;

procedure setX (value: Real);
begin
    x := value;
end;

end.
