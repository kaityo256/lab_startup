set term png
set out "calc_a.png"

set xlabel "Parameter" font "Arial,20"
set ylabel "Accuracy"  font "Arial,20" offset 1.5,0
set y2label "Elapsed Time" font "Ariak,20" offset 1.0,0
set ytics 0.2
set key at 0.95, 0.2
set y2tics
p [0:1] 1-exp(-x/0.2) lw 2 t "Accuracy"\
        ,x**2 axis x1y2 lw 2 t "Elapsed Time"\

set out "calc_b.png"

p [0:1] 1-exp(-x/0.15) lw 2 t "Accuracy"\
       ,1.3*x**2 axis x1y2 lw 2 t "Elapsed Time"

set out "calc_accuracy.png"
set xlabel "Parameter" font "Arial,20"
set ylabel "Accuracy"  font "Arial,20" offset 1.5,0
unset y2label
unset y2tics

p [0:1] 1-exp(-x/0.2) lw 2 t "X"\
       ,1-exp(-x/0.15) lw 2 t "Y"\


set out "calc_etime.png"
set xlabel "Parameter" font "Arial,20"
set ylabel "Elapsed Time"  font "Arial,20" offset 1.5,0
unset y2label
unset y2tics

p [0:1] x**2 lw 2 t "X"\
      ,1.3*x**2 lw 2 t "Y"

