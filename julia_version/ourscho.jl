function ourscho(X,train,testset,m,paridx,eta=1e-4,k=5,C=10)
	d=size(X,1)
	n=size(X,2)
	nratings = size(train,1)

	#Might need to tune initializations
	U=randn(d,k)/10
	V=randn(k,m)/10

	vUX = zeros(n)
	tmp_weight = zeros(n)

	rcount,totalcount=ranktest(U,V,0,testset,X)
	println("Iter 0 Acc ", rcount/totalcount);

	# Used for generating sparse matrix for updating U
	new_mlist = zeros(nratings)
	for i=1:m
		for jj=paridx[i]+1: paridx[i+1]
			new_mlist[jj] = i 
		end
	end

	time_partA = 0.0
	time_partB=0.0

	# Faster than UX=U'*X.......
	UX = (X'*U)'
	for iter=1:2000

		# Update U

		start_time = time_ns()
		loss=0.0
		newval = zeros(nratings)
		for i=1:m
				nowv = V[:,i]
				for jj=paridx[i]+1: paridx[i+1]
					real_jj = Int(train[jj,2])
					vUX[real_jj] = dot(nowv, UX[:, real_jj])
					tmp_weight[real_jj] = 0.0
				end
	
				for jj=paridx[i]+1:paridx[i+1]
					for kk=paridx[i]+1:paridx[i+1]
						if train[jj, 3] > train[kk, 3]
							real_jj = Int(train[jj,2])
							real_kk = Int(train[kk,2])
							tmp = 1-(vUX[real_jj]-vUX[real_kk])
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
					newval[jj] = tmp_weight[real_jj]
				end
		end

		AAA=sparse(train[:,2], new_mlist, newval, n, m)
		# Much faster than X*(AAA*V')...... 
		VV = V'
		deltau = X*(AAA*VV)

		output=0.5*vecnorm(U)+0.5*vecnorm(V)+C*loss
		println("After updating U, obj = ",output)

		gradf=U+2*C*deltau
		U=U-eta*gradf

		time_partA += (time_ns() -start_time)

		# Updata V

		start_time = time_ns()
		loss = 0.0
		#Much faster than UX = U'*X
		UX = (X'*U)'
		gradvi=zeros(k,m)
		train_total=0
		train_correct=0
		for i=1:m
				deltav=zeros(k)
				nowv = V[:,i]
				for jj=paridx[i]+1: paridx[i+1]
					real_jj = Int(train[jj,2])
					vUX[real_jj] = dot(nowv, UX[:, real_jj])
					tmp_weight[real_jj] = 0.0
				end
			
				for jj=paridx[i]+1:paridx[i+1]
					for kk=paridx[i]+1:paridx[i+1]
						if train[jj, 3] > train[kk, 3] 
							train_total+=1
							real_jj = Int(train[jj,2])
							real_kk = Int(train[kk,2])
							tmp = 1-(vUX[real_jj]-vUX[real_kk])
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

		time_partB += (time_ns() -start_time)

		rcount,totalcount=ranktest(U,V,0,testset,X,1)
		println("Iter ", iter, " Test_Accuracy ", rcount/totalcount, " Train_Accuracy ", train_correct/train_total ," Obj ", output, " Time $((time_partA+time_partB)/1e9) TimeU $(time_partA/1e9) TimeV $(time_partB/1e9)")
		#println("Iter ", iter, " rcount/total ", rcount, "/", totalcount, " train_correct/train_total ", train_correct, "/", train_total ," Obj ", output );

	end
	return U,V
end
		
