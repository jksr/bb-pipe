import sys
import os
sys.path.append('../scripts/')
import pdb_info

pdbs = [ '1ek9', '2f1c', '1p4t', '1bxw', '1k24', '1qj8', '1qd6', '1t16', '2f1t', '1i78', '1prn', '1uyn', '1e54', '1thq', '2o4v', '2mpr', '1kmo', '1nqe', '1fep', '2omf', '1xkw', '2fcp', '2por']#, '1a0s', '7ahl' ]


for i in range(len(pdbs)):
	pdb = pdbs[i]
	os.system('python get_odds_outstruct.py '+pdb)
	os.system('perl mkcoord.pl '+pdb+' '+str(i+1)) 
	os.system('perl mkstrandcoord.pl '+pdb) 

os.system('cat odds_tmp/*.strand.coords > odds_tmp/updated_strand.coord')


pdb_info = pdb_info.read_pdb_info('../pdb_info.list')
for i in range(len(pdbs)):
	pdb = pdbs[i]
	print pdb
	os.system('perl getpairs.pl '+pdb+' '+str(i+1)+' ' + pdb_info[pdb]['#tmstrand'])

os.system('rm odds_tmp/all*')
os.system('cat odds_tmp/*.strong > odds_tmp/all.strong')
os.system('cat odds_tmp/*.weak > odds_tmp/all.weak')
os.system('cat odds_tmp/*.vdw > odds_tmp/all.vdw')
