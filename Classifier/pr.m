function [ f ] = pr( rloc, ploc)

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


%% Init all features with zero
l = 0;
f = [l l l l l l l l l l l l l l l l l l l l l];

if isempty(rloc) || isempty(ploc)
%     remove = [1 2 3 6 7 9 10 11 12 15 16 17 18 19 21];
%     f(remove) = [];
    return;
end

dploc = diff(ploc);
drloc = diff(rloc);

%% <2 RR intervals = not enough data to analyze
if(length(drloc)<2)  
    return;
end

%% basic drloc features
stddev_diff_rloc = std(drloc);
stddev_diff_ploc = std(dploc);
if(isnan(stddev_diff_ploc))
    stddev_diff_ploc = l;
end

PR_Ratio = length(dploc)/length(drloc);
Median_Rloc_diff = median(drloc);
Median_Ploc_diff = median(dploc);
if(isnan(Median_Ploc_diff))
    Median_Ploc_diff = l;
end

f9 = abs(median(dploc) - median(drloc));
if(isnan(f9))
    f9 = l;
end

nP_Interval = length(dploc);
nR_Interval = length(drloc);
t = floor(length(drloc)/2);
f13 = median(drloc(1:t))/median(drloc(t:end));

%% 3 clustering approach
rng(0);
c = clusterdata(drloc','maxclust',3,'linkage','median');
c1 = find(c==1);
c2 = find(c==2);
c3 = find(c==3);
f4 =  min([ std(drloc(c1))/median(c1)  std(drloc(c2))/median(c2)  std(drloc(c3))/median(c3)] );

m =  [median(drloc(c1)) median(drloc(c2)) median(drloc(c3))];
f8 = std(m);
if(isnan(f9))
    f9 = l;
end

%% Remove outliers, FFT related features
a=find(drloc>(median(drloc)+std(drloc)));
b=find(drloc<(median(drloc)-std(drloc)));
c=union(a,b);
d=drloc;d(c)=[];
ff = abs(fft(d)); t= floor(length(ff)/2);
f14 = sum(ff(2:t))/length(2:t);
if(isnan(f14))
    f14 = l;
end

ff = abs(fft(dploc)); t= floor(length(ff)/2);
f15 = sum(ff(2:t))/length(2:t);
if(isnan(f15))
    f15 = l;
end

%% 2 clusters, properties of major cluster
rng(0);
c = clusterdata(drloc','maxclust',2,'linkage','median');
c1 = find(c==1);
c2 = find(c==2);
if(length(c1) > length(c2))
    major = c1;
else
    major = c2;
end
f5 = std(major);
f20 = median(major);

%% Remove outliers, std, median features RR and PP
tmp1 = find (dploc < (median(dploc)-120));
tmp2 = find (dploc > (median(dploc)+120));
dploc_new = dploc; 
dploc_new([tmp1 tmp2])=[];
f6 = std(dploc_new);
if(isnan(f6))
    f6 = l;
end

tmp1 = find (drloc < (median(drloc)-120));
tmp2 = find (drloc > (median(drloc)+120));
drloc_new = drloc; drloc_new([tmp1 tmp2])=[];
f7 = std(drloc_new);

%% brady/ tachy binary feature
brady_or_tachy = 0;
% brady less than 50 bpm
if(median(drloc) > 60*300/60 || median(drloc) < 60*300/100)
    brady_or_tachy =1;
end
BradyTachyIndicator1 = brady_or_tachy;

if (median(dploc) > 60*300/50 || median(dploc) < 60*300/100)
    BradyTachyIndicator2=1;
else
    BradyTachyIndicator2=0;
end

%% Range
f17 = max(drloc) - min(drloc);
if(length(dploc)<3)
    Range = 0;
else
    Range = max(dploc) - min(dploc);
end

f = [stddev_diff_rloc stddev_diff_ploc PR_Ratio f4 f5 f6 f7 f8 f9 Median_Ploc_diff nP_Interval nR_Interval ...
    f13 f14 f15 BradyTachyIndicator1 f17 BradyTachyIndicator2 Median_Rloc_diff f20 Range];

end
