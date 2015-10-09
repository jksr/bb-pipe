import sys
sys.dont_write_bytecode = True
sys.path.append('../pylib/twbio/')
import dsspdata
import AminoAcid
import Bio.PDB
import warnings
warnings.simplefilter('ignore', Bio.PDB.PDBExceptions.PDBConstructionWarning)

if len(sys.argv)!=3:
	print 'Usage: '+sys.argv[0]+' <pdb> <chain>'
	sys.exit(0)

pdb = sys.argv[1]
chain = sys.argv[2]

dssp = dsspdata.DSSPData('inputs/'+pdb+'/'+pdb+'.dssp')
resids = dssp.get_chain_res(chain)
last_res = resids[-1]
resids = set(resids)

pdb_structure = Bio.PDB.PDBParser().get_structure('', 'inputs/'+pdb+'/'+pdb+'.pdb')
pdb_chain = pdb_structure[0][chain]

f = open('inputs/'+pdb+'/'+pdb+'.res','w')
for i in range(1,last_res+1):
	if i in resids:
		aa = dssp.get(chain,i,'aa')
		if aa.islower():
			f.write( str(AminoAcid.one_to_index('C')) + '\n' )
		elif aa == 'X':
			if ('H_MSE',i,' ') in pdb_chain:
				f.write( str(AminoAcid.one_to_index('M')) + '\n' )
			else:
				f.write( '200\n' )
		else:
			f.write( str(AminoAcid.one_to_index(aa)) + '\n' )
	else:
		f.write('200\n')
f.close()
