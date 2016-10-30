%m=max(test(:,1));
m=100;  % as synthetic data
C=1;
d=size(X,1);
w=rand(d,1);
for iter=1:30
iter
maxtempu=zeros(d,1);
maxre=0;
%eta=1e-12;
for i=1:m
    i/m;
    A=rankgenA(i,test,X);
    pi=X*A;
    tempres=w'*pi;

    for j=1:size(A,2)      %gradient descent
        if (pi(:,j)==0)
            continue;
        end
        maxre=maxre+max(0,1-tempres(:,j));
        maxtempu=maxtempu+max(0,1-tempres(:,j))*pi(:,j);
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

eta=1e-6;
gradf=w-2*C*maxtempu;
%eta=Ulinesearch(gradf,U,C,maxre,V,m,X,test);
w=w-eta*gradf;
output=0.5*norm(w)+C*maxre*maxre
end
