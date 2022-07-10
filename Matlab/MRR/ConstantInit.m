function  ConstantInit

global sampleLenInBytes numDopplerBins numRxAnt numChirpTypes numRangeBins
global numTxAnt
global Mrr_Win2D
global noiseDivShift guardLen winLen
global DopplerthresholdScale
global detDopplerLines
global MAX_NUM_DET_PER_RANGE_GATE
global detObj1DRaw
global log2numVirAnt
global noiseDivShiftRange guardLenRange winLenRange RangethresholdScale

sampleLenInBytes=4;
numDopplerBins=128;
numRxAnt=4;
numTxAnt=1;
numChirpTypes=2;
numRangeBins=256;

log2numVirAnt=log2(numTxAnt*numRxAnt);

MAX_NUM_DET_PER_RANGE_GATE=3;

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
                          
                          
%Initialize detObj1DRaw structure
detObj1DRaw=struct;
detObj1DRaw.rangeIdx=0;
detObj1DRaw.dopplerIdx=0;
detObj1DRaw.velDisambFacValidity=0;
detObj1DRaw.dopplerSNRdB=0;
                          
%make numRangeBins*MAX_NUM_DET_PER_RANGE_GATE of them
%TODO: Not sure if a better way to make array of structures in Matlab
for k=2:1:(numRangeBins*MAX_NUM_DET_PER_RANGE_GATE)    
    
    detObj1DRaw(k).rangeIdx=0;
    detObj1DRaw(k).dopplerIdx=0;
    detObj1DRaw(k).velDisambFacValidity=0;
    detObj1DRaw(k).dopplerSNRdB=0;

end

                         
%Rangebin CFAR parameters
noiseDivShiftRange=4;
guardLenRange=4;
winLenRange=8;                         
RangethresholdScale = convertSNRdBtoThreshold(numInteg,SUBFRAME_MRR_MIN_SNR_dB...
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

