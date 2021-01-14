\d .graph

gvcmd:"/usr/bin/gv -watch -resize -geometry 560x530 -widgetless ";
gplotcmd:"gnuplot --persist ";
preamble:("set border 3";"do for [i=1:20] { set linetype i lw 3 }";
  "set linetype 1 lc rgb \"black\"";
  "set linetype 2 lc rgb \"#df0000\"";
  "set linetype 3 lc rgb \"#ff9010\"";
  "set linetype 4 lc rgb \"#dfdf00\"";
  "set linetype 5 lc rgb \"#009900\"";
  "set linetype 6 lc rgb \"#000099\"";
  "set linetype 7 lc rgb \"#990099\"";
  "set linetype 8 lc rgb \"#00dddd\"";
  "set linetype 8 lc rgb \"#ffa0a0\"";
  "set linetype 9 lc rgb \"#00ffc1\"";
  "set linetype 10 lc rgb \"#00c1ff\"";
  "set linetype 11 lc rgb \"#ff0999\"";
  "set linetype 12 lc \"#80c080\"";
  "set linetype 13 lc \"#905010\"";
  "set linetype 14 lc \"#b050ff\"";
  "set linetype 15 lc \"#108080\"";
  "set linetype 16 lc \"#60f010\"";
  "set linetype 17 lc \"#409000\"";
  "set linetype 18 lc \"#607020\"";
  "set linetype 19 lc \"#a0f080\"";
  "set linetype 20 lc \"#005555\"";
  "set key left; set boxwidth 0.5;set style fill solid");

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

 
xyt:{[t;c;b;a;opts]
  axlabels:.string.stringify each a;
  title:$[.Q.ty[c]~"c";.string.ssr[.string.stringify[c];"`";" "];" "];
  optd:.dict.def[(`join;1b;`xlab;first axlabels;`ylab;$[count[a]~2;axlabels 1;`y];`title;title;`xsort;1b;`terminal;`;`size;"600,400";`output;"");opts];
  optd[`title]:.string.ssr[optd`title;"_";" "];
  optd[`xlab]:.string.ssr[optd`xlab;"_";" "];
  optd[`ylab]:.string.ssr[optd`ylab;"_";" "];
  if[count[b]>1;'".graph.xyt: cannot handle multiple by cols"];
  by_group:not .Q.ty[b]~"B";
  wc:$[.Q.ty[c]~"c";parse each "," vs c;c];

  ylist:.string.append[`y] each til -1+count a;
  data:?[t;wc;.dict.kvd(`b;b);(`x,ylist)!a];
  grps:exec b from data;
  xydata:(uj/){[data;ylist;grp] t:flip data grp; `x xkey $[grp~0b;t;.tbl.rename[t;ylist;.string.append[;("_";grp)]'[ylist]]]}[data;ylist] each grps;

  labels:raze $[first[grps]~0b;1_a;count[a]~2;`$string each grps;{[y;g] {[y;g].string.append[y;("_";g)]}[;g] each y}[(1_a)] each grps]; 
  xydata:$[optd`xsort;`x xasc;] .tbl.rename[xydata;cols[xydata] except `x;labels];
  
  xtype:first exec t from select from (meta xydata) where c=`x;
  ytype:first exec first t from select from (meta xydata) where not c=`x;
  xfmt:$[xtype in "dpzt";"set xdata time; set timefmt \"%Y-%m-%d\";";""];
  bargraph:xtype in "s";
  yfmt:$[ytype in "dpzt";"set ydata time; set timefmt \"%Y-%m-%d\";";""];
  header: .graph.preamble;
  if[not null optd[`terminal];header,:enlist .string.format["set terminal %terminal% size %size%";optd]];
  if[not optd[`output]~"";header,:enlist .string.format["set output \"%output%\"";optd]];
  header,:enlist .string.format["set datafile separator \",\"; %xfmt% set autoscale fix";(`xfmt;xfmt)];
  header,:enlist .string.format["set title \"%title%\"; set xlabel \"%xlab%\" offset screen 0.4,0 right; set ylabel \"%ylab%\" offset screen 0,0.4 right";optd];
  xydata:$[bargraph;`n xcols update n:i from rotate[1;cols xydata]#0!xydata;0!xydata];
  data:.graph.tbl_to_string[xydata];

  ycols:cols[xydata] except `x`n;
  plotcmd0:$[bargraph; 
      ", " sv {.string.format["$mydata using 1:%icol%:xtic(%xtic%)title \"%title%\" with boxes";(`icol;y;`xtic;x;`title;z)]}[count[ycols]+2]'[2+til count ycols;ycols];
      ", " sv {.string.format["$mydata using 1:%icol% title \"%title%\" with %linetype% pt \".\"";(`icol;y;`linetype;x;`title;z)]}[$[optd`join;`linespoint;`points]]'[2+til count ycols;ycols]];
  plotcmd:enlist "plot ",plotcmd0;
  write_gpfile[raze (header;data;plotcmd)];
  show_gpfile[optd];
  1b};

cdf:{[t;c;b;a;opts]
  xlabel:.string.stringify a;
  title:.string.stringify[c] except "`";
  optd:.dict.def[(`join;1b;`xlab;xlabel;`ylab;`;`title;title;`normalize;1b);opts];
  optd:.dict.def[(`join;1b;`xlab;xlabel;`ylab;$[optd`normalize;`cumfrac;`cumqty];`title;title;`normalize;1b);opts];
  optd[`title]:.string.ssr[optd`title;"_";" "];
  optd[`xlab]:.string.ssr[optd`xlab;"_";" "];
  optd[`ylab]:.string.ssr[optd`ylab;"_";" "];
  if[count[b]>1;'".graph.xyt: cannot handle multiple by cols"];
  by_group:not .Q.ty[b]~"B";
  wc:$[.Q.ty[c]~"c";parse each "," vs c;c];

  data:?[t;wc;.dict.kvd(`b;b);.dict.kvd(`x;a)];
  grps:exec b from data;
  cdfdata:raze {[data;grp;optd] t:update byvar:grp,cumfrac:i%count[i],cumqty:i from `x xasc select from flip[data grp] where not null x; t}[data;;optd] each grps;
  .graph.xyt[cdfdata;();`byvar;(`x;$[optd[`normalize];`cumfrac;`cumqty]);optd];

   1b};

profile:{[t;c;b;a;optd]
  1b};

bar:{[t;c;b;a;optd]
  1b};

validate:{[] 
  0b};

