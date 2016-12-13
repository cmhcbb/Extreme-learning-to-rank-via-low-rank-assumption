function ranktest(U=0,V=0,w=0,testset=0,X=0,flag=1)
	rcount=0
	totalcount=0
	paridx=parindex(testset)
	m=size(paridx,1)-1
	#UX = U'*X
	UX = (X'*U)'
	n = size(X,2)
	vUX = zeros(n)
	for i=1:m
		for jj=paridx[i]+1: paridx[i+1]
			real_jj = Int(testset[jj,2])
			vUX[real_jj] = dot(V[:,i], UX[:, real_jj])
		end
		for jj=paridx[i]+1:paridx[i+1]
			for kk=paridx[i]+1:paridx[i+1]
				if testset[jj, 3] > testset[kk, 3]
					totalcount+=1
					real_jj = Int(testset[jj,2])
					real_kk = Int(testset[kk,2])
					tmp = 1-(vUX[real_jj]-vUX[real_kk])
					if ( tmp <=1 )
						rcount +=1
					end
				end
			end
		end
	end		

	return rcount,totalcount
end
