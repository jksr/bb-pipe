import os
import sys

if len(sys.argv) < 2:
	print "Usage: " +sys.argv[0]+ " pdb [, pdb, pdb, ...]"
	sys.exit(0)


for pdb in sys.argv[1:]:
	pdb = pdb.strip()
	os.system('wget http://www.rcsb.org/pdb/files/fasta.txt?structureIdList='+pdb+' -O inputs/'+pdb+'/'+pdb+'.fasta')
