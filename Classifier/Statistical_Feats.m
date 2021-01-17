function [features3] = Statistical_Feats(data1,Fs,FeatureIndices)

% Z-normalize the data first
data = zscore(data1);

% QRS detection
[qrs] = qrs_detect2(data(:),0.25,0.6,Fs);

ecg=data1;
ecg1 = Butterworth_LPF(ecg,2,10,Fs);
ecg1 = Butterworth_HPF(ecg1,2,0.5,Fs);
ecg=zscore(ecg1(:));
%% FFT Coeffs%%
[FFTCoefficients,f] = FFT_Coefficients(ecg,Fs);

%% %%%%Features%%%%%% %%
features3=[];
%% Trimmed mean%%%
if(ismember(1,FeatureIndices))
    trimmed_mean = trimmean(FFTCoefficients,10); %1
    features3=[features3 trimmed_mean];
end

%% skewness of the PCG FFT Coefficient%%%%%%
if(ismember(2,FeatureIndices))
    ECGskewness = skewness(FFTCoefficients); %2
    features3=[features3 ECGskewness];
end

%% Compute 80% energy containing band%%%
if(ismember(3,FeatureIndices))
        
    TotalEnergy80 = 0.8*(sum(FFTCoefficients.^2));
    CumsumTotEnergy = cumsum(FFTCoefficients.^2);
    indx = find(CumsumTotEnergy>TotalEnergy80);
    Freq80Percent =f(min(indx));
    clear TotalEnergy80 CumsumTotEnergy indx
    
    features3=[features3 Freq80Percent];
end

%% Kurtosis of frequency coefficients%%%
if(ismember(4,FeatureIndices))
    i1 = find(f<0.5,1,'last');
    i2 = find(f>5,1,'first');
    KurtosisFreqDom = kurtosis(FFTCoefficients(i1:i2)); %4
    features3=[features3 KurtosisFreqDom];
end

%% Kurtosis of time series data%%%
if(ismember(5,FeatureIndices))
    KurtosisTimeDom = kurtosis(ecg); %5
    features3=[features3 KurtosisTimeDom];
end
%% Hjorth parameters%
if(ismember(6,FeatureIndices))
    [~, ~, COMPLEXITY] = hjorth_cp(ecg); %6
    features3=[features3 COMPLEXITY];
end

%% SNR %%
if(ismember(7,FeatureIndices))
    Noise = snr(ecg,Fs);
    features3=[features3 Noise];
end
%% Total Harmonic Distortion (THD)
if(ismember(8,FeatureIndices))
    TDH = thd(ecg); %8
    features3=[features3 TDH];
end

%% Zero Crossing Rate (ZCR)
if(ismember(9,FeatureIndices))
    vect1 = ecg(1:end-1);
    vect2 = ecg(2:end);
    vect = vect1.*vect2;
    VectInd = find(vect<0);
    ZCR = length(VectInd)/(length(ecg)-1); %9
    features3=[features3 ZCR];
end

FrameSize = 2*Fs;
DataTrimmed = ecg(1:floor(length(ecg)/FrameSize)*FrameSize);
%% Short time energy
if(ismember(10,FeatureIndices))
    if (floor(length(ecg)/FrameSize)>1)
        Er = zeros(1,floor(length(ecg)/FrameSize));
        for Count = 1:floor(length(ecg)/FrameSize)
            Er(Count) = sum(DataTrimmed(FrameSize*(Count -1)+1:FrameSize*Count).^2)/FrameSize;
        end
        Er = mean(Er); %10
        features3=[features3 Er];
    else
        Er = sum(DataTrimmed.^2)/FrameSize;
        Er = mean(Er); %10
        features3=[features3 Er];
    end
end

