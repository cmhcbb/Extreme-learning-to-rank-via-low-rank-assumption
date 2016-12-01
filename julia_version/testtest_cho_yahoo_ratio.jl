using MAT
include("synthesisdatagen.jl")
include("parindex_cho.jl")
include("newgentest_ratio.jl")
include("ranksvm.jl")
include("acctest_cho.jl")
#include("synours3ver.jl")
include("ourscho.jl")

vars = matread("title.mat")
X = (vars["b"])'

train=readdlm("aftertrain.txt")
trainset,testset,paridx = genTestset_ratio(train,0.2)
#testset = readdlm("aftertest.txt")
paridx = parindex(trainset);
m=size(paridx,1)-1
U,V=ourscho(X,trainset,testset,m,paridx,5e-7, 10, 1)
#U,V=ourscho(X,trainset,testset,m,paridx,1e-5, 50, 0.1)
