using MAT
using JLD
include("synthesisdatagen.jl")
include("parindex_cho.jl")
#include("newgentest_ratio.jl")
include("gentest_item.jl")
include("ranksvm.jl")
include("acctest_new.jl")
#include("synours3ver.jl")
include("ourscho_filter.jl")
include("oneranksvm.jl")
include("allranksvm.jl")
include("ranksvmtest.jl")
include("ranksvmvar.jl")
include("vartest.jl")
#X=readcsv("ImageF.dat")
#X=X/67196
vars=matread("genres_feature.mat")
X=(vars["X"])'
#train=readdlm("aftertrain.txt")
train=load("../train_img_filter.jld","train")
#trainset,testset,paridx = genTestset_ratio(train,0.2)
trainset,testset = genTestset_item(train,0.2)
#testset = readdlm("aftertest.txt")
paridx = parindex(trainset);
m=size(paridx,1)-1
#U,V=ourscho(X,trainset,testset,m,paridx,5e-7, 150, 1)
#U,V=ourscho(X,trainset,testset,m,paridx,1e-3,5,0.001)
#U,V=ourscho(X,trainset,testset,m,paridx,1e-2, 10, 0.0001)
#U,V=oneranksvm(X,trainset,testset,m,paridx,1e-7, 1)
#U,V=allranksvm(X,trainset,testset,m,paridx,5e-9, 1)
w,Vt=ranksvmvar(X,trainset,testset,m,paridx,1e-7,1)
