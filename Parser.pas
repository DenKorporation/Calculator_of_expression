unit Parser;

interface
type
    TLexem = (lAdd, lSub, lMul, lDiv, lPow, lLBrack, lRBrack, lNum); //left/right bracket
    pExpression = ^TExpression;
    TExpression = record
        value: Real;
        curLexem: TLexem;
        pLeft: pExpression;
        pRight: pExpression;
    end;

function ExpressionInit():String;
function ParseExpression(sExpr:string; out isParsed:boolean):pExpression;

implementation

uses
  System.SysUtils;

//const
//    AvailableOperation : array[lAdd..lRBrack] of string =
//        ('+', '-', '*', '/', '^', '(', ')');


function ExpressionInit():String;      //read Expression
Begin                                  //in the Future, choice between form and file Input will be implemnted
    readln(result);
End;

function ParseExpression(sExpr:string; out isParsed:boolean):pExpression;        //in future add posOfError:Integer as attribute
var
    Pos:integer;
    ExprSize:Integer;


procedure SkipWhiteSpaces();
begin
    while (pos <= ExprSize) and (sExpr[pos] in [' ', #9]) do
        Inc(pos);
end;



function ParseNumber():Real;
var
    size, cod:Integer;
begin
    SkipWhiteSpaces;
    if(Pos > ExprSize) then
        isParsed := false
    else
    begin
        size := 0;
        while (pos <= ExprSize) and (sExpr[pos] in ['0'..'9', '.']) do
        begin
            Inc(size);
            Inc(pos);
        end;

        val(copy(sExpr, pos - size, size), Result, cod);
        isParsed := cod = 0;
    end;
end;



function ParseOperator():Tlexem;
var
    cod:Integer;
begin
    SkipWhiteSpaces;
    if(Pos > ExprSize) then
        isParsed := false
    else
    begin
        isParsed := true;
        case sExpr[Pos] of
            '+': result := lAdd;
            '-': result := lSub;
            '*': result := lMul;
            '/': result := lDiv;
            '^': result := lPow;
            '(': result := lLBrack;
            ')': result := lRBrack
            else isParsed := False  //mb result := lNum
        end;
        if isParsed then
            Inc(Pos);
    end;
end;


//number|variable|group
function ParseAtom():pExpression;  //atom is equal to term
begin
    New(result);
    result^.pLeft := nil;
    result^.pRight := nil;
    result^.curLexem := lNum;
    result^.value := parseNumber();

    if not isParsed then
        Dispose(result);
end;


//term('^' term)*
function ParsePower():pExpression;
begin

end;


//power(('*' power)|('/' power))*
function ParseMulDiv():pExpression;
begin

end;


//MulDiv(('+' MulDiv)|('-' MulDiv))*
function ParseAddSub():pExpression;
begin

end;



begin
    Pos := Low(sExpr);
    ExprSize := High(sExpr);

        result := parseAtom();//change
end;

end.
