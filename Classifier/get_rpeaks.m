function ri = get_rpeaks(ecg_block,Fs,type)
%Vignesh Kalidas 
%PhD - Computer Engineering, 
%Dept of Electrical Engineering, 
%University of Texas at Dallas, Texas, USA
% GNU General public License
    if(nargin < 3)
        type = 0;
    end
    
    if(type == 1)
        minpeak_dist = 0.25*Fs;
    else
        minpeak_dist = 0.23*Fs;
    end
    


    [~,ri1,~,~,qrs_i,~] = pan_tompkin(ecg_block,Fs,0);

    ri=zeros(length(qrs_i));
    for i=1:1:length(qrs_i)

        l_lim = max((qrs_i(i) - round(0.150*Fs)),1);
        u_lim = min((qrs_i(i)+round(0*Fs)),length(ecg_block));
        
        maxval = abs(max(ecg_block(l_lim:u_lim)));
        minval = abs(min(ecg_block(l_lim:u_lim)));
        [~,ri1(i)] = max(ecg_block(l_lim:u_lim));
        if(minval > (1.3*maxval))
            [~,ri1(i)] = min(ecg_block(l_lim:u_lim));
        else
            [~,ri1(i)] = max(ecg_block(l_lim:u_lim));
        end
        ri(i) = ri1(i) + l_lim - 1;

    end

    for i=1:1:length(ri)-1
        if(ri(i+1) - ri(i) <= ceil(minpeak_dist))
            ri(i+1) = ri(i);
        end
    end
    
    ri2 = ri;
    ri11 = diff(ri);
    ri11 = find(ri11 == 0);
    ri11 = ri11 + 1;
    
    ri = [];
    k=1;
    
    for i=1:1:length(ri2)
        if(~isempty(find(ri11==i,1)))
            continue;
        end
        if(abs(ecg_block(ri2(i)))  >= 0.11)
            ri(k) = ri2(i);
            k=k+1;
        end
    end
end