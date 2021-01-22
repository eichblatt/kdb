\d .file

is_hsym:{[path]  
  if[type[path]<>-11h;:0b];
  first[.string.stringify[path]]~":"};
    
remove:`b;

name:{[path] $[.file.is_hsym[path]; 1_string path;.string.stringify[path]]};

fname:`x;

.file.hsym:{[path] 
  if[.file.is_hsym[path];:path];
  if[.Q.ty[path]~"c";:`$.string.append[":";path]];
  path};

.file.exists:{[path] not .Q.ty[key .file.hsym[path]]~" "};

makepath:{[head;tail] .file.hsym[.string.append[head;("/";tail)]]};

stat_raw:{[p]
  p:.file.hsym[p];
  if[not .file.exists[p]; :8#enlist""];
  stat:system "stat ",.file.name[p];
  stat}
 
is_dir:{[p] .file.stat_raw[p][1] like "*directory"};
parent:{[p] 
  parent_dir:.file.add_trailing_slash ("/" sv -1_"/" vs .file.name p);
  if[not .file.exists[parent_dir];.log.error "parent of path ",.file.name[p]," does not exist"; '"no such parent"];
  parent_dir};

rm_trailing_slash:{[p] 
  pn:.file.name .file.rm_duplicate_slashes .file.name[p];
  pn:$["/"~last pn;-1_pn;pn];
  .file.hsym[pn]};

rm_duplicate_slashes:{[p] .file.hsym {ssr[x;"//";"/"]}/[.file.name[p]]};
add_trailing_slash:{[p] .file.rm_duplicate_slashes[.file.name[p],"/"]};

dirname:{[p] $[.file.is_dir[p];.file.add_trailing_slash[p];.file.parent[p]]}

savesplay:{[p;t] 
  1b} 
