function acc=rank1test(w,testset,X,m)
    rcount=0;
    totalcount=0;
    for i=1:m
        I=find(testset(:,1)==i);
        if (size(I,1)<=1)
            continue;
        end
        for j=1:size(I,1)
            for k=j+1:size(I,1)
                res=w'*(X(:,testset(I(j),2))-X(:,testset(I(k),2)));
                real=testset(I(j),3)-testset(I(k),3);
                if real==0
                    continue;
                end
                totalcount=totalcount+1;
                if res*real>0
                    rcount=rcount+1; 
                end
            end
        end
    end
    acc=rcount/totalcount;