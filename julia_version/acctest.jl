function ranktest(U=0,V=0,w=0,testset,X,flag=1)
	if flag==0:
		para=w
	else
		para=U*V
	rcount=0
	totalcount=0
	paridx=parindex(testset)
	for i=1:m
		if flag==1:
			w=para[:,i]
		end
		for j=paridx[i]:paridx[i+1]
			for k=j+1:paridx[i+1]
				real=testset[j,3]-testset[k,3]
				if real==0
					continue
				end
				res=w'*(X[:,testset[j,2]]-X[:,testset[k,2]])
				totalcount+=1
				if res*real>0
					rcount+=1
				end
			end
		end
	end		
	return rcount
end
