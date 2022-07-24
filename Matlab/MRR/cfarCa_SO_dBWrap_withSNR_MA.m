function [outIdx,out,outSNR]=cfarCa_SO_dBWrap_withSNR_MA(inp,...
    len,...
    const1,const2,...
    guardLen,...
    noiseLen)


% Inputs:
% 1- inp: input array (16-bit unsigned number)
% 2- Out array (indices of detected peaks (zero based counting))
% 3- outSNR: SNR array (SNR of detected peaks)
% 4- len: number of elemetns in input array
% 5- const1, const2: used to compare call under test (CUT) to the sum of
%    noise cells
% 6- guardLen: one sided guard length
% 7- noiselen: one sided Noise length
% 8- return: header of detected peaks (i.e length of out)


%plot(fftdabslog2)

%represent it in Q8 16 bit format

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
    
    %Find left guard idx
    tempGuardLeftIdx=k-guardLen;
    if(tempGuardLeftIdx<1)
        tempGuardLeftIdx=tempGuardLeftIdx+len;
    end
    
    %Find NoiseLeftStart
    tempNoiseLeftStart=tempGuardLeftIdx-1;
    if(tempNoiseLeftStart<1)
        tempNoiseLeftStart=tempNoiseLeftStart+len;
    end
    
    tempNoiseLeftEnd=tempNoiseLeftStart-noiseLen+1;
    if(tempNoiseLeftEnd<1)
        tempNoiseLeftEnd=tempNoiseLeftEnd+len;
    end
    
    
    tempGuardRightIdx=k+guardLen;
    if (tempGuardRightIdx>len)
        tempGuardRightIdx=tempGuardRightIdx-len;
    end
    
    
    tempNoiseRightStart=tempGuardRightIdx+1;
    if (tempNoiseRightStart>len)
        tempNoiseRightStart=tempNoiseRightStart-len;
    end
    
    tempNoiseRightEnd=tempNoiseRightStart+noiseLen-1;
    if (tempNoiseRightEnd>len)
        tempNoiseRightEnd=tempNoiseRightEnd-len;
    end
    
    
    %Store indices
    cfarIndices(k,1)=k;
    cfarIndices(k,2)=tempGuardLeftIdx;
    cfarIndices(k,3)=tempNoiseLeftStart;
    cfarIndices(k,4)=tempNoiseLeftEnd;
    cfarIndices(k,5)=tempGuardRightIdx;
    cfarIndices(k,6)=tempNoiseRightStart;
    cfarIndices(k,7)=tempNoiseRightEnd;
    
    %find sumleft and sumright
    sumLeft=0;
    sumRight=0;
    for m=0:1:noiseLen-1
        idx=tempNoiseLeftStart-m;
        if(idx<1)
            idx=idx+len;
        end
        sumLeft=sumLeft+inp(idx);
        
        idx=tempNoiseRightStart+m;
        if(idx>len)
            idx=idx-len;
        end
        sumRight=sumRight+inp(idx);
        
    end
    
    if (sumLeft < sumRight)
        sum=sumLeft;
    else
        sum=sumRight;
    end
    
    %C-code: ((sum>>(const2-1)) + const1)
    thld = sum/(2^(const2-1));  % sum>>const2-1
    thld = thld + const1;     %
    
    
    cfarIndices(k,8)=sumLeft;
    cfarIndices(k,9)=sumRight;
    cfarIndices(k,10)=sum;
    cfarIndices(k,11)=thld;
    
    if(inp(k)>thld)   
        outIdx=outIdx+1;
        out(outIdx)=k;
        temp = sum/(2^(const2-1));
        outSNR(outIdx)=inp(k)-temp;
    end
    
    
    
end

% plot(inp)
% hold on
% plot(cfarIndices(:,11),':r')

end