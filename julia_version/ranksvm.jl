function ranksvm(X,train,testset,m,A,paridx)
	C=10
	d=size(X,1)
	w=randn(d,1)/10
	for iter=1:100
		loss=0
		println("Iter=",iter)
		deltaw=zeros(d,1)
		for k=1:m
			deltamatrix=X*A[k]
			constidxmatrix=A[k]
			temp=zeros(size(deltamatrix,2),1)
			res=deltamatrix'*w
			temp=max(0,1-res)
			tempp=sparse(constidxmatrix*spdiagm(vec(temp)))
			loss+=sum(temp)
			tempp=sparse(sum(tempp,2))
			tempp=sparse(X*tempp)
			deltaw+=tempp	
		end
	eta=1e-6
	gradf=w-2*C*deltaw
	w=w-eta*gradf
	funv=0.5*norm(w)+C*loss*loss
	println("Func=",funv)
	rcount,totalcount=ranktest(0,0,w,testset,X,0,m)
	println("Rightpair=",rcount," ",totalcount)
	end
	return w
end
