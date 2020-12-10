\d .graph

gvcmd:"/usr/bin/gv -watch -resize -geometry 560x530 -widgetless ";
gplotcmd:"gnuplot --persist ";
preamble:("set border 3";"do for [i=1:20] { set linetype i lw 3 }";"set linetype 1 lc rgb \"black\"";"set linetype 2 lc rgb \"red\"";"set linetype 3 lc rgb \"orange\"";"set linetype 4 lc rgb \"green\"";"set linetype 4 lc rgb \"blue\"";"set linetype 4 lc rgb \"purple\"");


if[not`outpath in key[.graph];
  outpath:.file.makepath[getenv[`HOME];".qgraph/","_" sv (string"dv"$.z.Z)except'".:"];
  plotcounter:0; currentplot:0];
if[not`termname in key .graph; termname:.file.makepath[outpath;"terminal.gp"]];
pid:0Ni;tiny:1e-40;

nbins:10;
size: 1.5*294 260f;

removenulls:{[lis]
  if[not type[lis]~0h; :lis wher enot null lis];
  lis where not {any null x}each lis};

current_filename:{[] .file.makepath[.graph.outpath;.string.append["plot";(-4#"0000",string[plotcounter];".gp")]]};

write_gpfile:{[text]
   plotcounter::plotcounter+1;
   currentplot::plotcounter;
   if[not .file.exists[.graph.outpath];system "mkdir -p ",.file.name[.graph.outpath]];
   outfile:.graph.current_filename[];
   -1 string outfile 0: text};

show_gpfile:{[optd]
  optd:.dict.optd[optd];
  system .string.append[.graph.gplotcmd;.file.name .graph.current_filename[]];
  };

tbl_to_string:{[t]
  headstring:enlist "$mydata << EOD";
  datastring:"," 0: 0!t;
  tailstring:enlist "EOD";
  raze (headstring;datastring;tailstring)};

 
xyt:{[t;c;b;a;optd]
  axlabels:.string.stringify each a;
  title:.string.stringify[c] except "`";
  optd:.dict.def[(`join;1b;`xlab;first axlabels;`ylab;last axlabels;`title;title);optd];
  if[count[b]>1;'".graph.xyt: cannot handle multiple by cols"];
  by_group:not .Q.ty[b]~"B";
  wc:$[.Q.ty[c]~"c";parse each "," vs c;c];

  data:?[t;wc;.dict.kvd(`b;b);`x`y!a];
  grps:exec b from data;
  xydata:(uj/){[data;grp] t:flip data grp; `x xkey $[grp~0b;t;.tbl.rename[t;`y;grp]]}[data] each grps;
  xtype:first exec t from select from (meta xydata) where c=`x;
  ytype:first exec first t from select from (meta xydata) where not c=`x;
  xfmt:$[xtype in "dpzt";"set xdata time; set timefmt \"%Y-%m-%d\";";""];
  yfmt:$[ytype in "dpzt";"set ydata time; set timefmt \"%Y-%m-%d\";";""];
  xytheader: .graph.preamble;
  xytheader,:enlist .string.format["set datafile separator \",\"; %xfmt% set autoscale fix";(`xfmt;xfmt)];
  xytheader,:enlist .string.format["set title \"%title%\"; set xlabel \"%xlab%\" offset screen 0.4,0 right; set ylabel \"%ylab%\" offset screen 0,0.4 right";optd];
  xytdata:.graph.tbl_to_string[xydata];

  ycols:cols[xydata] except `x;
  plotcmd0:", " sv {.string.format["$mydata using 1:%icol% title \"%title%\" with %linetype% pt \".\"";(`icol;y;`linetype;x;`title;z)]}[$[optd`join;`linespoint;`points]]'[2+til count ycols;ycols];
  plotcmd:enlist "plot ",plotcmd0;
  write_gpfile[raze (xytheader;xytdata;plotcmd)];
  show_gpfile[optd];
  1b};

cdf:{[t;b;a;optd]
  1b};

profile:{[t;b;a;optd]
  1b};


