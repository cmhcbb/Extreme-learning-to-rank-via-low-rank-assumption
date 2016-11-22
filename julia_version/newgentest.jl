function genTestset(train,num)
	newtrain=zeros(1,3)
	testset=zeros(1,3)
	partitionindex=parindex(train)
	m=size(partitionindex,1)-1
	for i=1:m
		mo=partitionindex[i+1]-partitionindex[i]
		println(mo)
		if mo<=num
			testset=vcat(testset,train[partitionindex[i]+1:partitionindex[i+1],:])
		continue
		end		
		randp=randperm(mo)
		randp=randp''
		randp=randp+partitionindex[i]
		testset=vcat(testset, train[randp[1:num],:])
		newtrain=vcat(newtrain,train[randp[num+1:end],:])
	end
	testset=testset[2:end,:]
	newtrain=newtrain[2:end,:]
	return newtrain,testset,partitionindex
end
