function [features] = TimeDomainHRV_Features(ecg, fs, qrs)

RR = diff(qrs')/fs;

if length(qrs) < 6
    features = zeros(1,8);
    return
end

mean_RR = mean(RR); 
mad_RR = mad(RR); % median absolute deviation of RR
RMSSD = sqrt(mean(diff(RR).^2));% root mean square of successive differences
nRMSSD = RMSSD/mean_RR; % normalized RMS of successive differences

%PSD 
PSD_Distribution = PSD_Welch(qrs, 2, length(ecg), fs);

features = [nRMSSD mad_RR PSD_Distribution];
end

function [ hrv ] = PSD_Welch( m, Fs, len,fs )
% upsampling to 2 Hz sampling rate

    tt = m(2:end);
    nn = diff(m)/fs;
    
    nn = nn - mean(nn);
    T = 0:0.5:len;
    yy = spline(tt, nn, T.'); %Cubic spline data interpolation
    
    % Power Spectral Density estimate via Welch's method of the periodogram of
    % ECG upsampled at 2x fs
    % 256 windows with 50% overlap. 
    % Total of 512 DFT points sampled at 2 Hz 
    [z, ~] = pwelch(yy, 256, 128, 512, Fs);
    
    bin = [11 40 129];
    
    pt = sum(z);
    
    p1 = sum(z(1:bin(1)))/pt;
    p2 = sum(z(bin(1):bin(2)))/pt;
    p3 = sum(z(bin(2):bin(3)))/pt;
    hrv = [p1 p2 p3 p1/p2 p1/p3 p2/p3]; 
end