program SGT;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Classes,
  Math;

type
  Node = class // Êëàññ óçëà
  public
    key: integer;
    left: node;
    right: node;
    constructor Create(k: integer);
  end;

 var nodes: node;
     parent, x: node;
     parents: Tlist;
     nodesList: TList;

type
  ScapeGoatTree = class  // Êëàññ äåðåâà ñî øòðàôàìè
  public
    a: real; // Ïàðàìåòð alpha
    size: integer;
    max_size: integer;
    root: node;

    constructor Create(alpha: real);
    destructor Destroy(); override;
    function sizeOf(x: node): integer;
    function haT(): real;
    function isDeep(depth: integer): boolean;
    function brotherOf(nodes, parent: node): node;
    function myRebuildTree(root_: node; length: integer): node;
    procedure flatten(nodes: node; nodesList: TList);
    function buildTreeFromSortedList(nodesList: TList; start, ends: real): node;
    function minimum(x: node): node;
    procedure delete(delete_me: integer);
    function search(k: integer): node;
    procedure insert(k: integer);
    function isAWeightBalanced(x: node; size_of_x: integer): boolean;
    procedure inorder(x: node; k: integer);
    procedure Print();
  end;

 // Êîíñòðóêòîð êëàññà node
constructor Node.Create(k: integer);
begin
  self.key := k;
  self.left := Nil;
  self.right := Nil;
end;

// Êîíñòðóêòîð êëàññà ScapeGoatTree
constructor ScapeGoatTree.Create(alpha: real);
begin
  self.a := alpha;
  self.size := 0;
  self.max_size := 0;
  self.root := Nil;
end;

// Âîçâðàùàåò êîëè÷åñòâî "êëþ÷åé" â ïîääåðåâå ñ êîðíåì x, âêëþ÷àÿ ñàì x
function ScapeGoatTree.sizeOf(x: node): integer;
begin
  if x = Nil then begin
    result := 0;
    exit;
  end;
  result := 1 + self.sizeOf(x.left) + self.sizeOf(x.right);
end;

// Ôîðìóëà äëÿ ïðîâåðêè áàëàíñèðîâêè ïî âåñó
function ScapeGoatTree.haT(): real;
begin
  result := floor(logN(1.0/self.a, self.size));
end;

// Ïðîâåðêà áàëàíñà ïî âåñó
function ScapeGoatTree.isDeep(depth: integer): boolean;
begin
  result := depth > self.haT();
end;

// Âîçâðàùàåò óçåë áðàòà nodes, ó êîòîðîãî ðîäèòåëü parent
function ScapeGoatTree.brotherOf(nodes: node; parent: node): node;
begin
  if (parent.left <> Nil) and (parent.left.key = nodes.key) then
    result := parent.right
  else
    result := parent.left;
end;

// Ïåðåñòðîéêà äåðåâà
function ScapeGoatTree.myRebuildTree(root_: node; length: integer): node;
begin
  nodesList := TList.Create;
  self.flatten(root_, nodesList);
  result := self.buildTreeFromSortedList(nodesList, 0, length-1);
end;

// Çàïîëíåíèå âåðøèí â TList â inorder ïîðÿäêå
procedure ScapeGoatTree.flatten(nodes: node; nodesList: TList);
begin
  if nodes = Nil then
    begin
      exit;
    end;
  self.flatten(nodes.left, nodesList);
  nodesList.add(nodes);
  self.flatten(nodes.right, nodesList);
end;

// Ïåðåñòðîéêà äåðåâà èç ñîðòèðîâàííîãî TList
function ScapeGoatTree.buildTreeFromSortedList(nodesList: TList; start, ends: real): node;
var mid: integer; // Ìåäèàíà
    d, leftNode, rightNode, p: node;
begin
  if start > ends then
    begin
     result := Nil;
     exit;
    end;
  mid := ceil((start + ends) / 2.0);
  d := nodesList[mid];
  p := Node.Create(d.key);
  leftNode := self.buildTreeFromSortedList(nodesList, start, mid-1);
  p.left := leftNode;
  rightNode := self.buildTreeFromSortedList(nodesList, mid+1, ends);
  p.right := rightNode;
  result := p;
end;

// Ïîèñê ìèíèìàëüíîé âåðøèíû
function ScapeGoatTree.minimum(x: node): node;
begin
  while x.left <> Nil do
    x := x.left;
  result := x;
end;

// Óäàëåíèå ýëåìåíòà
procedure ScapeGoatTree.delete(delete_me: integer);
var is_left_child: boolean;
    succesor, tmp: node;

