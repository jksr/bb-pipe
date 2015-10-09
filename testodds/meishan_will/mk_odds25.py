import os
import sys
pdbs = ['1ek9', '2f1c', '1p4t', '1bxw', '1k24', '1qj8', '1qd6', '1t16', '2f1t', '1i78', '1prn', '1uyn', '1e54', '1thq', '2o4v', '2mpr', '1kmo', '1nqe', '1fep', '2omf', '1xkw', '2fcp', '2por', '1a0s', '7ahl']

contacttypes = ['strong', 'weak', 'vdw']

os.system('mkdir odds25')
for contacttype in contacttypes:
	for i in range(len(pdbs)):
		pdb = pdbs[i]
		os.system('mkdir odds25/{pdb}'.format(pdb=pdb))
		currpdbs = pdbs[:i]+pdbs[i+1:]
		os.system('rm tmp.contact')
		for tmp in currpdbs:
			os.system('cat contact/{tmp}.{ct} >> tmp.contact'.format(tmp=tmp, ct=contacttype))
		os.system('perl calcodds.pl tmp.contact')
		print('mv tmp.contact.odds odds25/{pdb}/{pdb}.{ct}.odds'.format(pdb=pdb, ct=contacttype))
		os.system('mv tmp.contact.odds odds25/{pdb}/{pdb}.{ct}.odds'.format(pdb=pdb, ct=contacttype))
os.system('rm tmp.contact')

os.system('rm odds25/all25.sidechain')
os.system('rm odds25/all25.strong')
os.system('rm odds25/all25.weak')
os.system('rm odds25/all25.vdw')
for pdb in pdbs:
	os.system('cat sidechain/{pdb}.sidechain >> odds25/all25.sidechain'.format(pdb=pdb))
	os.system('cat contact/{pdb}.strong >> odds25/all25.strong'.format(pdb=pdb))
	os.system('cat contact/{pdb}.weak >> odds25/all25.weak'.format(pdb=pdb))
	os.system('cat contact/{pdb}.vdw >> odds25/all25.vdw'.format(pdb=pdb))
os.system('perl calcodds.pl odds25/all25.strong')
os.system('perl calcodds.pl odds25/all25.weak')
os.system('perl calcodds.pl odds25/all25.vdw')
os.system('perl single_odds.pl odds25/all25.sidechain')
os.system('mv CoreIn.odds odds25')
os.system('mv CoreOut.odds odds25')
os.system('mv ExtraIn.odds odds25')
os.system('mv ExtraOut.odds odds25')
os.system('mv PeriIn.odds odds25')
os.system('mv PeriOut.odds odds25')
