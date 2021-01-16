function [feature] = Cross_Correlation_Feats(ecg_data1,Fs)
%% Data Preparation by Normalizing then sending through bidirectional Butterworth Filter
ecg_data1 = ecg_data1 - mean(ecg_data1);
lp_ecg = Butterwoth_bidir(1,ecg_data1,Fs,2,'low');
ecg_data1 = ecg_data1 - lp_ecg;

%% Feature Extraction
[x_fv] = get_features(ecg_data1,Fs);

feature = mean(x_fv,1);

end

function [temp_fv] = get_features(ecg_data1,Fs)

k = 1;
f_lim = (((length(ecg_data1)/Fs)-4)*4);
temp_fv = zeros(floor(f_lim),10);
    if f_lim < 1
        f_lim = 1; % If String Vey Small Run for Whole Signal
    end
        
    for ind=1:1:f_lim   
        if f_lim == 1
            st = 1;
            fi =length(ecg_data1);
        else
            st = ceil(ind*(0.25*Fs))+1;
            fi = st+(4*Fs)-1;
        end
            
        ecg_block = ecg_data1(st:fi);
        % Power Spectral Density (PSD) estimate via periodogram method.    
        [p,f] = periodogram(ecg_block,[],[],Fs);
                        
        p = p/max(p);
        freq_bins = length(p)/(Fs/2); % Frequency Resolution
            
        freq_40_bins = floor(40*freq_bins);
        freq_9_bins = floor(9*freq_bins);
        xcorr_ecg = xcorr(ecg_block,'coeff');
            
        p = p(1:freq_40_bins);
        xcorr_ecg = xcorr_ecg(1:fix(length(xcorr_ecg)/2));
        [xcorr_pks,xcorr_locs] = findpeaks(xcorr_ecg,'MINPEAKDISTANCE',31);

        xcorr_pksneg = length(find(xcorr_pks < 0));
        xcorr_locsdiff = diff(xcorr_locs);
        xcorr_locsavg = mean(xcorr_locsdiff);
        
        if(isempty(xcorr_locsdiff))
            xcorr_freq = Fs/xcorr_locs;
        else
            xcorr_freq = Fs/xcorr_locsavg;
        end
        
        xcorr_locsstd = -1;
        if(length(xcorr_locsdiff) > 2)
            xcorr_locsstd = std(xcorr_locsdiff);
        end

        xcorr_pksdiff = diff(xcorr_pks);
        
        xcorr_pksstd = -1;
        if(length(xcorr_locsdiff) > 2)
            xcorr_pksstd = std(xcorr_pksdiff);
        end

        no_0_2 = findpeaks(p,'MINPEAKHEIGHT',0.2,'MINPEAKDISTANCE',2);
        area_9 = sum(p(freq_9_bins:freq_40_bins));
        area_vf = sum(p(floor(3.29*freq_bins):ceil(8.3*freq_bins)));
        [~,max_pl] = max(p);
        area_pk = sum(p(max(1,max_pl-2):min(freq_40_bins,max_pl+2)));

        temp_fv(k,1) = max_pl;
        temp_fv(k,2) = length(no_0_2);
        temp_fv(k,3) = xcorr_freq; % Sampling Freq/ peaks or amp
        temp_fv(k,4) = 10*(max(xcorr_freq,(max_pl/4.15))/min(xcorr_freq,(max_pl/4.15)));
        temp_fv(k,5) = xcorr_locsstd; % std(delta(peaks))
        temp_fv(k,6) = xcorr_pksstd; % std(amplitude(peaks))
        temp_fv(k,7) = area_9;
        temp_fv(k,8) = 10*area_vf/sum(p);
        temp_fv(k,9) = 100*(area_pk/sum(p));
        temp_fv(k,10) = xcorr_pksneg;


        k=k+1;

    end

end
