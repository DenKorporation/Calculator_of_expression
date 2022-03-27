program calcOfExp;
{$APPTYPE CONSOLE}
{$R *.res}

uses
    System.SysUtils;

type
    TLexem = (lAdd, lSub, lMul, lDiv, lPow, lLBrack, lRBrack, lNum); //left/right bracket
    TArrOfLexems = array of TLexem;
    pExpression = ^TExpression;
    TExpression = record
        value: Real;
        curLexem: TLexem;
        pLeft: pExpression;
        PRight: pExpression;
    end;

const
    AvailableOperation : array[lAdd..lRBrack] of string =
        ('+', '-', '*', '/', '^', '(', ')');

var
    sExpr:String;
    exprTree:pExpression; //head contain result of calculating the expression


    function ExpressionInit():String;      //read Expression
Begin                                  //in the Future, choice between form and file Input will be implemnted
    readln(result);
End;


procedure normalizeExpr(var mExpr:String);//Deleting all spaces
var
    I, temp, count:Integer;
Begin
    count := 0;
    i := Low(mExpr);
    While i <= High(mExpr) do
    begin
        if mExpr[i] = ' ' then
        begin
            if count = 0 then
                temp := i;
            Inc(count);
        end
        else if count <> 0 then
        begin
            Delete(mExpr, temp, count);
            i := temp - 1;
            count := 0;
        end;
        Inc(i);
    end;
End;

function ParseExpression(sExpr:string):TExpression;        //in future add posOfError:Integer as attribute
begin

end;



function calculate(var treeNode:pExpression):Real;
var
    left, right:Real;
Begin
    with treeNode^ do
    begin
        if(curLexem <> lNum) then
        begin
            left := calculate(treeNode^.pLeft);  //guess that always exists left and right branch
            right := calculate(treeNode^.pRight);
            case curLexem of
                lAdd: value := left + right;
                lSub: value := left - right;
                lMul: value := left * right;
                lDiv: value := left / right;
            end;
        end;
        result := value;
    end;
End;

begin
    sExpr := ExpressionInit();
    normalizeExpr(sExpr);
    writeln(sExpr);
    readln;
end.










//////////////////GARBAGE///////////////////////////////

//function IsDigit(const str: string): boolean;
//var
//i: integer;
//begin
//    result :=
//    for i := 1 to length(str) do
//    begin
//        if not(str[i] in ['0' .. '9']) then
//            exit;
//    end;
//    result := true;
//end;
