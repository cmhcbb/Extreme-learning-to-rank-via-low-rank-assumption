function ranksvm(X,train,testset,m,deltax,paridx)
	C=1
	d=size(X,1)
	w=rand(d,1)
	res=deltax'*w
	loss=0
	for iter=1:200
		println("Iteration=",iter)
		deltaw=zeros(d,1)
		for i=1:size(res,1)
			loss+=max(0,1-res[i])
			deltaw+=max(0,1-res[i])*deltax[i]	
		end
	eta=1e-8
	gradf=w-2*C*deltaw
	w=w-eta*gradf
	funv=0.5*norm(w)+C*loss*loss
	println("Func=",funv)
	rcount=ranktest(0,0,w,testset,X,0)
	println("Rightpair=",rcount)
	end
	return w
end
