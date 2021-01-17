function [Y, ind]  = outlier_removal( X, factor )


Upperlim = mean(X) + factor*std(X);
Lowerlim = mean(X) - factor*std(X);

UpperOutliers_Locs=find(X>Upperlim);
LowerOutliers_Locs=find(X<Lowerlim);

try
    ind=sort([UpperOutliers_Locs;LowerOutliers_Locs]);
catch
    ind=sort([UpperOutliers_Locs LowerOutliers_Locs]);
end

Y = X(X < Upperlim & X >Lowerlim);
end

