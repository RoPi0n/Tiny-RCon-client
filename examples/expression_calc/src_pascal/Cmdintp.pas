program mcmd;
uses sysutils, strutils;

const rword: array[0..1] of string=('','');


function trim(s:string):string;
begin
s:=' '+s+' ';
 repeat
  delete(s,1,1);
 until (s[1]<>' ')or(length(s)=0);
 repeat
  delete(s,length(s),1);
 until (s[length(s)]<>' ')or(length(s)=0);
trim:=s;
end;

function smartlowercase(s:string):string;
var q:boolean;
begin
 smartlowercase:='';
 if length(s)=0 then exit;
 q:=false;
 repeat
  if (s[1]='#')and(q=false)
  then exit;
  if (s[1]='"')
  then q:=not q;
  if (q=true)
  then smartlowercase:=
       smartlowercase+s[1]
  else
  begin
       if not ((s[1]=s[2])and(s[1]=' ')) then
       smartlowercase:=
       smartlowercase+
       lowercase(s[1]);
  end;
  delete(s,1,1);
 until length(s)=0;
end;

function getfirststr(s:string):string;
var r:string;
begin
 r:='';
 delete(s,1,1);
 repeat
  if s[1]<>'"' then begin r:=r+s[1];
  delete(s,1,1); end;
 until (s[1]='"')or(length(s)=0);
 getfirststr:='"'+r+'"';
end;

function getfirstobj(s:string):string;
var r:string;
begin
 r:='';
 if s[1]='"' then begin
  getfirstobj:=getfirststr(s);
  exit;
 end;
 repeat
  if {isalpha(s[1])}s[1]<>' ' then r:=r+s[1];
  delete(s,1,1);
 until (s[1]=' ')or(length(s)=0);
 getfirstobj:=r;
end;

function getfirsttkn(s:string):string;
var x,y:integer;
begin
s:=trim(s);
 for x:=0 to length(rword)-1 do
 if (copy(s,0,length(rword[x]))=rword[x])
 and (s[length(rword[x])+1]=' ') then
  begin
   getfirsttkn:=copy(s,0,length(rword[x]));
   if getfirsttkn='"' then getfirsttkn:=getfirststr(s);
  end
 else getfirsttkn:=getfirstobj(s);
end;

function cutfirsttkn(s:string):string;
begin
 s:=trim(s);
 delete(s,1,length(getfirsttkn(s)));
 cutfirsttkn:=trim(s);
end;

function isstr(s:string):boolean;
begin
 isstr:=(s[1]='"')and(s[length(s)]='"')and
        (pos('"',copy(s,2,length(s)-2))=0);
end;

function getstr(s:string):string;
begin
 if isstr(s) then getstr:=copy(s,2,length(s)-2)
 else getstr:=s;
end;

var c:array of string;

procedure convert(str:string);
begin
 repeat
  setlength(c,length(c)+1);
  c[length(c)-1]:=getstr(getfirsttkn(str));
  str:=cutfirsttkn(str);
 until length(str)=0;
end;

procedure listen;
var s:string; 
begin
 readln(s);
 s:=smartlowercase(s);
 s:=trim(s);
 convert(s);
end;

var cmds:array[0..4] of ansistring=(
'echo',
'chdir',
'createfile',
'deletefile',
'dir'
);


procedure work;
var f:textfile;
begin
 if length(c)<>0 then
 begin
  case AnsiIndexStr(c[0],cmds) of
   0:writeln(c[1]);
   1:chdir(c[1]);
   2:begin
      assign(f,c[1]);
      rewrite(f);
      close(f);
     end;
   3:deletefile(c[1]);
   4:writeln(getcurrentdir);
   else writeln('Error: $1');
  end;
 end;
end;

procedure prepare;
begin
 setlength(c,0);
end;

begin
 writeln('#shell');
 repeat
  write('~>');
  prepare;
  listen;
  work;
 until false;
end.
