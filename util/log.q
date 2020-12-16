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

print:{[str] -1 str}

fatal:{[str] if[thresh<=FATAL; print[str]]};
  
error:{[str] if[thresh<=ERROR; print[str]]};

warn:{[str] if[thresh<=WARN; print[str]]};

info:{[str] if[thresh<=INFO; print[str]]};

debug:{[str] if[thresh<=DEBUG; print[str]]};

verbose:{[str] if[thresh<=VERBOSE; print[str]]};

set_thresh:{[lev] thresh::lev};

validate:{[]
  .log.set_thresh[.log.DEBUG];
  .log.info["info testing 1 2 3"];
  .log.warn["warning testing 1 2 3"];
  .log.debug["debug testing 1 2 3"];
  .log.verbose["verbose testing 1 2 3"];
  }
