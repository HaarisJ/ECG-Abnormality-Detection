%% Load in the trained ML Model and initialization of variables
load AdaBoostPrimary
load AdaBoostSecondaryA
load AdaBoostSecondaryB

ECG_Results = table('Size', [1,2], 'VariableNames',{'id', 'label'}, ...
'VariableTypes', {'int8','string'}); % Table to store the final result

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
        ECG_Results.label = ClassifyResult;

        wherequery = strcat('WHERE id =', num2str(count));
        update(conn, 'realset', 'label', ECG_Results(1,2), wherequery);
        
        IndFlag = 0;
        Flag = array2table(IndFlag);
        wherequery = ('WHERE flag.flag = 1')
        update(conn, 'flag', 'flag', IndFlag, wherequery);
    end
end
%close(conn)
