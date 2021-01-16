 function [ poincare ] = poincare_features( RR )
x = RR(1:end-1);
y = RR(2:end);

%% Mean Stepping Increment of Inter Beat Intervals
L = length(RR);
sumval = 0;
for i = 1 : L-2
    sumval = sumval + sqrt((x(i)-y(i))^2 + (x(i+1)-y(i+1))^2);
end
sumval = sumval / (L-2);
stepping = sumval / (mean(RR));


%% Dispersion of points around diagonal line in Poincare Plots
cp = (-RR(i)-RR(L)+2*sum(RR(1:L-1)))/(2*(L-1));
term1 = 0;
for i = 1 :  L - 1
    term1 = term1 + (RR(i)-RR(i+1))^2;
end
term1 = term1/(2*(L-1));

term2 = 0;
for i = 1 : L - 1
   term2 = term2 + abs(RR(i) - RR(i+1)); 
end
term2 = term2/(sqrt(2)*(L-1));
term2 = term2^2;

dispersion = sqrt(term1 - term2)/cp;

%% Number of clusters in Poincare Plots - try the mclust based clustering
data = [x y];

nobs = size(data,1);
kdist = zeros(nobs, 1);
D = squareform(pdist(data, 'euclidean'));
MinPts = 1;
for i = 1:nobs
    dtmp     = D(i, :);
    dtmp(i)  = [];
    dtmp     = sort(dtmp, 'ascend');
    kdist(i) = dtmp(MinPts);
end
kdist = sort(kdist, 'descend');
[~, loc] = max(kdist);


[clustLabel, ~] = dbscan(data, 1, kdist(loc+1));
clusters = unique(clustLabel);
if ismember(clusters,0)
    numclust = length(unique(clustLabel)) - 1;
else
    numclust = length(unique(clustLabel));
end

%% Feature List
poincare = [stepping dispersion numclust];

end

