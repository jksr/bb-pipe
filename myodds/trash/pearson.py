import scipy.stats as st
import numpy as np
import sys


a1 = np.loadtxt(sys.argv[1])
a2 = np.loadtxt(sys.argv[2])



print st.pearsonr(a1,a2)
