function ours2ver(X,train,testset,m,deltax,deltaxn,paridx,constidx,subX,dim,k=5)
	C=1
	d=size(X,1)
	srand(12)
	U=randn(d,k)/10
	srand(13)
	V=randn(k,m)/10
	for iter=1:100
		println("Iter=",iter)
		rcount=ranktest(U,V,0,testset,X,1)
		println("rcount=",rcount)
		loss=0
		deltau=zeros(d,k)
		for i=1:size(deltax,1)
			deltamatrix=deltax[i]
			#aindex=reshape(constidx[i]',size(deltamatrix,2),1)
			temp=zeros(size(deltamatrix,2),1)
			ux=U'*deltamatrix
			index=Int8(train[paridx[i]+1])
			#println(index)
			#println(countnz(temp),countnz(tempp))
			#println(temp)
			temp=max(0,1-V[:,index]'*ux)
			tempp=constidx*sparse(diagm(temp))
			loss+=sum(temp)/2
			#@printf "loss=%f " loss 
	        	#println(tempp)
			tempp=sum(tempp,2)
			deltau+=subX[i]*tempp'*V[:,index]'	
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
				if norm(ux[:,i])==0
					continue
				end
				temp=V[:,index]'*ux[:,i]
				deltav+=max(0,1-temp[1])*ux[:,i]
			end
		gradvi[:,index]=V[:,index]-2*C*deltav
		end
		V=V-eta*gradvi;
	end
	return U,V
end
		
