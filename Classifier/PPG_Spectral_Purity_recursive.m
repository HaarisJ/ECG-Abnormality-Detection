function [SPI, SPI_smooth, H1] = PPG_Spectral_Purity_recursive(PPG,fs,Aff,L)
% [SPI, SPI_smooth, H1] = PPG_Spectral_Purity_recursive(PPG,fs,Aff,L)
% Compute spectral purity index (p. 102, Sornmo Bioelectrical Signal
% Processing), described by Barlow 
% Time-domain estimates, using estimations of 1st and 2nd derivative of the
% signal% Sibylle Fallet
% Sasan Yazdani
% Jean-Marc Vesin
% GNU GEneral public License

if(nargin < 4)
L = 30;
end

%% Miror
% disp(size(PPG));

PPG = [flipud(PPG(1:end,:)); PPG];


%% Using sliding window of size L

K = size(PPG,2);

SPI = zeros(size(PPG)); 
SPI_smooth = zeros(size(PPG));

H1 = zeros(size(PPG)); 

d1 = zeros(size(PPG)); 
d2 = zeros(size(PPG));

w0 = zeros(size(PPG)); 
w2 = zeros(size(PPG)); 
w4 = zeros(size(PPG));

alpha = 0.8;

for n=L+1:length(PPG(:,1))-1    
    for j=1:K % For each column of the input data matrix
    
    d1(n,j) = PPG(n,j)-PPG(n-1,j);
    d2(n,j) = PPG(n+1,j) -2*PPG(n,j) + PPG(n-1,j);
    
    % zero-, second-, and fourth-order moments
    w0(n,j) = (2*pi/L)* sum(PPG(n-L+1:n,j).^2);
    w2(n,j) = (2*pi/L)* sum(d1(n-L+1:n,j).^2);
    w4(n,j) = (2*pi/L)* sum(d2(n-L+1:n,j).^2);
    
    SPI(n,j) = w2(n,j)^2/(w0(n,j)*w4(n,j));
    
    SPI_smooth(n,j) = alpha*(SPI_smooth(n-1,j))+ (1-alpha)*SPI(n,j);
    
      H1(n,j) = sqrt(w2(n,j)/w0(n,j));  
    end
end


%% On le racccourci
PPG = PPG((L+2):end,:);
SPI = SPI((L+2):end,:);
SPI_smooth = SPI_smooth((L+2):end,:);
H1 = H1((L+2):end,:);
% disp(size(PPG));

% ----------------------------
if(Aff ==1)
% axe1(1) = subplot(211);
% plot((1:length(PPG(:,1)))/fs,PPG); title('PPG'); grid on;
% ylabel('[A.U.]');
% axe1(2) = subplot(212);
% plot((1:length(SPI_smooth(:,1)))/fs,SPI_smooth); grid on; title('Signal Purity Indices');
% set(gca,'YLim',[0 1]);
% xlabel('Time [sec]');
% linkaxes(axe1,'x');

% LEGEND FOR ECG
axe1(1) = subplot(211);
plot((1:length(PPG(:,1)))/fs,PPG); title('Smoothed ECG'); grid on;
ylabel('[A.U.]');
axe1(2) = subplot(212);
plot((1:length(SPI_smooth(:,1)))/fs,SPI_smooth); grid on; title('Signal Purity Indices');
set(gca,'YLim',[0 1]);
xlabel('Time [sec]');
linkaxes(axe1,'x');



end

% linkaxes(axe1,'x');
