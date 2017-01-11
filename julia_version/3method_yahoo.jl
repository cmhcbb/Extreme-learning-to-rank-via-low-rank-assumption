using MAT
using JLD
include("synthesisdatagen.jl")
include("parindex_cho.jl")
include("newgentest_ratio.jl")
include("ranksvm.jl")
#include("acctest_cho.jl")
include("acctest_new.jl")
#include("synours3ver.jl")
include("ourscho_filter.jl")
include("oneranksvm.jl")
include("allranksvm.jl")
include("ranksvmtest.jl")

#vars = matread("abstract.mat")
vars = matread("title.mat")
X = (vars["b"])'

#train=readdlm("aftertrain.txt")
train=load("../50fil_train.jld","train")
trainset,testset,paridx = genTestset_ratio(train,0.3)
#testset = readdlm("aftertest.txt")
paridx = parindex(trainset);
m=size(paridx,1)-1
#U,V=ourscho(X,trainset,testset,m,paridx,5e-7, 10, 1)
U,V=ourscho(X,trainset,testset,m,paridx,5e-3,5,0.001)
#U,V=ourscho(X,trainset,testset,m,paridx,1e-2, 10, 0.0001)
#U,V=oneranksvm(X,trainset,testset,m,paridx,1e-7, 1)
#U,V=allranksvm(X,trainset,testset,m,paridx,5e-8, 1)
