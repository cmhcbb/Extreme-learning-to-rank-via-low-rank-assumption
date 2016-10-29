function A=rankgenA(i,train,X)

n=size(X,2);
A=sparse(n,1000);    %the size of A will change 
    
    %I=find(test(:,1)==i); 
    count=0;
    %maxi=max(I);
    %mini=min(I);
    tmpmat=train{i};
    maxi=size(tmpmat,1);
    randindex1=randi(maxi,500,1);
    randindex2=randi(maxi,500,1);
%{
    for i=1:size(randindex1,1)
        if randindex1(i)==randindex2(i)
            continue;
        end
        if (tmpmat(randindex1(i),3)>tmpmat(randindex2(i),3))
            count=count+1;
            A(tmpmat(randindex1(i),2),count)=1;
            A(tmpmat(randindex2(i),2),count)=-1;
        elseif (tmpmat(randindex1(i),3)<tmpmat(randindex2(i),3))
            count=count+1;
            A(tmpmat(randindex1(i),2),count)=-1;
            A(tmpmat(randindex2(i),2),count)=1;
        end
    end


%}
    for i=1:maxi                           % with all pairs
        for j=i+1:maxi
            if (tmpmat(i,3)>tmpmat(j,3))
                count=count+1;
                A(tmpmat(i,2),count)=1;
                A(tmpmat(j,2),count)=-1;
            elseif (tmpmat(i,3)<tmpmat(j,3))
                count=count+1;
                A(tmpmat(i,2),count)=-1;
                A(tmpmat(j,2),count)=1;
            end
        end
    end







%{
    for j=1:size(I,1)
        for k=j+1:size(I,1)
            if (test(I(j),3)>test(I(k),3))
            count=count+1;
            %{
            if (test(I(j),2)==0)
                A(n,count)=1;
            end
            if (test(I(k),2)==0)
                A(n,count)=-1;
            end
            %}
            A(test(I(j),2),count)=1;
            A(test(I(k),2),count)=-1;
           elseif (test(I(j),3)<test(I(k),3))
               count=count+1;
            %{
            if (test(I(j),2)==0)
                A(test(I(j),2),count)=-1;
            end
            if (test(I(k),2)==0)
                A(test(I(j),k),count)=1;
            end
            %}
            A(test(I(j),2),count)=-1;
            A(test(I(k),2),count)=1;
            end
            if count>=1000
                break;
            end
        end
end
%}
end

