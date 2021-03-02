function filtered_data = ECG_filter(ecg, Fs)
% Define powerline interference filter
    Fs = 300;
    Fnotch = 60; % Notch Frequency
    Q = 25; % Q factor
    Apass = 1; % Bandwidth Attenuation

    Wo = Fnotch/ (Fs/2);
    BW = Wo/Q;
    [b, a] = iirnotch (Wo, BW);
    Hd1 = dfilt.df2(b, a);

    filtered_data = zeros(1,length(ecg));

    data = ecg;
    filtered_data = highpass(data, 0.5, Fs);
    filtered_data = filter(Hd1, filtered_data);
end

