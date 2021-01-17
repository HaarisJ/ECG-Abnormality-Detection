function [STR_Array] = STR_Entropy_Features(ecg)
N = length(ecg);
%% Computation of Shannon, Tsallis and Renyi Entropi
bins = 50;
p = zeros(1,N);
[counts,centers] = hist(ecg,bins);
thr = mean((diff(centers))/2);
centers(2,:) = centers + thr;
for i=1:N
    p1 = find(ecg(i)<=centers(2,:));
    if ~isempty(p1)
        p(i) = counts(p1(1));
    else
        p(i) = counts(end);
    end
end

% find locations where p = 0; the p needs to be removed in those
% cases. This is done to bypass NaN situations
p = p(p~=0)/N;
Shannon = -1*sum(p.*log(p)); %http://people.math.harvard.edu/~ctm/home/text/others/shannon/entropy/entropy.pdf                                
Tsallis = sum(1 - p.^2); %https://www.researchgate.net/publication/226805234_Possible_generalization_of_Boltzmann-Gibbs_statistics
Renyi = log(sum(p.^2));  %https://www.mdpi.com/1099-4300/20/11/813/pdf
                     
%% Combining all 3 entropy values into single array
STR_Array = [Shannon Tsallis Renyi];


end

