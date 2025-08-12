set terminal pngcairo enhanced font 'Verdana,10'

N = system("sed '1q;d' para.dat")
a = system("sed '9q;d' para.dat")
u = system("sed '3q;d' para.dat")
b = system("sed '2q;d' para.dat")
f0 = system("sed '8q;d' para.dat")

nos = int(system("sed '1q;d' vari.dat"))

do for [i=1:nos] {
	lo(i) = system("sed '".i."q;d' l0.dat")
}

fnm = system("sed '1q;d' filen.dat")

set output sprintf("%s_runl.png",fnm)
set title sprintf("Run-Length Distribution: N = %s, pi = %s, e = %s , alpha = %s , f0 = %s pN",N,b,u,a,f0)
set ylabel "Run-length distribution p(x)"
set yrange [0:0.05]
set xlabel "Run-length x in nm"
plot for [i=1:nos] 'sls'.i.'_xdata.dat' w lp title sprintf('SLS lo = %s nm',lo(i)) ,  'dyn_xdata.dat' w lp title 'Mean-field'

set output sprintf("%s_fpt.png",fnm)
set title sprintf("FPT Distribution: N = %s, pi = %s, e = %s , alpha = %s , f0 = %s pN",N,b,u,a,f0)
set ylabel "FPT distribution p(t)"
set yrange [0:1]
set xlabel "FPT t in sec"
plot for [i=1:nos] 'sls'.i.'_tdata.dat' w lp title sprintf('SLS lo = %s nm',lo(i)) ,  'dyn_tdata.dat' w lp title 'Mean-field'

set output sprintf("%s_vl.png",fnm)
set title sprintf("Avg Velocity Distribution: N = %s, pi = %s, e = %s , alpha = %s , f0 = %s pN",N,b,u,a,f0)
set ylabel "Avg Velocity distribution p(v)"
set yrange [0:0.01]
set xlabel "Avg Velocity v in nm/sec"
plot for [i=1:nos] 'sls'.i.'_vdata.dat' w lp title sprintf('SLS lo = %s nm',lo(i)) ,  'dyn_vdata.dat' w lp title 'Mean-field'

set output sprintf("%s_stt.png",fnm)
set title sprintf("Stall Time Distribution: N = %s, pi = %s, e = %s , alpha = %s , f0 = %s pN",N,b,u,a,f0)
set ylabel "Stall time distribution p(st)"
set yrange [0:1]
set xlabel "Stall time st in sec"
plot for [i=1:nos] 'sls'.i.'_stdata.dat' w lp title sprintf('SLS lo = %s nm',lo(i)) ,  'dyn_stdata.dat' w lp title 'Mean-field'

set output sprintf("%s_fptlg.png",fnm)
set title sprintf("FPT Distribution over log scale: N = %s, pi = %s, e = %s , alpha = %s , f0 = %s pN",N,b,u,a,f0)
set ylabel "FPT distribution p(t)"
set yrange [0:1]
set xlabel "FPT log(t)"
plot for [i=1:nos] 'sls'.i.'_ltdata.dat' w lp title sprintf('SLS lo = %s nm',lo(i)) ,  'dyn_ltdata.dat' w lp title 'Mean-field'

set output sprintf("%s_sttlg.png",fnm)
set title sprintf("Stall Time Distribution over log scale: N = %s, pi = %s, e = %s , alpha = %s , f0 = %s pN",N,b,u,a,f0)
set ylabel "Stall time distribution p(st)"
set yrange [0:0.5]
set xlabel "Stall time log(st)"
plot for [i=1:nos] 'sls'.i.'_lstdata.dat' w lp title sprintf('SLS lo = %s nm',lo(i)) ,  'dyn_lstdata.dat' w lp title 'Mean-field'

set output sprintf("%s_sts.png",fnm)
set style data histogram
set style fill border
set boxwidth 0.9
set title sprintf("Stall States Distribution: N = %s, pi = %s, e = %s , alpha = %s , f0 = %s pN",N,b,u,a,f0)
set ylabel "Stall state probability p(n)"
set yrange [0:1]
set xlabel "Motor state n"
plot for [i=1:nos] 'sls'.i.'_stsdata.dat' using 2:xticlabels(1) title sprintf('SLS lo = %s nm',lo(i)) ,  'dyn_stsdata.dat' using 2:xticlabels(1) title 'Mean-field'
