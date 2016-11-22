function ourscho(X,train,testset,m,paridx,eta=1e-4,k=5,C=10)
	d=size(X,1)
	n=size(X,2)
	U=randn(d,k)/10
	V=randn(k,m)/10

	vUX = zeros(1,n)
	tmp_weight = zeros(1,n)

	rcount,totalcount=ranktest(U,V,0,testset,X,1,m)
	println("Iter 0 rcount/total ", rcount, "/", totalcount );

	time_partA = 0
	time_partB=0
	time_partC=0

	UX = U'*X
	for iter=1:1000
		loss=0
		deltau=zeros(d,k)
		total = 0
		wrong = 0
		total2=0
		for i=1:m
			start_time = time_ns()
			nowv = V[:,i]'
			for jj=paridx[i]+1: paridx[i+1]
				real_jj = Int(train[jj,2])
				temp = nowv*UX[:,real_jj]
				vUX[1,real_jj] = reshape(temp,1)[1]
				tmp_weight[real_jj] = 0
			end
			time_partA += (time_ns() -start_time)

			start_time = time_ns()
			for jj=paridx[i]+1:paridx[i+1]
				for kk=paridx[i]+1:paridx[i+1]
					total2+=1
					if train[jj, 3] > train[kk, 3]
						real_jj = Int(train[jj,2])
						real_kk = Int(train[kk,2])
						tmp = 1-(vUX[1,real_jj]-vUX[1,real_kk])
						total+=1
						if (tmp >1)
							wrong+=1
						end
						if ( tmp >= 0 )
							loss += tmp*tmp
							tmp_weight[real_jj] -= tmp
							tmp_weight[real_kk] += tmp
						end
					end
				end
			end

			time_partB += (time_ns()-start_time)

			start_time = time_ns()
			sumxvec = zeros(d,1);
			for jj=paridx[i]+1:paridx[i+1]
				real_jj = Int(train[jj,2])
				sumxvec += tmp_weight[real_jj]*X[:,real_jj];
			end
			deltau += sumxvec*nowv;

			time_partC += (time_ns()-start_time)
		end 

		println("total2: $(total2)");
		output=0.5*vecnorm(U)+0.5*vecnorm(V)+C*loss
		println("After updating U, obj = ",output)
		#println("Wrong = ", wrong)
		#println("Total = ", total)
		#println("Time partA: $(time_partA/1e9).  Time partB: $(time_partB/1e9).  Time partC: $(time_partC/1e9)")

		gradf=U+2*C*deltau
		U=U-eta*gradf

		tic()
		loss = 0
		UX = U'*X
		gradvi=zeros(k,m)
		train_total=0
		train_correct=0
		for i=1:m
			deltav=zeros(k,1)
			nowv = V[:,i]'
			for jj=paridx[i]+1: paridx[i+1]
				real_jj = Int(train[jj,2])
				temp = nowv*UX[:,real_jj]
				vUX[1,real_jj] = reshape(temp,1)[1]
				tmp_weight[real_jj] = 0
			end
			
			for jj=paridx[i]+1:paridx[i+1]
				for kk=paridx[i]+1:paridx[i+1]
					if train[jj, 3] > train[kk, 3] 
						train_total+=1
						real_jj = Int(train[jj,2])
						real_kk = Int(train[kk,2])
						tmp = 1-(vUX[1,real_jj]-vUX[1,real_kk])
						if ( tmp <=1 )
							train_correct+=1
						end
						if ( tmp >= 0 )
							loss += tmp*tmp
							tmp_weight[real_jj] -= tmp
							tmp_weight[real_kk] += tmp
						end
					end
				end
			end
			for jj=paridx[i]+1:paridx[i+1]
				real_jj = Int(train[jj,2])
				deltav += tmp_weight[real_jj]*UX[:, real_jj]
			end
			gradvi[:,i] = V[:,i]+2*C*deltav
		end

		output=0.5*vecnorm(U)+0.5*vecnorm(V)+C*loss
		V = V-eta*gradvi
		#println("After updating V, obj = ",output)

		toc()
		rcount,totalcount=ranktest(U,V,0,testset,X,1,m)
		println("Iter ", iter, " rcount/total ", rcount, "/", totalcount, " train_correct/train_total ", train_correct, "/", train_total ," Obj ", output );
	end
	return U,V
end
		
