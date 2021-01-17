function [Features_SD,Features_Physiological] = ECG_Feature_Extraction(ecg, fs, P_Wave_Index, Q_Wave_Index, R_Wave_Index, S_Wave_Index, T_Wave_Index)
PR_ratio = length(P_Wave_Index)/length(R_Wave_Index);

%% Invert ECG if necessary
Amplitude = ecg(R_Wave_Index);
if mean(Amplitude) < 0 && median(Amplitude) < 0
    ecg = -ecg;
end

%% Filter ECG
filtered_ecg = Butterworth_BPF( ecg );

%% Find RR_Interval
QRS = R_Wave_Index;
RR_Interval = diff(R_Wave_Index')/fs;

%% Error Checking to see if possible to do a 
%If ECG length is too short - cancel running script - too short to do
% proper analysis
if (length(R_Wave_Index) < 6 || isempty(Q_Wave_Index) || isempty(S_Wave_Index) || isempty(T_Wave_Index)) 
    Features_SD = 0;
    [Features_Physiological] = Physiological_Feats(ecg,fs,RR_Interval);
    return
end

%% Plotting
% plot(filtered_ecg); hold on; 
% plot(P_Wave_Index,filtered_ecg(P_Wave_Index),'k^');
% plot(Q_Wave_Index,filtered_ecg(Q_Wave_Index),'c^');
% plot(R_Wave_Index,filtered_ecg(R_Wave_Index),'r*');
% plot(S_Wave_Index,filtered_ecg(S_Wave_Index),'m^');
% plot(T_Wave_Index,filtered_ecg(T_Wave_Index),'g^');
% legend('ECG','P','Q','R','S','T');

%% Feature Extraction
%% SoA Features from RR_Interval Interval
% This section of Code is written by the University of Oxford
% AF score according to SoA
[AFEv, OriginCount, IrrEv, PACEv, DensityEv, AniEv] = AF_Evaluation(RR_Interval);

% Coefficient of variation of RR_Interval and delta(RR_Interval)
CVrr = std(RR_Interval)/mean(RR_Interval);
CVdrr = std(diff(RR_Interval))/mean(RR_Interval);

% Poincare Features
poincare = poincare_features(RR_Interval);

% Appending SoA Features into array
SoAFeats = [AFEv OriginCount IrrEv PACEv DensityEv AniEv CVrr CVdrr poincare];

%% Statistcal charateristics of RR_Interval Interval
mean_RR = mean(RR_Interval);
median_RR = median(RR_Interval);
min_RR = min(RR_Interval);
max_RR = max(RR_Interval);
delta_RR = max(RR_Interval) - min(RR_Interval);
skewness_RR = skewness(RR_Interval);
kurtosis_RR = kurtosis(RR_Interval);
variance_RR = var(RR_Interval);

% Appending Statistical features into StatisticalFeats array
StatisticalFeats = [mean_RR median_RR min_RR max_RR delta_RR skewness_RR kurtosis_RR variance_RR];

%% Wavelet Entropy
% Returns shannon entropy of vector 
W_Entropy = wentropy(RR_Interval,'shannon');

%% Hjorth Parameters
% Mobility = mean frequency or the proportion of standard deviation of the power spectrum.
% Complexity = change in frequency
[~, Hjorth_Mobility, Hjorth_Complexity] = hjorth(RR_Interval,0);

%% Features from the Probability Density Estimate of RR_Interval and delta(RR_Interval)
% Computes function estimate using kernel smoothing function
[f,xi] = ksdensity(RR_Interval);

kurtosis_PDE = kurtosis(f);
skewness_PDE = skewness(f);
[peaks,locs] = findpeaks(f);
num_peaks = length(peaks);
distance = zeros(1, num_peaks);
maxdist = 0;
mindist = 0;
if num_peaks > 1
    [~, dompeakloc] = max(peaks);
    pks1 = peaks; 
    %loc1 = locs;
    pks1(dompeakloc) = [];
    %loc1(dompeakloc) = [];
    for ii = 1 : length(pks1)
       distance(ii) = abs(xi(locs(dompeakloc))-xi(locs(ii)));
    end
    maxdist = max(distance);
    mindist = min(distance);
end
    
dRR = diff(RR_Interval);
[f1,~] = ksdensity(dRR);
kurtosis_f1 = kurtosis(f1);
skewness_f1 = skewness(f1);

% Appending PDE Features into PDE_Features array
PDE_Features = [kurtosis_PDE skewness_PDE num_peaks maxdist mindist kurtosis_f1 skewness_f1];

%% Amplitude based features for noise
amplitude = ecg(QRS);
temp = zeros(1, length(QRS)-1);
var_amp = std(amplitude)/mean(amplitude);

% Statistical features on amplitude of QRS
[f3,~] = ksdensity(amplitude);
kurt_f3 = kurtosis(f3);
skew_f3 = skewness(f3);
[pks3,~] = findpeaks(f3);
num_pks3 = length(pks3);

% Variance of Energy between R peaks
for i = 1 : length(QRS)-1
   temp(i) = mean(filtered_ecg(QRS(i)+1:QRS(i+1)-1));
end
var_en = std(temp)/mean(amplitude);

AmplitudeFeats = [kurt_f3 skew_f3 num_pks3 var_amp var_en];

%% HRV Features
diffNN = diff(RR_Interval);
SDSD  = std(diffNN);
NN50 = length(find(abs(diffNN)>0.5));
pNN50 = NN50/length(RR_Interval);
NN20 = length(find(abs(diffNN)>0.2));
pNN20 = NN20/length(RR_Interval);

HRV_Feats = [pNN20 pNN50 SDSD];

%% Depth of S (RS amplitude difference)
filtered_ecg(R_Wave_Index(find(filtered_ecg(R_Wave_Index) == 0))) = 0.00001;
rsfeat = abs(filtered_ecg(S_Wave_Index)./filtered_ecg(R_Wave_Index));
%rsfeat = rs./ecg_f(R_Wave_Index);
[~, r_ind] = outlier_removal(rsfeat,1);
rsfeat(r_ind) = [];
rs1 = std(rsfeat)/mean(rsfeat);
rs2 = max(rsfeat) - min(rsfeat);
rs3 = median(rsfeat);

%% Features from ST segment
% Slope of ST
 slope_ST = zeros(1,length(S_Wave_Index));
for i = 1 : length(S_Wave_Index)
   slope_ST(i) = (filtered_ecg(T_Wave_Index(i)) - filtered_ecg(S_Wave_Index(i)))/(T_Wave_Index(i) - S_Wave_Index(i));
end
slope_ST = rmmissing(slope_ST);

if ~isempty(slope_ST)
    slope_ST = outlier_removal(slope_ST,2);
end

if ~isempty(slope_ST)
    med_st = median(slope_ST);
    var_st = std(slope_ST)/mean(slope_ST);
    num_neg_st = length(find(slope_ST<0))/length(QRS);
else
    med_st = 0;
    var_st = 0;
    num_neg_st = 0;
end

% Crossing of ST segment w.r.t. baseline
deep_s = 0;
inflec_dist_s = 0;
deep_s1 = find(filtered_ecg(S_Wave_Index)<filtered_ecg(Q_Wave_Index));
mod_T_prev = zeros(1,length(deep_s1));

if(~isempty(deep_s1))
    deep_s = length(deep_s1)/length(S_Wave_Index);
    mod_S = S_Wave_Index(deep_s1);
    mod_T = T_Wave_Index(deep_s1);
    mod_Q = Q_Wave_Index(deep_s1);
    
    for jj = 1 : length(deep_s1)
        if deep_s1(jj) == 1
            mod_T_prev(jj) = 1;
        else
            mod_T_prev(jj) = T_Wave_Index(deep_s1(jj)-1);
        end
    end
    
    for z = 1 : length(mod_S)
        temp = filtered_ecg(mod_S(z):1:mod_T(z));
        if z == 1
            ind = find(temp>filtered_ecg(mod_Q(z)));
        else
            ind = find(temp>median(filtered_ecg(mod_T_prev(z):mod_Q(z))));
        end
        if isempty(ind)
            inflec_dist_s(z) = 0;
        else
            inflec_dist_s(z) = ind(1);
        end
    end
end
inflec_dist_s = median(inflec_dist_s);

%% RT interval Amplitude
tr_amp = filtered_ecg(T_Wave_Index)./filtered_ecg(R_Wave_Index);
% ecg_f(find(tr_amp<0)) = [];
if ~isempty(tr_amp)
    tr_amp = median(tr_amp);
else
    tr_amp = 0;
end

%% QS Width and QR Width
QRS_width = (S_Wave_Index - Q_Wave_Index)./fs;
QR_width = (R_Wave_Index - Q_Wave_Index)./fs;
Q1 = median(QRS_width);
Q2 = std(QRS_width)/mean(QRS_width);
Q3 = median(QR_width);
Q4 = std(QR_width)/mean(QR_width);

%% Ratio of Q segment to QRS complex segment
rqfeat = abs(filtered_ecg(Q_Wave_Index)./filtered_ecg(R_Wave_Index));
[~, r_ind1] = outlier_removal(rqfeat,1);
rqfeat(r_ind1) = [];
rq1 = std(rqfeat)/mean(rqfeat);
rq2 = max(rqfeat) - min(rqfeat);
rq3 = median(rqfeat);

%% Ratio of Depth of S to Height of R (w.r.t. Q)
S_depth = filtered_ecg(Q_Wave_Index) - filtered_ecg(S_Wave_Index);
R_height = filtered_ecg(R_Wave_Index) - filtered_ecg(Q_Wave_Index);
SR_Ratio = S_depth./R_height;
SR_Ratio = SR_Ratio(~isnan(SR_Ratio) & isfinite(SR_Ratio));
SR1 = median(SR_Ratio);
SR2 = std(SR_Ratio)/mean(SR_Ratio);

%% Slope of QR / RS / SJ
% Slope of QR
slope_QR = zeros(1,length(Q_Wave_Index));
slope_RS = zeros(1,length(Q_Wave_Index));
slope_SJ = zeros(1,length(S_Wave_Index)-1);

for i = 1 : length(Q_Wave_Index)
   slope_QR(i) = (filtered_ecg(R_Wave_Index(i)) - filtered_ecg(Q_Wave_Index(i)))/(R_Wave_Index(i) - Q_Wave_Index(i));
   slope_RS(i) = (filtered_ecg(S_Wave_Index(i)) - filtered_ecg(R_Wave_Index(i)))/(S_Wave_Index(i) - R_Wave_Index(i));
end

for i = 1 : length(S_Wave_Index) - 1
    J = S_Wave_Index(i) + 15;
    slope_SJ(i) = (filtered_ecg(J) - filtered_ecg(S_Wave_Index(i)))/(J - S_Wave_Index(i));
end

slope_QR = rmmissing(slope_QR);
slope_RS = rmmissing(slope_RS);
slope_SJ = rmmissing(slope_SJ);
    
if ~isempty(slope_QR)
    slope_QR = outlier_removal(slope_QR,2);
end
if ~isempty(slope_RS)
    slope_RS = outlier_removal(slope_RS,2);
end
if ~isempty(slope_SJ)
    slope_SJ = outlier_removal(slope_SJ,2);
end

if ~isempty(slope_QR)
    median_QR = median(slope_QR);
    variance_QR = std(slope_QR)/mean(slope_QR);
else
    median_QR = 0;
    variance_QR = 0;
end

if ~isempty(slope_RS)
    median_RS = median(slope_RS);
    variance_RS = std(slope_RS)/mean(slope_RS);
else
    median_RS = 0;
    variance_RS = 0;
end

if ~isempty(slope_SJ)
    median_SJ = median(slope_SJ);
    variance_SJ = std(slope_SJ)/mean(slope_SJ);
else
    median_SJ = 0;
    variance_SJ = 0;
end

%% Corrected QT-segment related features
QT_segment = T_Wave_Index - Q_Wave_Index;
QT_segment = QT_segment(1:end-1);
sqrtRR = sqrt(RR_Interval);
cubrtRR = nthroot(RR_Interval,3);
corrected_QT_Bazett = QT_segment./sqrtRR'; % Bazett's Formula
corrected_QT_Fridericia = QT_segment./cubrtRR'; % Fridericia's Formula
corrected_QT_Sagie = QT_segment + 0.154.*(1-RR_Interval'); % Sagie's Formula

cQTB_Median = median(corrected_QT_Bazett); 
cQTB_Variance = std(corrected_QT_Bazett)/mean(corrected_QT_Bazett);
cQTF_Median = median(corrected_QT_Fridericia); 
cQTF_Variance = std(corrected_QT_Fridericia)/mean(corrected_QT_Fridericia);
cQTS_Median = median(corrected_QT_Sagie); 
cQTS_Variance = std(corrected_QT_Sagie)/mean(corrected_QT_Sagie);

ECG_SignalFeats = [rs1 rs2 rs3 med_st var_st num_neg_st deep_s inflec_dist_s tr_amp PR_ratio ...
    Q1 Q2 Q3 Q4 rq1 rq2 rq3 SR1 SR2 median_QR variance_QR median_RS variance_RS median_SJ variance_SJ ...
    cQTB_Median cQTB_Variance cQTF_Median cQTF_Variance cQTS_Median cQTS_Variance];

[Features_Physiological] = Physiological_Feats(ecg,fs,RR_Interval);

%% Final Features Extracted
Features_SD = [SoAFeats StatisticalFeats W_Entropy Hjorth_Mobility Hjorth_Complexity PDE_Features AmplitudeFeats ECG_SignalFeats HRV_Feats];
Features_Physiological;
end



function [Features_Physiological] = Physiological_Feats(ecg,fs,RR_Interval)
ecg_data=resample(ecg,250,fs);
Fs=250;
%% Peak Counts
try
    [Peak_Count] = get_fv(ecg_data,Fs); %2
    if(isempty(Peak_Count))
        Peak_Count=zeros(1,2);
    end
catch
    Peak_Count=zeros(1,2);
end

%% Cross Correlation Features Using Periodogram
try
    [xcorr_PSD_Feats] = Cross_Correlation_Feats(ecg_data,Fs); %1*10 Feature : 12
    if(isempty(xcorr_PSD_Feats))
        xcorr_PSD_Feats=zeros(1,10);
    end
catch
    xcorr_PSD_Feats=zeros(1,10);
end

%% Max and Min BPM
try
    [Max_BPM,Min_BPM] = BPM_Calc(ecg_data,Fs); %13
    if(isempty(Max_BPM))
        Max_BPM=0;
    end
    if(isempty(Min_BPM))
        Min_BPM=0;
    end
catch
    Max_BPM = 0;
    Min_BPM=0;
end

%% Signal Purity Index Max and Mean
try
    [SPI_Max_Mean]= SPI_max_mean(ecg_data,Fs); %16
    if(isempty(SPI_Max_Mean))
        SPI_Max_Mean=zeros(1,2);
    end
catch
    SPI_Max_Mean=zeros(1,2);
end

%% Signal Quality Index Features
try
    [SQI_Feats, f10,peaks1,ecg1,fs] = ECG_SqiFeatures(ecg_data,Fs); % 6 Features %25
    if(isempty(SQI_Feats))
        SQI_Feats=zeros(1,6);
    end
    if(isempty(f10))
        f10=0;
    end
catch
    SQI_Feats=zeros(1,6);
    f10=0;
end

%% Heart Rate Features
try
    [HR_Feats] = Heart_Rate_Features(length(ecg1),peaks1,length(ecg1),fs, 0);%31
    if(isempty(HR_Feats))
        HR_Feats=zeros(1,6);
    end
catch
    HR_Feats=zeros(1,6);
end

%% Final Features
Features_Physiological = [Peak_Count xcorr_PSD_Feats Max_BPM Min_BPM SPI_Max_Mean max(RR_Interval) SQI_Feats f10 HR_Feats];

end

