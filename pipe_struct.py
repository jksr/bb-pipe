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
		## make folder for the pdb
		os.system('mkdir inputs/'+pdb)
		## download and process opm pdb
		os.system('python scripts/get_opm_pdb.py '+pdb)
		## get dssp
		os.system('mkdssp inputs/'+pdb+'/'+pdb+'.pdb > inputs/'+pdb+'/'+pdb+'.dssp')
		## get res
		os.system('python scripts/get_res.py '+pdb+' '+pdb_info[pdb]['chain'])
		## get strand intervals
		os.system('python scripts/get_strands.py '+pdb+' '+pdb_info[pdb]['chain'])
		## get the center of each strand
		os.system('python scripts/get_cen.py '+pdb+' '+pdb_info[pdb]['chain'])
		### get sidechain info of each residue
		os.system('python scripts/get_sidechain.py '+pdb+' '+pdb_info[pdb]['chain']+' '+pdb_info[pdb]['#subunit']+' '+pdb_info[pdb]['#barrel']+' '+pdb_info[pdb]['#tmstrand']+' '+pdb_info[pdb]['istoxin'])
		### get cen topo
		os.system('python scripts/get_centopo.py '+pdb)



		# not checked

		### get registrations
		#os.system('python scripts/get_reg.py '+pdb+' '+pdb_info[pdb]['chain'])


