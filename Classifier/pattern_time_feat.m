function time_domain_rand_feat = pattern_time_feat(ecg,Fs)

ecg = zscore(ecg);
[~,locs_max] = findpeaks(ecg);
[~,locs_min] = findpeaks(-ecg);
new_locs_min = zeros(length(locs_min),1);
new_locs_max = zeros(length(locs_max),1); %#ok<*PREALL>


if (min(locs_max)<min(locs_min)) % maxima detected first
    new_locs_min=[];
    for ji=1:length(locs_max)
        new_locs_min = [new_locs_min;locs_min(find(locs_min>locs_max(ji),1,'first'))]; %#ok<*AGROW>
    end
    if (length(new_locs_min) < length(locs_max))
        duo = [locs_max(1:length(new_locs_min)) new_locs_min ];
    else
        duo = [ locs_max new_locs_min(1:length(locs_max))];
    end
else
    new_locs_max=[];
    for ji=1:length(locs_min)
        new_locs_max = [new_locs_max;locs_max(find(locs_max>locs_min(ji),1,'first'))];
    end
    if (length(locs_min)<length(new_locs_max))
        duo = [locs_min new_locs_max(1:length(locs_min))];
    else
        duo = [locs_min(1:length(new_locs_max)) new_locs_max];
    end
end

a=duo(:,2)-duo(:,1);
xvalues = unique(a);
[num_elems,bin_centre]=hist(a,xvalues); %#ok<HIST>
xa=num_elems./sum(num_elems);
t1=find(bin_centre<11/300*Fs,1,'first');
t2=find(bin_centre>=11/300*Fs,1,'first');

time_domain_rand_feat1 = sum(xa(1:t1));
time_domain_rand_feat2 = sum(xa(t2:end));
time_domain_rand_feat = [time_domain_rand_feat1 time_domain_rand_feat2];
end