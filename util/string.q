\d .string

stringify:{[s]
   if[.Q.ty[s]~"c"; :s];
   if[.Q.ty[s]~"C";:enlist s];
   if[.Q.ty[s] in "IJFDZPS ";:string[s]];
   if[type[s]<=0;:string[s]];
   '"Cannot Stringify Type of ",.Q.ty[s]};

.string.ssr:{[s;pat;repl_pat]
   orig_type:.Q.ty[s];
   new_str:ssr[.string.stringify[s];.string.stringify[pat];.string.stringify repl_pat];
   result:orig_type$new_str;
   result};
   
.string.append:{[s1;s2] 
   if[.Q.ty[s1]~"C";s1:.string.stringify[s1]];
   orig_type:.Q.ty[s1];
   new_str:orig_type$.string.stringify[s1],.string.stringify[s2];
   new_str}
