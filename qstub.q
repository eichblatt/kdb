
c:.opts.addopt[`;`debug;1b;"debug"];
c:.opts.addopt[c;`path;`$":",getenv`HOME;"file path"];
parms:.opts.get_opts c;

main:{[parms]
  1b
  }

if[not parms[`debug];main[parms];exit 0];
