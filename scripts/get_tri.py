# get pdb.tri.center file
# created by Wei Tian, Dec 11.2014

import sys
sys.dont_write_bytecode = True
sys.path.append('../pylib/twbio/')
from dsspdata import DSSPData
import numpy as np

pdb = sys.argv[1]
chain = sys.argv[2]
subnum = int(sys.argv[3]) # subunit num of the strands that form the pore
if len(sys.argv) < 5:
	istoxin = False
else:
	istoxin = sys.argv[4] in ['true','True','1']

dssp = DSSPData('inputs/{0}/{0}.dssp'.format(pdb))
ss = np.loadtxt('inputs/{0}/{0}.strands'.format(pdb)).astype(int)

sublen = len(dssp.records)/subnum # the subunit length
substrandnum = len(ss) # the strand num of one subunit


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
subtricen = []
for i in range(substrandnum):
	mostcen = 0
	mostcenz = 300
	for j in range(ss[i][0],ss[i][1]+1):
		zca = dssp.get(chain,j,'zca')
		if abs(zca) < mostcenz:
			mostcenz = abs(zca)
			mostcen = j
	is2end = i==0 or i==substrandnum-1
	try:
		left, right = findpair(mostcen, is2end)
	except:
		left, right = -300, -300
	subtricen.append( [left, mostcen, right] )

if istoxin:
	subtricen = np.flipud(subtricen)



## compute tricenter matrix
# first compute the basic tricenter matrix
base = np.zeros( (substrandnum,3) )
base[0][0] = -1
base[-1][-1] = 1
tricenmtrx = base
for i in range(1,subnum):
	tricenmtrx = np.vstack( ( tricenmtrx, base+i*np.ones( (substrandnum,3) ) ) )
tricenmtrx = np.mod(tricenmtrx,subnum) * sublen

# then add the subtricen pattern to the basic tricenter matrix to get the final one
tricenmtrx = tricenmtrx + np.tile(subtricen, (subnum,1))
#np.savetxt('inputs/{0}/{0}.tri.center'.format(pdb), tricenmtrx, fmt='%d', delimiter='\t')


## compute the cen.topo file
cens =  tricenmtrx[:,1].astype(int).tolist()
centopo = []
sidechainf = open('inputs/{0}/{0}.sidechain'.format(pdb))
lines = sidechainf.readlines()
sidechainf.close()

for line in lines:
	splt = line.split()
	if int(splt[0]) in cens:
		if splt[3]=='IN':
			centopo.append([splt[0],1])
		else:
			centopo.append([splt[0],2])
if len(cens) != len(centopo):
	assert( len(cens)/len(centopo) == subnum )

centopo = np.array(centopo).astype(int)
np.savetxt('inputs/{0}/{0}.cen.topo'.format(pdb), centopo, fmt='%d', delimiter='\t')


## compute the triplet.con file
tripletcon = np.tile(tricenmtrx, (1,2)).astype(int)
for i in range(len(tripletcon)):
	if i%2==0:
		tripletcon[i][[0,1,2]] = tripletcon[i][[0,1,2]]- np.array([9,8,9])
		tripletcon[i][[3,4,5]] = np.array([1,2,1])
	else:
		tripletcon[i][[0,1,2]] = tripletcon[i][[0,1,2]] - np.array([8,9,8])
		tripletcon[i][[3,4,5]] = np.array([2,1,2])

np.savetxt('inputs/{0}/{0}.triplet.con'.format(pdb), tripletcon, fmt='%d', delimiter='\t')

