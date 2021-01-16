function [P_Wave_Index, Q_Wave_Index, R_Wave_Index, S_Wave_Index, T_Wave_Index] = ECG_Point_Extract(ecg, fs)

%Pre-allocate space for each index required - at the end of function remove any 0
%values that still remain - performance optimization
Q_Wave_Index = zeros(1,90);
S_Wave_Index = zeros(1,90);
T_Wave_Index = zeros(1,90);
Min_Diff = zeros(1,90);
Max_Diff = zeros(1,90); 

R_Wave_Index = qrs_detect3(ecg',0.25,0.6,fs);

%% P wave detection
[~, P_Wave_Index] = Pwave( ecg, fs );

%% Invert ECG if necessary
amp = ecg(R_Wave_Index);
if mean(amp) < 0 && median(amp) < 0
    ecg = -ecg;
end

%% P, Q, S, T Detection
ecg_f = Butterworth_BPF( ecg );

% Detect Q and S and T waves
for i = 1 : length(R_Wave_Index)
    
    % S and T detection
    if i == length(R_Wave_Index)
        temp = ecg_f(R_Wave_Index(i)+1:length(ecg_f));
        [~,SMax,~,SMin] = Extrema_Identification(temp);
        SMax = SMax + R_Wave_Index(i);
        SMin = SMin + R_Wave_Index(i);
        SMax = SMax(find(SMax <= R_Wave_Index(i)+round(0.6*(length(ecg_f)-R_Wave_Index(i)))));
        SMin = SMin(find(SMin <= R_Wave_Index(i)+round(0.6*(length(ecg_f)-R_Wave_Index(i)))));
    else
        temp = ecg_f(R_Wave_Index(i)+1:R_Wave_Index(i+1));
        [~,SMax,~,SMin] = Extrema_Identification(temp);
        SMax = SMax + R_Wave_Index(i);
        SMin = SMin + R_Wave_Index(i);
        SMax = SMax(find(SMax <= R_Wave_Index(i)+round(0.6*(R_Wave_Index(i+1)-R_Wave_Index(i)))));
        SMin = SMin(find(SMin <= R_Wave_Index(i)+round(0.6*(R_Wave_Index(i+1)-R_Wave_Index(i)))));
    end
    
    if isempty(SMin)
        if R_Wave_Index(i) == length(ecg_f)
            S_Wave_Index(i) = R_Wave_Index(i);
        else
            S_Wave_Index(i) = R_Wave_Index(i) + 1;
        end
    elseif length(SMin) == 1
        S_Wave_Index(i) = SMin(1);
    else
        if i == length(R_Wave_Index)
            SMin(find(SMin > R_Wave_Index(i)+round(0.3*(length(ecg_f)-R_Wave_Index(i))))) = [];
        else
            SMin(find(SMin > R_Wave_Index(i)+round(0.3*(R_Wave_Index(i+1)-R_Wave_Index(i))))) = [];
        end
        if length(SMin) == 1
            S_Wave_Index(i) = SMin(1);
        elseif isempty(SMin)
            if R_Wave_Index(i) == length(ecg_f)
                S_Wave_Index(i) = R_Wave_Index(i);
            else
                S_Wave_Index(i) = R_Wave_Index(i) + 1;
            end
        else
            for j = 1 : length(SMin)
                Min_Diff(j) = abs(ecg_f(SMin(j)) - ecg_f(R_Wave_Index(i)));
            end
            [~, maxind] = max(Min_Diff);
            S_Wave_Index(i) = SMin(maxind);
        end
    end
    clear ind
    
    SMax(find(SMax < S_Wave_Index(i))) = [];
    if isempty(SMax)
        if S_Wave_Index(i) == length(ecg_f)
            T_Wave_Index(i) = S_Wave_Index(i);
        else
            T_Wave_Index(i) = S_Wave_Index(i) + 1;
        end
    elseif length(SMax) == 1
        T_Wave_Index(i) = SMax(1);
    else
        for j = 1 : length(SMax)
            Max_Diff(j) = abs(ecg_f(SMax(j)) - ecg_f(S_Wave_Index(i)));
        end
        [~, maxind] = max(Max_Diff);
        T_Wave_Index(i) = SMax(maxind);
    end
        
    %Q detection
    if i == 1
        temp1 = ecg_f(1:R_Wave_Index(i));
        [~,QMax,~,QMin] = Extrema_Identification(temp1);
        QMax = QMax(find(QMax > round(0.8*(R_Wave_Index(i)-1))));
        QMin = QMin(find(QMin > round(0.8*(R_Wave_Index(i)-1))));
    else
        temp1 = ecg_f(R_Wave_Index(i-1)+1:R_Wave_Index(i));
        [~,QMax,~,QMin] = Extrema_Identification(temp1);
        QMax = QMax + R_Wave_Index(i-1);
        QMin = QMin + R_Wave_Index(i-1);
        QMax = QMax(find(QMax > R_Wave_Index(i-1) + round(0.8*(R_Wave_Index(i)-R_Wave_Index(i-1)))));
        QMin = QMin(find(QMin > R_Wave_Index(i-1) + round(0.8*(R_Wave_Index(i)-R_Wave_Index(i-1)))));
    end
    Q_All = sort([QMax; QMin]);
    if length(Q_All) == 1 
        Q_Wave_Index(i) = Q_All(1);
    elseif isempty(Q_All)
        if R_Wave_Index(i) == 1
            Q_Wave_Index(i) = R_Wave_Index(i);
        else
            Q_Wave_Index(i) = R_Wave_Index(i) - 1;
        end
    else
        for j = 2 : length(Q_All)
            diffs1(j-1) = abs(ecg_f(Q_All(j)) - ecg_f(Q_All(j-1)));
        end
        [~, ind1] = sort(diffs1,'descend');
        if isempty(ind1)
            Q_Wave_Index(i) = R_Wave_Index(i) - 1;
        else
            Q_Wave_Index(i) = Q_All(ind1(1));
        end
    end
 
    clear temp SMax SMin QMax QMin sall Q_All diffs diffs1 val req sorted_diffs sorted_diffs1 ind Min_Diff Max_Diff
end

Q_Wave_Index = Q_Wave_Index(Q_Wave_Index~=0);
S_Wave_Index = S_Wave_Index(S_Wave_Index~=0);
T_Wave_Index = T_Wave_Index(T_Wave_Index~=0);

end

