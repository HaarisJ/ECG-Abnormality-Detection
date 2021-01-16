function [y,h,w] = Butterwoth_bidir(cF,x,Fs,fil_order,fil_type)
%Vignesh Kalidas 
%PhD - Computer Engineering, 
%Dept of Electrical Engineering, 
%University of Texas at Dallas, Texas, USA
% GNU General public License
F_nyquist = Fs/2;
cF_norm = cF./F_nyquist;
   
[b,a] = butter(fil_order,cF_norm,fil_type);

x1 = filter(b,a,x);
x2 = fliplr(x1);
x3 = filter(b,a,x2);
y = fliplr(x3);

[h1,w1] = freqz(b,a,2000);

h = 20*log10(abs(h1));
w = w1/pi;