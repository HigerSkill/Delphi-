unit UnitVector;

interface
const flag = not true;
type TReal = array of real;
type TVector = class

  protected
    coordinates: TReal;
    n: integer;

    function getN:integer;

  public
    constructor Create(n: integer); overload;
    constructor Create(n, k: integer); overload;
    constructor Create(n: integer; coord: TReal); overload;
    destructor Destroy; override;

    function addition (a, b, c: TVector): TVector;
    function subtraction (a, b, c: TVector): TVector;
    function composition (a, b, c: TVector): TVector;
    function module: real;
    procedure print();

    function getVector(a, b: TVector): TVector;
    procedure setVector(); virtual;
    function getCoord: TReal;
    property Demension: integer read getN;
end;

var n: integer;
    v0, v1, v2: TVector;
    coord_vect: TReal;

implementation

procedure print(a: TVector);
var i: integer;
begin
    writeln;
  write('vector = ( ');
  for i := 0 to n-1 do
    write(a.coordinates[i]:4:2, ' ');
  write(')');

  readln;
end;

constructor TVector.Create(n: integer); // Конструктор с вводом элементов
var i: integer;
begin
  SetLength(coordinates, n);
  self.n := n;

  write('Enter coordinates: ');
  for i := 0 to n-1 do
    read(coordinates[i]);
end;

constructor TVector.Create(n, k: integer); // Коснтруктор с элементами равными k
var i: integer;
begin
  SetLength(coordinates, n);
  self.n := n;

  for i := 0 to self.n-1 do
    coordinates[i] := k;
end;

constructor TVector.Create(n: integer; coord: TReal);
var i: integer;
begin
  SetLength(coordinates, n);
  self.n := n;

  for i := 0 to n-1 do
    coordinates[i] := coord[i];
end;


destructor TVector.Destroy;
begin
  SetLength(self.coordinates, 0);
end;

function TVector.getN: integer;
begin
   result := n;
end;

function TVector.getVector(a, b: TVector): TVector;
var j: integer;
begin
 for j := 0 to n - 1 do
    b.coordinates[j] := a.coordinates[j];

  result := b;
end;

procedure TVector.setVector();
var i: integer;
begin
  writeln;
  write('Set coordinate: ');
  for i := 0 to n-1 do
    read(coordinates[i]);
  readln;
end;

function TVector.getCoord: TReal;
var j: integer;
begin
  SetLength(coord_vect, n);
    for j := 0 to n - 1 do
      coord_vect[j] := self.coordinates[j];
end;

function TVector.composition(a, b, c: TVector): TVector;
var j: integer;
begin
  for j := 0 to n - 1 do
    c.coordinates[j] := a.coordinates[j] * b.coordinates[j];

  result := c;
end;

function TVector.module: real;
var modul: real;
    j: integer;
begin
  modul := 0;
  for j := 0 to n - 1 do
    modul := modul + sqr(self.coordinates[j]);

  modul := sqrt(modul);
  result := modul;
end;

procedure TVector.print();
var i: integer;
begin
  write('v = ( ');
  for i := 0 to n-1 do
    write(coordinates[i]:4:2, ' ');
  write(')', ' module = ', module:4:2);
  writeln;
end;


function TVector.subtraction(a, b, c: TVector): TVector;
var j: integer;
begin
  for j := 0 to n - 1 do
    c.coordinates[j] := a.coordinates[j] - b.coordinates[j];

  result := c;
end;

function TVector.addition(a, b, c: TVector): TVector;
var j: integer;
begin
  for j := 0 to n - 1 do
    c.coordinates[j] := a.coordinates[j] + b.coordinates[j];

  result := c;
end;

initialization
if flag then
   begin
 write('N(dimension) = ');
 readln(n);

  v0 := TVector.Create(n);
  v1 := TVector.Create(n);
  v2 := TVector.Create(n, 0);

  v0.print();
  v1.print();

  v2 := v2.addition(v0, v1, v2);
    writeln ('Addition');
    v2.print();

  v2 := v2.subtraction(v0, v1, v2);
    writeln ('Substraction');
    v2.print();

  v2 := v2.composition(v0, v1, v2);
    writeln ('Composition');
    print(v2);

  writeln('l = ', v0.Demension);

  writeln('Module = ', v2.module:4:1);
  end;
finalization
if flag then
   begin
  v0.Destroy;
  v1.Destroy;
  v2.Destroy;

end;
end.

