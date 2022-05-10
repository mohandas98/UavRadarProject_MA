clc
clearvars
close all


global sampleLenInBytes numDopplerBins numRxAnt numChirpTypes numRangeBins
global radarcube
global DopplerthresholdScale noiseDivShift guardLen winLen
global detDopplerLines

ConstantInit;

%Pre-assign for speed
detMatrix=zeros(numRangeBins,numDopplerBins);


%------1D FFT is performed in sensor------------

%Sensor perform 1D FFT and stores results in buffer fftOut1D
%1D FFT is stored sequentially for every chirp from each antenna
%For eg: ChirpRx0, ChirpRx1,...ChirpRx3
%Ping buffer is moved to radarCube while Pong buffer is being filled
%for the next chirp.

%-----EDMA moves 1D FFT from fftOut1D to radarCube----

%-----RadarCube format-----
%--16bit integer for I and Q. No Fractional bit


%load the radarcube
load('MaRadarCubeRaw_OutsideWindow_22ndFloor.mat')
%load('RadarCubeCanned.mat')
radarcube = ReInterpretRadarCube(MaRadarCubeRaw);

%--Reset DopplerLines
detDopplerLines.dopplerLineMask=zeros(1,numDopplerBins);
detDopplerLines.currentIndex=0;

numDetDopplerLine1D=0;

temp1=zeros(256,10);
temp2=zeros(256,10);

%----Processing inside function MmwDemo_interFrameProcessing
for rangeIdx=1:1:numRangeBins
    
    %Perform 2D FFT and add from all the Rx antennas
    sumAbs=secondDimFFTandLog2Computation(rangeIdx);
    
    %Dopplerbin cfar    
    [numDetObjPerCfar,cfarDetObjIndexBuf,...
    cfarDebObjSNR]=cfarCa_SO_dBWrap_withSNR_MA(sumAbs,numDopplerBins,...
                                               DopplerthresholdScale,noiseDivShift,...
                                               guardLen,winLen);
    
    temp1(rangeIdx,1:length(cfarDetObjIndexBuf))=cfarDetObjIndexBuf(1:length(cfarDetObjIndexBuf));                                           
    temp2(rangeIdx,1:length(cfarDebObjSNR))=cfarDebObjSNR(1:length(cfarDebObjSNR));                                           
   

    %Reduce the detected objects to peaks    
    %pruneToPeaks 
    %TODO: function to implement
    numDetObjPerCfar=pruneToPeaks(cfarDetObjIndexBuf,cfarDebObjSNR,...
                                  numDetObjPerCfar,sumAbs,numDopplerBins);
                              
    %Decide which doppler 'gates' are to be subjected to the range-CFAR.
    %We only need to do so if a detected object from the doppler-CFAR is
    %detected at that 'doppler gate'
    if(numDetObjPerCfar>0)
        
        for detIdx1=1:1:numDetObjPerCfar
            
            %Check if the Doppler line is set
            if(~detDopplerLines.dopplerLineMask(cfarDetObjIndexBuf(detIdx1)))
                
                detDopplerLines.dopplerLineMask(cfarDetObjIndexBuf(detIdx1))=1;
                numDetDopplerLine1D=numDetDopplerLine1D+1;
            end
            
        end
        
    end
    
    %populate the pre-detection matrix
    %Move to detection matrix
    detMatrix(rangeIdx,:)=sumAbs;
        
    
end

%Perform CFAR detection along range lines. Only those doppler bins which
%were detected in the earlier CFAR along doppler dimension are considered

% if( numDetDopplerLine1D>0 )
%     
%     %Move first doppler line
%     dopplerLine=detDopplerLines.dopplerLineMask(detDopplerLines.currentIndex)
%     sumAbsRange=detMatrix(:,dopplerLine);
%     
%     
% end


%Plot detMatrix
MetersPerBin=0.681445313;
rangebins=(0:1:numRangeBins-1)*MetersPerBin;
%rangebins=(0:1:numRangeBins-1);

MpsPerBin=0.237190451;
%doppbins=(-(numDopplerBins/2):1:(numDopplerBins/2)-1)*MpsPerBin;
doppbins=(1:1:numDopplerBins);

temp=detMatrix;
figure
image(doppbins,rangebins,temp,'CDataMapping','scaled')
colorbar
xlabel('m/s')
ylabel('meters')
title('Range-Doppler-Plot')


% 
%  /*
%      * Perform CFAR detection along range lines. Only those doppler bins which were
%      * detected in the earlier CFAR along doppler dimension are considered
%      */




%1-EDMA moves 1DFFT for each rangebin data from radarcube to dstPingPongBuffer


%dstPingPong stores dopplerbins for each range and Rx antenna


%2D FFT (will be done in this script)

%---Simple floating point FFT

%Simulate a 2D FFT
% if(1)
% N=128;
% fs=10e3;
% fm=1e3;
% t=(0:1:N-1)*(1/fs);
% td=exp(1i*2*pi*fm*t);
% fftd=fft(td);
% %make it 32-bit signed number
% %fftdabs=10*log10(abs(fftd));
% 
% fftdabs=log2(abs(fftd));
% 
% 
% numInteg=1;
% ThresholdIndB=15;
% bitwidth=0;
% thresholdScale=convertSNRdBtoThreshold(numInteg,ThresholdIndB,bitwidth);
% 
% end



%Perform 2D Window: Output is 32 bit integer
%Perform 2D FFT: Output is 32 bit integer


%Perform log2Abs32:
%---computes log2(abs(x)): why log2?
%---input 32 bit complex
%---output 16 bit scaler


%Perfrom accumulation: mmwavelib_accum16
%--Accumulates input vector to the output vector:
%for(idx=0;idx<len;idx++)
%out[idx]+=inp[idx];//addition saturated to 0xFFF


%call CFAR
% sumAbs=fftdabs;
% numDopplerBins=128;
% noiseDivShift=4;
% guardLen=4;
% winLen=8;
% [numDetObjPerCfar,cfarDetObjIndexBuf,...
%     cfarDebObjSNR]=cfarCa_SO_dBWrap_withSNR_MA(sumAbs,numDopplerBins,...
%                                                thresholdScale,noiseDivShift,...
%                                                guardLen,winLen);
