set term pdf
set out "temperature.pdf"
set xlabel "t"
set ylabel "T"
p "temperature.dat" pt 6 t "Data"
