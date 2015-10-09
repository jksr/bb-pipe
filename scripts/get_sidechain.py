import sys
sys.dont_write_bytecode = True
sys.path.append('../pylib/twbio/')
import dsspdata
import AminoAcid

import Bio.PDB
import warnings
warnings.simplefilter('ignore', Bio.PDB.PDBExceptions.PDBConstructionWarning)

import numpy as np
import math


if len(sys.argv)!=7:
	print 'Usage: '+sys.argv[0]+' <pdb> <chain> <#subunit> <#barrel> <#tmstrand> <istoxin>'
	sys.exit(0)

pdb = sys.argv[1]
chain = sys.argv[2]

subnum = int(sys.argv[3])
barrelnum = int(sys.argv[4])
tmnum = int(sys.argv[5])
istoxin = int(sys.argv[6])

# get the position of pore
dssp = dsspdata.DSSPData('inputs/'+pdb+'/'+pdb+'.dssp')
f = open('inputs/'+pdb+'/'+pdb+'.cen')
lines = f.readlines()
f.close()
cens = [ int(line) for line in lines ]
if subnum/barrelnum == 1:
	porex = 0
	porey = 0
	for cen in cens:
		porex += dssp.get(chain, cen, 'xca')
		porey += dssp.get(chain, cen, 'yca')
	porex /= len(cens)
	porey /= len(cens)
else:
	# this is using the following equation to calculate the center of the pore
	#   cos0 -sin0    x1-x0      xn-x0
	#  (           )(       ) = (     )
	#   sin0  cos0    y1-y0      yn-y0
	x1 = dssp.get(chain,cens[0],'xca')
	y1 = dssp.get(chain,cens[0],'yca')
	xn = dssp.get(chain,cens[-1],'xca')
	yn = dssp.get(chain,cens[-1],'yca')
	theta = -float(tmnum-1)/(float(subnum/barrelnum)*tmnum)*2*math.pi
	if istoxin==1:
		theta = -theta
	aa = math.cos(theta)
	bb = math.sin(theta)
	cc = xn+bb*y1-aa*x1
	dd = yn-bb*x1-aa*y1
	porex = ((1-aa)*cc-bb*dd) / ((1-aa)**2+bb**2)
	porey = (bb*cc+(1-aa)*dd) / ((1-aa)**2+bb**2)

porecenter = np.array([porex,porey])


# read pdb structure
pdb_structure = Bio.PDB.PDBParser().get_structure('', 'inputs/'+pdb+'/'+pdb+'.pdb')
pdb_chain = pdb_structure[0][chain]


f = open('inputs/'+pdb+'/'+pdb+'.strands')
lines = f.readlines()
f.close()
strand_residues = []
strand_num = 0
strand_ids = []
for line in lines:
	start, end = line.split()
	# use extended strand than the detected strands
	strand_residues += range(int(start)-1,int(end)+2)
	#strand_residues += range(int(start),int(end)+1)
	strand_ids += [strand_num for item in range(int(start)-1,int(end)+2)]
	strand_num += 1


bondlength=1.521;
bondangle=110.4*3.14/180;
torsion=122.55*3.14/180;


f = open('inputs/'+pdb+'/'+pdb+'.sidechain','w')

for pdb_res in pdb_chain:
	hetflag, seqid, icode = pdb_res.get_id()
	if not seqid in strand_residues:
		continue
	if hetflag!=' ' and hetflag!='H_MSE':
		continue

	coordca = np.array( pdb_res['CA'].get_coord() )
	try:
		coordcb = np.array( pdb_res['CB'].get_coord() )
	except:
		coordc = np.array( pdb_res['C'].get_coord() )
		coordn = np.array( pdb_res['N'].get_coord() )
		vec_cn = coordn-coordc
		vec_cca = coordca-coordc
		u = vec_cca/np.linalg.norm(vec_cca)
		dis1 = np.dot(vec_cn,u)
		new_cca = u*dis1
		dis2 = np.linalg.norm(vec_cn-new_cca)
		new_dis = vec_cn - new_cca
		v = new_dis/dis2
		w = np.cross(u,v)
		coordcb = coordca+ ( u + v*math.cos(torsion) + w*math.sin(torsion) )*bondlength*math.cos(3.14-bondangle)

	if np.linalg.norm( coordca[0:2] - porecenter ) < np.linalg.norm( coordcb[0:2] - porecenter ):
		facing = 'OUT'
	else:
		facing = 'IN'
	f.write(str(seqid)+' '+facing+' '+AminoAcid.three_to_one(pdb_res.get_resname())+' '+str(coordca[2])+'\n')
	#f.write(str(seqid)+' '+facing+' '+AminoAcid.three_to_one(pdb_res.get_resname())+' '+str(coordca[2])+' '+str(strand_ids[strand_residues.index(seqid)])+'\n')

f.close()
