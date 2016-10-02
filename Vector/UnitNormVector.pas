unit UnitNormVector;

interface
  uses
   UnitVector;

   type TNormVector = class (TVector)

    public
     constructor Create(n: integer);  overload;
     constructor Create(n: integer; coord: TReal);  overload;
     procedure NormVector;
     procedure setVector(); override;

   end;

   var modul, temp: real;
       n: integer;
       v3: TNormVector;

implementation

{ TNormVector }

constructor TNormVector.Create(n: integer);
var i: integer;
begin
    SetLength(coordinates, n);
    self.n := n;

  write('Enter coordinates: ');
  for i := 0 to n-1 do begin
    read(coordinates[i]);
    modul := modul + sqr(coordinates[i]);
  end;
  modul := sqrt(modul);

  for i := 0 to n-1 do begin
    if modul <> 0 then
      coordinates[i] := coordinates[i] / modul;
  end;
end;

constructor TNormVector.Create(n: integer; coord: TReal);
var i: integer;
begin
    SetLength(coordinates, n);
    self.n := n;

  for i := 0 to n-1 do begin
    coordinates[i] := coord[i];
    modul := modul + sqr(coordinates[i]);
  end;
  modul := sqrt(modul);

  for i := 0 to n-1 do begin
    if modul <> 0 then
      coordinates[i] := coordinates[i] / modul;
  end;
end;

procedure TNormVector.NormVector;
var i: integer;
begin
  self.getCoord; // ��������� ������ ������������
  modul := self.module;

  for i := 0 to n-1 do
    self.coordinates[i] := self.coordinates[i] / modul;
end;

procedure TNormVector.setVector;
begin
  inherited;
  print();

  NormVector;
  print();
end;

initialization
  write('Demension for normal vector = ');
  readln(n);

  v3 := TNormVector.Create(n);
  v3.print();

  v3.setVector();

  finalization
    v3.Destroy;


end.



