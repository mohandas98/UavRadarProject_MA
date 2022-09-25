% Script will show the difference between Signal to Noise Density and Signal
% to Noise.

clc
clearvars
close all

N=256;               % Number of samples


%Sweep through SNR Noise Density


SNR_dB = -15:1:50;          % Commonly referred as power ratio  


SNR = 10.^(SNR_dB/10);

NoisePower = 0.1;     % variance
NoiseSamples=sqrt(NoisePower/2)*(randn(1,N)+1i*randn(1,N));
SignalPower =SNR*NoisePower;

%Generate a complex sinusoid
Amp = sqrt(SignalPower);  % This would be sqrt(SignalPowe/2) if only real samples
F1  = 0.125;               %cycles per sample or Fs*F1 Hz

%loop through all amps
k=length(Amp);

for i=1:1:k

Sig = Amp(i)*exp(1i*2*pi*F1*(0:1:N-1));
SigPower = var(Sig);

SigPlusNoise=Sig + NoiseSamples;

TotalTimeDomainPower=var(SigPlusNoise);

f=fft(SigPlusNoise);
fscaled=f/N;  % This can be avoided if only dealing with ratio but needed to
              % check if Time domain power is equal to freq domain power
ff=fscaled.*conj(fscaled);  % Power spectrum

%Parsavel's theorem: Time domain power should be equal to frequency domain
%power
TotalPowerFromFft = sum(ff);

%Estimate SNDensity from FFT
EstSigPower = max(ff);
EstNoisePower = TotalPowerFromFft-EstSigPower;
EstNoisePowerDensity =EstNoisePower/N;
EstSnrD=10*log10(SigPower/EstNoisePowerDensity)


%Actual SNdensity
Pd = NoisePower/N;
EstPd_dB =10*log10(Pd)
                                    
ActSnrD(i) = 10*log10(SignalPower(i)/Pd)





%-----------TI's way of doing this-----------------------

%W/o using Log2
fTi = (abs(fscaled));
[EstSigAmp,index] = max(fTi);  % Signal Amp

c=mean(fTi([1:index-1 index+1:N])); % Noise Amp Density
EstNoisePowerDensityT1=(c^2) ;   % Noise Power Density

EstSnrDensity = 10*log10(EstSigAmp^2/EstNoisePowerDensity)

%Using Log2
fTil = log2(abs(fscaled));
[EstSigAmpLog2,index] = max(fTil);  % Signal Amp
clog=mean(fTil([1:index-1 index+1:N])); % Noise Amp Density
TiSnr(i) = EstSigAmpLog2-clog
EstSnrDensityLog2(i) = 20*log10(2)*TiSnr(i)

diff(i)=EstSnrDensityLog2(i)-ActSnrD(i);

difflog2(i)=TiSnr(i)-ActSnrD(i);

%In Q8 format
ftiq8 = fTil*(2^8);
[EstSigAmpLog2q8,index] = max(ftiq8);  % Signal Amp
clogq8=mean(ftiq8([1:index-1 index+1:N])); % Noise Amp Density
TiSnrq8(i) = EstSigAmpLog2q8-clogq8

end

plot(ActSnrD,EstSnrDensityLog2)
title('Actual SNRDensity vs Ti SNRDensity in Log10')
xlabel('Actual SNRDensity dB')
ylabel('Ti SNR Density in Log10')
grid

figure
plot(ActSnrD,TiSnr)
title('Actual SNRDensity vs Ti SNRDensity in Log2')
xlabel('Actual SNRDensity dB')
ylabel('Ti SNR Density in Log2')
grid

figure
plot(difflog2)
hold on
plot(diff)
legend('Diff b/w Actual and Ti Log2','Diff b/w Actual and TI log10')
grid
