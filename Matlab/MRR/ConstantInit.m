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
global maxNumObj2DRaw
global detObj2DRaw detObj2D
global velResolution rangeResolution MIN_RANGE_OFFSET_METERS
global SNRThresholds peakValThresholds MAX_NUM_RANGE_DEPENDANT_SNR_THRESHOLDS
global maxRange minRange
global MRR_MAX_OBJ_OUT

sampleLenInBytes=4;
numDopplerBins=128;
numRxAnt=4;
numTxAnt=1;
numChirpTypes=2;
numRangeBins=256;

log2numVirAnt=log2(numTxAnt*numRxAnt);

MAX_NUM_DET_PER_RANGE_GATE=3;
maxNumObj2DRaw=200; 

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

%Initialize detObj2DRaw structure
detObj2DRaw=struct;
detObj2DRaw.rangeIdx=0;
detObj2DRaw.dopplerIdx=0;
detObj2DRaw.range=0;
detObj2DRaw.speed=0;
detObj2DRaw.peakVal=0;
detObj2DRaw.rangeSNRdB=0;
detObj2DRaw.dopplerSNRdB=0;

%make maxNumObj2DRaw of them
%TODO: Not sure if a better way to make array of structures in Matlab
for k=2:1:maxNumObj2DRaw
    detObj2DRaw(k).rangeIdx=0;
    detObj2DRaw(k).dopplerIdx=0;
    detObj2DRaw(k).range=0;
    detObj2DRaw(k).speed=0;
    detObj2DRaw(k).peakVal=0;
    detObj2DRaw(k).rangeSNRdB=0;
    detObj2DRaw(k).dopplerSNRdB=0;
    
end

%Initialize detObj2D structure
detObj2D=struct;
detObj2D.rangeIdx=0;
detObj2D.dopplerIdx=0;
detObj2D.range=0;
detObj2D.speed=0;
detObj2D.sinAzim=0;
detObj2D.peakVal=0;
detObj2D.rangeSNRdB=0;
detObj2D.dopplerSNRdB=0;
detObj2D.sinAzimSNRLin=0;
detObj2D.x=0;
detObj2D.y=0;
detObj2D.z=0;

MRR_MAX_OBJ_OUT=200;

for k=2:1:MRR_MAX_OBJ_OUT
        
    detObj2D(k).rangeIdx=0;
    detObj2D(k).dopplerIdx=0;
    detObj2D(k).range=0;
    detObj2D(k).speed=0;
    detObj2D(k).sinAzim=0;
    detObj2D(k).peakVal=0;
    detObj2D(k).rangeSNRdB=0;
    detObj2D(k).dopplerSNRdB=0;
    detObj2D(k).sinAzimSNRLin=0;
    detObj2D(k).x=0;
    detObj2D(k).y=0;
    detObj2D(k).z=0;
    
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

velResolution=0.237190451; % m/s
rangeResolution=0.681445313; %meters
MIN_RANGE_OFFSET_METERS=0.075;

SNRThresholds=struct;
SNRThresholds.rangelim=10;
SNRThresholds.threshold=convertSNRdBtoThreshold(1, 18.0,CFARTHRESHOLD_N_BIT_FRAC);

SNRThresholds(2).rangelim=35;
SNRThresholds(2).threshold=convertSNRdBtoThreshold(1, 16.0,CFARTHRESHOLD_N_BIT_FRAC);

SNRThresholds(3).rangelim=65535;
SNRThresholds(3).threshold=convertSNRdBtoThreshold(1, 1.0,CFARTHRESHOLD_N_BIT_FRAC);

peakValThresholds = struct;
peakValThresholds.rangelim=7;
peakValThresholds.threshold=4250;

peakValThresholds(2).rangelim=65535;
peakValThresholds(2).threshold=0;

peakValThresholds(3).rangelim=65535;
peakValThresholds(3).threshold=0;

MAX_NUM_RANGE_DEPENDANT_SNR_THRESHOLDS=3;

minRange = 0.5;
maxRange = (rangeResolution*256*0.9);

MRR_MAX_OBJ_OUT=200;

end

