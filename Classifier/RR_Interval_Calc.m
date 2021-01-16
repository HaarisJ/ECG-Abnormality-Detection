function[RR_Interval]= RR_Interval_Calc(signal_curr,Fs)
% Sibylle Fallet
% Sasan Yazdani
% Jean-Marc Vesin
% GNU GEneral public License

signal_curr=signal_curr-mean(signal_curr);
ecg1=signal_curr/max(signal_curr);
R_inds=F2AMM3(ecg1,Fs,1,1);
RR1=max(diff(R_inds)/Fs);


RR_Interval =RR1;

if isempty(RR_Interval)
    RR_Interval = 0;
end

end