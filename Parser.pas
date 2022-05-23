unit Parser;

interface
type
    TLexem = (lAdd, lSub, lMul, lDiv, lPow, lLBrack, lRBrack, lNum, lVar,
    lUPlus, lUMinus, lLg, lLn, lSin, lCos, lTan, lCtg, lSqrt); //left/right bracket   unary plus/minus
    TExpression = class
    public
        value: real;
        curLexem: TLexem;
        pLeft: TExpression;
        pRight: TExpression;
        constructor Create;
        destructor Destroy;
    end;

function ParseExpression(sExpr:string; varSupport:boolean; out isParsed:boolean; out posOfError:Integer):TExpression;

implementation

uses
  System.SysUtils, System.Math;

function ParseExpression(sExpr:string; varSupport:boolean; out isParsed:boolean; out posOfError:Integer):TExpression; //in future add posOfError:Integer as attribute
var
    Pos:integer;
    ExprSize:Integer;


procedure SkipWhiteSpaces();
begin
    while (pos <= ExprSize) and (sExpr[pos] in [' ', #9]) do
        Inc(pos);
end;



function ParseNumber():real; //change this fuck shit //через StrTofloat, или что-то типо
var
    size, cod:Integer;
begin
    result := 0;
    isParsed := false;
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
        if not isParsed then
            pos := pos - size + cod - 1;
    end;
end;



function ParseOperator():Tlexem;
begin
    result := lNum;
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
            ')': result := lRBrack;
            'x': result := lVar
            else isParsed := False
        end;
        if isParsed then
            Inc(Pos);
    end;
end;



function ParseFunction():TExpression;forward;

function ParseGroup():TExpression;forward;

//atom->number|variable|group
function ParseAtom():TExpression;
var
    tempPos:Integer;
    tempLexem:TLexem;
    tempExpr:TExpression;
    minusPos: Integer;
begin
    tempPos := Pos;
    minusPos := Pos;
    tempLexem := parseOperator;
    if not (tempLexem in [lAdd, lSub]) then
        Pos := tempPos;


    result := parseFunction;
    if (result = nil) then
    begin
        tempPos := Pos;
        result := ParseGroup;
        if (result = nil) and (tempLexem <> lLBrack) then
        begin
            Pos := tempPos;
            Result := TExpression.Create;
            with Result do
            begin
                curLexem := ParseOperator;
                if (curLexem = lVar) and not varSupport then
                begin
                    Dec(Pos);
                    isParsed := false;
                end else if curLexem = lNum then
                    value := parseNumber
                else if curLexem <> lVar then
                begin
                    Dec(Pos);
                    isParsed := false;
                end;
            end;
            if not isParsed then
            begin
                if tempLexem in [lAdd, lSub] then
                    Pos := minusPos;

                Result.Destroy;
                Result := nil;
            end;
        end;
    end;



    if (result <> nil) and (tempLexem in [lAdd, lSub]) then
    begin
        tempExpr := TExpression.Create;
        if tempLexem = lAdd then
            tempExpr.curLexem := lUPlus
        else
            tempExpr.curLexem := lUMinus;
        tempExpr.pLeft := result;
        result := tempExpr;
    end;
end;


//power->atom|atom^power
function ParsePower():TExpression;
var
    tempPos:Integer;
    tempPtr:TExpression;
begin
    Result := TExpression.Create;
    with result do
    begin
        pLeft := parseAtom;
        if (pLeft <> nil) then
        begin
            tempPos := Pos;
            curLexem := parseOperator;
            if (isParsed and (curLexem = lPow)) then
            begin
                pRight := ParsePower;
                if not isParsed then
                begin
                    result.free;
                    result := nil
                end;
            end else
            begin
                Pos := tempPos;
                SkipWhiteSpaces;
                tempPtr := pLeft;
                pLeft := nil;
                result.free;
                result := tempPtr;
                isParsed := true;
            end;
        end else
        begin
            result.free;
            result := nil
        end;
    end;
end;



//MulDiv->Power(('*' Power)|('/' Power))*
function ParseMulDiv():TExpression;
var
    tempPos:Integer;
    tempPtr:TExpression;
    isEndOfParsing:boolean;
begin
    Result := TExpression.Create;
    with result do
    begin
        pLeft := ParsePower;
        isEndOfParsing := pLeft = nil;
        while not isEndOfParsing do
        begin
            tempPos := Pos;
            curLexem := ParseOperator;
            if(isParsed and (curLexem in [lMul, lDiv])) then
            begin
                pRight := ParsePower;
                if (pRight <> nil) then
                begin
                    tempPtr := TExpression.Create;
                    tempPtr.pLeft := pLeft;
                    tempPtr.pRight := pRight;
                    tempPtr.curLexem := curLexem;
                    pLeft := tempPtr;
                end else
                begin
                    result.free;
                    result := nil;
                    isEndOfParsing := true;
                end;
            end else
            begin
                Pos := tempPos;
                SkipWhiteSpaces;
                tempPtr := pLeft;
                pLeft := nil;
                result.free;
                result := tempPtr;
                isParsed := true;
                isEndOfParsing := true;
            end;
        end;
        if not isParsed then
        begin
            result.free;
            result := nil
        end;
    end;
end;



//AddSub->MulDiv(('+' MulDiv)|('-' MulDiv))*
function ParseAddSub():TExpression;
var
    tempPos:Integer;
    tempPtr:TExpression;
    isEndOfParsing:boolean;
begin
    Result := TExpression.Create;
    with result do
    begin
        pLeft := ParseMulDiv;
        isEndOfParsing := pLeft = nil;
        while not isEndOfParsing do
        begin
            tempPos := Pos;
            curLexem := ParseOperator;
            if(isParsed and (curLexem in [lAdd, lSub])) then
            begin
                pRight := ParseMulDiv;
                if (pRight <> nil) then
                begin
                    tempPtr := TExpression.Create;
                    tempPtr.pLeft := pLeft;
                    tempPtr.pRight := pRight;
                    tempPtr.curLexem := curLexem;
                    pLeft := tempPtr;
                end else
                begin
                    result.free;
                    result := nil;
                    isEndOfParsing := true;
                end;
            end else
            begin
                Pos := tempPos;
                SkipWhiteSpaces;
                tempPtr := pLeft;
                pLeft := nil;
                result.free;
                result := tempPtr;
                isParsed := true;
                isEndOfParsing := true;
            end;
        end;
        if not isParsed then
        begin
            result.free;
            result := nil
        end;
    end;
end;


//Group->'(' addsub ')'
function ParseGroup():TExpression;
var
    tempPos:Integer;
    tempLexem:TLexem;
begin
    tempPos := Pos;
    tempLexem := ParseOperator;
    if(isParsed) and (tempLexem = lLBrack) then
    begin
        result := ParseAddSub;
        if Pos > ExprSize then
        begin
            Pos := tempPos;
            SkipWhiteSpaces;
            isParsed := false;
            Result.free;
            Result := nil;
        end else
        begin
            if isParsed then
            begin
                tempPos := Pos;
                tempLexem := parseOperator;
                if not isParsed or (tempLexem <> lRBrack) then
                begin
                    Pos := tempPos;
                    SkipWhiteSpaces;
                    isParsed := false;
                    Result.free;
                    Result := nil;
                end;
            end;
        end;
    end else
    begin
        Pos := tempPos;
        SkipWhiteSpaces;
        isParsed := false;
        result := nil;
    end;
end;




function ParseFunction():TExpression;
var
    size, cod, tempPos:Integer;
    tempValue: real;
    name: String;
    tempLexem: TLexem;
    tempExpr: TExpression;
begin
    result := nil;
    SkipWhiteSpaces;
    tempPos := Pos;
    if(Pos > ExprSize) then
        isParsed := false
    else
    begin
        size := 0;
        while (pos <= ExprSize) and (sExpr[pos] in ['a'..'z', 'A'..'Z']) do
        begin
            Inc(size);
            Inc(pos);
        end;
        name := copy(sExpr, pos - size, size);
        isParsed := true;

        if name = 'lg' then
            tempLexem := lLg
        else if name = 'ln' then
            tempLexem := lLn
        else if name = 'cos' then
            tempLexem := lCos
        else if name = 'sin' then
            tempLexem := lSin
        else if name = 'tg' then
            tempLexem := lTan
        else if name = 'ctg' then
            tempLexem := lCtg
        else if name = 'sqrt' then
            tempLexem := lSqrt
        else if name = 'e' then
        begin
            tempLexem := lNum;
            tempValue := Exp(1.0);
        end
        else if name = 'pi' then
        begin
            tempLexem := lNum;
            tempValue := pi;
        end else
            isParsed := false;

        if isParsed then
        begin
            if tempLexem <> lNum then
            begin
                result := parseGroup;
                if result <> nil then
                begin
                    tempExpr := TExpression.Create;
                    tempExpr.curLexem := tempLexem;
                    tempExpr.pLeft := result;
                    result := tempExpr;
                end;
            end else
            begin
                result := TExpression.Create;
                with result do
                begin
                    curLexem := tempLexem;
                    value := tempValue;
                end;
            end;
        end else
            Pos := tempPos;
    end;
end;



begin
    Pos := Low(sExpr);
    ExprSize := High(sExpr);

    sExpr := LowerCase(sExpr);

    result := ParseAddSub;

    if Pos <= ExprSize then
    begin
        PosOfError := Pos;
        isParsed := false;
        Result.Free;
        result := nil;
    end else
        PosOfError := -1;
end;

{ TExpression }

constructor TExpression.Create;
begin
    value := 0;
    curLexem := lNum;
    pLeft := nil;
    PRight := nil;
end;

destructor TExpression.Destroy;
begin
    pLeft.Free;
    pRight.Free;
end;

end.
