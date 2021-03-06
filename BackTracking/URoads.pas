unit URoads;

interface

const
  maxN = 12;
type
  TIndex = 1..MaxN;
  TMatr = array[TIndex,TIndex]of Boolean;
  TSet = set of TIndex;
  TPath = array[TIndex] of TIndex;
  TRoad = record
    t1,t2: TIndex;
  end;
  TDel = array[1..3] of TRoad;

  procedure Init(var R: TMatr);
  procedure RandomFill(var R: TMatr; N: Integer);
  function MainFind(var Roads: TMatr; A,B: TIndex):boolean;
  procedure DeleteColRow(var R: TMatr; index: TIndex; var N: Integer);
  function ChangeRoad(var R: TMatr; i,j: TIndex; isRoad: Boolean): Boolean;
  function MainTask(var R: TMatr; A,B,N: TIndex; var del: TDel):boolean;
  function DelToStr(var del: TDel): string;
  procedure ReturnDel(var R: TMatr; del: TDel);


implementation

uses
  SysUtils,
  Math;

//������������� ������� �����
procedure Init(var R: TMatr);
var i, j: integer;
begin
  for i := 1 to MaxN do
    begin
      R[i,i]:=true;
      for j := i + 1 to MaxN do
        begin
          R[i,j]:= false ;
          R[j,i]:= R[i,j];
        end;
    end;
end;

//��������� ���������� ������� ����� �� N �������
procedure RandomFill(var R:TMatr; N: Integer);
var i, j: integer;
begin
  Randomize;
  for i := 1 to N do
      for j := i+1 to N do
        begin
          R[i,j]:= random(3)=1; 
          R[j,i]:= R[i,j];
        end;
end;

//��������� �������� ������ index
procedure DeleteColRow(var R:TMatr; index: TIndex; var N: Integer);
var
  i,j: TIndex;
begin
  for i:= index to MaxN-1 do
    begin
      for j:=1 to MaxN-1 do
        begin
          R[i,j]:= R[i+1,j];
          R[j,i]:= R[j,i+1];
        end;
      R[i,i]:= True;
    end;
  for j:=1 to MaxN do
    begin
      R[N,j]:= False;
      R[j,N]:= False;
    end;
  R[N,N]:= True;
  Dec(N);
end;

//���������� ������ ��������� ����� � ���� ������
function DelToStr(var del: TDel): string;
var
  i: TIndex;
begin
  result:= '';
  for i:=1 to 3 do
    with del[i] do
      result:= Result + IntToStr(Min(t1,t2))+IntToStr(Max(t1,t2))+' ';
end;

//���������� � ������� ����� ��������� �� ������� del
procedure ReturnDel(var R: TMatr; del: TDel);
var
  i: TIndex;
begin
  for i:=1 to 3 do
    with del[i] do
      ChangeRoad(R,t1,t2,True);
end;

//��������� ��������� ������ ����� �������� i � j �� ��������� isRoad, ���������� false ���� ������ ��� � �������� ���������
function ChangeRoad(var R: TMatr; i,j: TIndex; isRoad: Boolean): Boolean;
begin
  if R[i,j] = isRoad then
    result:= False
  else
    begin
      R[i,j]:= isRoad;
      R[j,i]:= isRoad;
      result:= True;
    end;
end;  

//�������� �� ������������� ���� ����� �������� � � �
function MainFind(var Roads: TMatr; A,B: TIndex):boolean;
var
  v:TSet;  
  p:TPath;
  len:integer;

  { ����� ���� �� ������ t � ����� B.
  visited - ��������� �������, ������� ��������}
  function FindPath(t: TIndex; var visited: TSet):boolean;
  var
    i:integer;
  begin
    if t = B then
      result:= true   
    else
      begin
        i:= 1;
        result:= false;
        {���� �� ��������� ��� ������ � �� ����� ����}
        while (i <= MaxN) and not result do
          {���� ������ �� t � i ���������� � i ��� �� ��������}
          if Roads[t,i] and not (i in visited) then
            begin
              len:= len+1;
              P[len]:=i;  {������� ����� i � ����}
              Include(visited,i);  {�������� i � ��������� �������, �. ��������}
              result:=FindPath(i,visited); {����� ���� �� i ������}
              if not result then   {���� �� ������ i �� ������}
                begin
                  Exclude(visited,i); {��������� i �� ��������� �������, �. ��������}
                  len:=len-1;
                  i:=i+1;
                end;
            end
          else
            i:=i+1;
      end;
  end; //FindPath

begin
  len:= 1;
  P[len]:= A;
  v:=[A];
  result:= FindPath(A,v)
end; //MainFind


//�������� ������� - ������� ������, � del ���������� ��������� ������
function MainTask(var R: TMatr; A,B,N: TIndex; var del: TDel):boolean;
var
  len: Integer;   //������� ��������� �����

  //�������������� ������� ��������
  function Check(t:TIndex): Boolean;
  var
    i: TIndex;
  begin
    result:= (len = 3) and not MainFind(R,A,B);
    i:=1;
    while (i <= N) and (not Result) do
      if (t <> i) and R[t,i] and (len < 3) then
        begin
          Inc(len);
          del[len].t1:= t;
          del[len].t2:= i;
          ChangeRoad(R,t,i,False);
          Result:= Check(i);
          if not Result then
            begin
              with del[len] do
                ChangeRoad(R,t1,t2,True);
              Dec(len);
              Inc(i);
            end;
        end
      else
        Inc(i);
  end;

begin
  len:=0;
  Result:= Check(A);
end;


end.
