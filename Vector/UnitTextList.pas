unit UnitTextList;

interface
  uses
    UnitVector, UnitNormVector, classes;

  Type
    TContainerList = class (TList)

      constructor Create(filename: string); overload;
      procedure Sort();
      procedure Print();
    end;

    var containerL: TContainerList;

implementation

{ TContainerList }

var k: integer;
constructor TContainerList.Create(filename: string);
var f: TextFile;
    coord: TReal;
    dem, i, j: integer;
    ch: char;
begin
  AssignFile(f, filename);
  reset(f);

  j := 1;
  readln(f, dem);
  SetLength(coord, dem);
   inherited Create;

  while not EOF(f) do begin
    readln(f, ch);
    if ch = 'V' then begin
      for i := 0 to dem-1 do
        read(f, coord[i]);
        readln(f);
      Add(TVector.Create(dem, coord));
    end
    else if ch = 'N' then begin
      for i := 0 to dem-1 do
        read(f, coord[i]);
        readln(f);
      Add(TNormVector.Create(dem, coord));
    end;
    j := j + 1;
  end;

  k := j;
end;

procedure TContainerList.Print;
var i: integer;
    c: TVector;
begin
  for i := 0 to k-2 do begin
    c := get(i);
    c.print;
  end;
end;

procedure TContainerList.Sort;
var a, b: TVector;
    j, i: integer;
begin
   for j := 0 to k-3 do
    for i := 0 to k-j-3 do begin
      a :=  get(i);
      b :=  get(i+1);
      if a.module > b.module then
        Move(i, i+1);
    end;
end;

initialization
  containerL := TContainerList.Create('F:\file.txt');
  writeln;
  writeln('List: ');

  containerL.Print;

  containerL.Sort;

  writeln('List after sort: ');
  containerL.Print;

finalization
  containerL.Destroy;
end.
