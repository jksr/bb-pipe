import sys
sys.dont_write_bytecode = True
sys.path.append('../pylib/twbio')
import dsspdata
import collections


if len(sys.argv)!=3:
	print 'Usage: '+sys.argv[0]+' <pdb> <chain>'
	sys.exit(0)

pdb = sys.argv[1]
chain = sys.argv[2]

dssp = dsspdata.DSSPData('inputs/'+pdb+'/'+pdb+'.dssp')

def construct_barrel(fn):
	f = open(fn)
	lines = f.readlines()
	f.close()
	barrel = []
	for i in range(len(lines)):
		start, end = lines[i].split()
		start = int(start)
		end = int(end)
		if i%2==0:
			barrel.append(range(start,end+1))
		else:
			barrel.append(range(end,start-1,-1))
	return barrel


def determine_reg(barrel):
	strandn = len(barrel)
	regs = []

	for i in range(strandn):
		ireg = []
		for pos1 in range(len(barrel[i])):
			pos2 = None
			bp1 = dssp.get(chain, barrel[i][pos1], 'bp1')
			if bp1>0:
				bp1 = dssp.records[bp1]['resnum']
				try:
					pos2 = barrel[(i+1)%strandn].index(bp1)
				except:
					pass
			bp2 = dssp.get(chain, barrel[i][pos1], 'bp2')
			if bp2>0:
				bp2 = dssp.records[bp2]['resnum']
				try:
					pos2 = barrel[(i+1)%strandn].index(bp2)
				except:
					pass
			if not pos2 is None:
				ireg.append(pos2-pos1)
		if len(set(ireg))>1:
			print 'Warning: potential beta bulge detected in '+pdb+' between strand '+str(i)+' and strand '+str((i+1)%strandn)
			print ireg
		regs.append( collections.Counter(ireg).most_common(1)[0][0] )

	return regs


barrel = construct_barrel('inputs/'+pdb+'/'+pdb+'.strands')
regs = determine_reg(barrel)
f = open('inputs/'+pdb+'/'+pdb+'.regs','w')
for reg in regs:
	f.write(str(reg)+'\n')
f.close()

tmbarrel = construct_barrel('inputs/'+pdb+'/'+pdb+'.tmstrands')
tmregs = determine_reg(tmbarrel)
f = open('inputs/'+pdb+'/'+pdb+'.tmregs','w')
for reg in tmregs:
	f.write(str(reg)+'\n')
f.close()

