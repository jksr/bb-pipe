import sys
import os

if len(sys.argv)!=2:
	print 'Usage: '+sys.argv[0]+' <.list file>'
	sys.exit(0)

dirn = sys.argv[1]
dirn = dirn[dirn.find('/')+1:dirn.rfind('.')]

os.system('mkdir '+dirn)

f = open(sys.argv[1])
pdbs = f.readlines()
f.close()

for postfix in ['strong', 'weak', 'vdw']:

	lines = []
	for pdb in pdbs:
		pdb = pdb.strip()
		f = open('single_pdb_contact/'+pdb+'.'+postfix)
		lines += f.readlines()
		f.close()

	of = open(dirn+'/'+dirn+'.'+postfix,'w')
	for line in lines:
		of.write(line)
	of.close()

