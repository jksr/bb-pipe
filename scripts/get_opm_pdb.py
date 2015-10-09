import time
import os
import sys
sys.dont_write_bytecode = True

pdb = sys.argv[1]
os.system('wget http://opm.phar.umich.edu/pdb/'+pdb+'.pdb -qO inputs/'+pdb+'/'+pdb+'.pdb &> /dev/null')
time.sleep(1)

f = open('inputs/'+pdb+'/'+pdb+'.pdb')
lines = f.readlines()
f.close()


dssp_line_len = 80
f = open('inputs/'+pdb+'/'+pdb+'.pdb','w')
for line in lines:
	if len(line)<dssp_line_len+1:
		line = line[:-1] + ' '*(dssp_line_len-len(line[:-1]))+'\n'
	f.write(line)
f.close()
