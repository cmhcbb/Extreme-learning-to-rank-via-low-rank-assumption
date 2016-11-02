function ranksvm(X,train,testset,m,deltax,paridx)
	C=1
	d=size(X,1)
	w=randn(d,1)
	for iter=1:200
		loss=0
		println("Iteration=",iter)
		deltaw=zeros(d,1)
		res=deltax'*w
		for i=1:size(res,1)
			loss+=max(0,1-res[i,1])
			deltaw+=max(0,1-res[i,1])*deltax[:,i]	
		end
	eta=1e-5
	gradf=w-2*C*deltaw
	w=w-eta*gradf
	funv=0.5*norm(w)+C*loss*loss
	println("Func=",funv)
	rcount=ranktest(0,0,w,testset,X,0)
	println("Rightpair=",rcount)
	end
	return w
end
