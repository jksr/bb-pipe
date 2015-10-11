import sys
sys.path.append('../pylib/twbio')
from dsspdata import DSSPData

if len(sys.argv)<0:
	print 'Usage '+sys.argv[0]+' <pdb> <chain>'
	sys.exit(0)

pdb = sys.argv[1]
chain = sys.argv[2]

dssp = DSSPData('inputs/{pdb}/{pdb}.dssp'.format(pdb=pdb))

def aa(chain,res):
	rtn = dssp.get(chain,res,'aa')
	if rtn == 'X': 
		rtn = 'M'
	elif rtn == 'a' or rtn == 'b': 
		rtn = 'C'
	return rtn


neighbor_dict = {}
with open('inputs/{pdb}/{pdb}.strands'.format(pdb=pdb)) as fout:
	strandnum = 0
	while True:
		line = fout.readline()
		if not line:
			break
		split = line.split()
		for i in range(int(split[0]),int(split[1])+1):
			neighbor_dict[i]=strandnum
		strandnum += 1

def neighbor_strand(res1,res2):
	if res1 not in neighbor_dict or res2 not in neighbor_dict: 
		return False
	rlt = (neighbor_dict[res1]-neighbor_dict[res2])%strandnum
	if rlt == 1 or rlt == strandnum-1:
		return True
	else:
		return False



with open('inputs/{pdb}/{pdb}.sidechain'.format(pdb=pdb))as fin:
	sidechains = []
	for line in fin.readlines():
		split = line.split()
		sidechains.append( [int(split[0]),split[1],split[2],float(split[3])] )


sfout = open('inputs/{pdb}/{pdb}.strong'.format(pdb=pdb),'w')
vfout = open('inputs/{pdb}/{pdb}.vdw'.format(pdb=pdb),'w')
wfout = open('inputs/{pdb}/{pdb}.weak'.format(pdb=pdb),'w')



for sidechain in sidechains:
	res, face, rtn, zca = sidechain
	#if 13.5<zca and zca <=20.5:
	#	dep = 5
	#elif 6.5<zca and zca <=13.5:
	#	dep = 4
	#elif -6.5<=zca and zca <=6.5:
	#	dep = 3
	#elif -13.5<=zca and zca <-6.5:
	#	dep = 2
	#elif -20.5<=zca and zca <-13.5:
	#	dep = 1
	#else:
	#	continue

	# these are the dssp nums not res ids
	resnum = dssp.get(chain,res,'num')
	bp1num = dssp.get(chain,res,'bp1')
	bp2num = dssp.get(chain,res,'bp2')
	hbond1num = int(dssp.get(chain,res,'h_nho1').split(',')[0])+resnum
	hbond2num = int(dssp.get(chain,res,'h_ohn1').split(',')[0])+resnum
	if bp1num !=0:
		bp1res = dssp.records[bp1num].get('resnum', 0)
	else:
		bp1res = 0
	if bp2num !=0:
		bp2res = dssp.records[bp2num].get('resnum', 0)
	else:
		bp2res = 0
	hbond1res = dssp.records[hbond1num].get('resnum')
	hbond2res = dssp.records[hbond2num].get('resnum')

	strong = 0
	vdw = 0
	weak1 = 0
	weak2 = 0
	if not aa(chain,res)=='P':
		if bp1res == hbond1res and hbond1res == hbond2res:
			strong = bp1res
			vdw = bp2res
		elif bp2res == hbond1res and hbond1res == hbond2res:
			strong = bp2res
			vdw = bp1res
		else:
			strong = 0
			if bp1res != 0:
				vdw = bp1res
			elif bp2res != 0:
				vdw = bp2res
	else:
		if bp1res != 0 and bp2res == 0:
			vdw = bp1res
			if hbond2res != 0 and hbond2res != bp1res and neighbor_strand(res,hbond2res):
				strong = hbond2res
		elif bp2res != 0 and bp1res == 0:
			vdw = bp2res
			if hbond2res != 0 and hbond2res != bp2res and neighbor_strand(res,hbond2res):
				strong = hbond2res
	weak1 = strong-1
	weak2 = vdw-1

	if neighbor_strand(res,strong):
		sfout.write('{res}\t{strong}\n'.format(res=res,strong=strong,vdw=vdw,weak1=weak1,weak2=weak2))
	if neighbor_strand(res,vdw):
		vfout.write('{res}\t{vdw}\n'.format(res=res,strong=strong,vdw=vdw,weak1=weak1,weak2=weak2))
	if neighbor_strand(res,weak1):
		wfout.write('{res}\t{weak1}\n'.format(res=res,strong=strong,vdw=vdw,weak1=weak1,weak2=weak2))
	if neighbor_strand(res,weak2):
		wfout.write('{res}\t{weak2}\n'.format(res=res,strong=strong,vdw=vdw,weak1=weak1,weak2=weak2))

sfout.close()
vfout.close()
wfout.close()
