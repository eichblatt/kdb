\d .graph

gvcmd:"/usr/bin/gv -watch -resize -geometry 560x530 -widgetless ";
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

write_gpfile:{[text]
   plotcounter::plotcounter+1;
   currentplot::plotcounter;
   if[not .file.exists[.graph.outpath];system "mkdir -p ",.file.name[.graph.outpath]];
   outfile:.file.makepath[.graph.outpath;.string.append["plot";(-4#"0000",string[plotcounter];".gp")]];
   -1 string outfile 0: text};

/view_gpfile:{[optd]

tbl_to_string:{[t]
  headstring:enlist "$mydata << EOD";
  datastring:"," 0: 0!t;
  tailstring:enlist "EOD";
  raze (headstring;datastring;tailstring)};

 
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
  xytheader: enlist .string.format["set datafile separator \",\"; %xfmt% set autoscale fix";(`xfmt;xfmt)];
  xytdata:.graph.tbl_to_string[xydata];

  ycols:cols[xydata] except `x;
  /plotcmd0:", " sv {.string.format["$mydata using 1:%icol% title \"%title%\" with %linetype%";(`icol;y;`linetype;x;`title;z)]}[`linespoint]'[2+til count ycols;ycols];
  plotcmd0:", " sv {.string.format["$mydata using 1:%icol% title \"%title%\" with %linetype%";(`icol;y;`linetype;x;`title;z)]}[`lines]'[2+til count ycols;ycols];
  plotcmd:enlist "plot ",plotcmd0;
  write_gpfile[raze (xytheader;xytdata;plotcmd)];
  1b};

cdf:{[t;b;a;optd]
  1b};

profile:{[t;b;a;optd]
  1b};


