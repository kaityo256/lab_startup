set term png
set out "zuru1.png"
set xtics 0.2
set pointsize 1.5
set key at 0.9,2.5
set xlabel "Parameter" font "Arial,20"
set out "zuru1.png"
set ylabel "Relative Performance" font "Arial,20" offset 1.5,0
p [:] [:] "zuru.dat" u 1:($3/$2) pt 7 , 1.0 w l lt 1 lc 0 t ""

set out "zuru2.png"
set ylabel "Relative Performance" font "Arial,20" offset 1.5,0
p [:] [0:] "zuru.dat" u 1:($3/$2) pt 7 , 1.0 w l lt 1 lc 0 t ""


