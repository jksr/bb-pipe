# get pdb.tri.center file
# created by Wei Tian, Dec 11.2014

import sys
sys.dont_write_bytecode = True
sys.path.append('../pylib/twbio/')
from dsspdata import DSSPData
import numpy as np

pdb = sys.argv[1]
chain = sys.argv[2]
subnum = int(sys.argv[3])
barrelnum = int(sys.argv[4])
tmstrandnum = int(sys.argv[5])
istoxin = int(sys.argv[6])

rep = subnum/barrelnum # replication times of the subunits
sublen = len(open('inputs/{0}/{0}.res'.format(pdb)).readlines()) # len of a subunit

dssp = DSSPData('inputs/{0}/{0}.dssp'.format(pdb))
ss = np.loadtxt('inputs/{0}/{0}.strands'.format(pdb)).astype(int)

def findpair(center, is2end):
	for offset in [0, 1, -1, 2, -2, 3, -3, 4, -4]:
		mid = center + offset
	#for mid in range(center-4, center+5):
		rightref = dssp.get(chain,mid,'bp1')
		leftref = dssp.get(chain,mid,'bp2')
		if leftref in dssp.records and rightref in dssp.records:
			right = dssp.records[rightref]['resnum'] + offset
			left = dssp.records[leftref]['resnum'] + offset
			if is2end:
				return left,right
			else:
				return right,left

# compute tricenter pattern of one subunit
cens = open('inputs/{0}/{0}.cen'.format(pdb)).readlines()
cens = [int(cen) for cen in cens]

subtricen = []
for i in range(tmstrandnum):
	mostcen = cens[i]
	is2end = i==0 or i==tmstrandnum-1
	try:
		left, right = findpair(mostcen, is2end)
	except:
		left, right = -300, -300
	subtricen.append( [left, mostcen, right] )

if istoxin==1:
	subtricen = np.flipud(subtricen)

tricenmtrx = np.tile(subtricen, (rep,1))

# compute the triplet.con file
tripletcon = np.tile(tricenmtrx, (1,2)).astype(int)
for i in range(len(tripletcon)):
	if i%2==0:
		tripletcon[i][[0,1,2]] = tripletcon[i][[0,1,2]]- np.array([9,8,9])
		tripletcon[i][[3,4,5]] = np.array([1,2,1])
	else:
		tripletcon[i][[0,1,2]] = tripletcon[i][[0,1,2]] - np.array([8,9,8])
		tripletcon[i][[3,4,5]] = np.array([2,1,2])

np.savetxt('inputs/{0}/{0}.triplet.con'.format(pdb), tripletcon, fmt='%d', delimiter='\t')

