%[indexnew, title] = libsvmread('newstitle.txt.svm');
%[indexnew, abstract] = libsvmread('newsabstract.txt.svm');
%indexcorrespond=load('indexcorrespond');
%X=title';
%X=abstract';
load('imagefeature')
load('matrixA')
%read the data
%test=load('aftertrain.txt');     % user rate matrix train
test=load('user_ratedmovies.dat');

test=test(:,1:3);
%testset=load('aftertest.txt');     % user rate matrix test
%testset=testset(1:262,:);
%testindex=randi(size(test,1),8000,1);

%testset=test(testindex,:);
%test(testindex,:)=[];
train= arrayfun(@(x) test(test(:,1)==x,:),unique(test(:,1)),'uniformoutput',false);
testset=genTestset(train,5);        % 5 per user as the testset
testset= arrayfun(@(x) testset(testset(:,1)==x,:),unique(testset(:,1)),'uniformoutput',false);

%need to be completely changed
