%
function [Pf] = Spectralbased(ecg,Fs)
% Morteza Zabihi
% GNU General Public License
% fb1 =  [0 5];
% fb2 =  [5 10];
% fb3 =  [10 15];
% fb4 =  [20 50];
% fb5 =  [50 150];
fb1 =  [0 2];
fb2 =  [2 4];
fb3 =  [4 10];
fb4 =  [10 150];
%%
 [PSD,F] = pwelch(ecg,Fs,Fs/2,Fs,Fs);
%------------------  find the indexes corresponding bands ------------------ 
ifb1 = (F>=fb1(1)) & (F<fb1(2));
ifb2 = (F>=fb2(1)) & (F<fb2(2));
ifb3 = (F>=fb3(1)) & (F<fb3(2));
ifb4 = (F>=fb4(1)) & (F<fb4(2));
% ifb5 = (F>=fb5(1)) & (F<fb5(2));
%------------------  calculate areas, within the freq bands (ms^2) ------------------ 
Ifb1 = trapz(F(ifb1),PSD(ifb1));
Ifb2 = trapz(F(ifb2),PSD(ifb2));
Ifb3 = trapz(F(ifb3),PSD(ifb3));
Ifb4 = trapz(F(ifb4),PSD(ifb4));
% Ifb5 = trapz(F(ifb5),PSD(ifb5));

aTotal = Ifb1^2+Ifb2^2+Ifb3^2+Ifb4^2;%+Ifb5^2;
%------------------ calculate areas relative to the total area (%) ------------------ 
Pfb1 =(Ifb1^2/aTotal)*100;
Pfb2 =(Ifb2^2/aTotal)*100;
Pfb3 =(Ifb3^2/aTotal)*100;
Pfb4 =(Ifb4^2/aTotal)*100;
% Pfb5 =(Ifb5^2/aTotal)*100;

Pf = [Pfb1 Pfb2 Pfb3 Pfb4];% Pfb5];

