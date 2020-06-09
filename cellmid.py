import numpy as np
import sys
data = sys.stdin.readlines()
numarr = np.array(data[0].split())
numarr = np.array([float(x) for x in numarr])

xmin=numarr[range(3)]
xmax=numarr[range(4,7)]
origin=numarr[-3:]
boxsize = np.abs(xmin-xmax)
boxsize = np.ceil(boxsize)+1
boxsize = boxsize.astype(int)
print ("cellBasisVector1		{}	0	0".format(boxsize[0]))
print ("cellBasisVector2		0	{}	0".format(boxsize[1]))
print ("cellBasisVector3		0	0	{}".format(boxsize[2]))
print ("cellOrigin   " + str(origin[0]) + "    " + str(origin[1]) + "     "  + str(origin[2]))
