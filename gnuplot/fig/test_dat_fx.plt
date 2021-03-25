set term pngcairo
set out "test_dat_fx.png"

f(x) = a * x
a = 1

p "test.dat", f(x)
