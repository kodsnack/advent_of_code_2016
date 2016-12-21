program Day01;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Types, Classes;

var
  CurrentPoint:TPoint;
  aNESW:byte;
  slInstructions:TStringList;
  sInstruction:string;
  iLength:integer;
begin
  CurrentPoint:=TPoint.Zero;
  aNESW:=$88;
  slInstructions:=TStringList.Create;
  try
    slInstructions.LoadFromFile('input.txt');
    slInstructions.Text:=StringReplace(slInstructions.Text,', ',System.sLineBreak,[rfReplaceAll]);
    for sInstruction in slInstructions do
    begin
      iLength:=StrToInt(copy(sInstruction,2,length(sInstruction)-1));
      if sInstruction[1]='L' then
      asm
        rol aNESW,1
      end else
      asm
        ror aNESW,1
      end;
      case aNESW and $F of
        $1:dec(CurrentPoint.X,iLength);
        $2:inc(CurrentPoint.Y,iLength);
        $4:inc(CurrentPoint.X,iLength);
        $8:dec(CurrentPoint.Y,iLength);
      end;
    end;
    WriteLn('X='+IntToStr(CurrentPoint.X)+', Y='+IntToStr(CurrentPoint.Y));
    WriteLn('Blocks='+IntToStr(Abs(CurrentPoint.X)+Abs(CurrentPoint.Y)));
    WriteLn('Distance='+FormatFloat('0.00',CurrentPoint.Distance(TPoint.Zero)));
  finally
    slInstructions.Free;
  end;
end.
