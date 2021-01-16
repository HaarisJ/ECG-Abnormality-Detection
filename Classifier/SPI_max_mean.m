function[FEATURES]= SPI_max_mean(ECG,Fs)
% Sibylle Fallet
% Sasan Yazdani
% Jean-Marc Vesin
% GNU GEneral public License

%% Data cleaning and preparation
fs2 = 35; % Waveforms are resampled at 15 Hz prior to adaptive frequency tracking
Cuttoff=40; Wp=(Cuttoff/Fs)*2; % Cuttoff frequency to filter ECG
b=fir1(100,Wp); a=1;
ECG(:,1) = filtfilt(b,a,ECG(:,1));
ECG = zscore(ECG);
ECG = resample(ECG,fs2,Fs);
[trans1, ~] = Moving_Average(ECG(:,1),5);
[~, SPI_smooth, ~] = PPG_Spectral_Purity_recursive([trans1(:)],fs2,0,2*fs2);

L=3; 
j=1;
count_max=1;
%% Compute mean and max SPI on L sec windows
SpectralPurity_stat=zeros(length(SPI_smooth),1);
while(count_max < length(SPI_smooth))
    strt = (5*fs2)+((j-1)*fs2);
    st_end = (5*fs2)+((j-1)*fs2)+(L*fs2);
    if (length(SPI_smooth) < st_end)  && (j == 1)% For Small Length SIgnal
        strt = 1 ; st_end = length(SPI_smooth);
        SpectralPurity_stat(j,1) = mean(SPI_smooth(strt:st_end,1));
        SpectralPurity_stat(j,2) = max(SPI_smooth( strt:st_end,1));
        break;
    else
        SpectralPurity_stat(j,1) = mean(SPI_smooth(strt:st_end,1));
        SpectralPurity_stat(j,2) = max(SPI_smooth( strt:st_end,1));
    end
    j = j+1;
    count_max = (5*fs2)+((j-1)*fs2)+(L*fs2);
end


FEATURES(1) = max(SpectralPurity_stat(:,1));
FEATURES(2) = max(SpectralPurity_stat(:,2));

end