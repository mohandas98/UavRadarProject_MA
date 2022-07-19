function dstPingPong = GetAllDopplerBins(rangeIdx,rxAntIdx)

global numDopplerBins radarcube


d3=1; % Fast=1, Slow =2;

%Get all Doppler bins for corresponding Rx Ant, Chirp type and range bin
dstPingPong=squeeze(radarcube(1:numDopplerBins,rxAntIdx,d3,rangeIdx));




end