%% Spectral Centriod
if(ismember(11,FeatureIndices))
    if (floor(length(ecg)/FrameSize)>1)
        for Count = 1:floor(length(ecg)/FrameSize)
            clippedData = DataTrimmed(FrameSize*(Count-1)+1:FrameSize*Count);
            [Coeff_CD,f_CD] = FFT_Coefficients(clippedData,1000);
            Cr(Count) = sum(Coeff_CD.*f_CD')/sum(abs(Coeff_CD));
        end
        Cr = mean(Cr); %11
        features3=[features3 Cr];
    else
        Count = 1;
        clippedData = DataTrimmed;
        [Coeff_CD,f_CD] = FFT_Coefficients(clippedData,1000);
        Cr(Count) = sum(Coeff_CD.*f_CD')/sum(abs(Coeff_CD));
        Cr = mean(Cr); %11
        features3=[features3 Cr];
    end
end

%% Spectral roll off
if(ismember(12,FeatureIndices))
    if (floor(length(ecg)/FrameSize)>1)
        for Count = 1:floor(length(ecg)/FrameSize)
            clippedData = DataTrimmed(FrameSize*(Count-1)+1:FrameSize*Count);
            [Coeff_CD,~] = FFT_Coefficients(clippedData,1000);
            Energy85P = 0.85*sum(abs(Coeff_CD));
            CumSumCoeff = cumsum(Coeff_CD);
            RrIndex = find(CumSumCoeff>Energy85P);
            RrInd(Count) = min(RrIndex);
        end
        Rr = mean(RrInd); %12
        features3=[features3 Rr];
    else
        Count = 1;
        clippedData = DataTrimmed;
        [Coeff_CD,~] = FFT_Coefficients(clippedData,1000);
        Energy85P = 0.85*sum(abs(Coeff_CD));
        CumSumCoeff = cumsum(Coeff_CD);
        RrIndex = find(CumSumCoeff>Energy85P);
        RrInd(Count) = min(RrIndex);
        Rr = mean(RrInd); %12
        features3=[features3 Rr];
    end
end

%% Spectral flux
if(ismember(13,FeatureIndices))
    if (floor(length(ecg)/FrameSize)>1)
        for Count = 1:floor(length(ecg)/FrameSize)-1
            clippedData = DataTrimmed(FrameSize*(Count-1)+1:FrameSize*Count);
            clippedDataNext = DataTrimmed(FrameSize*(Count)+1:FrameSize*(Count+1));
            [Coeff_CD,~] = FFT_Coefficients(clippedData,1000);
            [Coeff_CDNext,~] = FFT_Coefficients(clippedDataNext,1000);
            Fr(Count) = sum((Coeff_CDNext - Coeff_CD).^2);
        end
        Fr = mean(Fr); %13
        features3=[features3 Fr];
    else
        Count = 1;
        clippedData = DataTrimmed;
        clippedDataNext = DataTrimmed;
        [Coeff_CD,~] = FFT_Coefficients(clippedData,1000);
        [Coeff_CDNext,~] = FFT_Coefficients(clippedDataNext,1000);
        Fr(Count) = sum((Coeff_CDNext - Coeff_CD).^2);
        Fr = mean(Fr); %13
        features3=[features3 Fr];
    end
end
%% TIme Domain pattern based
here = pattern_time_feat(ecg,Fs);
if(ismember(14,FeatureIndices))%14
    features3=[features3 here(1)];
end

if(ismember(15,FeatureIndices))%15
    features3=[features3 here(2)];
end

if(ismember(16,FeatureIndices))
    [~,ind1] = sort(FFTCoefficients,'descend');
    features3 =[features3 f(ind1(1))];
end

if(ismember(17,FeatureIndices))
    [~,ind1] = sort(FFTCoefficients,'descend');
    features3 =[features3 f(ind1(2))-f(ind1(1))];
end

if(ismember(18,FeatureIndices)||ismember(19,FeatureIndices))
    if(length(qrs)>=5)
        hr = diff(qrs);
        hr_s = 60*Fs./hr;
        imf = emd(hr_s);
        fimf = imf(1,:)';
        signum = sign(fimf);	% get sign of data
        signum(fimf==0) = 1;	% set sign of exact data zeros to positiv
        idss=find(diff(signum)~=0);	% get zero crossings by diff ~= 0
        feat18=numel(idss)/numel(fimf);
        feat19 = std(fimf);
    else
        feat18=1;
        feat19=100;
    end
    
    if(ismember(18,FeatureIndices))
        features3=[features3 feat18];
    end
    if(ismember(19,FeatureIndices))
        features3=[features3 feat19];
    end
end

if(ismember(20,FeatureIndices)||ismember(21,FeatureIndices)||ismember(22,FeatureIndices)||ismember(23,FeatureIndices))
    if(length(qrs)>=5)
        hr = diff(qrs);
        hr_s = 60*Fs./hr;
        delta_hr_s =abs(diff(hr_s));
        % feat 20
        feat20 = median(delta_hr_s)^2;
        %--------------------------
        majority = 0.55;
        bt_0_10 = numel(intersect(find(delta_hr_s>=0),find(delta_hr_s<10)));
        bt_10_30 = numel(intersect(find(delta_hr_s>=10),find(delta_hr_s<30)));
        bt_30_inf = numel(find(delta_hr_s>=30));
        
        tritle = [bt_0_10 bt_10_30 bt_30_inf]./numel(delta_hr_s);
        [~,id] = max(tritle);%find(tritle>majority);
        % feat 21
        feat21 = 5*(2*id-1);
        %--------------------------
        mdn = median(delta_hr_s);
        num = ceil(0.4*numel(delta_hr_s));
        
        [val,idxs] = sort(delta_hr_s);
        mdn_left_idxs = idxs(find(val<=mdn,num,'last'));
        mdn_right_idxs = idxs(find(val>=mdn,num,'first'));
        % feat 22
        feat22 = sum((mdn - val(mdn_right_idxs)).^2);
        %----------------------------
        bd = sort([mdn_left_idxs(:);mdn_right_idxs(:)]);
        severity = [bd bd+2];
        s_idx = [];
        for jter=1:size(severity,1)
            s_idx = [s_idx [qrs(severity(jter,1)):qrs(severity(jter,2))]];
        end
        %         plot(data);hold all;plot(s_idx,data(s_idx),'.r');
        %         keyboard;
        [Coeffnew,fnew] = FFT_Coefficients(data(s_idx),Fs);
        [~,ind1] = sort(Coeffnew,'descend');
        feat23=fnew(ind1(1));
        
    else
        feat20=10000;
        feat21=1000;
        feat22=100000;
        feat23=10000;
    end
    
    if(ismember(20,FeatureIndices))
        features3=[features3 feat20];
    end
    if(ismember(21,FeatureIndices))
        features3=[features3 feat21];
    end
    if(ismember(22,FeatureIndices))
        features3=[features3 feat22];
    end
    if(ismember(23,FeatureIndices))
        features3=[features3 feat23];
    end
end
if(ismember(24,FeatureIndices)||ismember(25,FeatureIndices)||ismember(26,FeatureIndices)||ismember(27,FeatureIndices))
    [Pf] = Spectralbased(data,Fs);
    feat24=Pf(1);
    feat25=Pf(2);
    feat26=Pf(3);
    feat27=Pf(4);
    
    if(ismember(24,FeatureIndices))
        features3=[features3 feat24];
    end
    if(ismember(25,FeatureIndices))
        features3=[features3 feat25];
    end
    if(ismember(26,FeatureIndices))
        features3=[features3 feat26];
    end
    if(ismember(27,FeatureIndices))
        features3=[features3 feat27];
    end
end

