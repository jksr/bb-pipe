import os

name = 'new55'
pdbs = ['1a0s', '1bxw', '1e54', '1ek9', '1fep', '1i78', '1k24', '1kmo', '1nqe', '1p4t', '1prn', '1qd6', '1qj8', '1t16', '1thq', '1tly', '1uyn', '1xkw', '1yc9', '2erv', '2f1c', '2f1t', '2fcp', '2gr8', '2lhf', '2lme', '2mlh', '2mpr', '2o4v', '2omf', '2por', '2qdz', '2vqi', '2wjr', '2ynk', '3aeh', '3bs0', '3csl', '3dwo', '3dzm', '3fid', '3kvn', '3pik', '3rbh', '3rfz', '3syb', '3szv', '3v8x', '3vzt', '4c00', '4e1s', '4gey', '4pr7', '4q35', '4k3c']


types = ['strong', 'vdw', 'weak', 'sidechain']
os.system('mkdir {name}'.format(name=name,type=type))
for type in types:
	os.system('rm {name}.{type}'.format(name=name,type=type))
	for pdb in pdbs:
		os.system('cat ../inputs/{pdb}/{pdb}.{type} >> {name}/{name}.{type}'.format(name=name,pdb=pdb,type=type))

