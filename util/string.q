\d .string

stringify:{[s]
   if[.Q.ty[s]~"c"; :s];
   if[(.Q.ty[s]~"C") and type[s]~-10h;:enlist s]; // this is a string
   if[(.Q.ty[s]~"C") and all (type each s)=10h;:" " sv s]; // this is a list of strings
   if[s~();:""];
   if[.Q.ty[s] in "IJFDZPS ";:string[s]];
   if[type[s]<=0;:string[s]];
   '"Cannot Stringify Type of ",.Q.ty[s]};

.string.ssr:{[s;pat;repl_pat]
   orig_type:.Q.ty[s];
   new_str:ssr[.string.stringify[s];.string.stringify[pat];.string.stringify repl_pat];
   result:orig_type$new_str;
   result};

.string.append_help:{[s1;s2] 
   if[.Q.ty[s1]~"C";s1:.string.stringify[s1]];
   orig_type:.Q.ty[s1];
   new_str:orig_type$.string.stringify[s1],.string.stringify[s2];
   new_str}   

.string.append:{[s1;s2] 
   if[type[s2]~type[("a";`b)]; s2:(.string.append_help/)[first[s2];1_s2]];
   new_str:.string.append_help[s1;s2]}

.string.format:{[fmt;vardict]
   vardict:$[type[vardict]<0;.dict.kvd(`;vardict);vardict];
   vardict:.dict.optd[vardict];
   if[not[.Q.ty[fmt]~"c"];'"Format string must be a string"];
   vardict:.string.stringify each vardict;
   result:.string.ssr/[fmt;{"%",string[x],"%"} each key vardict;get vardict];
   result}; 
