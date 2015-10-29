import os
import sys
sys.dont_write_bytecode = True
sys.path.append('../pylib/twbio/')
import dsspdata

def extend_strand(strand, beginning, length):
	if beginning:
		if strand[0]<strand[-1]:
			extended = range(strand[0]-length, strand[0])
			newstrand = extended + strand
		else:
			extended = range(strand[0]+length, strand[0], -1)
			newstrand = extended + strand
	else:
		if strand[0]<strand[-1]:
			extended = range(strand[-1]+1, strand[-1]+length+1)
			newstrand = strand + extended 
		else:
			extended = range(strand[-1]-1, strand[-1]-length-1, -1)
			newstrand = strand + extended 
	return newstrand, extended

#haha = range(5, 10)
#print haha
#print len(extend_strand(haha, False, 5)), extend_strand(haha, False, 5)
#print '~'*10
#hehe = range(9, 4, -1)
#print hehe
#print len(extend_strand(hehe, False, 5)), extend_strand(hehe, False, 5)


if len(sys.argv)!= 3:
	print 'Usage: '+sys.argv[0]+' <pdb> <chain>'
	sys.exit(0)

pdb = sys.argv[1]
chain = sys.argv[2]

dssp = dsspdata.DSSPData('inputs/'+pdb+'/'+pdb+'.dssp')

f = open('inputs/'+pdb+'/'+pdb+'.strands')
#f = open('inputs/'+pdb+'/'+pdb+'.tmstrands')
lines = f.readlines()
f.close()


cens = []
for line in lines:
	start, end = line.split()
	start = int(start)
	end = int(end)

	# construct a strand always from peri to extra, ie. zca from - to +
	p2e_strand = range(start, end+1)
	extended = []
	zperi = dssp.get(chain, start, 'zca')
	zextra = dssp.get(chain, end, 'zca')
	if zperi > zextra:
		p2e_strand = list(reversed(p2e_strand))
		zperi, zextra = zextra, zperi
	if zperi*zextra < 0:
		pass
	elif zperi >= 0:
		p2e_strand, extended = extend_strand(p2e_strand, True, 4)
	else:
		p2e_strand, extended = extend_strand(p2e_strand, False, 4)

	#print p2e_strand
	# find the res closet to the midplane
	cen = None
	cenz = 10000
	for res in p2e_strand:
		try:
			z = dssp.get(chain, res, 'zca')
		except KeyError:
			continue
		if abs(z)<cenz:
			cenz = abs(z)
			cen = res
			#print cen, cenz
			if cenz < 1 and cen in extended:
				# regard the first res within +/- 1 out of strand interval as the center.
				# to elimitate the situation of abnormal strand
				break
	cens.append(cen)

f = open('inputs/'+pdb+'/'+pdb+'.cen','w')
for cen in cens:
	f.write(str(cen)+'\n')
	#f.write(str(cen)+' '+str(dssp.get(chain,cen,'zca'))+'\n')
f.close()

