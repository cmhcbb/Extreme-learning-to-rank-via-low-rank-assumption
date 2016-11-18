include("parindex.jl")
include("gentest.jl")
include("ranksvm.jl")
include("acctest.jl")
include("ours3ver.jl")
using MAT
train=readdlm("user_ratedmovies.dat")
train=train[:,1:3]
train=train[1:34471,:]  #100 users
X=readcsv("ImageF.dat")
X=X/67196  # normalize the data
d=size(X,1)	
mo=65133
testset,paridx=genTestset(train,5) # 5 ratings per user
m=size(paridx,1)-1
deltax=Array{Array{Float64,2},1}(m)
constidx=Array{Array{Float64,2},1}(m)
subX=Array{Array{Float64,2},1}(m)
tempdic=matread("matrixA.mat")
A=tempdic["A"]
#=for i=1:m        # gen all pairs
	dim=paridx[i+1]-paridx[i]
	subpar=train[(paridx[i]+1):(paridx[i+1]),2]
	subpar=convert(Array{Int64,1},subpar)
	subX[i]=X[:,subpar]
	println(i)
	#println(A[i])
	mat=A[i]
	#println(mat)
	constidxmat=sparse(zeros(dim,size(mat,2)))
	for j=1:dim
		constidxmat[j,:]=mat[Int(train[paridx[i]+j,2]),:]
	end
	constidx[i]=constidxmat
	deltax[i]=X*mat
end
=#
#U,V=ours3ver(X,train,testset,m,paridx,A,subX,40)
