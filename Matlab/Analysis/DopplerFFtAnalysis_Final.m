%Script to analyze the 2D FFT in greater detail

%For an on-bin range signal (1D FFT of 256 points), the max magnitude of the signal would
%be 256 or 48 dB.
%For an on-bin range signal and on-bin Doppler signal the max magnitude of
%the 2D FFT of 128 points would be 256*128=32768



clc
clearvars
close all


N=256;  % Number of range bins
n=0:1:N-1;
k=100; % Range bin with signal. Whole number produces on-bin signal

% Phase due to doppler velocity
M=128         % Number of Doppler bins
j= 10.1;        % Doppler bin signal. Whole number produces on-bin signal
d=j*(2*pi)/M; % Delta phase from each Doppler bin (see analysis for this
              % spreadsheet MRR_MA_Rev1, chirp sub-sheet)
p1=pi/3;      % Initial phase. Can be arbitary phase


for m=1:1:128
   
    s(:,m)=exp(1i*2*pi*(k/N)*n + 1i*(p1+(m-1)*d));
    f(:,m)=fft(s(:,m));
    
end


%2D FFT

for m=1:1:256
    
    DopplerBins=f(m,:);
    
    f2(m,:)=fft(DopplerBins);
    
end



temp=20*log10(abs(f2));
image(temp,'CDataMapping','scaled')
colorbar
xlabel('Range Bins')
ylabel('Doppler Bins')
title('Range-Doppler-Plot')



