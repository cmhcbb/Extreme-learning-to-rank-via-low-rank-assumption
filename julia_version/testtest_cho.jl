include("synthesisdatagen.jl")
include("parindex.jl")
include("gentest.jl")
include("ranksvm.jl")
include("acctest_cho.jl")
#include("synours3ver.jl")
include("ourscho.jl")
d=64
X=readcsv("ImageF.dat")
X=X/67196
train=readdlm("user_ratedmovies.dat")
train=train[1:34471,1:3]
#testset,paridx=genTestset(train,30) # 5 ratings per user
#train=testset
testset,paridx=genTestset(train,5)
paridx = parindex(train);
m=size(paridx,1)-1
constidx=Array{Array{Float64,2},1}(m)
#paridx_int = Int.(paridx)
U,V=ourscho(X,train,train,m,paridx,1e-4, 5, 10)
