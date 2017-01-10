function ranksvmtest(W,testset,X,flag)
	 rcount=0
	 totalcount=0
	 paridx=parindex(testset)
	 m=size(paridx,1)-1
	 n=size(X,2)
	 if flag==0
	 	WX = (X'*W)
	else
		WX = zeros(n)
	end
	for i=1:m
		for jj=paridx[i]+1: paridx[i+1]
			real_jj = Int(testset[jj,2])
			if flag!=0
				WX[real_jj] = dot(W[:,i], X[:, real_jj])
			end
		end
		for jj=paridx[i]+1:paridx[i+1]
			for kk=paridx[i]+1:paridx[i+1]
				if testset[jj, 3] > testset[kk, 3]
				totalcount+=1
				real_jj = Int(testset[jj,2])
				real_kk = Int(testset[kk,2])
				tmp = 1-(WX[real_jj]-WX[real_kk])
					if ( tmp <=1 )
						rcount +=1
					end
				end
			end
		end
	end
	return rcount,totalcount
end			
