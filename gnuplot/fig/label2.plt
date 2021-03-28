set term pngcairo
set out "label2.png"

set xlabel "Temperature" font "Helvetica,40"
p sin(x)
