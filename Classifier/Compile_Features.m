function all_features = Compile_Features(ecg, fs)
% function all_features = Compile_Features(recordName)

%
% Sample entry for the 2017 PhysioNet/CinC Challenge.
%
% INPUTS:
% recordName: string specifying the record name to process
%
% OUTPUTS:
% classifyResult: integer value where
%                     N = normal rhythm
%                     A = AF
%                     O = other rhythm
%                     ~ = noisy recording (poor signal quality)
%
% classifyResult = 'N'; % default output normal rhythm
% read the filename
% May need to suppress warnings
warning('off','all')
% [tm,ecg,fs,siginfo]=rdmat(recordName);

% if length of ecg is under 400 - cant execute this function 
if length(ecg) < 400
    return
end

% Cancel noise and get clean ECG
raw_ecg = ecg;
[ ecg ] = ECG_CancelNoise( ecg, fs );

% Compute the ECG points
[P_Wave_Index, Q_Wave_Index, R_Wave_Index, S_Wave_Index, T_Wave_Index] = ECG_Point_Extract( ecg, fs );

% ECG features
[Features_SD, Features_Physiological] = ECG_Feature_Extraction(ecg, fs, P_Wave_Index, Q_Wave_Index, R_Wave_Index, S_Wave_Index, T_Wave_Index);
if length(Features_SD) == 1
    Features_SD = zeros(1,68);
end
Features_Freq = STR_Entropy_Features(ecg);
Features_Freq = [Features_Freq Frequency_Feats(ecg, fs)];
Features_ADC = pr( R_Wave_Index, P_Wave_Index);
feat_ind = 1:27;
Features_statistical = Statistical_Feats(raw_ecg, fs, feat_ind);
Features_soa = TimeDomainHRV_Features(ecg, fs, R_Wave_Index);
features_HRV = Heart_Rate_Variability_Features(ecg, fs, R_Wave_Index); 

all_features = [Features_SD Features_Freq Features_ADC Features_soa Features_statistical features_HRV Features_Physiological];

% Need to add NaN and Inf handling
load MeanVector_208
MeanVect = MeanVector_208;
replaceFeat = union(find(isnan(all_features)),find(isinf(abs(all_features))));
all_features(replaceFeat) = MeanVect(replaceFeat);


end

