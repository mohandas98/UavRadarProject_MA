function numDetObj2D = findandPopulateIntersectionOfDetectedObjects(...
                                  cfarDetObjIndexBuf,...
                                  numDetObj2D,...
                                  dopplerLine,...
                                  cfarDetObjSNR,...
                                  numDetObjPerCfar,...
                                  sumAbsRange)
                                  
    
global velResolution rangeResolution MIN_RANGE_OFFSET_METERS


global maxNumObj2DRaw
global MAX_NUM_DET_PER_RANGE_GATE
global detObj1DRaw detObj2DRaw
global numDopplerBins
global log2numVirAnt


for detIdx2=1:1:numDetObjPerCfar
    
    if (numDetObj2D < maxNumObj2DRaw)
        
        for detIdx1=1:1:MAX_NUM_DET_PER_RANGE_GATE
            
            rangeIdx = cfarDetObjIndexBuf(detIdx2);
            detObj1DRawIdx = (rangeIdx-1)*MAX_NUM_DET_PER_RANGE_GATE + detIdx1;
            
            if ( (detObj1DRaw(detObj1DRawIdx).velDisambFacValidity >=0) &...
                    (detObj1DRaw(detObj1DRawIdx).dopplerIdx == dopplerLine))
                
                %Calculate speed: TODO: The indexing need some work.
                if(dopplerLine >= (numDopplerBins/2)+1)
                    
                    dopplerIdxActual = dopplerLine - (numDopplerBins);
                else
                    
                    dopplerIdxActual = dopplerLine;                   
                    
                end
                
                %disambiguatedSpeed
                speed = (dopplerIdxActual-1)*velResolution;
                
                range = ((rangeIdx-1)*rangeResolution)-MIN_RANGE_OFFSET_METERS;
                
                if(range<0)
                    range=0;
                end
                
                numDetObj2D=numDetObj2D+1;
                
                detObj2DRaw(numDetObj2D).dopplerIdx = dopplerLine;
                detObj2DRaw(numDetObj2D).rangeIdx=rangeIdx;
                %detObj2DRaw(numDetObj2D).speed=fix(disambiguatedSpeed*oneQFormat);
                detObj2DRaw(numDetObj2D).speed=speed;
                detObj2DRaw(numDetObj2D).range=range;
                detObj2DRaw(numDetObj2D).peakVal=sumAbsRange(rangeIdx)/(2^log2numVirAnt);
                detObj2DRaw(numDetObj2D).rangeSNRdB=cfarDetObjSNR(detIdx2)/(2^log2numVirAnt);
                detObj2DRaw(numDetObj2D).dopplerSNRdB=detObj1DRaw(detObj1DRawIdx).dopplerSNRdB;
                
                
                
                
                
            end
            
        end
        
        
    end
    
    
end



end

