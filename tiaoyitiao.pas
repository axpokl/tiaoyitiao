uses SysUtils,Windows,Display;

var w:longword=1080;
var h:longword=1920;
var dx:longword=981;
var dy:longword=563;
var rx0:longint=-31;
var ry0:longint=7;

var mult:double=1.342;
var tplus:longint=11;
var c0:longword=56+54*$100+83*$10000;

var t1:longword=400;
var t2:longword=200;
var t3:longword=1500;
var t4:longword=0;

var sc:ansistring='screen.png';
var bmp:pbitmap;
var bb:pbitbuf;

var rx,ry,rx1,ry1:longword;
var sx,sy,sx1,sx2:longword;
var ri,rj:longword;
var t,t0:longword;
var a,b:longword;
var c:longword;
var d:double;

procedure GetScreen();
begin
WinExec(PChar('adb shell screencap -p /sdcard/'+sc),0);
if FileExists(sc) then DeleteFile(sc);
sleep(t1);
WinExec(PChar('adb pull /sdcard/'+sc),0);
while not(FileExists(sc)) and IsWin() do ;
end;

procedure GetBMP();
begin
ReleaseBMP(bmp);
sleep(t2);
if IsWin() then
  begin
  bmp:=LoadBMP(sc);
  bb:=CreateBB(bmp);
  GetBB(bb);
  end;
end;

procedure FindColor(c:longword);
begin
rx:=0;
ry:=0;
for ri:=0 to w-1 do
for rj:=0 to h-1 do
if GetBBPixel(bb,ri,rj)=c then
  begin
  rx:=ri;
  ry:=rj;
  end;
rx:=max(0,rx+rx0);
ry:=max(0,ry+ry0);
end;

function FindEdge(y:longword;var x1,x2:longword):boolean;
begin
a:=5;b:=w div 2-30;
if rx<w div 2 then begin c:=a;a:=w-b;b:=w-c;end;
c:=GetBBPixel(bb,1,y);
FindEdge:=(c=GetBBPixel(bb,b,y));
if FindEdge then
  begin
  x1:=a;
  repeat
  x1:=x1+1;
  until (GetBBPixel(bb,x1,y)<>c) or (x1=b);
  x2:=b;
  repeat
  x2:=x2-1;
  until (GetBBPixel(bb,x2,y)<>c) or (x2=a);
  end
end;

procedure FindEdgeY();
begin
sy:=h div 5;
repeat
FindEdge(sy,sx1,sx2);
sy:=sy+1;
until (sy=h-1) or (sx2>a);
end;

procedure FindEdgeX();
begin
repeat
sx:=sx2;
sy:=sy+1;
FindEdge(sy,sx1,sx2);
until (sy=h div 2) or (sx2<=sx);
sx:=(sx1+sx2)div 2;
end;

procedure FindLine();
begin
c:=GetBBPixel(bb,sx,sy);
sx1:=sx;
repeat
sx1:=sx1-1;
until (sx1=0) or (GetBBPixel(bb,sx1,sy)<>c);
sx2:=sx;
repeat
sx2:=sx2+1;
until (sx2=w-1) or (GetBBPixel(bb,sx2,sy)<>c);
sx:=(sx1+sx2) div 2;
end;

procedure PressScreen(x,y,t:longword);
begin
WinExec(pchar('adb shell input swipe '+
i2s(x)+' '+i2s(y)+' '+i2s(x)+' '+i2s(y)+' '+i2s(t)),0);
end;

procedure LoadIni();
var f:text;
begin
if fileexists('tiaoyitiao.ini') then
  begin
  assign(f,'tiaoyitiao.ini');
  reset(f);
  read(f,w);readln(f);
  read(f,h);readln(f);
  read(f,dx);readln(f);
  read(f,dy);readln(f);
  read(f,rx0);readln(f);
  read(f,ry0);readln(f);
  read(f,mult);readln(f);
  read(f,tplus);readln(f);
  read(f,c0);readln(f);
  read(f,t1);readln(f);
  read(f,t2);readln(f);
  read(f,t3);readln(f);
  read(f,t4);readln(f);
  close(f);
  end;
end;

begin
LoadIni();
randomize();
CreateWin(w div 2,h div 2);
repeat
GetScreen();
GetBMP();
If IsWin() then
  begin
  FindColor(c0);
  if rx>0 then
    begin
    DrawBMP(bmp,_pmain,0,0,w,h,0,0,w div 2,h div 2);
    FindEdgeY();
    Bar(sx2 div 2-8,sy div 2-8,4,4,blue);
    FindEdgeX();
    Bar(rx div 2-4,ry div 2-4,8,8,green);
    Bar(sx1 div 2-2,sy div 2-2,4,4,blue);
    Bar(sx2 div 2-2,sy div 2-2,4,4,blue);
    Bar(sx div 2-2,sy div 2-2,4,4,red);

    sy:=round(981-abs(563-sx)/1.725);
    Bar(sx div 2-2,sy div 2-2,4,4,red);

    FindLine();
    Bar(sx1 div 2-4,sy div 2-4,8,8,blue);
    Bar(sx2 div 2-4,sy div 2-4,8,8,blue);
    Bar(sx div 2-4,sy div 2-4,8,8,red);
    d:=sqrt((rx-sx)*(rx-sx)+(ry-sy)*(ry-sy));
    t:=round(d*mult);
    writeln(rx,#9,ry,#9,sx,#9,sy,#9,t);
    FreshWin();
    if t0=t then
      begin
      PressScreen(w div 4+random(w div 2),h div 4+(h div 4),t+tplus);
      sleep(t3+random(t4));
      t0:=0;
      end
    else
      t0:=t;
    end;
  While IsNextMsg() do ;
  Sleep(1);
  end;
until not(iswin());
end.
