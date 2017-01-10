function oneranksvm(X,train,testset,m,paridx,eta=5e-7,C=10)
	d=size(X,1)
	n=size(X,2)
	w=randn(d)/10
	tmp_weight=zeros(n)
	rcount,totalcount=ranksvmtest(w,testset,X,0)
	println("Iter 0 Acc ", rcount/totalcount)
	for iter=1:2000
		loss=0.0
		train_total=0
		train_correct=0
		wX=(X'*w)
		gradw=zeros(d)
		for i=1:m
			deltaw=zeros(d)
			for jj=paridx[i]+1:paridx[i+1]
				real_jj=Int(train[jj,2])
				tmp_weight[real_jj]=0.0
			end
			for jj=paridx[i]+1:paridx[i+1]
				for kk=paridx[i]+1:paridx[i+1]
					if train[jj,3]>train[kk,3]
						train_total+=1
						real_jj=Int(train[jj,2])
						real_kk=Int(train[kk,2])
						tmp = 1- (wX[real_jj]-wX[real_kk])
						if (tmp<=1)
							train_correct+=1
						end
						if (tmp>=0)
							loss+=tmp*tmp
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
			gradw+=w+2*C*deltaw
		end
	output=0.5*norm(w)+C*loss
	w=w-eta*gradw
	rcount,totalcount=ranksvmtest(w,testset,X,0)
	println("Iter ",iter," Test_Accuracy ", rcount/totalcount, " Train_Accuracy ", train_correct/train_total, " Output ", output)
	end
	return w
end
