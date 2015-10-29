import sys
sys.dont_write_bytecode = True
sys.path.append('../pylib/twbio/')
import dsspdata

if len(sys.argv)!=3:
	print 'Usage: '+sys.argv[0]+' <pdb> <chain>'
	sys.exit(0)


pdb = sys.argv[1]
chain = sys.argv[2]

dsspfn = 'inputs/'+pdb+'/'+pdb+'.dssp'
pdbfn = 'inputs/'+pdb+'/'+pdb+'.pdb'


dssp = dsspdata.DSSPData(dsspfn)
resids = dssp.get_chain_res(chain)

## get mem thickness of the pdb
f = open(pdbfn)
#thickness = 13.5
thickness = float(f.readline().split()[-1])
f.close()

## get all beta structures
betas = []
start = None
end = None
last_resid = None
for resid in resids:
	if start is None and dssp.get(chain,resid,'struct')[2]=='E':
		start = resid
	elif (start is not None) and (dssp.get(chain,resid,'struct')[2]!='E'):
		end = last_resid
		betas.append((start,end))
		start = None
	last_resid = resid

## filter the betas
filtered_betas = []
for beta in betas:
	# remove strands that are too short: len<4
	if beta[1]-beta[0] < 3:
		continue
	# remove strands that not TM
	isTM = False
	for resnum in range(beta[0], beta[1]+1):
		if abs(dssp.get(chain, resnum, 'zca')) <= thickness:
			isTM = True
			break
	if not isTM:
		continue
	filtered_betas.append(beta)
betas = filtered_betas


#################### graph_reduce ####################
def graph_reduce(betas):
	graph = [ (set(),set()) for beta in betas ]
	for i in range(len(betas)):
		beta = betas[i]
		for resnum in range(beta[0], beta[1]+1):
			try:
				neighbor = dssp.records[dssp.get(chain, resnum, 'bp1')]['resnum']
				for j in range(len(betas)):
					if neighbor >= betas[j][0] and neighbor <=  betas[j][1]:
						graph[i][0].add(j)
						break
			except:
				pass
			try:
				neighbor = dssp.records[dssp.get(chain, resnum, 'bp2')]['resnum']
				for j in range(len(betas)):
					if neighbor >= betas[j][0] and neighbor <=  betas[j][1]:
						graph[i][1].add(j)
						break
			except:
				pass
	#print graph

	# catenate broken strands
	#newgraph = []
	#newgraph.append(graph[0])
	#tocatenate = []
	#for i in range(1,len(graph)):
	#	if len(graph[i][0].difference(graph[i-1][0])) == 0 and len(graph[i][1].difference(graph[i-1][1])) == 0:
	#		tocatenate.append(i)
	#	else:
	#		newgraph.append(graph[i])
	#for i in reversed(tocatenate):
	#	curr = betas.pop(i)
	#	prev = betas.pop(i-1)
	#	if curr[0]-prev[1] <= 2:
	#		betas.insert(i-1, (prev[0],curr[1]))
	#	else:
	#		if curr[1]-curr[0]<prev[1]-prev[0]:
	#			curr = prev
	#		betas.insert(i-1, curr)
	#graph = newgraph


	filtered_betas = []
	reduced = False
	for i in range(len(graph)):
		if len(graph[i][0])>0 and len(graph[i][1])>0:
			filtered_betas.append(betas[i])
		else:
			reduced = True
	
	return filtered_betas,reduced
######################################################

# reduce the betas using graph_reduce method
reduced = True
while(reduced):
	betas, reduced = graph_reduce(betas)


# output the strands detected
f = open('inputs/'+pdb+'/'+pdb+'.strands','w')
for beta in betas:
	f.write( str(beta[0])+'\t'+str(beta[1])+'\n' )
f.close()


# cut the extended strands, just keep the TM part
tol = 0
tmpbetas = []
for beta in betas:
	tmpbetas.append([])
	for res in range(beta[0], beta[1]+1):
		z = dssp.get(chain, res, 'zca')
		if z <= thickness+tol:
			tmpbetas[-1].append(res)
tmbetas = [(beta[0],beta[-1]) for beta in tmpbetas]

# output the tm strands 
f = open('inputs/'+pdb+'/'+pdb+'.tmstrands','w')
for beta in tmbetas:
	f.write( str(beta[0])+'\t'+str(beta[1])+'\n' )
f.close()

