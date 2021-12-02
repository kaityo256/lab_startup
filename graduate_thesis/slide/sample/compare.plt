set term png
set out "compare1.png"
set xtics 0.2
set pointsize 1.5
set key at 0.9,2.5
set xlabel "Parameter" font "Arial,20"
set ylabel "Performance" font "Arial,20" offset 1.5,0
p "compare.dat" u 1:2 pt 6 t "Original", "compare.dat" u 1:3 pt 7 t "Improved"

set out "compare2.png"
set ylabel "Relative Performance" font "Arial,20" offset 1.5,0
p [0:1] [0:] "compare.dat" u 1:($3/$2) pt 7 , 1.0 w l lt 1 lc 0 t ""

