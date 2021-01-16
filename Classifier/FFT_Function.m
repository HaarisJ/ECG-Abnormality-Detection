
function [FFTCoeff ,f]  = FFT_Function(data,fs)

% 
% Copyright (C) 2017 
% Shreyasi Datta
% Chetanya Puri
% Ayan Mukherjee
% Rohan Banerjee
% Anirban Dutta Choudhury
% Arijit Ukil
% Soma Bandyopadhyay
% Rituraj Singh
% Arpan Pal
% Sundeep Khandelwal
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

Fs = fs;            % Sampling frequency
L = length(data);     % Length of signal
Y = fft(data);
P2 = abs(Y/L);

FFTCoeff = P2(1:floor(L/2)+1);
f = Fs*(0:floor(L/2))/L;
% plot(f,FFTCoeff)
% title('Single-Sided Amplitude Spectrum of PCG data')
% xlabel('f (Hz)')
% ylabel('|AMP(f)|')