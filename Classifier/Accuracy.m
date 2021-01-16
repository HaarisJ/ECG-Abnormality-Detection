%% Accuracy.m
% Function used to test the accuracy of the ML Model using a custom testset
% from multiple physionet databases with signals including: NSR, AFib, Too
% Noisy, and other various heart conditions

% trainSet = load('ECGDataV2_OG.mat').trainSet;
% trainSet.Data = trainSet.Data(1345:1365,1:5000);
% trainSet.Labels = trainSet.Labels(1345:1365,1);

addpath 'D:\QueensU\Year 4\ELEC 490'
testSet = load('testSet.mat').testSet;
testSet.Data = testSet.Data(:,1:2500);
testSet.Labels = testSet.Labels(:,1);

N = 600;
predictions = string(zeros(1, N));
labels = string(zeros(1, N));
err = 0;

% load train_model
load BoostS1 
load BoostS2 
load BoostS3

for i=560:580
    fs = testSet.Freq{i};
    trueLabel = testSet.Labels{i};
    ecgData = testSet.Data(i,:)';
    ecgDataNew = resample(ecgData, 75, 32); % This resamples from fs=128 to fs=300
    fs = 300;
    
    tic
    features = Compile_Features(ecgDataNew, fs);
    label = EnsembleClassifierModel(features,BoostS1,BoostS2,BoostS3);
    toc
    
    % Convert to original labels
    if (label==0)
        classifyResult = 'NSR';
    elseif(label==1)
        classifyResult = 'Other';
    elseif(label==2)
        classifyResult = 'Other';
    else
        classifyResult = 'Noisy';
    end
    
    predictions(i) = classifyResult;
    labels(i) = trueLabel;
end

for i = 1:length(predictions)
   if predictions(i) ~= labels(i)
       err = err + 1;
   end
end

accuracy = (N - err) / N
