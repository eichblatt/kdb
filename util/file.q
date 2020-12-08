\d .file

is_hsym:{[path]  
  if[type[path]<>-11h;:0b];
  first[.string.stringify[path]]~":"};
    
remove:`b;
name:`z;
fname:`x;

.file.hsym:{[path] 
  if[.file.is_hsym[path];:path];
  if[.Q.ty[path]~"c";:`$.string.append[":";path]];
  path};

.file.exists:{[path] not .Q.ty[key .file.hsym[path]]~" "};

makepath:{[head;tail] .file.hsym[.string.append[head;("/";tail)]]};

parent:`z
dir:`z
