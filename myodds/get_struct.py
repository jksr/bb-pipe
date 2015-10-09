import sys


if len(sys.argv)!= 3:
	print 'Usage: '+sys.argv[0]+' <dssp_file> <chain_id>'
	sys.exit(0)


fin = open(sys.argv[1])
foutn = sys.argv[1]
foutn = 'temp/'+foutn[ foutn.rfind('/')+1 : foutn.rfind('.dssp') ] +'.struct'
fout = open(foutn, 'w')

started = False
while True:
	line = fin.readline()
	if not line:
		break
	if line[2]=='#':
		started = True
		continue

	if started:
		try:
			id,chain = line[5:12].split()
		except:
			continue

		struct = line[16:26].strip()
		if len(struct)>0:
			struct = struct[0]
		else:
			struct = '0'
		fout.write(id+' '+struct+'\n')

fin.close()
fout.close()
