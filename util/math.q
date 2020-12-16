\d .math

mad:{[list]  // median of abs deviation of a list
  med[abs[list-med[list]]]};
  
k) p5:{avg x(<x)@_.05*-1 0+#x,:()};
k) p25:{avg x(<x)@_.25*-1 0+#x,:()};
k) p75:{avg x(<x)@_.75*-1 0+#x,:()};
k) p95:{avg x(<x)@_.95*-1 0+#x,:()};

simple_stats:{[list]
  .dict.kvd(`N;count list;`mean;avg list;`std;sdev list;`mad;mad list;`min;min list;`p5;p5 list;`p25;p25 list;`median;med list;`p75;p75 list;`p95;p95 list;`max;max list)};
/
.math.simple_stats[100]
\
