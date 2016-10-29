function [ndcg]=rankndcg(U,V,X,testset)
    para=U*V;
    ndcg=zeros(size(testset,1),1);
    for i=1:size(testset,1)
        testmat=testset{i};
        if (size(testmat,1)<200)
		continue;
	end
	w=para(:,testmat(1,1));
        rating=testmat(:,3)';
        rel=w'*X(:,testmat(:,2));
        [sortedrel,indexrel]=sort(rel,'descend');
        newrating=rating(indexrel);
        [sortedrat,indexrat]=sort(rating,'descend');
        
        sumrel=0;
        sumirel=0;
        for j=1:200
            sumrel=sumrel+(2.^(newrating(j))-1)/log2(j+1);
            sumirel=sumirel+(2.^(sortedrat(j))-1)/log2(j+1);
        end

        ndcg(i)=sumrel/sumirel;
    end
end
