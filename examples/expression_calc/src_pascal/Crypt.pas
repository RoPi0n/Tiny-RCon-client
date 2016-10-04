//compressor
function cryptstring(s:string):string;
var b:string;
begin
 b:='';
 cryptstring:='';
 if length(s)=0 then exit;
 repeat
  b:=b+inttostr(
   ord(s[1])+255
  );
  delete(s,1,1);
 until length(s)=0;
 cryptstring:=b;
end;

const repA:array[1..107] of string=(
'100','200','300','400','700','800','900',
'00','01','02','03','04','05','06','07','08','09',
'10','11','12','13','14','15','16','17','18','19','20',
'21','22','23','24','25','26','27','28','29','30','31',
'32','33','34','35','36','37','38','39','40','41','42',
'43','44','45','46','47','48','49','50','51','52','53',
'54','55','56','57','58','59','60','61','62','63','64',
'65','66','67','68','69','70','71','72','73','74','75',
'76','77','78','79','80','81','82','83','84','85','86',
'87','88','89','90','91','92','93','94','95','96','97',
'98','99'
);

const repB:array[1..107] of string=(
'⅔','¾','⅜','³','⁴','⅝','⅞',
'×','¶','∆','¿','¡','–','·','±','₱','½',
'a','b','c','d','e','f','g','h','i','j','k','l','m',
'n',
'o','p','q','r','s','t','u','v','w','x','y','z','A',
'B','C','D','E','F','G','H','I','J','K','L','M','N',
'O','P','Q','R','S','T','U','V','W','X','Y','Z','@',
'#','$','%','&','-','+','(',')','*','"','''',':',';',
'!','?','_','/',',','.','~','|','^','=','{','}','[',
']','`','•','£','¢','€','¥','√','©','®','÷'
);

function replacerepeats(s:string):string;
var i:integer;
begin
 for i:=1 to 90 do
 begin
  s:=stringreplace(s,repA[i],repB[i],
  [rfReplaceAll]);
 end;
 replacerepeats:=s;
end;

function rep(s:string):string;
var i:integer;
begin
 for i:=1 to 90 do
 begin
  s:=stringreplace(s,repB[i],repA[i],
  [rfReplaceAll]);
 end;
 rep:=s;
end;

function Compress(dasm_code:string):string;
begin
 dasm_code:=delwaste(dasm_code);
 dasm_code:=delwasteblocks(dasm_code);
 dasm_code:=delwaste(dasm_code);
 dasm_code:=cryptstring(dasm_code);
 dasm_code:=replacerepeats(dasm_code);
 compress:=dasm_code;
end;


//De compress
function chrs(s:string):string;
var i:integer; b:string;
begin
 b:='';
 if (length(s) mod 3)<>0 then err('Can''t decompress bytecode');
 repeat
  i:=strtoint(copy(s,1,3))-255;
  b:=b+chr(i);
  delete(s,1,3);
 until length(s)=0;
 chrs:=b;
end;


function DeCompress(bin:string):string;
begin
 bin:=rep(bin);
 bin:=chrs(bin);
 DeCompress:=bin;
end;
