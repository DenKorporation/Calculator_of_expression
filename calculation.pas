unit calculation;

interface
uses
    System.SysUtils, System.Math,
    Parser;

function calculate(var treeNode:TExpression):Real;

implementation

function calculate(var treeNode:TExpression):Real;//add checking of calculation
var                                               //and issue errors
    left, right:Real;
Begin
    with treeNode do
    begin
        if(curLexem <> lNum) then
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
        end;
        result := value;
    end;
End;

end.
