function label=WKNN(X,Y,test,kn)
% Weighted K-Nearest Neighbors function.
% X: train features
% Y: train labels
% test: test features
    m=2;
    for i=1:size(test,1)
        d=dist(X,test(i,:)');
        w=(1./d).^m;    
        [~,indx]=sort(d);
        I=Y(indx(1:kn)); % indices of k nearest neighbors  
        
        
        WI=w(indx(1:kn)); % weights of k nearest neighbors  
        for x=min{Y}:max{Y} % number of classes
            labl=find(I==x);
            if isempty(labl)
                vote(x)=0;
            else
                vote(x)=sum(WI(labl));
            end
        end
        [~,label(i)]=max(vote);
        label=label';
        
        
    end
end