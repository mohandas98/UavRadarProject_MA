%Find the SNR vs Range
clc
close all
clearvars

%Estimated Noise Power
EstNoisePwrdBm=-90;

%Received power
PtxdBm = 12; % Datasheet
Fudge=6;
GtxdBi = 14+Fudge;

GrxdBi = 10;
SigmadB = 5;
ThetaAzRad = (56/180);
ThetaElRad = (28/180);
lamda= 0.003893409;


R=1:1:150;

Prx = PtxdBm + GtxdBi + GrxdBi + 10*log10(ThetaAzRad) + 10*log10(ThetaElRad)...
    + 10*log10(pi/4)+10*log10(lamda^2)-(10*log10(((4*pi)^3)*(R.^2)));

%Signal to Noise density
Snr = Prx-EstNoisePwrdBm;

%Signal to Noise density
SnrDensity = Prx-(EstNoisePwrdBm-10*log10(256));

%Convert to Ti

plot(R,Snr)
title('Signal to Noise Density')
xlabel('Range meter')
ylabel('Snr')
grid
figure
semilogx(Snr)
