constidx={};
deltax={};
for i=1:size(A,2)
i
mat=A{i};
constmat=sparse(zeros(size(train{i},1),size(mat,2)));
for j=1:size(constmat,1)
	constmat(j,:)=mat(train{i}(j,2),:);
end
constidx{i}=constmat;
deltax{i}=X*mat;
end
save('constidx.mat','constidx')
save('deltax.mat','deltax')
