%% Load in the trained ML Model and initialization of variables
load AdaBoostPrimary
load AdaBoostSecondaryA
load AdaBoostSecondaryB

ECG_Results = table('Size', [1,3], 'VariableNames',{'id', 'label', 'datetime'}, ...
'VariableTypes', {'int8','string','string'}); % Table to store the final result

%% Form the connection to the ecgdata database
datasource = 'ecgdata'
username = 'admin'
password = '490database'

conn=database(datasource, username, password)
i = isopen(conn)

while (true)
    
    % Check Indicator Flag for new data
    selectquery = strcat('SELECT * FROM flag');
    IndFlag = table2array(select(conn,selectquery));

    if IndFlag == 1
        %% SQL Queries to gather necessary information
        % begin repeat loop here
        countquery = "SELECT COUNT(*) FROM realset";
        count = table2array(select(conn,countquery)); % determines the most recent entry that needs to be filled

        selectquery = strcat('SELECT value FROM realset_data WHERE id =', num2str(count));
        data = select(conn,selectquery); % using count, it grabs the data of the most recent entry

        ecg_Data = table2array(data);
        ecg_Data = cast(ecg_Data, 'double');
        ecg_Data = ecg_Data * 3.3/4096;
        fs = 300;
        ECGData = Notch_Filter(ecg_Data, fs);


        %% Classify the ECG
        features = Compile_Features(ECGData, fs);
        label = EnsembleClassifierModel(features,BoostS1,BoostS2,BoostS3);

        % Convert to original labels
        if (label==0)
                classifyResult = "NSR";
            elseif(label==1)
                classifyResult = "Other";
            elseif(label==2)
                classifyResult = "Other";
            else
                classifyResult = "Noisy";
        end
        %% Prepare data and submit back to DB
        ECG_Results.id = count;
        ECG_Results.label = classifyResult;
        ECG_Results.datetime = datestr(datetime);

        wherequery = strcat('WHERE id =', num2str(count));
        update(conn, 'realset', 'label', ECG_Results(1,2), wherequery);
        update(conn, 'realset', 'datetime', ECG_Results(1,3), wherequery);
        
%        n = length(ECGData);
%        RealsetData = repmat(count,1,n)';
%        RealsetData = array2table([repmat(count,1,n)' (1:n)' ECGData], 'VariableNames', {'id','index','value'});
        
%         update(conn, 'realset_data', 'value', RealsetData(:,3), wherequery);
        
        IndFlag = 0;
        Flag = array2table(IndFlag);
        wherequery = ('WHERE flag.flag = 1');
        update(conn, 'flag', 'flag', IndFlag, wherequery);
        disp("Complete")
    end
end
close(conn)
