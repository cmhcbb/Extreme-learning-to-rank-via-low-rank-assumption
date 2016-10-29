parpool('local',64)
p=gcp();
n=size(train);
%A={};
%A=distributed(A);
%parfor i=200:264
%   A=rankgenA(i,train,X);
%end
%delete(gcp)
%p = gcp();
% To request multiple evaluations, use a loop.
for idx = 1:n
  f(idx) = parfeval(p,@rankgenA,1,idx,train,X); % Square size determined by idx
end
% Collect the results as they become available.
A = cell(1,2113);
for idx = 1:n
  % fetchNext blocks until next results are available.
  [completedIdx,value] = fetchNext(f);
  A{completedIdx} = value;
  fprintf('Got result with index: %d.\n', completedIdx);
end
delete(gcp)
save('matrixA','A');
