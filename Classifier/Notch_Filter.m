function filtered_data = Notch_Filter(ecg, fs)
% Define powerline interference filter
    Fnotch = 60; % Notch Frequency
    Q = 25; % Q factor
    Apass = 1; % Bandwidth Attenuation

    Wo = Fnotch/ (fs/2);
    BW = Wo/Q;
    [b, a] = iirnotch (Wo, BW);
    Hd1 = dfilt.df2(b, a);

    filtered_data = zeros(1,length(ecg));

    data = ecg;
    filtered_data = highpass(data, 0.5, fs);
    filtered_data = filter(Hd1, filtered_data);
end

