include("synthesisdatagen.jl")
include("parindex.jl")
include("gentest.jl")
include("ranksvm.jl")
include("acctest.jl")
include("synours3ver.jl")
m=100
d=64
train,X=syngentrain()
#train,paridx=genTestset(train,20)
testset,paridx=genTestset(train,5) # 5 ratings per user
deltax=Array{Array{Float64,2},1}(m)
deltaxn=Array{Array{Float64,2},1}(m)
constidx=Array{Array{Float64,2},1}(m)
subX=Array{Array{Float64,2},1}(m)
A=Array{Array{Float64,2},1}(m)
pairidx=[]
for i=1:m        # gen all pairs
	dim=paridx[i+1]-paridx[i]
	subpar=train[(paridx[i]+1):(paridx[i+1]),2]
	subpar=convert(Array{Int64,1},subpar)
	subX[i]=X[:,subpar]
	A[i]=ones(100,1)
	for j=paridx[i]+1:paridx[i+1]
		for k=j+1:paridx[i+1]
			tempcol=sparse(zeros(100,1))
			if train[j,3]==train[k,3]
				continue
			elseif train[j,3]>train[k,3]
				tempcol[Int(train[j,2]),1]=1
				tempcol[Int(train[k,2]),1]=-1
			else
				tempcol[Int(train[j,2]),1]=-1
				tempcol[Int(train[k,2]),1]=1
			end
			#println(tempcol)
			A[i]=hcat(A[i],tempcol)
		end
	end
		#println(A[i])
		A[i]=A[i][:,2:end]
		mat=A[i]
		#println(mat)
		#constidxmat=sparse(zeros(dim,size(mat,2)))
		#for j=1:dim
		#	constidxmat[j,:]=mat[Int(train[paridx[i]+j,2]),:]
		#end
		#constidx[i]=constidxmat
		deltax[i]=X*mat
end
w=ranksvm(X,train,testset,m,A,paridx)
	#println(deltaxn[2])
	#println(deltax[2])
#U,V=ours(X,train,testset,m,deltax,paridx)
U,V=ours3ver(X,train,testset,m,paridx,A,subX,5)
