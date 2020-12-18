\d .log

SILENT:0W
FATAL:6
ERROR:5
WARN:4
INFO:3
DEBUG:2
VERBOSE:1
ALL:0

thresh:3

print:{[str] -1 (7#str),string[.z.Z]," -- ",7_str}

fatal:{[str] if[thresh<=FATAL; print["FATAL: ",str]]};
  
error:{[str] if[thresh<=ERROR; print["ERROR: ",str]]};

warn:{[str] if[thresh<=WARN;   print["WARN:  ",str]]};

info:{[str] if[thresh<=INFO;   print["INFO:  ",str]]};

debug:{[str] if[thresh<=DEBUG; print["DEBUG: ",str]]};

verbose:{[str] if[thresh<=VERBOSE; print["VERBOSE:",str]]};

set_thresh:{[lev] thresh::lev};

validate:{[]
  .log.set_thresh[.log.DEBUG];
  .log.info["info testing 1 2 3"];
  .log.warn["warning testing 1 2 3"];
  .log.debug["debug testing 1 2 3"];
  .log.verbose["verbose testing 1 2 3"];
  }
