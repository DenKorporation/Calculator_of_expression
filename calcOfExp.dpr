program calcOfExp;
{$APPTYPE GUI}
//{$APPTYPE CONSOLE}
{$R *.res}

uses
    Vcl.Forms,
    System.SysUtils,
    MainForm in 'MainForm.pas' {frmMain};

begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
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



//procedure normalizeExpr(var mExpr:String);//Deleting all spaces
//var
//    I, temp, count:Integer;
//Begin
//    count := 0;
//    i := Low(mExpr);
//    While i <= High(mExpr) do
//    begin
//        if (mExpr[i] = ' ') or (mExpr[i] = #9) then
//        begin
//            if count = 0 then
//                temp := i;
//            Inc(count);
//        end
//        else if count <> 0 then
//        begin
//            Delete(mExpr, temp, count);
//            i := temp - 1;
//            count := 0;
//        end;
//        Inc(i);
//    end;
//End;
