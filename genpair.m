parpool('local',32)
p=gcp();
n=size(train,1);
%A={};
%A=distributed(A);
%parfor i=200:264
%   A=rankgenA(i,train,X);
%end
%delete(gcp)
%p = gcp();
% To request multiple evaluations, use a loop.
for idx = 1:n
  f(idx) = parfeval(p,@rankgenAnew,2,idx,train,X); % Square size determined by idx
end
% Collect the results as they become available.
A = cell(1,2113);
constidx=cell(1,2113);
for idx = 1:n
  % fetchNext blocks until next results are available.
  [completedIdx,value1,value2] = fetchNext(f);
  A{completedIdx} = value1;
  constidx{completedIdx} = value2;
  fprintf('Got result with index: %d.\n', completedIdx);
end
delete(gcp)
save('matrixAn','A');
save('constidx','constidx')
