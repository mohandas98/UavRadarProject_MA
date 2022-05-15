%Changes:
% MA: Reinterpret radarcube as an multidimension array of complex numbers


clc
clearvars
close all

%load('MaRadarCubeRaw.mat')
load('MaRadarCubeRaw_OutsideWindow_9thFloor.mat')
%load('MaRadarCubeRaw_OutsideWindow_22ndFloor.mat')
load('Mrr_2D_Window.mat')

fs=4652e3;

A=MaRadarCubeRaw;
numDopplerBins=128;
numRxAnt=4;
numChirpTypes=2;
numRangeBins=256;

B=reshape(A,[numDopplerBins,...    %d2
             numRxAnt,...          %d3
             numChirpTypes,...     %d4
             numRangeBins]);       %d5
         
%Get any 1DFFT             
d2=1; % chirp# could be any of the 128 chirps
d3=1;   % rxAnt#
d4=1;   % Fast=1, slow=2
% 
% for k=1:1:numRangeBins
%     
%     fCpx(k)=B(d2,d3,d4,k);
%     
% end

MetersPerBin=0.681445313;

fCpx=squeeze(B(d2,d3,d4,1:numRangeBins));
rangebins=(0:1:numRangeBins-1)*MetersPerBin;

plot(rangebins,20*log10(abs(fCpx)))

%Get samples for all rangebins

d3=1; %Rx Ant#
d4=1; % Fast=1, Slow =2;
d5=5; % Rangebin#

SampleCtr=1;
for m=1:1:numRangeBins
    for k=1:1:numDopplerBins
        
        rfft(m,k)=B(k,d3,d4,m);
        
    end
end

% Perform doppler fft along each row
for m=1:numRangeBins,
    dfft(m,:) = fftshift(fft(rfft(m,:).*Mrr_Win2D));
end

MetersPerBin=0.681445313;
rangebins=(0:1:numRangeBins-1)*MetersPerBin;

MpsPerBin=0.237190451;
doppbins=(-(numDopplerBins/2):1:(numDopplerBins/2)-1)*MpsPerBin;

temp=abs(20*log10(dfft));
figure
image(doppbins,rangebins,temp,'CDataMapping','scaled')
colorbar
xlabel('m/s')
ylabel('meters')
title('Range-Doppler-Plot')

% 
% %Plot 2D spectrogram
% TwoDFft = fReal2D + 1i*fImag2D;
% w=128;
% nooverlap=0;
% nfft=128;
% %figure
% %spectrogram(TwoDFft,w,nooverlap,nfft,fs,'centered','yaxis');
% [s,f,t]=spectrogram(TwoDFft,w,nooverlap,nfft,fs,'centered','yaxis');
% 
% %plot Doppler FFT for rangebin 2
% x=(-numDopplerBins/2:1:(numDopplerBins/2)-1);
% figure
% plot(x,abs(s(:,2)))
% 
% %spectrogram(TwoDFft,w,nooverlap,nfft,fs,'centered','yaxis');
% %[s,f,t]=spectrogram(TwoDFft,w,nooverlap,nfft,fs);
% %spectrogram(TwoDFft,'yaxis')
% 
% 'CDataMapping','scaled')
% 
