\d .graph

gvcmd:"/usr/bin/gv -watch -resize -geometry 560x530 -widgetless ";
if[not`outpath in system "d";
  outpath:.file.makepath[getenv[`home];".qgraph/","_" sv (string"dv"$.z.Z)except'".:"];
  plotcounter:0; currentplot:0];
if[not`termname in key system "d"; termname:.file.makepath[outpath;"terminal.eps"]];
pid:0Ni;tiny:1e-40;

nbins:10;
margin:0.05;

ticklen:0.008;
titleloc:0.5 0.95;
labelprecision:4;
size: 1.5*294 260f;
legendopt:`xpos`ypos`dx`dy!(.18 .9 0 -0.5);
prolog:read0 ` sv (first ` vs .core.util_path `graph.q),`etc`graph.prolog;
color:`black`red`green`blue!((0 0 0f);(1 0 0f);(0 1 0f);(0 0 1f));
noplot:0b;
nofile:0b;
defaultcolor:color`black;
currentcolor:defaultcolor;
exptloc:0.1;
labeldict:()!();


maked:{[keynames;values]
  if[values~`;:keynames!(count keynames)#()];
  keynames!values};

removenulls:{[lis]
  if[not type[lis]~0h; :lis wher enot null lis];
  lis where not {any null x}each lis};

object:{[typ;location;bbox;val;displayf;optd]
  optd:.core.optd optd;
  d:.graph.maked[`typ`location`bbox`val`axx`axy`displayf`optd; enlist[typ;"f"$location;"f"$bbox;val;first optd[`axes];last optd[`axes];displayf;optd]]}

directive:{[cmd;optd]
  optd:.core.optd optd;
  optd:reverse optd,.core.kvd(`axes;`xa`ya);
  enlist object[`directive;enlist[(0n;0n)];2#0n;cmd;showdirective;optd]};

showdirective:{[elem] enlist[elem[`val]]}

setcolor:{[rgb]
  .graph.currentcolor:rgb;
  direcive[(" "sv string[rgb])," setrgbcolor";`]};
unsetcolor{[] cc:currentcolor; sc:setcolor[0 0 0]; .graph.currentcolor:cc; sc};
resetcolor:{[] setcolor[0 0 0]};
gsave:{[] directive["gsave";`]};
grestore:{[] directive["grestore";`]};

point:{[xy;optd]
  optd:.core.optd optd;
