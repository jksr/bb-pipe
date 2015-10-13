#!/usr/bin/python
import os
import sys
sys.dont_write_bytecode = True
sys.path.append('scripts/')
import pdb_info


if __name__ == '__main__':
	pdb_info = pdb_info.read_pdb_info('pdb_info.list')
	if len(sys.argv) < 2:
		pdbs = sorted(pdb_info.keys())
	else:
		pdbs = sys.argv[1:]
	
	for pdb in pdbs:
		print pdb
		## get the strong, weak, vdw pair of the pdb
		os.system('python scripts/get_pair.py '+pdb+' '+pdb_info[pdb]['chain'])
		## compute  the strong, weak, vdw odds
		#TODO
		## compute  the single body odds
		#TODO

