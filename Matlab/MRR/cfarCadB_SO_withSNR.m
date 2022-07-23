function [outIdx,out,outSNR] = cfarCadB_SO_withSNR(inp,...
                                            len,...                                            
                                            const1,...
                                            const2,...
                                            guardLen,...
                                            noiseLen)




%----------INPUT-----------------
%inp=fftdabslog2;
%inp=(1:1:32);
%noiseLen=8;
%guardLen=4;
%len=128;
%len=32;
%const1=2389;  %thresholdScale
%const2=4;     %noiseDivShift log2(2*noiseLen)
%---------------------------------

%----------INIT-----------------
%out;
outIdx=0;
out=0;
outSNR=0;
%---------------------------------

for k=1:1:len
    
    
    %Initialize for the loop
    skipLeft=0;
    skipRight=0;
    tempNoiseLeftStart=0xFFF;
    tempNoiseLeftEnd=0xFFF;
    tempNoiseRightStart=0xFFF;
    tempNoiseRightEnd=0xFFF;
    
    
    
    %Find left guard idx
    tempGuardLeftIdx=k-guardLen;
    if(tempGuardLeftIdx<1)
        skipLeft=1;
        
    else
        %Find NoiseLeftStart
        tempNoiseLeftStart=tempGuardLeftIdx-1;
        if(tempNoiseLeftStart<1)
            skipLeft=1;
        else
            %find NoiseLeftEnd
            tempNoiseLeftEnd=tempNoiseLeftStart-noiseLen+1;
            if(tempNoiseLeftEnd<1)
                skipLeft=1;
            end
        end
        
    end
    
    %Find right guard idx
    tempGuardRightIdx=k+guardLen;
    if (tempGuardRightIdx>len)
        skipRight=1;
    else
        %find NoiseRightStart
        tempNoiseRightStart=tempGuardRightIdx+1;
        if (tempNoiseRightStart>len)
            skipRight=1;
        else
            %find NoiseRightEnd
            tempNoiseRightEnd=tempNoiseRightStart+noiseLen-1;
            if (tempNoiseRightEnd>len)
                skipRight=1;
            end
        end
        
        
    end
    
    %storeindices
    cfarIndices(k,1)=k;
    cfarIndices(k,2)=tempGuardLeftIdx;
    cfarIndices(k,3)=tempNoiseLeftStart;
    cfarIndices(k,4)=tempNoiseLeftEnd;
    cfarIndices(k,5)=tempGuardRightIdx;
    cfarIndices(k,6)=tempNoiseRightStart;
    cfarIndices(k,7)=tempNoiseRightEnd;
    cfarIndices(k,8)=skipRight;
    cfarIndices(k,9)=skipLeft;
    
    %find sumleft and sumright
    sumLeft=0;
    sumRight=0;
    
    if(skipRight==0)
        sumRight=sum(inp(tempNoiseRightStart:tempNoiseRightEnd));
    end
    if(skipLeft==0)
        %sumLeft=sum(inp(tempNoiseLeftStart:tempNoiseLeftEnd));
        sumLeft=sum(inp(tempNoiseLeftEnd:tempNoiseLeftStart));
    end
    
    
    %Two-sided comparision
    if( (skipRight==0) && (skipLeft==0) )
        if (sumLeft < sumRight)
            sumTotal=sumLeft;
        else
            sumTotal=sumRight;
        end
        
    elseif ((skipRight==0) && (skipLeft==1) )
        %only right side
        sumTotal= sumRight;
        
    elseif ((skipRight==1) && (skipLeft==0) )
        %only left side
        sumTotal= sumLeft;
        
    end
    
    %C-code: ((sum>>(const2-1)) + const1)
    thld = sumTotal/(2^(const2-1));  % sum>>const2-1
    thld = thld + const1;     %
    
    
    
    cfarIndices(k,10)=sumLeft;
    cfarIndices(k,11)=sumRight;
    cfarIndices(k,12)=sumTotal;
    cfarIndices(k,13)=thld;
    cfarIndices(k,14)=inp(k);
    
    
    if(inp(k)>thld)
        outIdx=outIdx+1;
        out(outIdx)=k;
        temp = sumTotal/(2^(const2-1));
        outSNR(outIdx)=inp(k)-temp;
    end
    
end

end




