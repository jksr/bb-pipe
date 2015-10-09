import sys
sys.dont_write_bytecode = True

if len(sys.argv)!=2:
	print 'Usage: '+sys.argv[0]+' pdb'
	sys.exit(0)

pdb = sys.argv[1]
f = open('inputs/'+pdb+'/'+pdb+'.cen')
lines = f.readlines()
f.close()
cens = [ line.strip() for line in lines ]

f = open('inputs/'+pdb+'/'+pdb+'.sidechain')
lines = f.readlines()
f.close()
topos = {}
for line in lines:
	split = line.split()
	res = split[0]
	facing = split[1]
	topos[res]=facing

f = open('inputs/'+pdb+'/'+pdb+'.cen.topo','w')
for cen in cens:
	if topos[cen]=='IN':
		f.write(cen+'\t1\n')
	else:
		f.write(cen+'\t2\n')
f.close()



