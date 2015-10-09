import sys


if len(sys.argv)!=3:
	print 'Usage: '+sys.argv[0]+' <pdb_file> <chain_id>'
	sys.exit(0)


fin = open(sys.argv[1])

foutn = sys.argv[1]
foutn = 'temp/'+foutn[ foutn.rfind('/')+1 : foutn.rfind('.pdb') ] +'.out'
fout = open(foutn,'w')

while True:
	line = fin.readline()
	if not line:
		break
	if line[:4]!='ATOM':
		continue
	split = line.split()
	if split[4]!=sys.argv[2]:
		continue
	fout.write(line)

fin.close()
fout.close()
