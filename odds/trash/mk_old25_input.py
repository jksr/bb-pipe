import os

name = 'old25'
pdbs = ['1ek9', '2f1c', '1p4t', '1bxw', '1k24', '1qj8', '1qd6', '1t16', '2f1t', '1i78', '1prn', '1uyn', '1e54', '1thq', '2o4v', '2mpr', '1kmo', '1nqe', '1a0s', '1fep', '7ahl', '2omf', '1xkw', '2fcp', '2por']

types = ['strong', 'vdw', 'weak', 'sidechain']
os.system('mkdir {name}'.format(name=name,type=type))
for type in types:
	os.system('rm {name}.{type}'.format(name=name,type=type))
	for pdb in pdbs:
		os.system('cat ../inputs/{pdb}/{pdb}.{type} >> {name}/{name}.{type}'.format(name=name,pdb=pdb,type=type))


