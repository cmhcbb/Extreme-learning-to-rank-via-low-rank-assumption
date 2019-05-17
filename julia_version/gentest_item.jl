function genTestset_item(train,ratio)
	newtrain = zeros(1,3)
	testset = zeros(1,3)
#	partitionindex = parindex(train)
	itemset = unique(train[:,2])
 	shuffle!(itemset)
	mo = Int(floor(size(itemset,1)*ratio))
	trainitem = itemset[1:mo]
	testitem = itemset[mo+1:end]
	for i=1:size(train,1)
		if train[i,2] in trainitem
			#print(train[i,:])
			newtrain=vcat(newtrain,train[i,:]')
		else
			#print(train[i,:])
			testset = vcat(testset,train[i,:]')
		end
	end
	testset = testset[2:end,:]
	newtrain = newtrain[2:end,:]
	return newtrain, testset
end
