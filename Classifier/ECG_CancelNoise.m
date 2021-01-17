function [ new_ecg ] = ECG_CancelNoise( ecg, fs )
%% Read Record and find all ECG positions
    [~, Q_index, rloc, S_index, T_index] = ECG_Point_Extract( ecg, fs );

%% noise cancellation
      
    [s,~,~] = spectrogram(ecg,fs/10,0.9*fs/10,1000,fs);
    s1 = [];
    mov_mean_len = 100;
    s1=movmean(sum(abs(s(101:end,:))),mov_mean_len);
    thres = 2.5*median(s1);
    g1= find(s1>thres);
    
    % find consecutive numbers as pairs
    p=find(diff(g1)==1); % 1 x m
    q=[p;p+1]; % 2 x m
    n1 = g1(q);  % 2 x m, this plot gives all the pairs of consecutive numbers
    rows = size(n1);
    if(rows~=2)
        n1 = n1';
    end
    fact = floor(length(ecg)/length(s1));
    n1 = n1 * fact;

    n2 = [];
    if(~isempty(n1))
        for i=1:length(n1(1,:))
            n2 = [n2 n1(1,i):1:n1(2,i)];
        end
    end
    n2 = unique(n2);

    % find the rlocs in n2
    noise_rloc = [];
    if(length(rloc)>=2)
        for i=1:length(rloc)
            if( ~isempty (intersect(n2, rloc(i))))
                if(i==1)
                    noise_rloc = [noise_rloc; [rloc(1) rloc(2)]];
                elseif i==length(rloc)
                    noise_rloc = [noise_rloc; [rloc(end-1) rloc(end)]];
                else
                    noise_rloc = [noise_rloc; [rloc(i-1) rloc(i)]; [rloc(i) rloc(i+1)]];
                end
            end
        end
    end
        
    % what if noisy data do not cover a peak?
    % n2 will have some data which is not in noise_rloc1
    more_noise_rloc = [];
    if(~isempty(n2))
        n3=setdiff(n2,noise_rloc);
        for i=1:length(n3)
           r=find(rloc<n3(i));
           if(isempty(r))
               continue;
           end
           start = rloc(r); start=start(end);
           r= find(rloc>n3(i));
           if(isempty(r))
               continue;
           end
           stop  = rloc(r); 
           stop=stop(1);
           if(isempty(more_noise_rloc))
               more_noise_rloc = [start stop];
           elseif(~find(more_noise_rloc==start))
                more_noise_rloc = [more_noise_rloc; [start stop]];
           end;
        end
    end
    noise_rloc = [noise_rloc; more_noise_rloc]; 
    
    n3=[];
    if (~isempty(noise_rloc))
        for i=1:length(noise_rloc(:,1))
            n3 = [n3 noise_rloc(i,1):1:noise_rloc(i,2)];
        end
    end
    
    %% Remove noisy part of ecg, regenerate features
    new_ecg = ecg;
    new_ecg(n3)=[];
    
end

