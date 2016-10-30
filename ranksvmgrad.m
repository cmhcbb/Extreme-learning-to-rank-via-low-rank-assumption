%m=max(test(:,1));
m=100; %for synthesis data
C=1;
d=size(X,1);
k=5; %k is the rank
%U=(-1*ones(d,k)+2*randn(d,k))/10;
%V=(-1*ones(k,m)+2*randn(k,m))/10;
U=randn(d,k)/10;
V=randn(k,m)/10;
%U=u;
%V=v;
n=size(train);
%A={};
%for i=1:n
%    i
%	A{i}=rankgenA(i,train,X);
%end
%save('matrixA','A');)
accs=zeros(100,1);
rcounts=zeros(100,1);
objfuns=zeros(100,1);
ndcgs=zeros(100,1);
for iter=1:100
%precompute the (xj-xk)vi'                         //index transfer
iter
[rcount,totalcount]=ranktest(U,V,testset,X);
%if (mod(iter,15)==0)
%     eta=eta*2;
%end
rcount
rcounts(iter)=rcount;
acc=rcount/totalcount;
accs(iter)=acc;
ndcg=rankndcg(U,V,X,train);
%mean(ndcg)
%ndcgs(iter)=mean(ndcg);
maxtempu=zeros(d,k);
maxre=0;
%eta=1e-12;
%parpool('local',64);
for i=1:100  %2113
    %if ~any(test(:,1)==i)
    %    continue;
    %endi
    newmat=A{i};
    pi=X*newmat;
    tempres=U'*pi;
    index=train{i}(1,1);
    for j=1:size(newmat,2)      %gradient descent
        if (pi(:,j)==0)
            continue;
        end
        tempresres=trace(tempres(:,j)*V(:,index)');
        maxre=maxre+max(0,1-tempresres);
        maxtempu=maxtempu+max(0,1-tempresres)*pi(:,j)*V(:,index)';
    end


    %{
    for initer=1:30               %sgd
        j=unidrnd(size(A,2));
        if (~any(pi(:,j)))
            continue;
        end
        tempresres=trace(tempres(:,j)*V(:,i)');
        maxre=maxre+max(0,1-tempresres);
        maxtempu=maxtempu+max(0,1-tempresres)*pi(:,j)*V(:,i)';
    end
    %}
end
%delete(gcp);
output=0.5*norm(U,'fro')+0.5*norm(V,'fro')+C*maxre*maxre
objfuns(iter)=output;
%for i=1:size(A,2)*(m+1)
%    if (re(:,:,i)==0)
%        continue;
%    end
%    maxre=maxre+max(0,1-trace(U'*re(:,:,i)));
%    maxtempu=maxtempu+max(0,1-trace(U'*re(:,:,i)))*re(:,:,i);
%end
eta=1e-4;
gradf=U-2*C*maxtempu;
%eta=Ulinesearch(gradf,U,C,maxre,V,m,X,test);
U=U-eta*gradf;


%compute gradient fixed U  
% use the batch technique

gradvi=zeros(k,m);
maxre=0;
maxtempv=zeros(k,1);
%parpool('local',64);
for j=1:100 %2113    % batch size is 50
    %if ~any(test(:,1)==j)
    %    continue;
    %end
    newmat=A{j};
    index=train{j}(1,1);            
    %maxtempv=zeros(k,m);
    %A=rankgenA(j,train,X);
    pindex=X*newmat;
    tempres=U'*pindex;
                                
    
    for i=1:size(newmat,2)                  %gradient descent
        if (pindex(:,i)==0)
            continue;
        end
        tempresres=trace(tempres(:,i)*V(:,index)');
        maxtempv=maxtempv+max(0,1-tempresres)*tempres(:,i);  %re(:,:,(index-1)*size(A,2)+i)
        %maxre=maxre+max(0,1-tempresres);
    end
    gradvi(:,index)=V(:,index)-2*C*maxtempv; 
    %{
    for initer=1:30                  %sgd
        i=unidrnd(size(A,2));
        if (~any(pindex(:,i)))
            continue;
        end
        tempresres=trace(tempres(:,i)*V(:,index)');
        maxtempv=maxtempv+max(0,1-tempresres)*tempres(:,i);  %re(:,:,(index-1)*size(A,2)+i)
        maxre=maxre+max(0,1-tempresres);
     end
    %}
    %gradvi(:,index)=V(:,index)-2*C*maxtempv;
end
%delete(gcp);    
%eta=newVlinesearch(gradvi,V,C,maxre,U,m,X,test);
   % gradv=V-2*C*maxtempv;
    V=V-eta*gradvi;

    %output=objectValue(U,V,X,test,m)
end

%acc=ranktest(U,V,testset,X)
