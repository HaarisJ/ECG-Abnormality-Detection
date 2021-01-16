function [ F ] = Frequency_Feats( ecg, fs )

%FREQUENCY_FEATURES 

% 2 second window 
    winlen = fs*2;  
    winnum = 2*floor(length(ecg)/winlen) - 1;
    window_spec = [];
    if (winnum<=2)
        F = zeros(1, 12);
    else
    
    for j = 1:winnum
        temp = ecg((j-1)*winlen/2+1:(j-1)*winlen/2+winlen);
        z = abs(fft(temp));
        z = z(1:end/2);
        pow = z.*z;
        if (j~=1)
        % frequency range 0-100, 100-200, 200-300, 300-400; 400-500 Hz
        freq_range = [100;150];
        %freq_range = [50;100;150;200;250];
        bin_range = freq_range*length(z)/fs;
        % calculate total spectral power
        PT = 1;
        % calculate normalized power in each of the 4 spetra
        b = 1:length(z);
        centroid = sum(b*z)/sum(z);
        rolloff = 0.85*sum(z);
        flux = norm(z - z_prev);
        kur = kurtosis(temp);
        
        % define the window
        winlen = length(temp);
        window_spec = [window_spec; centroid rolloff flux kur];
       
        end
        z_prev = z;
    end
    
    % mean window spec feature
    
    spec1 = mean(window_spec(:,1:end-1));
    kur1 = window_spec(:,end);
    ttt = find(isnan(kur1)==1);
    kur1(ttt) = [];
   kur_mean = mean(kur1);
   window_spec_mean = [spec1 kur_mean]; 

level = 5;
[c,l] = wavedec(ecg,level,'db4');

%a5 = appcoef(c,l,'db4');
%det5 = detcoef(c,l,level);
%det4 = detcoef(c,l,level-1);
det3 = detcoef(c,l,level-2);
%--------------------------------------------------------------------------
f7 = log2(var(det3));                                       %7
%--------------------------------------------------------------------------
% xx = downsample(ecg, 8);
% [f14, ~, f15] = Spectral(xx);                               %13 14
%--------------------------------------------------------------------------
[lp,~] = lpc(double(ecg),10);
f161821232425 = lp([2 4 7 9 10 11]);                        %16 18 21 23 24 25
%--------------------------------------------------------------------------
N = length(ecg);
xdft = fft(ecg);
% if rem(N,2) ~= 0
%     N = N - 1;
% end
xdft = xdft(1:(N/2)+1);
psdx = (1/(2*pi*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);

f = fs*(0:(N/2))/N;
frequency_centroid = (sum(f'.*(psdx.^2)))/(sum(psdx.^2));   %26

F = [window_spec_mean f7 f161821232425 frequency_centroid];
    end
