function B = ReInterpretRadarCube(A)

global  numDopplerBins numRxAnt numChirpTypes numRangeBins

B=reshape(A,[numDopplerBins,...    %d2
             numRxAnt,...          %d3
             numChirpTypes,...     %d4
             numRangeBins]);       %d5


end

