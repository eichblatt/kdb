\d .tbl

rename:{[t;c1;c2] // rename columns c1 in table t to c2
   allcols:cols[t];
   newcols:@[allcols;where allcols in c1;:;c2];
   t:newcols xcol t;
   t:.Q.id[t];
   t};

split_help:{[t;b;s;c;x] 
  wc:enlist(=;s;enlist x);
  label:{[c;l].string.append[c;("_";l)]}[;x]each c,();
  ?[t;wc;{x!x}b,();label!{(last;x)} each c,()]} 

split:{[t;b;s;c] // split table by b on columns s, return columns c
   t:0!t;
   labels:?[t;();();(distinct;s)];
   c:$[all null c;cols[t] except b,s;c];
   rr:b xasc (uj/)split_help[t;b;s;c] each labels;
   rr}
/
parms:.opts.get_opts[c]
\
