unit UnitText;

interface
  uses
    UnitVector, UnitNormVector;

  Type
    TContainer = class
      mas : array [1..10] of TVector;

      constructor Create(filename: string); overload;
      procedure Sort();
      procedure Print();
  end;

  var contain: TContainer;

implementation
 var k: integer;

{ TContainer }

constructor TContainer.Create(filename: string);
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

  while not EOF(f) do begin
    readln(f, ch);
    if ch = 'V' then begin
      for i := 0 to dem-1 do
        read(f, coord[i]);
        readln(f);
      mas[j] := TVector.Create(dem, coord);
    end
    else if ch = 'N' then begin
      for i := 0 to dem-1 do
        read(f, coord[i]);
        readln(f);
      mas[j] := TNormVector.Create(dem, coord);
    end;
    j := j + 1;
  end;

  k := j;
end;

procedure TContainer.Print;
var i: integer;
begin
  for i := 1 to k-1 do
    mas[i].print;
end;

procedure TContainer.Sort;
var temp: TVector;
    j, i: integer;
begin
  for j := 1 to k-1 do
    for i := 1 to k-j-1 do
      if mas[i].module > mas[i+1].module then begin
        temp := mas[i];
        mas[i] := mas[i+1];
        mas[i+1] := temp;
      end;
end;

initialization
contain := TContainer.Create('F:\file.txt');

  writeln('k = ', k);
  writeln('Container before sort');
    contain.print;

  contain.Sort;

  writeln('Container after sort');
    contain.print;
end.
