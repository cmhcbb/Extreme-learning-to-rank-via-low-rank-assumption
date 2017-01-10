function allranksvm(X,train,testset,m,paridx,eta=5e-7,C=10)
	d=size(X,1)
	n=size(X,2)
	W=randn(d,m)/10
	wiX=zeros(n)
	tmp_weight=zeros(n)
	rcount,totalcount=ranksvmtest(W,testset,X,1)
	println("Iter 0 Acc ", rcount/totalcount)
	for iter=1:2000
		loss=0.0
		gradwi=zeros(d,m)
		train_total=0
		train_correct=0
		for i=1:m
			deltaw=zeros(d)
			noww=W[:,i]
			for jj=paridx[i]+1:paridx[i+1]
				real_jj=Int(train[jj,2])
				wiX[real_jj]=dot(noww,X[:,real_jj])
				tmp_weight[real_jj]=0.0
			end
			for jj=paridx[i]+1:paridx[i+1]
				for kk=paridx[i]+1:paridx[i+1]
					if train[jj,3]>train[kk,3]
						train_total+=1
						real_jj=Int(train[jj,2])
						real_kk=Int(train[kk,2])
						tmp=1-(wiX[real_jj]-wiX[real_kk])
						if (tmp<=1)
							train_correct+=1
						end
						if (tmp>=0)
							loss+= tmp*tmp
							tmp_weight[real_jj]-=tmp
							tmp_weight[real_kk]+=tmp
						end
					end
				end
			end
			for jj=paridx[i]+1:paridx[i+1]
				real_jj=Int(train[jj,2])
				deltaw+=tmp_weight[real_jj]*X[:,real_jj]
			end
			gradwi[:,i]=W[:,i]+2*C*deltaw
		end
	output=0.5*vecnorm(W)+C*loss
	W=W-eta*gradwi
	rcount,totalcount=ranksvmtest(W,testset,X,1)
	println("Iter ", iter, " Test_Accuracy", rcount/totalcount, " Train_Accuracy ", train_correct/train_total, " Output ",output)
	end
	return W
end




