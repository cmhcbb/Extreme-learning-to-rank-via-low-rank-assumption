function ranktest(U=0,V=0,w=0,trainset=0,testset=0,X=0,flag=1)
	rcount=0
	totalcount=0
	ratio=0.2
	trainparidx=parindex(trainset)
	testparidx=parindex(testset)
	m=size(trainparidx,1)-1
	#UX = U'*X
	UX = (X'*U)'
	n = size(X,2)
	vUX = zeros(n)
	traintest=zeros(1,3)
	for i=1:m
		mo=trainparidx[i+1]-trainparidx[i]
		num = Int(floor(mo*ratio))
		randp=randperm(mo)
		randp=randp''
		randp=randp+trainparidx[i]
		traintest=vcat(traintest,trainset[randp[1:num],:])
	end
	trainset=traintest[2:end,:]
	trainparidx=parindex(trainset)
#	print(size(trainset))
#	print(trainparidx)
	m = size(trainparidx,1) -1
	for i=1:m
#		mo=trainparidx[i+1]-trainparidx[i]
#		num = Int(floor(mo*ratio))
#		randp=randperm(mo)
#		randp=randp''
#		randp=randp+trainparidx[i]
		for jj=trainparidx[i]+1: trainparidx[i+1]
			real_jj = Int(trainset[jj,2])
			vUX[real_jj] = dot(V[:,i], UX[:, real_jj])
		end
		for jj=testparidx[i]+1: testparidx[i+1]
			real_jj = Int(testset[jj,2])
			vUX[real_jj] = dot(V[:,i], UX[:, real_jj])
		end
		for jj=trainparidx[i]+1:trainparidx[i+1]
			for kk=testparidx[i]+1:testparidx[i+1]
				if trainset[jj, 3] > testset[kk, 3]
					totalcount+=1
					real_jj = Int(trainset[jj,2])
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
