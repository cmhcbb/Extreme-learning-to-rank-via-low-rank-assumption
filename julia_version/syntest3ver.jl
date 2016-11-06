include("synthesisdatagen.jl")
include("parindex.jl")
include("gentest.jl")
include("ranksvm.jl")
include("acctest.jl")
include("ours2ver.jl")
include("ours.jl")
m=100
d=64
train,X=syngentrain()
testset,paridx=genTestset(train,5) # 5 ratings per user
deltax=Array{Array{Float64,2},1}(m)
deltaxn=Array{Array{Float64,2},1}(m)
constidx=Array{Array{Float64,2},1}(m)
subX=Array{Array{Float64,2},1}(m)
pairidx=[]
#index=zeros(15,15,m)    # dim not clear
for i=1:m        # gen all pairs
	deltax[i]=ones(d,1)
	deltaxn[i]=ones(d,1)
	dim=paridx[i+1]-paridx[i]
	constidx[i]=zeros(dim,dim)                 # to get the const index to speedup
	subpar=train[(paridx[i]+1):(paridx[i+1]),2]
	subpar=convert(Array{Int64,1},subpar)
	subX[i]=X[:,subpar]
	for j=paridx[i]+1:paridx[i+1]
		index1=j-paridx[i]
		for k=j+1:paridx[i+1]
			index2=k-j
			if train[j,3]==train[k,3]
				#deltax[i]=hcat(deltax[i],zeros(d,1))
				continue
			elseif train[j,3]>train[k,3]
				deltax[i]=hcat(deltax[i],(X[:,Int8(train[j,2])]-X[:,Int(train[k,2])]))
			else
				deltax[i]=hcat(deltax[i],(X[:,Int8(train[k,2])]-X[:,Int(train[j,2])]))
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
				deltaxn[i]=hcat(deltaxn[i],(X[:,Int8(train[j,2])]-X[:,Int(train[l,2])]))
				constidx[i][index1,index2]=1
			else
				deltaxn[i]=hcat(deltaxn[i],(X[:,Int8(train[l,2])]-X[:,Int(train[j,2])]))

				constidx[i][index1,index2]=-1
			end
		end
	end
	deltaxn[i]=deltaxn[i][:,2:end]
	deltax[i]=deltax[i][:,2:end]
end
#w=ranksvm(X,train,testset,m,deltax,paridx)
	#println(deltaxn[2])
	#println(deltax[2])
#U,V=ours(X,train,testset,m,deltax,paridx)
U,V=ours2ver(X,train,testset,m,deltax,deltaxn,paridx,constidx,subX,15)
