m=100;  %number of users
C=1;
X=randn(64,100);  % d=64 #movies=100
d=size(X,1);
k=5; %k is the rank
%u=(-1*ones(d,k)+2*rand(d,k))/10;
%v=(-1*ones(k,m)+2*rand(k,m))/10;
u=randn(d,k);
v=randn(k,m);
realU=u;
realV=v;
realpara=realU*realV;
train={};
for i=1:100
    realw=realpara(:,i);
    rating=realw'*X;
    sampleindex=randi(100,15,1);     % each user has 15 ratings
    usercol=ones(15,1)*i;
    samplecol=sampleindex;
    ratecol=rating(sampleindex)';
    train{i}=[usercol,samplecol,ratecol];
end
train=train';
testset=genTestset(train,5);        % 5 ratings per user as the testset
testset= arrayfun(@(x) testset(testset(:,1)==x,:),unique(testset(:,1)),'uniformoutput',false);
syngenpair;
ranksvmgrad;
