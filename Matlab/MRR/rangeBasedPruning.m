function numObjOut = rangeBasedPruning(numDetectedObjects)



global SNRThresholds peakValThresholds MAX_NUM_RANGE_DEPENDANT_SNR_THRESHOLDS
global detObj2DRaw detObj2D
global maxRange minRange MRR_MAX_OBJ_OUT
numObjOut=0;
j=1;
k=1;

for i=1:1:numDetectedObjects
    
    if((detObj2DRaw(i).range <= maxRange)&& (detObj2DRaw(i).range >= minRange))
        
        searchSNRThresh=0;
        
        if ( detObj2DRaw(i).range > SNRThresholds(j).rangelim)
            
            searchSNRThresh=1;
            
        elseif( j>1)
            
            if(detObj2DRaw(i).range < SNRThresholds(j-1).rangelim)
                
                searchSNRThresh=1;
                
            end
        end
        
        if(searchSNRThresh==1)
            
            for j=1:1:MAX_NUM_RANGE_DEPENDANT_SNR_THRESHOLDS-1
                
                if (detObj2DRaw(i).range < SNRThresholds(j).rangelim)
                    break;
                end
                
            end
            
        end
        
    end
    
    searchpeakValThresh=0;
    if(detObj2DRaw(i).range > peakValThresholds(k).rangelim)
        
        searchpeakValThresh=1;
        
    elseif( k>1)
        if(detObj2DRaw(i).range < peakValThresholds(k-1).rangelim)
            
            searchpeakValThresh=1;
            
        end
    end
    
    if(searchpeakValThresh==1)
        
        for k=1:1:MAX_NUM_RANGE_DEPENDANT_SNR_THRESHOLDS-1
            
            if (detObj2DRaw(i).range < peakValThresholds(k).rangelim)
                break;
            end
            
        end
        
    end
    
    if ( (detObj2DRaw(i).rangeSNRdB > SNRThresholds(j).threshold) &&...
            (detObj2DRaw(i).peakVal > peakValThresholds(j).threshold))
        
        numObjOut=numObjOut+1;
        detObj2D(numObjOut).rangeIdx = detObj2DRaw(i).rangeIdx;
        detObj2D(numObjOut).dopplerIdx = detObj2DRaw(i).dopplerIdx;
        detObj2D(numObjOut).range = detObj2DRaw(i).range;
        detObj2D(numObjOut).speed = detObj2DRaw(i).speed;
        detObj2D(numObjOut).peakVal = detObj2DRaw(i).peakVal;
        detObj2D(numObjOut).rangeSNRdB = detObj2DRaw(i).rangeSNRdB;
        detObj2D(numObjOut).dopplerSNRdB = detObj2DRaw(i).dopplerSNRdB;
        
        if (numObjOut == MRR_MAX_OBJ_OUT)
            
            break;
        end
        
        
    end
    
    
end






end





