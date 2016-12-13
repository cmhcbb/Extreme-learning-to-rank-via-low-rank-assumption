function pargenpair(X,train,paridx,mini,maxi,m,d)
deltax=Array{Array{Float64,2},1}(m)
deltaxn=Array{Array{Float64,2},1}(m)
constidx=Array{Array{Float64,2},1}(m)
subX=Array{Array{Float64,2},1}(m)
for i=mini:maxi       # gen all pairs
	#println(i)
	deltax[i]=ones(d,1)
	deltaxn[i]=ones(d,1)
	dim=paridx[i+1]-paridx[i]
	constidx[i]=zeros(dim,dim)                 # to get the const index to speedup
	subpar=train[(paridx[i]+1):(paridx[i+1]),2]
	subpar=convert(Array{Int64,1},subpar)
	subX[i]=X[:,subpar]
	for j=paridx[i]+1:paridx[i+1]
		for k=j+1:paridx[i+1]
			if train[j,3]==train[k,3]
				#deltax[i]=hcat(deltax[i],zeros(d,1))
				continue
			elseif train[j,3]>train[k,3]
				deltax[i]=hcat(deltax[i],(X[:,Int(train[j,2])]-X[:,Int(train[k,2])]))
			else
				deltax[i]=hcat(deltax[i],(X[:,Int(train[k,2])]-X[:,Int(train[j,2])]))
			end
		end
		index1=j-paridx[i]
		for l=paridx[i]+1:paridx[i+1]
			index2=l-paridx[i]
			if train[j,3]==train[l,3]
				deltaxn[i]=hcat(deltaxn[i],zeros(d,1))
				constidx[i][index1,index2]=0
				continue
			elseif train[j,3]>train[l,3]
				deltaxn[i]=hcat(deltaxn[i],(X[:,Int(train[j,2])]-X[:,Int(train[l,2])]))
				constidx[i][index1,index2]=1
			else
				deltaxn[i]=hcat(deltaxn[i],(X[:,Int(train[l,2])]-X[:,Int(train[j,2])]))

				constidx[i][index1,index2]=-1
			end
		end
	end
	deltaxn[i]=deltaxn[i][:,2:end]
	deltax[i]=deltax[i][:,2:end]
end
return deltaxn,deltax,constidx,subX
end
