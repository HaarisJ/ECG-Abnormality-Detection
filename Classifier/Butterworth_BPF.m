function [ filtered_ecg ] = Butterworth_BPF( ecg )

[b,a] = butter(1,[0.5/(300/2) 30/(300/2)]);
filtered_ecg = filtfilt(b,a,ecg);
end

