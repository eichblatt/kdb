\d .dict

optd:1

kvd:{[kv] 
  if[not mod[count[kv];2]~0;'"key/value list not divisible by 2"];
  k:kv first ff:flip 2 cut til count kv;
  v:kv last ff;
  k!v}
