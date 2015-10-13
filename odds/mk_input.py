import os


name = 'new58'
pdbs = ['1a0s', '1bxw', '1e54', '1ek9', '1fep', '1i78', '1k24', '1kmo', '1nqe', '1p4t', '1prn', '1qd6', '1qj8', '1t16', '1thq', '1tly', '1uyn', '1xkw', '1yc9', '2erv', '2f1c', '2f1t', '2fcp', '2gr8', '2lhf', '2lme', '2mlh', '2mpr', '2o4v', '2omf', '2por', '2qdz', '2vqi', '2wjr', '2ynk', '3aeh', '3bs0', '3csl', '3dwo', '3dzm', '3fid', '3kvn', '3pik', '3rbh', '3rfz', '3syb', '3szv', '3v8x', '3vzt', '4c00', '4e1s', '4gey', '4pr7', '4q35', '4k3c', '7ahl', '3b07', '3o44']


#name = 'new55'
#pdbs = ['1a0s', '1bxw', '1e54', '1ek9', '1fep', '1i78', '1k24', '1kmo', '1nqe', '1p4t', '1prn', '1qd6', '1qj8', '1t16', '1thq', '1tly', '1uyn', '1xkw', '1yc9', '2erv', '2f1c', '2f1t', '2fcp', '2gr8', '2lhf', '2lme', '2mlh', '2mpr', '2o4v', '2omf', '2por', '2qdz', '2vqi', '2wjr', '2ynk', '3aeh', '3bs0', '3csl', '3dwo', '3dzm', '3fid', '3kvn', '3pik', '3rbh', '3rfz', '3syb', '3szv', '3v8x', '3vzt', '4c00', '4e1s', '4gey', '4pr7', '4q35', '4k3c']



#name = 'old25'
#pdbs = ['1ek9', '2f1c', '1p4t', '1bxw', '1k24', '1qj8', '1qd6', '1t16', '2f1t', '1i78', '1prn', '1uyn', '1e54', '1thq', '2o4v', '2mpr', '1kmo', '1nqe', '1a0s', '1fep', '7ahl', '2omf', '1xkw', '2fcp', '2por']



types = ['strong', 'vdw', 'weak', 'sidechain']

os.system('mkdir {name}'.format(name=name,type=type))

for i in range(len(pdbs)):
	currpdb = pdbs[i]
	os.system('mkdir {name}/{pdb}'.format(name=name,pdb=currpdb))
	tmppdbs = pdbs[:i]+pdbs[i+1:]
	for type in types[:-1]:
		os.system('rm {name}/{pdb}/{pdb}.{type}'.format(name=name,type=type, pdb=currpdb))
		for pdb in tmppdbs:
			os.system('cat ../inputs/{pdb}/{pdb}.{type} >> {name}/{pdb}/{pdb}.{type}'.format(name=name,pdb=pdb,type=type))


for type in types:
	os.system('rm {name}/all.{type}'.format(name=name,type=type))
	for pdb in pdbs:
		os.system('cat ../inputs/{pdb}/{pdb}.{type} >> {name}/all.{type}'.format(name=name,pdb=pdb,type=type))

import glob
for type in types[:-1]:
	for fn in glob.glob('{name}/*.{type}'.format(name=name, type=type))+glob.glob('{name}/*/*.{type}'.format(name=name, type=type)):
		os.system('python pairodds.py {fn}'.format(fn=fn))

for fn in glob.glob('{name}/*.{type}'.format(name=name, type='sidechain'))+glob.glob('{name}/*/*.{type}'.format(name=name, type='sidechain')):
	os.system('python singleodds.py {fn}'.format(fn=fn))
