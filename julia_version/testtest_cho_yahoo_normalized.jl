using MAT
include("synthesisdatagen.jl")
include("parindex.jl")
include("newgentest.jl")
include("ranksvm.jl")
include("acctest_cho.jl")
#include("synours3ver.jl")
include("ourscho_normalized.jl")

vars = matread("title.mat")
X = (vars["b"])'

train=readdlm("aftertrain.txt")
trainset,testset,paridx = genTestset(train,5)
#testset = readdlm("aftertest.txt")
paridx = parindex(trainset)
m=size(paridx,1)-1

U,V=ourscho(X,trainset, testset,m,paridx,1e-2, 50, 1)
