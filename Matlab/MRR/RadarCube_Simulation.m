% Script simulates FMCW de-chirped for target and forms the radarcube
% This version only generates 1D and 2D FFT

clc
clearvars
close all




%---FMCW Parameter----(copied from MRR code)
MMWDEMO_SPEED_OF_LIGHT_IN_METERS_PER_USEC=3.e02;
PROFILE_MRR_DIGOUT_SAMPLERATE_VAL=4652;
PROFILE_MRR_FREQ_SLOPE_MHZ_PER_US=4;
SUBFRAME_MRR_NUM_CMPLX_ADC_SAMPLES=256;
PROFILE_MRR_RANGE_RESOLUTION_METERS=...
    ((MMWDEMO_SPEED_OF_LIGHT_IN_METERS_PER_USEC ...
    * PROFILE_MRR_DIGOUT_SAMPLERATE_VAL)...
    / (2000.0 * PROFILE_MRR_FREQ_SLOPE_MHZ_PER_US...
    * SUBFRAME_MRR_NUM_CMPLX_ADC_SAMPLES) );    

fs=PROFILE_MRR_DIGOUT_SAMPLERATE_VAL*1e3; % sampling rate in Hz
numRangeBins=SUBFRAME_MRR_NUM_CMPLX_ADC_SAMPLES;
HzPerBin=fs/numRangeBins;
OneMeterRoundTripUsec=2*(1/MMWDEMO_SPEED_OF_LIGHT_IN_METERS_PER_USEC);
OneMeterRoundTripHz=OneMeterRoundTripUsec*PROFILE_MRR_FREQ_SLOPE_MHZ_PER_US...
                    *1e6;
MetersPerBin = PROFILE_MRR_RANGE_RESOLUTION_METERS;
                

PROFILE_MRR_START_FREQ_GHZ=76.01;
PROFILE_MRR_LAMBDA_MILLIMETER= (MMWDEMO_SPEED_OF_LIGHT_IN_METERS_PER_USEC...
                               /PROFILE_MRR_START_FREQ_GHZ);
lamdaInMeter=PROFILE_MRR_LAMBDA_MILLIMETER*1e-3;


CHIRP_MRR_0_IDLE_TIME_VAL=0;
PROFILE_MRR_IDLE_TIME_VAL=500;
PROFILE_MRR_RAMP_END_TIME_VAL=6000;
SUBFRAME_MRR_CHIRPTYPE_0_CHIRP_REPETITION_PERIOD_US=...
    (CHIRP_MRR_0_IDLE_TIME_VAL+...
    PROFILE_MRR_IDLE_TIME_VAL+...
    PROFILE_MRR_RAMP_END_TIME_VAL)/100;
SUBFRAME_MRR_CHIRPTYPE_0_NUM_CHIRPS=128;
SUBFRAME_MRR_CHIRPTYPE_0_VEL_RESOLUTION_M_P_S=...
    (((1000.0/SUBFRAME_MRR_CHIRPTYPE_0_CHIRP_REPETITION_PERIOD_US)/...
    SUBFRAME_MRR_CHIRPTYPE_0_NUM_CHIRPS)*(PROFILE_MRR_LAMBDA_MILLIMETER/2));
SUBFRAME_MRR_CHIRPTYPE_0_MAX_VEL_M_P_S=...
    (SUBFRAME_MRR_CHIRPTYPE_0_VEL_RESOLUTION_M_P_S*...
    SUBFRAME_MRR_CHIRPTYPE_0_NUM_CHIRPS/2);

MpsPerBin = SUBFRAME_MRR_CHIRPTYPE_0_VEL_RESOLUTION_M_P_S;

TcUs=SUBFRAME_MRR_CHIRPTYPE_0_CHIRP_REPETITION_PERIOD_US;
numDopplerBins=SUBFRAME_MRR_CHIRPTYPE_0_NUM_CHIRPS;

Tc=TcUs*1e-6;

%-----Target parameters
NumOfTargets =2;
r=[50 100];  % in meters
%r=[MetersPerBin*50 MetersPerBin*25];
fr=r*OneMeterRoundTripHz;  % Target in frequency
InitialPhase=(4*pi*r)/lamdaInMeter;   %Eq 7 of MmWave Fundamentals TI doc
v=[5 -2]; %m/s
%v=[MpsPerBin*10 MpsPerBin*(-10)];


deltaphase=(4*pi*v*Tc)/lamdaInMeter;  %Eq 10 of MmWave Fundamentals TI doc

t=(0:1:numRangeBins-1)*(1/fs);

for k=1:1:numDopplerBins
    
    AdcOut=0;
    for i=1:1:NumOfTargets
        
        temp=exp(1i*((2*pi*fr(i)*t)+InitialPhase(i)+(k-1)*deltaphase(i)));
        AdcOut=AdcOut+temp;
        
    end
    
   
    OneDfft(:,k)=fft(AdcOut);
    
    
end

%Convert to 16 bit integer
OneDfftFxd=fix(OneDfft*2^15-1);
numRxAnt=4;
numChirpTypes=2;
%Put it into radarcube multidimension
radarcube=zeros(numDopplerBins,numRxAnt,numChirpTypes,numRangeBins);
for k=1:1:numDopplerBins
    for l=1:1:numRxAnt
        for m=1:1:numChirpTypes
            StartIdx = ((m-1)*numRangeBins)+1;
            EndIdx = StartIdx+numRangeBins-1;
            radarcube(k,l,m,:)=OneDfftFxd(StartIdx:EndIdx);
        end
    end
end



%BCode below is only for plotting
if(0)

%Perform 2D FFT
for k=1:1:numRangeBins
    
    TwoDfft(k,:)=fftshift(fft(OneDfft(k,:)));
    %TwoDfft(k,:)=(fft(OneDfft(k,:)));
    
end


%plot range fft
ChirpNum=1;
rangefft=OneDfft(:,ChirpNum);
rangebins=(0:1:numRangeBins-1)*MetersPerBin;
%plot(rangebins,20*log10(abs(rangefft)))
plot(rangebins,(abs(rangefft)))

%plot Doppler fft
Rangebin=51;
dopfft = (TwoDfft(Rangebin,:));
%doppbins = (-(numDopplerBins/2):1:(numDopplerBins/2)-1)*(MpsPerBin);% Need to check why /2 (fudge factor)
%doppbins = 0:1:numDopplerBins-1;
doppbins=(-(numDopplerBins/2):1:(numDopplerBins/2)-1)*MpsPerBin;
figure
%plot(doppbins,20*log10(abs(dopfft)))
plot(doppbins,(abs(dopfft)))

temp=20*log10(abs(TwoDfft));
%temp=abs(TwoDfft);
figure
image(doppbins,rangebins,temp,'CDataMapping','scaled')
colorbar
xlabel('m/s')
ylabel('meters')
title('Range-Doppler-Plot')

% figure
% image(rangebins,doppbins,temp.')
% colorbar
% ylabel('m/s')
% xlabel('meters')
% title('Range-Doppler-Plot')

% AdcOut=exp(1i*((2*pi*fr*t)+Phase));

% f=fftshift(fft(AdcOut));
% N=256;
% x=(-N/2:1:(N/2)-1)*(fs/N);
% plot(x,20*log10(abs(f)))

end




