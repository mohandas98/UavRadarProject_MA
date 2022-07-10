function sumAbs = secondDimFFTandLog2Computation(rangeIdx)

%This function performs 2D FFT

global numRxAnt numTxAnt numDopplerBins radarcube
global Mrr_Win2D

sumAbs=0;

for rxAntIdx=1:1:numRxAnt*numTxAnt
    
    %Get all Dopplerbins for the randeIdx and rxAntIdx        
    dstPingPong=GetAllDopplerBins(rangeIdx,rxAntIdx);
    
    %Perform 2D windowing (mmwavelib_windowing16x32)
    windowingBuf2D=PerformWindowing(dstPingPong,Mrr_Win2D);   
        
    %Perform 2D FFT (DSP_fft32x32)
    %TODO: Check on the scalling 
    fftOut2D=fft(windowingBuf2D);
    
    
    %Perform log2Abs32:
    %---computes log2(abs(x)): why log2?
    %---input 32 bit complex
    %---output 16 bit scaler   
    % Takes a 32 bit complex input vector and computes the log2(abs(x[i])).
    % The abs(a+j*b) is approximated using (max(|a|,|b|) + min(|a|,|b|)*3/8).
    % Subsequently, log2 is found using a lookup table based approximation.
    % The output is a 16 bit number in Q8 format.
    % Thus each value of the output is computed as round(log2(abs(x[i]))*2^8)
    log2Abs=log2(abs(fftOut2D))*2^8;
    
    %Perfrom accumulation: mmwavelib_accum16
    %--Accumulates input vector to the output vector:
    %for(idx=0;idx<len;idx++)
    %out[idx]+=inp[idx];//addition saturated to 0xFFF
    sumAbs=sumAbs+log2Abs;
    
    
    
end



end

