include("parindex.jl")
include("gentest.jl")
include("ranksvm.jl")
include("acctest.jl")
include("ours2ver.jl")
include("genpair.jl")
include("pargenpair.jl")
train=readdlm("user_ratedmovies.dat")
train=train[:,1:3]
X=readcsv("ImageF.dat")
testset,paridx=genTestset(train,5)
m=size(paridx,1)-1
d=size(X,1)
deltax=Array{Array{Float64,2},1}(21)
deltaxn=Array{Array{Float64,2},1}(21)
constidx=Array{Array{Float64,2},1}(21)
subX=Array{Array{Float64,2},1}(21)

#addprocs(20)
for i=1:20
	deltaxn[i],deltax[i],constidx[i],subX[i]=genpair(X,train,paridx,i,d)	
end
#=@parallel for i=1:21
#deltaxn,deltax,constidx,subX=pargenpair(X,train,paridx,100*(i-1)+1,100*i,100,d)
	deltax[i]=rand(1:i*100,64,5)
	deltaxn[i]=rand(1:i*100,64,10)
	constidx[i]=rand(15,15)
	#name1="deltax"*string(i)
	#name2="deltaxn"*string(i)
	#name3="constidx"*string(i)
	#writedlm(name1,deltax)
	#writedlm(name2,deltaxn)
	#writedlm(name3,constidx)
end
=#
