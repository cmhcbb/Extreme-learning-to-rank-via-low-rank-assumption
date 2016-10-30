function rcount=rank1test(w,testset,X,m)
    rcount=0;
    totalcount=0;
    for i=1:size(testset,1)
        testmat=testset{i};
        for j=1:size(testmat,1)
            for k=j+1:size(testmat,1)
                real=testmat(j,3)-testmat(k,3);
                if real==0
                    continue;
                end
                res=w'*(X(:,testmat(j,2))-X(:,testmat(k,2)));
                totalcount=totalcount+1;
                if res*real>0
                    rcount=rcount+1; 
                end
            end
        end
    end
    %acc=rcount/totalcount;
