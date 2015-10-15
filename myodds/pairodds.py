import sys

if len(sys.argv)!=2:
	print 'Usage: '+sys.argv[0]+' <pair file>'
	sys.exit(0)

lastpair = ''
length = 1

exptot = {}
obstot = {}
for i in range(20):
	exptot[i] = {}
	obstot[i] = {}
	for j in range(20):
		exptot[i][j] = 0.0
		obstot[i][j] = 0.0

first = [0.0]*20
second = [0.0]*20

with open(sys.argv[1]) as fin:
	while True:
		line = fin.readline()
		if not line:
			break
		split = line.split()
		pair = split[0]
		aa1 = int(split[1])
		aa2 = int(split[2])
		if pair != lastpair:
			for i in range(20):
				for j in range(20):
					exptot[i][j] += first[i]*second[j]/length
					if i!=j:
						exptot[i][j] += first[j]*second[i]/length
			for i in range(20):
				first[i] = 0.0;
				second[i] = 0.0;
			length = 0.0
		first[aa1]+=1.0
		second[aa2]+=1.0
		obstot[aa1][aa2]+=1.0
		if aa1 != aa2:
			obstot[aa2][aa1]+=1.0

		lastpair = pair
		length+=1.0

for i in range(20):
	for j in range(20):
		exptot[i][j] += first[i]*second[j]/length
		if i!=j:
			exptot[i][j] += first[j]*second[i]/length

with open(sys.argv[1]+'.odds','w') as fout:
	for i in range(20):
		for j in range(i,20):
			if exptot[i][j] == 0:
				fout.write( '1.00\n' )
			else:
				fout.write( '%.2f\n'%(obstot[i][j]/exptot[i][j]) )


