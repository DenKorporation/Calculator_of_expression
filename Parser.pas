unit Parser;

interface
type
    TLexem = (lAdd, lSub, lMul, lDiv, lPow, lLBrack, lRBrack, lNum); //left/right bracket
    pExpression = ^TExpression;
    TExpression = class
    public
        value: Real;
        curLexem: TLexem;
        pLeft: TExpression;
        pRight: TExpression;
        constructor Create;
        destructor Destroy;
    end;

function ParseExpression(sExpr:string; out isParsed:boolean):TExpression;

implementation

uses
  System.SysUtils;

//const
//    AvailableOperation : array[lAdd..lRBrack] of string =
//        ('+', '-', '*', '/', '^', '(', ')');

function ParseExpression(sExpr:string; out isParsed:boolean):TExpression;        //in future add posOfError:Integer as attribute
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
    result := 0;
    SkipWhiteSpaces;
    if(Pos > ExprSize) then
        isParsed := false
    else
    begin
        size := 0;
        if (pos <= ExprSize) and (sExpr[pos] = '-') then
        begin
            Inc(Pos);
            Inc(Size);
        end;
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
            ')': result := lRBrack
            else isParsed := False  //mb result := lNum
        end;
        if isParsed then
            Inc(Pos);
    end;
end;



function ParseGroup():TExpression;forward;

//atom->number|variable|group in future
function ParseAtom():TExpression;
var
    tempPos:Integer;
begin
    tempPos := Pos;
    result := ParseGroup;
    if(result = nil) then
    begin
        Pos := tempPos;
        Result := TExpression.Create;
        with Result do
        begin
            curLexem := lNum;
            value := parseNumber;
        end;
    end;

    if not isParsed then
    begin
        result.Free;
        result := nil
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
        if(pLeft <> nil) then
        begin
            tempPos := Pos;
            curLexem := parseOperator;
            if(isParsed and (curLexem = lPow)) then
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
                tempPtr := pLeft;
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


//MulDiv->Power|power*mulDiv|power/MulDiv //some problem
//MulDiv->Power(('*' Power)|('/' Power))*
function ParseMulDiv():TExpression;
var
    tempPos:Integer;
    tempPtr:TExpression;
    isEndOfParsing:boolean;
begin
    Result := TExpression.Create;
    isEndOfParsing := false;
    with result do
    begin
        pLeft := ParsePower;
        while (pLeft <> nil) and not isEndOfParsing do
        begin
                tempPos := Pos;//check this
            curLexem := ParseOperator;
            if(isParsed and ((curLexem = lMul) or (curLexem = lDiv))) then
            begin    
                pRight := parsePower;
                if(pRight <> nil) then
                begin
                    tempPtr := TExpression.Create;
                    tempPtr.pLeft := pLeft;
                    tempPtr.pRight := pRight;
                    tempPtr.curLexem := curLexem;
                    pLeft := tempPtr;
                end else
                begin
                    result.free;
                    result := nil    
                end;
            end else
            begin
                Pos := tempPos;
                tempPtr := pLeft;
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

//AddSub->MulDiv|MulDiv+AddSub|MulDiv-AddSub //some problem (12 / 12 / 12) for example
//AddSub->MulDiv(('+' MulDiv)|('-' MulDiv))*
function ParseAddSub():TExpression;
var
    tempPos:Integer;
    tempPtr:TExpression;
    isEndOfParsing:boolean;
begin
    Result := TExpression.Create;
    isEndOfParsing := false;
    with result do
    begin
        pLeft := ParseMulDiv;
        while (pLeft <> nil) and not isEndOfParsing do
        begin
                tempPos := Pos;//check this
            curLexem := ParseOperator;
            if(isParsed and ((curLexem = lAdd) or (curLexem = lSub))) then
            begin    
                pRight := ParseMulDiv;
                if(pRight <> nil) then
                begin
                    tempPtr := TExpression.Create;
                    tempPtr.pLeft := pLeft;
                    tempPtr.pRight := pRight;
                    tempPtr.curLexem := curLexem;
                    pLeft := tempPtr;
                end else
                begin
                    result.free;
                    result := nil
                end;
            end else
            begin
                Pos := tempPos;
                tempPtr := pLeft;
                result.free;
                result := tempPtr;
                isParsed := true;
                isEndOfParsing := true;
            end;
        end;
        if pLeft = nil then
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
        if isParsed then
        begin
            tempLexem := parseOperator;
            if not isParsed or (tempLexem <> lRBrack) then
            begin
                isParsed := false;
                result := nil;
            end;
        end else
        begin
            isParsed := false;
            result := nil;
        end;
    end else
    begin
        Pos := tempPos;
        isParsed := false;
        result := nil;
    end;
end;



begin
    Pos := Low(sExpr);
    ExprSize := High(sExpr);

        result := ParseAddSub;//change
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
