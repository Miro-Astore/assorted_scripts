import numpy as np
import sys
data = sys.stdin.readlines()
numarr= np.loadtxt(data)
arrmax = max(numarr)
arrmin = min(numarr)
length = np.ceil(np.abs(arrmax-arrmin))
center = arrmax-arrmin/2
print str(int(length))
