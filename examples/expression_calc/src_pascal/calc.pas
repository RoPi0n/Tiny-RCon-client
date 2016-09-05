program strcalc;
{$mode objfpc}

uses sysutils;

function eval(s:string):string;
 
  const
   op_add='+';
   op_sub='-';
   op_mul='*';
   op_div='/';

  type TTokenType=(ttop,ttnum);

  type TToken=record
   typ:TTokenType;
   val:string;
  end;

  var
   tokens:array of TToken;
   r:string;
   errors:boolean;

  procedure evalerror(m:string);
  begin
   errors:=true;
   r:=m;
  end;

  procedure parse(s:string);
  var
   l:string;
  begin
   l:='';
   setlength(tokens,0);
   repeat
    if (s[1] in [op_add,op_sub,op_mul,op_div]) then
     begin
       if length(l)<>0 then {tokens+left token}
       begin
        setlength(tokens,length(tokens)+1);
        with tokens[length(tokens)-1] do
         begin
          val:=l;
          typ:=ttnum;
         end;
        l:='';
       end;
        setlength(tokens,length(tokens)+1); {+,-,*,/}
        with tokens[length(tokens)-1] do
         begin
          val:=s[1];
          typ:=ttop;
         end;
        delete(s,1,1);
     end
      else
       begin
        l:=l+s[1];
        delete(s,1,1);
       end;
   until length(s)=0;
   if length(l)<>0 then
    begin
        setlength(tokens,length(tokens)+1);
        with tokens[length(tokens)-1] do
         begin
          val:=l;
          typ:=ttnum;
         end;
    end;
  end;

  procedure removetoken(index:word);
  var i:word;
  begin
   if index<>length(tokens)-1 then
    for i:=index to length(tokens)-2 do
     tokens[i]:=tokens[i+1];
   setlength(tokens,length(tokens)-1);    
  end;

  procedure correctops;
  var i:integer;
  begin
   i:=0;
   if (tokens[0].val=op_sub)and(tokens[1].typ=ttnum)
   then
    begin
     tokens[1].val:=op_sub+tokens[1].val;
     removetoken(0);
    end;
   repeat
    if (tokens[i].typ=ttop)     and   {-- = +}
       (tokens[i].val=op_sub)   and
       (tokens[i+1].typ=ttop)   and
       (tokens[i+1].val=op_sub) then
       begin
        removetoken(i+1);
        tokens[i].val:=op_add;
        dec(i);
       end
    else
    if (tokens[i].typ=ttop)     and   {++ = +}
       (tokens[i].val=op_add)   and
       (tokens[i+1].typ=ttop)   and
       (tokens[i+1].val=op_add) then
       begin
        removetoken(i+1);
        dec(i);
       end
    else
    if (tokens[i].typ=ttop)     and   {-+ = -}
       (tokens[i].val[1] in [op_sub,op_add])   and
       (tokens[i+1].typ=ttop)   and
       (tokens[i+1].val[1] in [op_sub,op_add]) then
       begin
        removetoken(i+1);
        tokens[i].val:=op_sub;
        dec(i);
       end
    else
    if (tokens[i].typ=ttnum)     and   {error}
       (tokens[i+1].typ=ttnum) then
       begin
        evalerror('ExpressionCalcError')
       end
    else
    if (tokens[i].typ=ttop)     and {**,//,/* error}
       (tokens[i].val[1] in [op_div,op_mul])   and
       (tokens[i+1].typ=ttop)   and
       (tokens[i+1].val[1] in [op_div,op_mul]) then
       begin
        evalerror('ExpressionCalcError')
       end
    else
    inc(i);
   until (length(tokens)=1)or(i=length(tokens)-1);
  end;

  procedure lvl1;  {* и /}
  var i:word;
  begin
   i:=0;
   repeat
    if tokens[i].val=op_mul then
     begin
      tokens[i-1].val:=floattostr
      (strtofloat(tokens[i-1].val)
       *
       strtofloat(tokens[i+1].val));
      removetoken(i+1);
      removetoken(i);
      dec(i);
     end else
    if tokens[i].val=op_div then
     begin
      tokens[i-1].val:=floattostr
      (strtofloat(tokens[i-1].val)
       /
       strtofloat(tokens[i+1].val));
      removetoken(i+1);
      removetoken(i);
      dec(i);
     end;
    inc(i);
   until i=length(tokens);
  end;

  procedure lvl2;
  var i:word;
  begin
   i:=0;
   repeat
    if tokens[i].val=op_add then
     begin
      tokens[i-1].val:=floattostr
      (strtofloat(tokens[i-1].val)
       +
       strtofloat(tokens[i+1].val));
      removetoken(i+1);
      removetoken(i);
      dec(i);
     end else
    if tokens[i].val=op_sub then
     begin
      tokens[i-1].val:=floattostr
      (strtofloat(tokens[i-1].val)
       -
       strtofloat(tokens[i+1].val));
      removetoken(i+1);
      removetoken(i);
      dec(i);
     end;  
    inc(i);
   until i=length(tokens);
  end;

begin
 errors:=false;
 parse(s);
 correctops;
 lvl1;
 lvl2;
 if errors=false then
  r:=tokens[0].val;
 result:=r;
end;

var s:string;
begin
 readln(s);
 writeln(eval(s));
end.
