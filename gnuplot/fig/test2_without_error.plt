set term pngcairo
set out "test2_without_error.png"

f(x) = a * x
a = 1
fit f(x) "test2.dat" via a
p "test2.dat" w e, f(x)
