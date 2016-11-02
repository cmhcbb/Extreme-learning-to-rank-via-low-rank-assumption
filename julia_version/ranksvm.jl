function ranksvm(X,train,testset,m,deltax,paridx)
	C=1
	d=size(X,1)
	w=rand(d,1)
	res=deltax'*w
	loss=0
	for iter=1:200
		printf "Iteration %d\n" iter
		deltaw=zeros(d,1)
		for i=1:size(res,1)
			loss+=max(0,1-res[i])
			deltaw+=max(0,1-res[i])*deltax[i]	
		end
	eta=1e-6
	gradf=w-2*C*deltaw
	w=w-eta*gradf
	funv=0.5*norm(w)+C*loss*loss
	println("Func=%f" funv)
	rcount=ranktest(w=w,testset=testset,X=X,flag=0)
	end
	return w
end
