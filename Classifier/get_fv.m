function [feature] = get_fv(ecg_data,Fs)
   %Vignesh Kalidas 
%PhD - Computer Engineering, 
%Dept of Electrical Engineering, 
%University of Texas at Dallas, Texas, USA
% GNU General public License 
%     ecg_data1 = ecg_data((290*Fs)+1 : 300*Fs);
    ecg_data1 = ecg_data - mean(ecg_data);
    
%     ppg_data1 = ppg_data((290*Fs)+1 : 300*Fs);
%     ppg_data1 = ppg_data1 - mean(ppg_data1);
    
    [x_fv] = get_features(ecg_data1,Fs);
    feature(1) = mean(x_fv(:,1));
    feature(2) = mean(x_fv(:,2));
    
end

function [temp_fv] = get_features(ecg_data1,Fs)

    k = 1;
    temp_fv = [];
    f_lim = (((length(ecg_data1)/Fs)-4)*4);


    x_fv(k,(1:(length(ecg_data1)))) = ecg_data1; % ECG data
    x_fv(k,(1:(length(ecg_data1)))) = x_fv(k,(1:(length(ecg_data1)))) - mean(x_fv(k,(1:(length(ecg_data1))))); % Normalized data 
    lp_ecg = Butterwoth_bidir(1,x_fv(k,(1:(length(ecg_data1)))),Fs,2,'low'); % bidirectional filtered data (maximally flat data at passband)
    x_fv(k,(1:(length(ecg_data1)))) = x_fv(k,(1:(length(ecg_data1)))) - lp_ecg; %Another normalization

    temp_x = x_fv(k,1:(length(ecg_data1)));
    pts_01 = [find(temp_x >= 0.11) find(temp_x <= -0.11)];
    pts_11 = [1 sort(pts_01) (length(ecg_data1))];

    pts_01std = max(diff(pts_11));

    no_01 = length(find(temp_x >= 0.11)) + length(find(temp_x <= -0.11));

    temp_fv(k,(1:2)) = [no_01,pts_01std];
    k=k+1;

    for ind=1:1:f_lim
        st = ceil(ind*(0.25*Fs))+1;
        fi = st+(4*Fs)-1;
        if ind == 1 && fi > length(ecg_data1)
            st = 1;
            fi = length(ecg_data1);
        elseif fi > length(ecg_data1)
            break;

        end
        ecg_d= ecg_data1(st:fi);
        x_fv(k,(1:(length(ecg_d)))) = ecg_d;
        x_fv(k,(1:(length(ecg_d)))) = x_fv(k,(1:(length(ecg_d)))) - mean(x_fv(k,(1:(length(ecg_d)))));
        lp_ecg = Butterwoth_bidir(1,x_fv(k,(1:(length(ecg_d)))),Fs,2,'low');
        x_fv(k,(1:(length(ecg_d)))) = x_fv(k,(1:(length(ecg_d)))) - lp_ecg;


        temp_x = x_fv(k,1:(length(ecg_d)));
        pts_01 = [find(temp_x >= 0.11) find(temp_x <= -0.11)];
        pts_11 = [1 sort(pts_01) (length(ecg_d))];

        pts_01std = max(diff(pts_11));
        no_01 = length(find(temp_x >= 0.11)) + length(find(temp_x <= -0.11));

        temp_fv(k,(1:2)) = [no_01,pts_01std];
        k=k+1;

    end
end