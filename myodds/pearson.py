import scipy.stats as ss
import numpy as np
import sys


a = np.loadtxt(sys.argv[1])
b = np.loadtxt(sys.argv[2])


print ss.pearsonr(a,b)
