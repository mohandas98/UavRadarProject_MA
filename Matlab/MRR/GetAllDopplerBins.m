function dstPingPong = GetAllDopplerBins(randeIdx,rxAntIdx)

global numDopplerBins radarcube


d4=1; % Fast=1, Slow =2;

dstPingPong=complex(zeros(1,numDopplerBins));

for k=1:1:numDopplerBins
        
    dstPingPong(k)=radarcube(k,rxAntIdx,d4,randeIdx);
        
end



end



