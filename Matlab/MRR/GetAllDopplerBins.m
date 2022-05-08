function dstPingPong = GetAllDopplerBins(randeIdx,rxAntIdx)

global numDopplerBins radarcube


d4=1; % Fast=1, Slow =2;

dstPingPong=complex(zeros(1,numDopplerBins));

for k=1:1:numDopplerBins
    
    a=radarcube(1,k,rxAntIdx,d4,randeIdx);
    b=radarcube(2,k,rxAntIdx,d4,randeIdx);
    fftReal=getInt16([a b]);
    
    a=radarcube(3,k,rxAntIdx,d4,randeIdx);
    b=radarcube(4,k,rxAntIdx,d4,randeIdx);
    fftImag=getInt16([a b]);
    
    dstPingPong(k)=fftReal + 1i*fftImag;
    
    
end



end



