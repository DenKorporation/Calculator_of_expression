unit calculation;

interface
uses
    System.SysUtils, System.Math,
    Parser;
type
    TCalculator = class
    public
        exprTree:TExpression;
        x:Real;//абсцисса

        function calculate(out ErrorMessage: String):Real;
    end;

    ECalcError = class(Exception);



implementation



{ TCaclulator }

function TCalculator.calculate(out ErrorMessage: String): Real;
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
                lDiv:
                begin
                    if right <> 0  then         //change with epsilon
                        value := left / right
                    else
                        raise ECalcError.Create('Division by zero');
                end;
                lPow:
                begin
                    try
                        value := Power(left, right);
                    except
                        raise ECalcError.Create('Incorrect power');
                    end;
                end;

            end;
        end else if curLexem in [lUPlus, lUMinus, lLg, lLn, lSin, lCos, lTan, lCtg, lSqrt] then
        begin
            left := calculate(pLeft);
            case curLexem of
                lUPlus:     value := left;
                lUMinus:    value := -left;
                lLg:
                begin
                    if (left > 0) then
                        value := Log10(left)
                    else
                        raise EcalcError.Create('The logarithm of a negative number');
                end;
                lLn:
                begin
                    if (left > 0) then
                        value := LogN(exp(1), left)
                    else
                        raise EcalcError.Create('The logarithm of a negative number');
                end;
                lSin:       value := Sin(left);
                lCos:       value := Cos(left);
                lTan:
                begin
                    try
                        value := Tan(left);
                    except
                        raise EcalcError.Create('tg(' + floatToStrf(left, ffGeneral, 10, 5) + 'not exist');
                    end;

                end;
                lCtg:
                begin
                    try
                        value := Cotan(left);
                    except
                        raise EcalcError.Create('ctg(' + floatToStrf(left, ffGeneral, 10, 5) + ') not exist');
                    end;

                end;
                lSqrt:
                begin
                    if left >= 0 then
                        value := Sqrt(left)
                    else
                        raise ECalcError.Create('sqrt of a negativ number');
                end;
            end;
        end else if curLexem = lVar then
            value := x;

        result := value;
    end;
End;
begin
    ErrorMessage := '';
    try
        result := calculate(exprTree);
    except
        on ex:ECalcError do
            ErrorMessage := ex.Message;
        else
            raise;
    end;
end;

end.
