function numDetObjPerCfarActual = pruneToPeaksOrNeighbourOfPeaks(cfarDetObjIndexBuf,...
                                               cfarDetObjSNR,...
                                               numDetObjPerCfar,...
                                               sumAbs,...
                                               numBins)



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
    
    if(prevIdx==1)
        prevPrevIdx=numBins;
    else
        prevPrevIdx=prevIdx-1;
    end
    
    if (currObjLoc == numBins)
        
        nextIdx = 1;
        
    else
        
        nextIdx = currObjLoc + 1;
    end
    
    if (nextIdx == numBins)
        
        nextNextIdx = 1;
        
    else
        
        nextNextIdx = currObjLoc + 1;
    end
    
    is_peak = ((sumAbs(nextIdx) < sumAbs(currObjLoc)) && ...
        (sumAbs(prevIdx) < sumAbs(currObjLoc)));
    is_neighbourOfPeakNext = ((sumAbs(nextNextIdx) < sumAbs(currObjLoc))...
        && (sumAbs(prevIdx) < sumAbs(currObjLoc)));
    is_neighbourOfPeakPrev = ((sumAbs(nextIdx) < sumAbs(currObjLoc))...
        && (sumAbs(prevPrevIdx) < sumAbs(currObjLoc)));
    
    if (is_peak || is_neighbourOfPeakNext || is_neighbourOfPeakPrev)
        
        numDetObjPerCfarActual = numDetObjPerCfarActual+1;
        
        %TODO: This does not appear to be correct. Overwritting
        cfarDetObjIndexBuf(numDetObjPerCfarActual) = currObjLoc;
        %TODO: This does not appear to be correct. Overwritting
        cfarDetObjSNR(numDetObjPerCfarActual) = cfarDetObjSNR(detIdx);
        
    end
    
    
end


end

