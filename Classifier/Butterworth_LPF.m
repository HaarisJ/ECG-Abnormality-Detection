% function low_pass_filtered_signal = butterworth_low_pass_filter(original_signal,order,cutoff,sampling_frequency)
%
% Low-pass filter a given signal using a forward-backward, zero-phase
% butterworth low-pass filter.
%
%% INPUTS:
% original_signal: The 1D signal to be filtered
% order: The order of the filter (1,2,3,4 etc). NOTE: This order is
% effectively doubled as this function uses a forward-backward filter that
% ensures zero phase distortion
% cutoff: The frequency cutoff for the low-pass filter (in Hz)
% sampling_frequency: The sampling frequency of the signal being filtered
% (in Hz).
% figures (optional): boolean variable dictating the display of figures
%
%% OUTPUTS:
% low_pass_filtered_signal: the low-pass filtered signal.

function low_pass_filtered_signal = Butterworth_LPF(original_signal,order,cutoff,sampling_frequency)

%Get the butterworth filter coefficients
[B_low,A_low] = butter(order,2*cutoff/sampling_frequency,'low');
low_pass_filtered_signal = filtfilt(B_low,A_low,original_signal);

end
