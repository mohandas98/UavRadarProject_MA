function B = ReInterpretRadarCube(A)

global sampleLenInBytes numDopplerBins numRxAnt numChirpTypes numRangeBins

B=reshape(A,[sampleLenInBytes,...  %d1
             numDopplerBins,...    %d2
             numRxAnt,...          %d3
             numChirpTypes,...     %d4
             numRangeBins]);       %d5


end

