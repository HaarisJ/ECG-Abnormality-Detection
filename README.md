# ECG-Abnormality-Detection

Arrhythmias (abnormal heart rhythms) may only occur occasionally, but their detection through electrocardiogram (ECG) is necessary for the early diagnosis of heart disease patients. Current solutions for prolonged ECG monitoring such as the Holter monitor, are inefficient due to poor electrode technology and the need for seven to 14 days of data being manually interpreted by a cardiologist.

This project involved developing a low-profile monitoring system that uses stretchable graphene electrodes and wirelessly classifies ECG readings in near real-time, while optimizing accuracy, signal quality, and ease-of-use.

View the final web application and results [here](https://ecg-abnormality-detection.web.app/).

*This was a 4th-year Capstone project developed under the guidance of Dr. Shideh Kabiri Ameri at Queen's University Department of Electrical and Computer Engineering*

## Team Members
- [Haaris Jamil](https://github.com/HaarisJ/)
- [Kyle Kwok](https://github.com/kylek740)
- [Elijah De Groote](https://github.com/15eddg)
- Ryan Chen

## Subsystem Interaction
<img src="https://user-images.githubusercontent.com/38993813/114242314-ae936880-9958-11eb-9446-c6bf1b4a50ff.png" alt="drawing" width="500"/>

## Harware Design
<img src="https://user-images.githubusercontent.com/38993813/114243039-e5b64980-9959-11eb-93dd-460f3eba4749.png" alt="drawing" width="400"/>


## AdaBoost Ensemble Model
#### Architecture
<img src="https://user-images.githubusercontent.com/38993813/114242744-67f23e00-9959-11eb-89c2-3f0890f92876.png" alt="drawing" width="400"/>

#### Performance
<div>F1 Score = 91.00</div>
<img src="https://user-images.githubusercontent.com/38993813/114242945-b6074180-9959-11eb-95e1-9a186e248285.png" alt="drawing" width="400"/>

### Open Source Contribution Credits
|     Filename    |     Author(s)    |     Source    |     License    |
|-|-|-|-|
|     Metrics.m    |     Gari D Clifford     Roberta Colloca     Julien Oster    |     Physionet 2017   Challenge    |     BSD 3 Clause    |
|     Comp_dRR.m    |     Gari D Clifford     Roberta Colloca     Julien Oster    |     Physionet 2017   Challenge    |     BSD 3 Clause    |
|     calculateSNR.m    |     Michiel   Rooijakkers     Linda M.   EerikÃ¤inen     Joaquin Vanschoren     Michael J.   Rooijakkers     Rik Vullings     Ronald M. Aarts    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU   General public License    |
|     Cross_Correlation_Feats.m    |     Shreyasi   Datta, Chetanya Puri, Ayan Mukherjee, Rohan Banerjee, Anirban Dutta Choudhury   Rituraj Singh, Arijit Ukil, Soma Bandyopadhyay, Arpan Pal, Dr Sundeep   Khandelwal     |     Physionet 2017   Challenge    |     GNU   General public License    |
|     Hjorth.m    |                Hjorth           |     [1] B.   Hjorth,        EEG   analysis based on time domain properties         Electroencephalography and Clinical Neurophysiology, vol. 29, no. 3, pp.   306-310, September 1970.     [2] B.   Hjorth,        Time Domain   Descriptors and their Relation to particulare Model for Generation of EEG   activity.        in G.   Dolce, H. Kunkel: CEAN Computerized EEG Analysis, Gustav Fischer 1975,   S.3-8.     |     GNU   General public License    |
|     Dbscan.m    |     Paolo Inglese    |     Ester, Martin;   Kriegel, Hans-Peter; Sander, JÃ¶rg;     Xu, Xiaowei   (1996). Simoudis, Evangelos; Han, Jiawei; Fayyad, Usama M.,     eds. A   density-based algorithm for discovering clusters in large spatial databases   with noise. Proceedings of the Second International Conference     on Knowledge   Discovery and Data Mining (KDD-96). AAAI Press. pp. 226?231.     ISBN   1-57735-004-9. CiteSeerX: 10.1.1.71.1980    |          |
|     differentBeatDetection.m    |     Michiel   Rooijakkers     Linda M.   EerikÃ¤inen     Joaquin Vanschoren     Michael J.   Rooijakkers     Rik Vullings     Ronald M. Aarts    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU   General public License    |
|     ECG_CancelNoise.m    |          |          |          |
|     ECG_Point_Extract.m    |     Shreyasi   Datta, Chetanya Puri, Ayan Mukherjee, Rohan Banerjee, Anirban Dutta Choudhury   Rituraj Singh, Arijit Ukil, Soma Bandyopadhyay, Arpan Pal, Dr Sundeep   Khandelwal     |          |     GNU   General public License    |
|     ECG_SqiFeatures    |     Michiel   Rooijakkers     Linda M.   EerikÃ¤inen     Joaquin Vanschoren     Michael J.   Rooijakkers     Rik Vullings     Ronald M. Aarts    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU   General public License    |
|     Extrema_IDentification    |     Carlos   Adrián Vargas Aguilera    |          |     %   From       : http://www.mathworks.com/matlabcentral/fileexchange     % File   ID : 12275          |
|     Frequency_Features.m    |     Shreyasi   Datta, Chetanya Puri, Ayan Mukherjee, Rohan Banerjee, Anirban Dutta Choudhury   Rituraj Singh, Arijit Ukil, Soma Bandyopadhyay, Arpan Pal, Dr Sundeep   Khandelwal     |          |     GNU   General public License    |
|     Get_fv.m    |     Vignesh   Kalidas    |          |     GNU   General public License    |
|     Get_rpeaks.m    |          |          |          |
|     Heart_Rate_Features    |          |          |          |
|     Heart_Rate_Variability_Features.m    |          |          |          |
|     Hjorth_cp.m    |          |          |          |
|     HRV_Approx_Entropy    |     Kijoon   Lee    |          |     MATLAB File   Exchange Copyright    |
|          |          |          |          |
|     Moving_Average.m    |          |          |          |
|     nonlinearHRV.m    |     John T.   Ramshur    |          |     GNU General Public License    |
|     Pan_tompkin.m    |     Vignesh   Kalidas           |          |     GNU   General public License    |
|     Pattern_time_feat.m    |          |          |          |
|     Poincare_features.m    |          |          |          |
|     PoincareHRV.m    |     John T.   Ramshur    |          |     GNU   General public License    |
|     PPG_Spectral_Purity_recursive.m    |     Sibylle   Fallet     Sasan   Yazdani     Jean-Marc   Vesin    |          |     GNU General Public License    |
|     Pr.m    |     Shreyasi   Datta, Chetanya Puri, Ayan Mukherjee, Rohan Banerjee, Anirban Dutta Choudhury   Rituraj Singh, Arijit Ukil, Soma Bandyopadhyay, Arpan Pal, Dr Sundeep   Khandelwal     |          |     GNU General Public License    |
|     Pwave.m    |          |          |          |
|     QRS_Complex_Identification    |     Linda   M. Eerikäinen (1), Joaquin Vanschoren (2), Michael J. Rooijakkers (1), Rik   Vullings (1), Ronald M. Aarts (1)(3)    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU General Public License    |
|     Qrs_detect2.m    |     Joachim   Behar     Oxford   university, Intelligent Patient Monitoring Group    |     FECG extraction toolbox, version 1.0, Sept 2013    % Released under the GNU General Public License    %    % Copyright (C) 2013  Joachim Behar                |     GNU General Public License    |
|     Qrs_detect3.m    |     Joachim   Behar     Oxford   university, Intelligent Patient Monitoring Group    |     FECG extraction toolbox, version 1.0, Sept 2013    % Released under the GNU General Public License    %    % Copyright (C) 2013  Joachim Behar    |     GNU General Public License    |
|     rpeakdetection    |     Linda   M. Eerikäinen (1), Joaquin Vanschoren (2), Michael J. Rooijakkers (1), Rik   Vullings (1), Ronald M. Aarts (1)(3)    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU General public   License    |
|     Segment selection    |     Linda   M. Eerikäinen (1), Joaquin Vanschoren (2), Michael J. Rooijakkers (1), Rik   Vullings (1), Ronald M. Aarts (1)(3)    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU General public   License    |
|     Spectral Based    |     Morteze Zabihi    |          |     GNU   General public License    |
|     SPI_max_mean    |     Sibylle   Fallet     Sasan   Yazdani     Jean-Marc   Vesin    |          |     GNU   General public License    |
|     Statistical_Feats.m    |     Shreyasi   Datta, Chetanya Puri, Ayan Mukherjee, Rohan Banerjee, Anirban Dutta Choudhury   Rituraj Singh, Arijit Ukil, Soma Bandyopadhyay, Arpan Pal, Dr Sundeep   Khandelwal     |          |     GNU GENERAL PUBLIC   LICENSE    |
|     Streamingpeakdetection.m    |     Linda   M. Eerikäinen (1), Joaquin Vanschoren (2), Michael J. Rooijakkers (1), Rik   Vullings (1), Ronald M. Aarts (1)(3)    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU   GENERAL PUBLIC LICENSE    |
|     Waveletanalysis    |     Linda   M. Eerikäinen (1), Joaquin Vanschoren (2), Michael J. Rooijakkers (1), Rik   Vullings (1), Ronald M. Aarts (1)(3)    |     http://www.cinc.org/archives/2015/pdf/0293.pdf    |     GNU   GENERAL PUBLIC LICENSE    |
