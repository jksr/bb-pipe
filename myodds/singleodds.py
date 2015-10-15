import sys
sys.path.append('../../pylib/twbio')
import AminoAcid as AA

if len(sys.argv)!=2:
	print 'Usage: '+sys.argv[1]+' <sidechain>'
	sys.exit(0)
dirn = sys.argv[1][:sys.argv[1].rfind('/')]

ecap = {}
ein = {}
eout = {}
cin = {}
cout = {}
pin = {}
pout = {}
pcap = {}
nx = {}
for i in range(20):
	ecap[i]=0.0
	ein[i]=0.0
	eout[i]=0.0
	cin[i]=0.0
	cout[i]=0.0
	pin[i]=0.0
	pout[i]=0.0
	pcap[i]=0.0
	nx[i]=0.0

nall = 0
nr={'ecap':0.0,'ein':0.0,'eout':0.0,'cin':0.0,'cout':0.0,'pin':0.0,'pout':0.0,'pcap':0.0}

with open(sys.argv[1]) as fin:
	while True:
		line = fin.readline()
		if not line:
			break
		dummy, face, aa, zca = line.split()
		zca = float(zca)
		aaid = AA.one_to_index(aa)

		if 13.5 < zca and zca <= 20.5: 
			ecap[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['ecap']+=1.0
		elif 6.5 < zca and zca <= 13.5 and face == 'IN': 
			ein[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['ein']+=1.0
		elif 6.5 < zca and zca <= 13.5 and face == 'OUT': 
			eout[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['eout']+=1.0
		elif -6.5 <= zca and zca <= 6.5 and face == 'IN': 
			cin[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['cin']+=1.0
		elif -6.5 <= zca and zca <= 6.5 and face == 'OUT': 
			cout[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['cout']+=1.0
		elif -13.5 <= zca and zca < -6.5 and face == 'IN': 
			pin[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['pin']+=1.0
		elif -13.5 <= zca and zca < -6.5 and face == 'OUT': 
			pout[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['pout']+=1.0
		elif -20.5 <= zca and zca < -13.5: 
			pcap[aaid]+=1.0
			nx[aaid]+=1.0
			nall+=1.0
			nr['pcap']+=1.0

regionlist = [ecap, ein, eout, cin, cout, pin, pout, pcap]
regionname = ['ecap', 'ein', 'eout', 'cin', 'cout', 'pin', 'pout', 'pcap']
foutn = ['tmp.tmp', 'ExtraIn.odds', 'ExtraOut.odds', 'CoreIn.odds', 'CoreOut.odds', 'PeriIn.odds', 'PeriOut.odds', 'tmp.tmp']
fout = [ open(dirn+'/'+fn,'w') for fn in foutn ]

for j in range(8):
	for i in range(20):
		try:
			fout[j].write( '%.3f\n'%((regionlist[j][i]/nr[regionname[j]])/(nx[i]/nall)) )
		except ZeroDivisionError:
			if regionlist[j][i] == 0 and nx[i] == 0.0:
				fout[j].write( '1.000\n' )
			elif regionlist[j][i] == 0:
				fout[j].write( 'o.000\n' )
			else:
				print "ERORROROOROORO!!!!!!!!!!!!!!!!!!11"

