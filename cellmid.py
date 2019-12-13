import numpy as np
import sys
data = sys.stdin.readlines()
numarr= np.loadtxt(data)
xmin=numarr[range(3)]
xmax=numarr[range(3,6)]
origin=numarr[range(6,9)]
boxsize = np.abs(xmin-xmax)
boxsize = np.ceil(boxsize)+1
boxsize = boxsize.astype(int)
print ("cellBasisVector1		{}	0	0".format(boxsize[0]))
print ("cellBasisVector2		0	{}	0".format(boxsize[1]))
print ("cellBasisVector3		0	0	{}".format(boxsize[2]))
print ("cellOrigin   " + str(origin[0]) + "    " + str(origin[1]) + "     "  + str(origin[2]))
