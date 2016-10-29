m=500;
C=1;
X=10000*rand(64,10000);
d=size(X,1);
k=3; %k is the rank
%u=(-1*ones(d,k)+2*rand(d,k))/10;
%v=(-1*ones(k,m)+2*rand(k,m))/10;
u=randn(d,k);
v=randn(k,m);
realU=u;
realV=v;
realpara=realU*realV;
train={};
for i=1:500
    realw=realpara(:,i);
    rating=realw'*X;
    sampleindex=randi(10000,50,1);
    usercol=ones(50,1)*i;
    samplecol=sampleindex;
    ratecol=rating(sampleindex)';
    train{i}=[usercol,samplecol,ratecol];
end
train=train';
testset=genTestset(train,5);        % 5 per user as the testset
testset= arrayfun(@(x) testset(testset(:,1)==x,:),unique(testset(:,1)),'uniformoutput',false);
syngenpair;
ranksvmgrad;
