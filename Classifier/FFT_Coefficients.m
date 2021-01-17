function [FFTCoeff ,f]  = FFT_Coefficients(data,fs)

Length = length(data);
Y = fft(data);
Coeffs = abs(Y/Length);

FFTCoeff = Coeffs(1:floor(Length/2)+1);
f = fs*(0:floor(Length/2))/Length;
end