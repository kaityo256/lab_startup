import random
from math import exp,sin, pi

with open("pressure.dat", "w") as f:
    for i in range(100):
        x = i * 2 * pi / 100
        y = sin(x) + random.random() * 0.1
        f.write(f"{i*0.1:02f} {y:04f}\n")

with open("temperature.dat", "w") as f:
    for i in range(100):
        x = i * 2 * pi / 100
        y = 1.0 - exp(-x/0.4) + random.random() * 0.1
        f.write(f"{i*0.1:02f} {y:04f}\n")

