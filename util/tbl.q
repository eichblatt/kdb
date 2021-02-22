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

stack:{[t;b;c;optd] // stack table columns c by b.
   if[all null c;c:cols[t] except b];
   base:?[t;();{x!x}b,();{x!{(last;x)}each x}c,()];
   m:0!select from (meta base) where not c in b;
   m:update parmname:.string.append[`parm] each t,valname:.string.append[`val]each t from m; 
   stakd:b xasc raze {[tt;elem] b:cols key[tt];0!?[0!tt;();{x!x}b,();(elem`parmname`valname)!(enlist[elem`c];(last;elem`c))]}[base] each m;
   stakd};
/
parms:.opts.get_opts[c]
\
