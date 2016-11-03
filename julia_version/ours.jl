function ours(X,train,testset,m,deltax,paridx,k=5)
	C=1
	d=size(X,1)
	U=randn(d,k)/10
	V=randn(k,m)/10
	for iter=1:200
		println("Iter=",iter)
		rcount=ranktest(U,V,0,testset,X,1)
		println("rcount=",rcount)
		loss=0
		deltau=zeros(d,k)
		for i=1:size(deltax,1)
			deltamatrix=deltax[i]
			ux=U'*deltamatrix
			index=Int8(train[paridx[i]+1])
			#println(index)
			#index=i
			for j=1:size(deltamatrix,2)
				temp=V[:,index]'*ux[:,j]
				loss+=max(0,1-temp[1])
				deltau+=max(0,1-temp[1])*deltamatrix[:,j]*V[:,index]'	
			end
		end
		output=0.5*vecnorm(U)+0.5*vecnorm(V)+C*loss*loss
		println("Func=",output)
		eta=1e-4  # may lead to divergence
		gradf=U-2*C*deltau
		U=U-eta*gradf
		
		gradvi=zeros(k,m)
		deltav=zeros(k,1)
		for j=1:size(deltax,1)
			deltamatrix=deltax[j]
			index=Int8(train[paridx[j]+1])
			#index=i
			ux=U'*deltamatrix
			for i=1:size(deltamatrix,2)
				temp=V[:,index]'*ux[:,i]
				deltav+=max(0,1-temp[1])*ux[:,i]
			end
		gradvi[:,index]=V[:,index]-2*C*deltav
		end
		V=V-eta*gradvi;
	end
	return U,V
end
		
