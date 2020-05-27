{10. �� ������� ������������ ����� ����������, ����� ��,
������ �����-���� ��� �� ���, �������� ����, ����� �� ������ �
������ ���� ������� � ����� �.}


unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, URoads, ExtCtrls;


type
  TForm1 = class(TForm)
    sgRoads: TStringGrid;
    rgAction: TRadioGroup;
    pnlControl: TPanel;
    btnDoAction: TButton;
    btnTask: TButton;
    btnShowTask: TButton;
    procedure btnShowTaskClick(Sender: TObject);
    procedure btnDoActionClick(Sender: TObject);
    procedure ShowRoads(sgRoads: TStringGrid; var R:TMatr; N: TIndex);
    procedure FormCreate(Sender: TObject);
    procedure btnTaskClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Roads: TMatr;
  N: Integer;
  del: TDel;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  Init(Roads);
  N:= 0;
  rgAction.ItemIndex:= 0;
end;

procedure TForm1.btnShowTaskClick(Sender: TObject);
begin
  ShowMessage('�� ������� ������������ ����� ����������, ����� ��, '+
    '������ �����-���� ��� �� ���, �������� ����, ����� �� ������ � ' +
    '������ ���� ������� � ����� �.');
end;

procedure TForm1.ShowRoads(sgRoads: TStringGrid; var R:TMatr; N: TIndex);
var
  i, j:Integer;
begin
  sgRoads.ColCount:= N+1;
  sgRoads.RowCount:= N+1;
  for i:=1 to N+1 do
    begin
      sgRoads.Cells[0,i]:= IntToStr(i);
      sgRoads.Cells[i,0]:= IntToStr(i);
      for j:=1 to N+1 do
        if R[i,j] then
          sgRoads.Cells[i,j]:= '1'
        else
          sgRoads.Cells[i,j]:= '0';
    end;
end;

procedure TForm1.btnDoActionClick(Sender: TObject);
var
  Index: TIndex;
  num,num2: Integer;
begin
  case rgAction.ItemIndex of
    0 : if TryStrToInt(InputBox('��������� ������� �����', '������� ���������� �������', '6'),num) then
          if num in [1..MaxN] then
            begin
              N:= num;
              RandomFill(Roads,N);
              ShowRoads(sgRoads,Roads,N);
              sgRoads.Visible:= True;
            end
          else
            ShowMessage('����� ������ ���� � ��������� [1..' + IntToStr(MaxN)+']')
        else
          ShowMessage('���������� ������������� ������ � �����');
    1 :
      begin
        if N < MaxN then
          begin
            inc(N);
            ShowRoads(sgRoads,Roads,N);
            sgRoads.Visible:= True;
          end
        else
          ShowMessage('���������� ������������ ����� �������');
      end;
    2 : if N = 0 then
          ShowMessage('������� ����� ������')
        else
          if TryStrToInt(InputBox('���������� ������', '������� ����� ������� ������', ''),num) and
            TryStrToInt(InputBox('���������� ������', '������� ����� ������� ������', ''),num2)
          then
            if (num in [1..N]) and (num2 in [1..N]) then
                if not ChangeRoad(Roads,num,num2,True) then
                  ShowMessage('��� ������ ����������')
                else
                  ShowRoads(sgRoads,Roads,N)
            else
              ShowMessage('����� ������ ���� � ��������� [1..' + IntToStr(N)+']')
          else
            ShowMessage('���������� ������������� ������ � �����');

    3 : if N = 0 then
          ShowMessage('������� ����� ������')
        else
          if TryStrToInt(InputBox('�������� ������', '������� ����� ���������� ������', IntToStr(N)),num) then
            if num in [1..N] then
              begin
                Index:= num;
                DeleteColRow(Roads,Index,N);
                ShowRoads(sgRoads,Roads,N);
                sgRoads.Visible:= N > 0;
              end
            else
              ShowMessage('����� ������ ���� � ��������� [1..' + IntToStr(N)+']')
          else
            ShowMessage('���������� ������������� ������ � �����');
    4 : if N = 0 then
          ShowMessage('������� ����� ������')
        else
          if TryStrToInt(InputBox('�������� ������', '������� ����� ������� ������', ''),num) and
            TryStrToInt(InputBox('�������� ������', '������� ����� ������� ������', ''),num2)
          then
            if (num in [1..N]) and (num2 in [1..N]) then
              if num = num2 then
                ShowMessage('����� ���� � ��� �� �����')
              else
                if not ChangeRoad(Roads,num,num2,False) then
                  ShowMessage('��� ������ �� ����������')
                else
                  ShowRoads(sgRoads,Roads,N)
            else
              ShowMessage('����� ������ ���� � ��������� [1..' + IntToStr(N)+']')
          else
            ShowMessage('���������� ������������� ������ � �����');
    5 : if N = 0 then
          ShowMessage('������� ����� ������')
        else
          begin
            with sgRoads do
              begin
                for num:=0 to ColCount-1 do
                  Cols[num].Clear;
                Visible:= false;
              end;
            Init(Roads);
            N:= 0;
          end;
  end;
  btnTask.Visible:= N > 0;
end;


procedure TForm1.btnTaskClick(Sender: TObject);
var
  A,B: Integer;
begin
  if TryStrToInt(InputBox('����� ������', '������� ����� ������� ������', ''),A) and
    TryStrToInt(InputBox('����� ������', '������� ����� ������� ������', ''),B)
  then
    if (A in [1..N]) and (B in [1..N]) then
      if A = B then
        ShowMessage('����� ���� � ��� �� �����')
      else
        begin
          if not MainFind(Roads,A,B) then
            ShowMessage('�� ���������� ������ ����� �������� '+IntToStr(A)+' � '+IntToStr(B))
          else
            if MainTask(Roads,A,B,N,del) then
              begin
                ShowRoads(sgRoads,Roads,N);
                ShowMessage('�����'+#10#13+'�������� ������: '+DelToStr(del));
                if MessageDlg('������� ������ �������?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
                  begin
                    ReturnDel(Roads,del);
                    ShowRoads(sgRoads,Roads,N);
                  end;
              end
            else
              ShowMessage('������');
        end
    else
      ShowMessage('����� ������ ���� � ��������� [1..' + IntToStr(N)+']')
  else
    ShowMessage('���������� ������������� ������ � �����');
end;

end.
