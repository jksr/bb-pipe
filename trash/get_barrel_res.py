import sys
import os
pdb = sys.argv[1]
subnum = int(sys.argv[2])
barrelnum = int(sys.argv[3])

rep = subnum/barrelnum

if rep==1:
	os.system('cp inputs/{0}/{0}.res inputs/{0}/{0}.barrelres'.format(pdb))
else:
	sublen = len(open('inputs/{0}/{0}.res'.format(pdb)).readlines())
	# test
	with open('inputs/{0}/{0}.barrelres'.format(pdb), 'w') as fout:
		for i in range(rep):
			for j in range(sublen):
				fout.write(str(j+1)+'\n')
