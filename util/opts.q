\d .opts

/opts_dict:.Q.opt .z.x;
opts_tbl:enlist `name`default`description!3#enlist(::);

addopt:{[d;name;default;description]
   if[.Q.ty[d]~"S"; if[null[d];d:.opts.opts_tbl]];
   if[count[d]=0; d:.opts.opts_tbl];
   d,enlist cols[d]!(name;default;enlist description)};

.opts.parse_opts:{[tbl;args]
   args_dict:.Q.opt args;
   defs:(tbl`name)!tbl`default;
   optd:.Q.def[defs;args_dict];
   // now, fix the hsyms
   hsyms:where .file.is_hsym each 1_defs;    
   optd:@[optd;hsyms;:;hsym each optd[hsyms]];
   optd}

.opts.get_opts:{[tbl]
   .opts.parse_opts[tbl;.z.x]}
/
c:.opts.addopt[`;`debug;0b;"debug"];
c:.opts.addopt[c;`filename;`:/home/steve;"testing file type"];
c:.opts.addopt[c;`other;`asdf;"testing sym type"];
parms:.opts.get_opts[c]

\
