import os
import sys
pdbs = ['1a0s' ,'1bxw' ,'1e54' ,'1ek9' ,'1fep' ,'1i78' ,'1k24' ,'1kmo' ,'1nqe' ,'1p4t' ,'1prn' ,'1qd6' ,'1qj8' ,'1t16' ,'1thq' ,'1tly' ,'1uun' ,'1uyn' ,'1xkw' ,'1yc9' ,'2erv' ,'2f1c' ,'2f1t' ,'2fcp' ,'2gr8' ,'2lhf' ,'2lme' ,'2mlh' ,'2mpr' ,'2o4v' ,'2omf' ,'2por' ,'2qdz' ,'2vqi' ,'2wjr' ,'2ynk' ,'3aeh' ,'3b07' ,'3bs0' ,'3csl' ,'3dwo' ,'3dzm' ,'3emn' ,'3fid' ,'3kvn' ,'3o44' ,'3pik' ,'3rbh' ,'3rfz' ,'3syb' ,'3szv' ,'3v8x' ,'3vzt' ,'4c00' ,'4e1s' ,'4gey' ,'4k3c' ,'4pr7' ,'4q35' ,'7ahl']

contacttypes = ['strong', 'weak', 'vdw']

os.system('mkdir odds60')
for contacttype in contacttypes:
	for i in range(len(pdbs)):
		pdb = pdbs[i]
		os.system('mkdir odds60/{pdb}'.format(pdb=pdb))
		currpdbs = pdbs[:i]+pdbs[i+1:]
		os.system('rm tmp.contact')
		for tmp in currpdbs:
			os.system('cat contact/{tmp}.{ct} >> tmp.contact'.format(tmp=tmp, ct=contacttype))
		os.system('perl calcodds.pl tmp.contact')
		print('mv tmp.contact.odds odds60/{pdb}/{pdb}.{ct}.odds'.format(pdb=pdb, ct=contacttype))
		os.system('mv tmp.contact.odds odds60/{pdb}/{pdb}.{ct}.odds'.format(pdb=pdb, ct=contacttype))

os.system('rm tmp.contact')

os.system('rm odds60/all60.sidechain')
os.system('rm odds60/all60.strong')
os.system('rm odds60/all60.weak')
os.system('rm odds60/all60.vdw')
for pdb in pdbs:
	os.system('cat sidechain/{pdb}.sidechain >> odds60/all60.sidechain'.format(pdb=pdb))
	os.system('cat contact/{pdb}.strong >> odds60/all60.strong'.format(pdb=pdb))
	os.system('cat contact/{pdb}.weak >> odds60/all60.weak'.format(pdb=pdb))
	os.system('cat contact/{pdb}.vdw >> odds60/all60.vdw'.format(pdb=pdb))
os.system('perl calcodds.pl odds60/all60.strong')
os.system('perl calcodds.pl odds60/all60.weak')
os.system('perl calcodds.pl odds60/all60.vdw')
os.system('perl single_odds.pl odds60/all60.sidechain')
os.system('mv CoreIn.odds odds60')
os.system('mv CoreOut.odds odds60')
os.system('mv ExtraIn.odds odds60')
os.system('mv ExtraOut.odds odds60')
os.system('mv PeriIn.odds odds60')
os.system('mv PeriOut.odds odds60')
