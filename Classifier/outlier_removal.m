function [Y, ind]  = outlier_removal( X, factor )

%ind=[];
hlim = mean(X) + factor*std(X);
llim = mean(X) - factor*std(X);

ind1=find(X>hlim);
ind2=find(X<llim);
%ind=[ind ind1 ind2];
%ind=sort(ind);
if iscolumn(ind1) && iscolumn(ind2)
    ind=sort([ind1;ind2]);
else
    ind=sort([ind1 ind2]);
end

X = X(X < hlim & X >llim);

Y=X;
end

