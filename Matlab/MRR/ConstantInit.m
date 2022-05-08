function  ConstantInit

global sampleLenInBytes numDopplerBins numRxAnt numChirpTypes numRangeBins
global numTxAnt
global Mrr_Win2D
global noiseDivShift guardLen winLen
global DopplerthresholdScale
global detDopplerLines

sampleLenInBytes=4;
numDopplerBins=128;
numRxAnt=4;
numTxAnt=1;
numChirpTypes=2;
numRangeBins=256;

%2D Window
load('Mrr_2D_Window.mat');

%Dopplerbin CFAR parameters
noiseDivShift=4;
guardLen=4;
winLen=8;

numInteg=numRxAnt*numTxAnt;
SUBFRAME_MRR_MIN_SNR_dB=14;
CFARTHRESHOLD_N_BIT_FRAC=8;
DopplerthresholdScale=convertSNRdBtoThreshold(numInteg,SUBFRAME_MRR_MIN_SNR_dB...
                              ,CFARTHRESHOLD_N_BIT_FRAC);
                          
                          
%--Doppler Line Mask---
% detDopplerLines.dopplerLineMask=zeros(1,max(numDopplerBins/32,1));
% detDopplerLines.currentIndex=0;
% detDopplerLines.dopplerLineMaskLen = max(numDopplerBins/32,1);

% Use the simpler way of keeping track of dopplerLine
% index 1 of dopplerLineMask corresponds to first dopplerbin
detDopplerLines.dopplerLineMask=zeros(1,numDopplerBins);
detDopplerLines.currentIndex=1;
detDopplerLines.dopplerLineMaskLen = numDopplerBins;



end

