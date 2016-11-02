include("synthesisdatagen.jl")
include("parindex.jl")
include("gentest.jl")
include("ranksvm.jl")
m=100
d=64
train,X=syngentrain()
testset,paridx=genTestset(train,5) # 5 ratings per user
deltax=zeros(d,1)
for i=1:m        # gen all pairs
	for j=paridx[i]+1:paridx[i+1]
		for k=j+1:paridx[i+1]
			if train[j,3]==train[k,3]
				continue
			elseif train[j,3]>train[k,3]
				deltax=[deltax (X[:,Int8(train[j,2])]-X[:,Int(train[k,2])])]
			else
				deltax=[deltax (X[:,Int8(train[k,2])]-X[:,Int(train[j,2])])]
			end
		end
	end
end
deltax=deltax[:,2:end]
w=ranksvm(X,train,testset,m,deltax,paridx)
