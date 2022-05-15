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

%-----------Angle parameters-------------
numRxAntennas=4;
RxAntSpacing=lamdaInMeter/2;
RxAntPos=(0:1:numRxAntennas-1)*RxAntSpacing;


%----------radarcube-------------------
numChirpTypes=2;
%d1=dopplerbin
%d2=RxAnt
%d3=chirp type (1=fast, 2=slow)
%d4=Rangebins
radarcube=zeros(numDopplerBins,numRxAntennas,numChirpTypes,numRangeBins);


%-----Target parameters
NumOfTargets =1;
%r=[50 100];  % in meters
%r=[MetersPerBin*50 MetersPerBin*25];
OnBinRange=50;
r=MetersPerBin*OnBinRange;
fr=r*OneMeterRoundTripHz;  % Target in frequency
InitialPhase=(4*pi*r)/lamdaInMeter;   %Eq 7 of MmWave Fundamentals TI doc
%v=[5 -2]; %m/s
%v=[MpsPerBin*10 MpsPerBin*(-10)];
OnBinVel=10;
v=MpsPerBin*OnBinVel;

Aoa_rad= 30*pi/180;
Aoa_deg=(Aoa_rad*180)/pi;
RxPhaseDiff=(2*pi/lamdaInMeter)*RxAntPos*sin(Aoa_rad); %in radians


deltaphase=(4*pi*v*Tc)/lamdaInMeter;  %Eq 10 of MmWave Fundamentals TI doc

t=(0:1:numRangeBins-1)*(1/fs);

for m=1:1:numRxAntennas
    
    for k=1:1:numDopplerBins
        
        AdcOut=0;
        for i=1:1:NumOfTargets
            
            temp=exp(1i*((2*pi*fr(i)*t)+InitialPhase(i)+(k-1)*deltaphase(i)));
            
            %Apply Antenna phase shift
            temp=temp.*exp(1i*RxPhaseDiff(m));
            
            AdcOut=AdcOut+temp;
            
        end
        
        %Convert to fixed point
        OneDfftTemp=fft(AdcOut);
        %OneDfftFxd=fix(OneDfftTemp*2^15-1);
        
        %move it to radarcube (load only fast chirp)
        radarcube(k,m,1,:)=OneDfftTemp;
        
        
        
    end    
 
    
end



%plot range-doppler image
%d1=dopplerbin
d2=1;%RxAnt
d3=1;%chirp type (1=fast, 2=slow)
%d4=Rangebins

for k=1:1:numRangeBins
    
    DopplerBins = squeeze(radarcube(:,d2,d3,k));
    
    TwoDfft(k,:)=fftshift(fft(DopplerBins));
    
    
end


%plot range-doppler
d1=1;% dopplerbin
%rangefft=OneDfft(:,ChirpNum);
rangefft = squeeze(radarcube(d1,d2,d3,:));
rangebins=(0:1:numRangeBins-1)*MetersPerBin;
%plot(rangebins,20*log10(abs(rangefft)))
%plot(rangebins,(abs(rangefft)))

%plot Doppler fft
Rangebin=51;
dopfft = (TwoDfft(Rangebin,:));
%doppbins = (-(numDopplerBins/2):1:(numDopplerBins/2)-1)*(MpsPerBin);% Need to check why /2 (fudge factor)
%doppbins = 0:1:numDopplerBins-1;
doppbins=(-(numDopplerBins/2):1:(numDopplerBins/2)-1)*MpsPerBin;
%figure
%plot(doppbins,20*log10(abs(dopfft)))
%plot(doppbins,(abs(dopfft)))

temp=20*log10(abs(TwoDfft));
%temp=abs(TwoDfft);
figure
image(doppbins,rangebins,temp,'CDataMapping','scaled')
colorbar
xlabel('m/s')
ylabel('meters')
title('Range-Doppler-Plot')


%plot range-azimuth aoa
rangeIdx=OnBinRange+1;
doppIdx=OnBinVel+(numDopplerBins/2)+1;

%TI method: 1- Perform 2D FFT of range-doppler intersection
for m=1:1:numRxAntennas
    
    %Get all doppler bins for rangeidx
    doppbins=squeeze(radarcube(:,m,1,rangeIdx));
    %perform fft
    temp=fftshift(fft(doppbins));
    %get the range-doppler intersection
    RangeDoppAnt(m)=temp(doppIdx);
end

%Do angle fft
%N=numRxAntennas;
N=64;
RangeAngleFFT=fftshift(fft(RangeDoppAnt,N));
temp=abs(RangeAngleFFT);
x=(-N/2:1:(N/2)-1);
aoa_x_rad=asin(2*x/N);
aoa_x_deg=(aoa_x_rad*180)/pi;
anglebins=aoa_x_deg;
figure
stem(anglebins,temp)

%Range AOA plot
%Get rangexangle matrix




for k=1:1:numRangeBins
    
    %Get all range from any Doppler
    AntBins =squeeze(radarcube(1,:,1,k));
    RangeAngleFFT(k,:)=fftshift(fft(AntBins,N));
    
end

%Plot range angle



%temp=20*log10(abs(RangeAngleFFT));


temp=abs(RangeAngleFFT);
rangebins=(0:1:numRangeBins-1)*MetersPerBin;
x=(-N/2:1:(N/2)-1);
aoa_x_rad=asin(2*x/N);
aoa_x_deg=(aoa_x_rad*180)/pi;
anglebins=aoa_x_deg;
figure
stem(anglebins,temp(rangeIdx,:))

if(1)
figure    
image(anglebins,rangebins,temp,'CDataMapping','scaled')
colorbar
xlabel('Degree')
ylabel('meters')
title('Range-Angle-Plot')
end