begin
  nodes := self.root;
  parent := Nil;
  is_left_child := True;

  // Ïîèñê ýëåìåíòà äëÿ óäàëåíèÿ
  while nodes.key <> delete_me do
  begin
    parent := nodes;
    if delete_me > nodes.key then
      begin
        nodes := nodes.right;
        is_left_child := False;
      end
    else
      begin
        nodes := nodes.left;
        is_left_child := True;
      end;
  end;

    succesor := Nil; // Íàñëåäíèê
  // Óçåë íå èìåþùèé äåòåé
  if (nodes.left = Nil) and (nodes.right = Nil) then
    begin end
  else if nodes.left = Nil then // Åñëè åñòü òîëüêî ïðàâûé "ñûí"
    succesor := nodes.right
  else if nodes.right = Nil then // Åñëè åñòü òîëüêî ëåâûé "ñûí"
    succesor := nodes.left
  else // Åñëè åñòü è ïðàâûé è ëåâûé
    begin // Ïîèñê íàñëåäíèêà
      succesor := self.minimum(nodes.right);
        if succesor = nodes.right then
          succesor.left := nodes.left
        else
          begin
            writeln('finding succesor');
            succesor.left := nodes.left;
            tmp := succesor.right;
            succesor.right := nodes.right;
            nodes.right.left := tmp;
          end;
    end;
    // Ïåðåìåùåíèå óçëà
    if parent = Nil then
      self.root := succesor
    else if is_left_child then
      parent.left := succesor
    else
      parent.right := succesor;

    self.size := self.size - 1;
    // Ïðîâåðêà íà ñáàëàíñèðîâàííîñòü
    if self.size <= (self.a * self.max_size) then
      begin
        self.root := self.myRebuildTree(self.root, self.size);
        self.max_size := self.size;
      end;
end;

// Ïîèñê çàäàííîé âåðèøíû
function ScapeGoatTree.search(k: integer): node;
begin
  x := self.root;
  while x <> Nil do
    begin
      if x.key > k then
        x := x.left
      else if x.key < k then
        x := x.right
      else begin
        result := x;
        exit;
      end;
    end;

  result := Nil;
end;

// Áàëàíñ ïî âåñó
function ScapeGoatTree.isAWeightBalanced(x: node; size_of_x: integer): boolean;
var c, b: boolean;
begin
  c := self.sizeOf(x.left) <= (self.a * (size_of_x));
  b := self.sizeOf(x.right) <= (self.a * (size_of_x));
  result := c and b;
end;

// Âñòàâêà íîâîãî ýëåìåíòà
procedure ScapeGoatTree.insert(k: integer);
var y, z, scapegoat, size_temp, tmp: node;
    depth, i, q: integer;
    sizes: array of integer;
begin
  parents := TList.Create;

  z := Node.Create(k);
  y := Nil;
  x := self.root;

  depth := 0;
  q := -1;

  // Çàïîëíÿåì TList âåðøèíàìè
  while x <> Nil do
    begin
      parents.insert(0, x);
      y := x;
      if z.key < x.key then
        x := x.left
      else
        x := x.right;
      depth := depth + 1;
    end;

  if y = Nil then
    self.root := z
  else if z.key < y.key then
    y.left := z
  else
    y.right := z;

  self.size := self.size + 1;
  self.max_size := max(self.size, self.max_size);

  // Íóæíà ëè ïåðåáàëàíñèðîâêà
  if self.isDeep(depth) then
    begin
      scapegoat := Nil;
      parents.insert(0, z);

      for i := 1 to parents.count do
        begin
          setlength(sizes, i);
          sizes[i-1] := 0;
        end;

      for i := 1 to parents.count - 1 do
        begin
          size_temp := self.brotherOf(parents[i-1], parents[i]);
          sizes[i] := sizes[i-1] + self.sizeOf(size_temp)+1;

          if not (self.isAWeightBalanced(parents[i], sizes[i]+1)) then
            begin
              scapegoat := parents[i]; // Íàøëè âåðøèíó, íàðóøàþùóþ áàëàíñ
              q := i;
            end;
        end;
    if scapegoat <> Nil then
      begin
      tmp := self.myRebuildTree(scapegoat, sizes[q]+1);
      // Ïåðåñòðîèëè äåðåâî
      scapegoat.left := tmp.left;
      scapegoat.right := tmp.right;
      scapegoat.key := tmp.key;
      end;
    end;
end;

// Âûâîä äåðåâà
procedure ScapeGoatTree.inorder(x: Node; k: integer);
begin
  if x <> Nil then
    begin
      self.inorder(x.left, k+1);
      writeln(x.key: k*3+1);
      self.inorder(x.right, k+1);
    end;
end;

// Ïåðåäà÷à çíà÷åíèÿ self.root
procedure ScapeGoatTree.print();
begin
  self.inorder(self.root, 0);
end;

destructor ScapeGoatTree.Destroy();
begin
  if (Parents <> Nil) and (NodesList <> Nil) then begin
    Parents.Destroy;
    NodesList.Destroy;
  end;
end;


var l, t, nd: integer;
    alpha: real;
    tree: ScapeGoatTree;
    value, tm: node;
 begin
  l := -1;
  write('Enter alpha: ');
  readln(alpha);
  // Óñòàíàâëèâàåì ïàðàìåòð alpha
  tree := scapegoattree.Create(alpha);
  writeln('1: Add element. 2: Print tree. 3: Delete node. 4: Search node.');
  while  l <> 0 do
    begin
      write('Enter: ');
      readln(l);
      if l = 1 then
        begin
          readln(t);
          tree.insert(t);
        end
      else if l = 2 then
        begin
        tree.print();
        writeln('');
        end
      else if l = 3 then
        begin
          write('Some of the node to delete?: ');
          readln(nd);
          tm := tree.search(nd);
            if tm = Nil then begin
                writeln('This node not found');
                continue;
            end;
          tree.delete(nd);
          writeln('Deleted');
        end
      else if l = 4 then
        begin
          write('What the node want to find?: ');
          readln(nd);
          value := tree.search(nd);
          if value = nil then
            writeln('Key not found')
          else
            writeln('Found: ', value.key);
        end;
    end;

    tree.Destroy;
end.

