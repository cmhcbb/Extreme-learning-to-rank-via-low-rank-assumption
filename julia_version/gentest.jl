function genTestset(train,num)
	testset=zeros(1,3)
	partitionindex=parindex(train)
	m=size(partitionindex,1)
	for i=2:m
		rpre=partitionindex[i-1]
		rend=partitionindex[i]
		for j=1:num
			randindex=rand(rpre+1:rend,1)
			tmp=train[randindex,:]
			testset=[testset;tmp]
		end
	end
	testset=testset[2:end,:]
	return testset,partitionindex
end
