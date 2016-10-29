function [maxtempu,maxre]=pargrad(i,U,V,A)
    newmat=a{i};
    pi=x*newmat;
    tempres=u'*pi;
    index=train{i}(1,1);
    for j=1:size(newmat,2)      %gradient descent
        if (pi(:,j)==0)
            continue;
        end
        tempresres=trace(tempres(:,j)*v(:,index)');
        maxre=maxre+max(0,1-tempresres);
        maxtempu=maxtempu+max(0,1-tempresres)*pi(:,j)*v(:,index)';
    end

