set term pngcairo
set out "test2_with_error.png"

f(x) = a * x
a = 1
fit f(x) "test2.dat" using 1:2:3 via a
p "test2.dat" w e, f(x)
