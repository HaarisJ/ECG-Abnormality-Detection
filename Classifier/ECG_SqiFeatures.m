function [sqi_features,num_diff_peaks,peaks1,ecg1,Fs] = ECG_SqiFeatures(ecg1,Fs)
% Linda M. Eerikäinen (1), Joaquin Vanschoren (2), Michael J. Rooijakkers (1), Rik Vullings (1), Ronald M. Aarts (1)(3)
% 
% (1) Department of Electrical Engineering, Eindhoven University of Technology
% (2) Department of Mathematics and Computer Science, Eindhoven University of Technology
% (3) Department of Personal Health Solutions, Philips Research, Eindhoven
% GNU GENERAL PUBLIC LICENSE

% Compute 7 signal quality features for ECG in a specified window. 
%
%   [sqi_features, peaks1, matches] = ecgSqiFeatures(ecg1, ecg2, Fs, window)
%
% Inputs:
%       ecg1: ECG signal from one lead
%       ecg2: ECG signal from another lead
%       Fs: sampling frequency of the signals
%       window: window in seconds in which the quality features are
%               computed
%
% Outputs:
%   sqi_features: a vector containing
%                   1: median local noise level
%                   2: ratio of detected beats from the other ECG lead
%                   3: pcaSQI
%                   4: ratio of power in the QRS complex (~5-15 Hz)
%                   5: ratio of power in the baseline (~0-1 Hz)
%                   6: kurtosis
%                   6: skewness
%   peaks1: R-peak locations from the first ECG lead
%   matches: locations of R-peaks detected in both leads
% 
% Written by: Linda Eerikäinen, 3 August, 2015

if Fs~=125
    ecg1=resample(ecg1,125,Fs);
    Fs=125;
end

sqi_features = zeros(1,6);

segment_beginning =1;
segment_end = length(ecg1);


% Detect R-peaks and compute local noise level
out1 = streamingpeakdetection([ecg1; ecg1(1:end)]', Fs);
peaks1 = out1.peakPositionArray(out1.peakPositionArray <= segment_end);
snr = out1.SNR;

% out2 = streamingpeakdetection([ecg2; ecg2(end-500+1:end)]', Fs);
% peaks2 = out2.peakPositionArray(out2.peakPositionArray <= segment_end);

% Find peaks that are detected in both ECG leads
% matches = beatMatch(peaks1, peaks2, Fs);

% Compute the median local noise level in the segment
if isempty(peaks1)
    snr_median = 0;
else
snr_median = median(snr(peaks1 >= segment_beginning & peaks1 <= segment_end));
end
peaks_in_segment = peaks1 >= segment_beginning & peaks1 <= segment_end-Fs*0.1;
peak_positions_in_segment = peaks1(peaks_in_segment);
numPeaks = numel(peak_positions_in_segment);

% if numPeaks > 0
%     matchRatio = nnz(matches(peaks_in_segment))/numPeaks;
% else
%     matchRatio = 0;
% end

% If there are more peaks in the segment, align peaks and compute principal
% component analysis
if numPeaks > 2
    % Correct peak positions to be aligned according to the maximum
    for i = 1:numPeaks
        [~,idx] = max(ecg1(peak_positions_in_segment(i)-3:peak_positions_in_segment(i)+3));
        peak_positions_in_segment(i) = peak_positions_in_segment(i)+idx-4;
    end
    if peak_positions_in_segment(end) >= segment_end-floor(Fs*0.1)
        peak_positions_in_segment(end) = [];
        numPeaks = numPeaks-1;
    end
    
    dataMatrix = zeros(numPeaks,2*Fs*0.1);
    for i = 1:numPeaks
        dataMatrix(i,:) = ecg1(peak_positions_in_segment(i)-floor(Fs*0.1): ...
            peak_positions_in_segment(i)+floor(Fs*0.1));
    end
    
    [~,~,eigenvalues]= pca(dataMatrix);
    % The ratio of sum of the 5 largest eigenvalues and sum of all
    % eigenvalues
    if length(eigenvalues) < 5
          pca_sqi = sum(eigenvalues(1))/sum(eigenvalues);
    else
    pca_sqi = sum(eigenvalues(1:5))/sum(eigenvalues);
    end
else
    pca_sqi = 0;
end

% Spectral features
[pxx,fx] = pwelch(ecg1(segment_beginning:segment_end), [], [], [],Fs);
f_start_5 = find(fx <= 5, 1, 'last');
f_end_1 = find(fx >= 1, 1, 'first');
f_end_qrs = find(fx <= 15, 1, 'last');
f_end_40 = find(fx >= 40, 1, 'first');
p_sqi = trapz(fx(f_start_5:f_end_qrs),pxx(f_start_5:f_end_qrs))/ ...
    trapz(fx(f_start_5:f_end_40),pxx(f_start_5:f_end_40));
bas_sqi = trapz(fx(1:f_end_1),pxx(1:f_end_1))/ ...
    trapz(fx(1:f_end_40),pxx(1:f_end_40));

% Statistical quality measures
k_sqi = kurtosis(ecg1(segment_beginning:segment_end));
s_sqi = skewness(ecg1(segment_beginning:segment_end));

sqi_features(1) = snr_median;
% sqi_features(2) = matchRatio;
sqi_features(2) = pca_sqi;
sqi_features(3) = p_sqi;
sqi_features(4) = bas_sqi;
sqi_features(5) = k_sqi;
sqi_features(6) = s_sqi;

%% Special Feature 
   [diffPeaks, checkMatrix] = differentBeatDetection(ecg1, Fs);
    checkSum = sum(checkMatrix,2);
    diffPeaks = diffPeaks(checkSum >= 2);
    n_diff_peaks =intersect(find(diffPeaks>=segment_beginning),find(diffPeaks<=segment_end));
    num_diff_peaks = length(n_diff_peaks);


end

