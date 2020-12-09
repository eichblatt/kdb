\d .graph

gvcmd:"/usr/bin/gv -watch -resize -geometry 560x530 -widgetless ";
if[not`outpath in key[.graph];
  outpath:.file.makepath[getenv[`home];".qgraph/","_" sv (string"dv"$.z.Z)except'".:"];
  plotcounter:0; currentplot:0];
if[not`termname in key .graph; termname:.file.makepath[outpath;"terminal.gp"]];
pid:0Ni;tiny:1e-40;

nbins:10;
size: 1.5*294 260f;

removenulls:{[lis]
  if[not type[lis]~0h; :lis wher enot null lis];
  lis where not {any null x}each lis};

dtyped:"dpztfij"!`time`time`time`time```;

xyt:{[t;b;a;optd]
  if[count[b]>1;'".graph.xyt: cannot handle multiple by cols"];
  by_group:not .Q.ty[b]~"B";
  axlabels:.string.stringify each a;
  data:?[t;();.dict.kvd(`b;b);`x`y!a];
  grps:exec b from data;
  xydata:(uj/){[data;grp] `x xkey .tbl.rename[flip data grp;`y;grp]}[data] each grps;
  xtype:first exec t from select from (meta ddd) where c=`x;
  ytype:first exec first t from select from (meta ddd) where not c=`x;
  xfmt:$[xtype in "dpzt";"set xdata time; set timefmt \"%Y-%m-%d\";";""];
  yfmt:$[ytype in "dpzt";"set ydata time; set timefmt \"%Y-%m-%d\";";""];
  xytheader: .string.format["set datafile separator \",\"; %xfmt% set autoscale fix; $mydata << EOD";(`xfmt;xfmt)];
  breakx;
  1b};

cdf:{[t;b;a;optd]
  1b};

profile:{[t;b;a;optd]
  1b};


