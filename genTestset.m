function testset=genTestset(train,num)
    %m=max(test(:,1));
    m=size(train,1);
    testset=zeros(1,3);
    for i=1:m
        %if ~any(test(:,1)==i)
        %    continue;
        %end
        %I=find(test(:,1)==i);
        %maxi=max(I);
        %mini=min(I);
        tmpmat=train{i};
        randindex=randi(size(tmpmat,1),num,1);
        tmp=train{i}(randindex,:);
        testset=[testset;tmp];
    end
    testset=testset(2:size(testset,1),:);
    
end