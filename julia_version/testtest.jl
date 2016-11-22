include("synthesisdatagen.jl")
include("parindex.jl")
include("newgentest.jl")
include("ranksvm.jl")
include("acctest.jl")
include("synours3ver.jl")
d=64
X=readcsv("ImageF.dat")
X=X/67196
train=readdlm("user_ratedmovies.dat")
train=train[1:34471,1:3]
train,testset,paridx=genTestset(train,30)
train=testset
train,testset,paridx=genTestset(train,5)
paridx=parindex(train)
m=size(paridx,1)-1
constidx=Array{Array{Float64,2},1}(m)
subX=Array{Array{Float64,2},1}(m)
A=Array{Any,1}(m)
for i=1:m        # gen all pairs
	println(i)
	dim=paridx[i+1]-paridx[i]
	#subpar=train[(paridx[i]+1):(paridx[i+1]),2]
	#subpar=convert(Array{Int64,1},subpar)
	#subX[i]=X[:,subpar]
	temp=spzeros(65133,1)
	for j=paridx[i]+1:paridx[i+1]
		for k=j+1:paridx[i+1]
			tempcol=spzeros(65133,1)
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
			temp=hcat(temp,tempcol)
		end
	end
		#println(A[i])
		temp=temp[:,2:end]
		A[i]=sparse(temp)
		#println(mat)
		#constidxmat=sparse(zeros(dim,size(mat,2)))
		#for j=1:dim
		#	constidxmat[j,:]=mat[Int(train[paridx[i]+j,2]),:]
		#end
		#constidx[i]=constidxmat
end
#w=ranksvm(X,train,testset,m,A,paridx)
	#println(deltaxn[2])
	#println(deltax[2])
#U,V=ours(X,train,testset,m,deltax,paridx)
U,V=ours3ver(X,train,testset,m,paridx,A,subX,20)
