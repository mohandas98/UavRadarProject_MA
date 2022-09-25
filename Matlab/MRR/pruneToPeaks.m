function [numDetObjPerCfarActual,cfarDetObjIndexBuf,cfarDetObjSNR]...
                              = pruneToPeaks(cfarDetObjIndexBuf,...
                                          cfarDetObjSNR,numDetObjPerCfar,...
                                            sumAbs,numBins)



numDetObjPerCfarActual=0;

if(numDetObjPerCfar==0)
    return
end

for detIdx=1:1:numDetObjPerCfar
    
    currObjLoc=cfarDetObjIndexBuf(detIdx);
    
    if(currObjLoc==1)
        prevIdx=numBins;
    else
        prevIdx=currObjLoc-1;
    end
    
    if (currObjLoc == numBins)
        
        nextIdx = 1;
        
    else
        
        nextIdx = currObjLoc + 1;
    end
    
    %Only accept a peak if the adjoining bins are lower in magnitude
    
    if( (sumAbs(nextIdx) < sumAbs(currObjLoc))...
         && (sumAbs(prevIdx) < sumAbs(currObjLoc)))
     
     numDetObjPerCfarActual = numDetObjPerCfarActual+1;
     
     %TODO: This does not appear to be correct. Overwritting the same
     %buffer while reading from it.
     cfarDetObjIndexBuf(numDetObjPerCfarActual) = currObjLoc;
     %TODO: This does not appear to be correct. Overwritting
     cfarDetObjSNR(numDetObjPerCfarActual) = cfarDetObjSNR(detIdx);
     
     
    end
    
    
    
    
end


end

