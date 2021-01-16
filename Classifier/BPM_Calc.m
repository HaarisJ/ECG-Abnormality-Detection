function [Max_BPM,Min_BPM] = BPM_Calc(ecg_data_f,Fs)

%Vignesh Kalidas 
%PhD - Computer Engineering, 
%Dept of Electrical Engineering, 
%University of Texas at Dallas, Texas, USA
% GNU General public License
%

    ecg_data1 =ecg_data_f - mean(ecg_data_f);

    [Max_BPM,~,Min_BPM,~] = BPM_Feat_Calc(ecg_data1,Fs);

end

function [maxBPM,ecg_locs_max,minBPM,ecg_locs_min] = BPM_Feat_Calc(ecg_data1,Fs)

lp_ecg = Butterwoth_bidir(1,ecg_data1,Fs,2,'low');
ecg_data1 = ecg_data1 - lp_ecg;
[ecg_locs_max] = get_rpeaks(ecg_data1,Fs,1);

l=1;
% Limiting max to 16 R peaks and min to 4 R Peaks
% reduce either as necessary

    if(length(ecg_locs_max) >= 17)
        ecgloc_max = 16;
    elseif(length(ecg_locs_max) >= 11)
        ecgloc_max = 10;
    else
        ecgloc_max = 1; % Very small length signal
    end
    
    if(length(ecg_locs_min) >= 5)
        ecgloc_min = 4;
    elseif(length(ecg_locs_min) >= 3)
        ecgloc_min = 2;
    else
        ecgloc_min = 1; % For Very Small Length Signal
    end
        
    for i=1:1:length(ecg_locs_max)-ecgloc_max
        ecg_beats = ecg_locs_max(i:i+ecgloc_max);
        diff_locs = diff(ecg_beats); % difference between R peaks : RR_int
        mean_locs = mean(diff_locs); % mean value of RR interval
        ebpmmax_17 = 60*Fs/mean_locs; % Estimated Beats per Minute
        l=l+1;     
    end
    
    for i=1:1:length(ecg_locs_min)-ecgloc_min
        ecg_beats = ecg_locs_min(i:i+ecgloc_min); 
        diff_locs = diff(ecg_beats); % difference between R peaks : RR_int
        mean_locs = mean(diff_locs); % mean value of RR interval
        ebpmmin_5 = 60*Fs/mean_locs; % Estimated Beats per Minute
        l=l+1;
    end

maxBPM = [max(ebpmmax_17)];
minBPM = [min_ebpm1];
end
