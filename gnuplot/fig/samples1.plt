set term pngcairo
set out "samples1.png"

p [-30:30] sin(x)

set term pdfcairo
set out "samples1.pdf"

rep
