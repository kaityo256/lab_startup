set term pdf
set out "pressure.pdf"
set xlabel "t"
set ylabel "P"
p "pressure.dat" pt 6 t "Data"
