function [out, loc1] = Pwave( ecg, fs )

loc = [];
[QRS] = qrs_detect3(ecg',0.25,0.6,fs);
amplitude = ecg(QRS);

% Invert if the ECG is flipped about the x-axis
if mean(amplitude) < 0 && median(amplitude) < 0
    ecg = -ecg;
    [QRS] = qrs_detect3(ecg',0.25,0.6,fs);
end

[b,a] = butter(1,15/fs,'low');
ecg1 = filtfilt(b,a,ecg);

[~,ind1] = Extrema_Identification(ecg1);


for i = 1 : length(QRS)-1
    temp_ind = intersect(find(ind1>QRS(i)),find(ind1<QRS(i+1)));
    temp_ind = ind1(temp_ind);
    dist = QRS(i+1)-QRS(i);
    reoveind = intersect(temp_ind,QRS(i):QRS(i)+round(0.7*dist));
    reoveind = union(reoveind,intersect(temp_ind,QRS(i)+round(0.95*dist):QRS(i+1)));
    for j = 1 :  length(reoveind)
        temp_ind(find(temp_ind==reoveind(j))) = [];
    end
    if ~isempty(temp_ind)
        temp_ind = temp_ind(end);
    end
    loc = [loc temp_ind];
    temp_ind = [];
end


out = length(loc)/length(QRS);
loc1 = loc;
end

