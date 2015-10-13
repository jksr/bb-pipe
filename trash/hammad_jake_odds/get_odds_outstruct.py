import sys

if len(sys.argv)!=2:
	print 'Usage: '+sys.argv[0]+' <pdb>'
	sys.exit(0)


pdb = sys.argv[1]
with open('../inputs/'+pdb+'/'+pdb+'.pdb') as fin:
	lines = fin.readlines()
with open('odds_tmp/'+pdb+'.out','w') as fout:
	for line in lines:
		if line.startswith('ATOM'):
			fout.write(line)


with open('../inputs/'+pdb+'/'+pdb+'.dssp') as fin:
	lines = fin.readlines()
with open('odds_tmp/'+pdb+'.struct','w') as fout:
	for line in lines:
		if len(line)==137:
			if line[5:11].strip().isdigit() and len(line[16:17].strip())!=0:
				fout.write(line[5:11].strip()+' '+line[16:17].strip()+'\n')
