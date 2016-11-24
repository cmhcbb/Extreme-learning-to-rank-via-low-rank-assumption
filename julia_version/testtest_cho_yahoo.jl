using MAT
include("synthesisdatagen.jl")
include("parindex.jl")
include("newgentest.jl")
include("ranksvm.jl")
include("acctest_cho.jl")
#include("synours3ver.jl")
include("ourscho.jl")

vars = matread("title.mat")
X = (vars["b"])'

train=readdlm("aftertrain.txt")
trainset,testset,paridx = genTestset(train,10)
#testset = readdlm("aftertest.txt")
paridx = parindex(train);
m=size(paridx,1)-1
U,V=ourscho(X,train,testset,m,paridx,5e-7, 10, 1)
