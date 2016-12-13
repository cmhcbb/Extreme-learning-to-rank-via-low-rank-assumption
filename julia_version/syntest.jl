include("synthesisdatagen.jl")
include("parindex.jl")
include("gentest.jl")
include("ranksvm.jl")
include("acctest.jl")
include("ours.jl")
m=100
d=64
train,X=syngentrain()
testset,paridx=genTestset(train,5) # 5 ratings per user
deltax=Array{Array{Float64,2},1}(m)
constidx=Array{Array{Float64,2},1}(m)
pairidx=[]
#index=zeros(15,15,m)    # dim not clear
for i=1:m        # gen all pairs
	deltax[i]=ones(d,1)
	dim=paridx[i+1]-paridx[i]
	constidx[i]=zeros(dim,dim)                 # to get the const index to speedup
	for j=paridx[i]+1:paridx[i+1]
		for k=j+1:paridx[i+1]
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
		for l=1:dim
			if train[j,3]==train[l,3]
				constidx[i][index1,l]=0
				continue
			elseif train[j,3]>train[l,3]
				constidx[i][index1,l]=1
			else
				constidx[i][index1,l]=-1
			end
		end
	end
	deltax[i]=deltax[i][:,2:end]
end
#w=ranksvm(X,train,testset,m,deltax,paridx)
U,V=ours(X,train,testset,m,deltax,paridx)
