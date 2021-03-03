function [PredictedLabel] = EnsembleClassifierModel(FeatureVector,AdaBoostPrimary,AdaBoostSecondaryB,AdaBoostSecondaryA)
% Ensembling of 3 Adaboost classifiers to generate 2 levels with level 1
% splitting it into NSR and AFib or into Other and Too Noisy. Second level
% of classifiers will seperate them further into their own class.

% Loading in which features are required by each classifier
load ClassifierFeatureBreakdown
PrimaryClassifier_FeatureIndex  = L1 ;
SecondaryClassifierB_FeatureIndex  = L3 ;
SecondaryClassifierA_FeatureIndex  = L2 ;


% if (length(FeatureVector) ~= 166)
%     PredictedLabel = 3;
%     return
% end

% Predicition Placeholder
PredictedLabel = 1;

ensemblePredictFcnL1 = @(x) predict(AdaBoostPrimary, x);
trainedClassifier.predictFcnL1 = @(x) ensemblePredictFcnL1(x);

ensemblePredictFcnL3 = @(x) predict(AdaBoostSecondaryA, x);
trainedClassifier.predictFcnL3 = @(x) ensemblePredictFcnL3(x);

ensemblePredictFcnL2 = @(x) predict(AdaBoostSecondaryB, x);
trainedClassifier.predictFcnL2  = @(x) ensemblePredictFcnL2(x);

%Primary Cascade Classifier:
% Splits the signal into the classification of NSR and AFib or Too Noisy
% and Other. 
Primary_Label = trainedClassifier.predictFcnL1(FeatureVector(PrimaryClassifier_FeatureIndex));

    %Secondary Cascade Classifier A: NSR or AF
    if(Primary_Label == 0)
        Secondary_Label_A = trainedClassifier.predictFcnL3(FeatureVector(SecondaryClassifierB_FeatureIndex));
        if( Secondary_Label_A == 1)
            PredictedLabel = 1;
        end
        if ( Secondary_Label_A == 0)
            PredictedLabel = 3;
        end

    %Secondary Cascade Classifier B: Too Noisy or Other
    elseif(Primary_Label == 1)
        Secondary_Label_B = trainedClassifier.predictFcnL2(FeatureVector(SecondaryClassifierA_FeatureIndex));
        if( Secondary_Label_B == 1)
            PredictedLabel = 0;
        end
        if( Secondary_Label_B == 0)
            PredictedLabel = 2;
        end
    end

end



