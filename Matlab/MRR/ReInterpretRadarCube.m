function B = ReInterpretRadarCube(A)

%Reinterpret the radar cube so that it can be accessed as a
%multidimensional matrix. There are four dimensions.


global  numDopplerBins numRxAnt numChirpTypes numRangeBins

B=reshape(A,[numDopplerBins,...    %d1
             numRxAnt,...          %d2
             numChirpTypes,...     %d3
             numRangeBins]);       %d4


end

