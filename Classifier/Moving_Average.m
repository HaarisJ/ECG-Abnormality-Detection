function [average, stdev] = Moving_Average(x,M)
% Sibylle Fallet
% Sasan Yazdani
% Jean-Marc Vesin
% GNU GEneral public License

% Moving average using a centered window (mirror conditions at extremities)
% Inputs:
% - M: window length (should be odd)
% Outputs:
% - average and standard deviation

L = round((M-1)/2);
x = x(:);
z = [flipud(x(1:M)) ; x ; flipud(x(end-M+1:end))];

average = zeros(length(z),1);
stdev = zeros(length(z),1);

K = length(z);
for k=L+1:K-(L+1)
   average(k) = mean(z(k-L:k+L));
   stdev(k) = std(z(k-L:k+L));
end

average = average(M+1:end-M);
stdev = stdev(M+1:end-M);

              
end

