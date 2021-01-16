function [PredictedAnnotation] = EnsembleClassifierModel(FeatureVector,tb_allS1,tb_allS2,tb_allS3)

%
% Copyright (C) 2017
% Shreyasi Datta
% Chetanya Puri
% Ayan Mukherjee
% Rohan Banerjee
% Anirban Dutta Choudhury
% Arijit Ukil
% Soma Bandyopadhyay
% Rituraj Singh
% Arpan Pal
% Sundeep Khandelwal
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

load FeatureIndices209
L1_Ind  = L1 ;
L2_ind  = L2 ;
L3_ind  = L3 ;

% prediction stage
PredictedAnnotation     = 1; %%Intial prediction

ensemblePredictFcnL1            = @(x) predict(tb_allS1 , x);
trainedClassifier.predictFcnL1  = @(x) ensemblePredictFcnL1(x);
ensemblePredictFcnL3            = @(x) predict(tb_allS3, x);
trainedClassifier.predictFcnL3  = @(x) ensemblePredictFcnL3(x);
ensemblePredictFcnL2            = @(x) predict(tb_allS2, x);
trainedClassifier.predictFcnL2  = @(x) ensemblePredictFcnL2(x);

%%%Cascade level one:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Splits the signal into the classification of NSR and AFib or Too Noisy
% and Other. 
predicted_labelsS1 = trainedClassifier.predictFcnL1(FeatureVector(L1_Ind));

%%%Cascade level two A: NSR or AFib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(predicted_labelsS1 == 0)
    
    predicted_labelsS3 = trainedClassifier.predictFcnL3(FeatureVector(L3_ind));
    if( predicted_labelsS3 == 1)
        PredictedAnnotation = 1;
    end
    if ( predicted_labelsS3 == 0)
        PredictedAnnotation = 3;
    end
end
%%%Cascade level two B: Too Noisy or Other
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(predicted_labelsS1 == 1)
    predicted_labelsS2 = trainedClassifier.predictFcnL2(FeatureVector(L2_ind));
    if( predicted_labelsS2 == 1)
        PredictedAnnotation = 0;
    end
    if( predicted_labelsS2 == 0)
        PredictedAnnotation = 2;
    end
end


end



