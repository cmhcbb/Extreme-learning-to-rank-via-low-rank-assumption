function ours4ver(X,train,testset,m,paridx,A,subX,k=5)
	C=10
	d=size(X,1)
	U=randn(d,k)/10
	V=randn(k,m)/10
	for iter=1:1000
		#if iter%1000==0
			println("Iter=",iter)
			rcount=ranktest(U,V,0,testset,X,1)
			println("rcount=",rcount)
		#end
		loss=0
		deltau=zeros(d,k)
		for i=1:m
			deltamatrix=X*A[i]
			constidxmatrix=A[i]
			temp=zeros(size(deltamatrix,2),1)
			ux=U'*deltamatrix
			#index=Int8(train[paridx[i]+1])
			index=i
			#println(index)
			#println(countnz(temp),countnz(tempp))
			#println(temp)
			temp=max(0,1-V[:,index]'*ux)
			tempp=sparse(constidxmatrix*spdiagm(vec(temp)))
			loss+=sum(temp)
			#@printf "loss=%f " loss 
	        	#println(tempp)
			tempp=sparse(sum(tempp,2))	
			tempp=sparse(X*tempp)
			#println(size(tempp))
			#tempp=tempp[train[paridx[i]+1:paridx[i+1],2],:]
			#println(size(tempp))
			deltau+=tempp*V[:,index]'	
		end
		output=0.5*vecnorm(U)+0.5*vecnorm(V)+C*loss*loss
		#if iter%1000==0
		println("Func=",output)
		#end
		#eta=1e-16  # may lead to divergence
		gradf=U-2*C*deltau
		eta=Ulinesearch(U,V,gradf,loss,A,C,m)
		println(eta)
		U=U-eta*gradf
		#println(U)
		gradvi=zeros(k,m)
		deltav=zeros(k,1)
		eta=1e-16
		for j=1:m
			deltamatrix=X*A[j]
			#index=train[paridx[j]+1,1]
			#index=Int64(index)
			index=j
			ux=U'*deltamatrix
			deltav+=ux*max(0,1-V[:,index]'*ux)'
		gradvi[:,index]=V[:,index]-2*C*deltav
		end
		V=V-eta*gradvi;
	end
	return U,V
end
		
