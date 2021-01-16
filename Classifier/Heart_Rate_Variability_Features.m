function features = Heart_Rate_Variability_Features(ecg, fs, qrs)

% 
% Copyright (C) 2017 
% Shreyasi Datta
% Chetanya Puri
% Ayan Mukherjee
% Rohan Banerjee
% Anirban Dutta Choudhury
% Arijit Ukil
% Soma Bandyopadhyay
% Rituraj Singh
% Arpan Pal
% Sundeep Khandelwal
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


features = zeros(1,19);

if length(qrs) < 6
    return
end

RR = diff(qrs')/fs;

%% Nonlinear HRV features
ibi = qrs/fs;
ibi = ibi(2:end)';
ibi = [ibi RR];
output = nonlinearHRV(ibi);
sampentropy = output.sampen;
dfa = output.dfa;
dfa_feat = dfa.alpha1;
if isempty(any(isnan(dfa_feat))) || isempty(any(isinf(dfa_feat)))
    dfa_feat = [0 0];
end

num_inf = (nnz(~isinf(sampentropy)));
sampentropy(~isinf(sampentropy)) = 100;
sampentropy(isnan(sampentropy)) = 0;

entropy_feat = sampentropy';

if ~isempty(sampentropy)
    max_entropy = max(sampentropy);
    min_entropy = min(sampentropy);
    max_ind = find(sampentropy == max_entropy);
    min_ind = find(sampentropy == min_entropy);
    
    if length(max_ind) > 1
        max_ind = max_ind(1);
    end
    if length(min_ind) > 1
        min_ind = min_ind(1);
    end
    
    entropy_feat = [entropy_feat num_inf max_entropy min_entropy max_ind min_ind];
else
    entropy_feat = [entropy_feat num_inf 0 0 0 0];
end

%% Poincare HRV features
output = poincareHRV(ibi);
poincare_feat = [output.SD1 output.SD2];

%% Approximate Entropy of RR Intervals
tau = 1;
sd1 = std(RR);
apen = zeros(1,5);
for i = 1 : 5
    r = 1 * 0.02;
    apen(i) = HRV_Approx_Entropy(i, r*sd1, RR, tau);
end

features = [entropy_feat dfa_feat poincare_feat apen];

end

