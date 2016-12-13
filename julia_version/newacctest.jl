function ranktest(U=0,V=0,w=0,testset=0,X=0,flag=1,m=0)
	if flag==0
		para=w
	else	
		para::SparseMatrixCSC{Float64,Int64}=U*V
	end
	rcount::Int64=0
	totalcount::Int64=0
	paridx=parindex(testset)
	m=size(paridx,1)-1
	for i=1:m
		if flag==1
			index::Int64=testset[paridx[i]+1,1]
		#	w::SparseVector{Float64,Int64}=para[:,index]
			
		end
		for j=paridx[i]+1:paridx[i+1]
			for k=j+1:paridx[i+1]
				real::Float64=testset[j,3]-testset[k,3]
				if real==0.0
					continue
				end
				tempx=X[:,Int(testset[j,2])]-X[:,Int(testset[k,2])]
				res=dot(para[:,index],tempx)
				totalcount+=1
				temp=res*real
				if temp>=0
					rcount+=1
				end
			end
		end
	end		
	return rcount,totalcount
end
