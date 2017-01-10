function train_filter(train,filter_num)
	#train=readdlm("aftertrain.txt")
	m=Int(maximum(train[:,1]))
	n=Int(maximum(train[:,2]))
	X=readcsv("ImageF.dat")
	A=spzeros(m,n)
	for i=1:size(train,1)
		A[Int(train[i,1]),Int(train[i,2])]=train[i,3]
	end
	for i=1:n
		if sum(X[:,i])==0
			A[:,i]=0
		end
	end
	dropzeros!(A)
	println("get A")
	A=A'
	vals=nonzeros(A)
	rows=rowvals(A)
	newtrain=zeros(1,3)
	for i=1:m #let the small rating column be dropped out
		for j in nzrange(A,i)
			movie=rows[j]
			rating=vals[j]
			newtrain=vcat(newtrain,[i movie rating])
		end
	end
	return newtrain[2:end,:]  #index of moive will be changed.
end
