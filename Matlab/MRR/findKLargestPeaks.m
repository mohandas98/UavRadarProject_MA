function [numDetObjPerCfar,cfarDetObjIndexBuf,cfarDetObjSNR] =...
                           findKLargestPeaks(cfarDetObjIndexBuf,...
                                    cfarDetObjSNR,...
                                    numDetObjPerCfar,...
                                    sumAbs,...
                                    K)



if(numDetObjPerCfar <= 1)
   
    return;
end

if (K >= numDetObjPerCfar)
    K=numDetObjPerCfar;
end

for detIdx1=1:1:K
    
    currMax=0;
    for detIdx2=detIdx1:1:numDetObjPerCfar
        
        if (currMax <= sumAbs(cfarDetObjIndexBuf(detIdx2)))
            
            currMax = sumAbs(cfarDetObjIndexBuf(detIdx2));
            currMaxIdx = detIdx2;
            
        end
        
    end
    
    tempIdx = cfarDetObjIndexBuf(detIdx2);
    tempSNR = cfarDetObjSNR(detIdx1);
    cfarDetObjIndexBuf(detIdx1) = cfarDetObjIndexBuf(currMaxIdx);
    cfarDetObjSNR(detIdx1) = cfarDetObjSNR(currMaxIdx);
    cfarDetObjIndexBuf(currMaxIdx) = tempIdx;
    cfarDetObjSNR(currMaxIdx) = tempSNR;
    
end



end

