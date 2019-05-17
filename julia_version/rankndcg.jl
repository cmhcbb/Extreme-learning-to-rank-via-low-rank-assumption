function rankndcg(U,V,W,m,X,testset,k,flag)
	para=U*V
	if flag!=0
		para=W
	end
        testparidx=parindex(testset)
	ndcg=zeros(m,1)
	dcg=0.0
	tdcg=0.0
	for i=1:m
		if flag==1
			w=W
		elseif flag==2
			w=W[:,i]
		else
			w=para[:,i]
		end
		rating=(X'*w)
		index=testparidx[i]+1:testparidx[i+1]
		realrating=testset[index,3]
		movieindex=testset[index,2]
		rating_use=rating[round(Int64,movieindex)]
		sortindex=sortperm(rating_use,rev=true)
		score=realrating[sortindex]
		sort!(realrating,rev=true)
		for j=1:k
			if testparidx[i+1]-testparidx[i]<j
				break;
			end
			dcg+=(2^score[j]-1)/log2(j+1)
			tdcg+=(2^realrating[j]-1)/log2(j+1)
		end
	end
	return dcg/tdcg
end
