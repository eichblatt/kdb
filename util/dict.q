\d .dict

optd:{[d]
  if[type[d]~99h;:d];
  d:$[type[d]~0h;.dict.kvd d;d];
  d:$[type[d]~-11h;()!();d];
  d}

kvd:{[kv] 
  if[not mod[count[kv];2]~0;'"key/value list not divisible by 2"];
  k:kv first ff:flip 2 cut til count kv;
  v:kv last ff;
  k!v};

def:{[defaults;dict] 
  defaults:.dict.optd[defaults];
  dict:.dict.optd[dict];
  newkeys:key[dict] except key[defaults];
  values: defaults upsert dict;

  typematch:(type each values key defaults) = type each defaults;
  if[any not typematch; -1 "Note: Changing type of ","," sv string each where not typematch];
  if[count[newkeys]>0; -1 "Note: No defaults for ","," sv string each newkeys];
  values};

/
usage: when defining a function, add an optd argument like this:
  my_function:{[x;y;optd]
    optd:.dict.def[(`verbose;0b;`method;`test;`threshold;3.0);optd];
    / now optd will have the defaults, and any overrides which were passed in.
    threshold:optd`threshold;
\
