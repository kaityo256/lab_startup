import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


x = np.arange(0, 2*np.pi, 2*np.pi*0.01)
y = np.sin(x)

plt.plot(x,y)
plt.savefig("sin.pdf")
