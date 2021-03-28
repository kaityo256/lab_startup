set term pngcairo
set out "samples2.png"

set samples 1000
p [-30:30] sin(x)

set term pdfcairo
set out "samples2.pdf"

rep


