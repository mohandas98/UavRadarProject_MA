function [cfarThld] = convertSNRdBtoThreshold(numInteg,...
                                                    ThresholdIndB,...
                                                    bitwidth)

%numInteg: number of 2D FFT summed together
%ThresholdIndB: arbitary
%bitwidth: number of fractional bit

scaleFac=(2^bitwidth)*numInteg;
convertFrom_10Log10_to_20Log2=ThresholdIndB*(1/6);
cfarThld=(scaleFac)*convertFrom_10Log10_to_20Log2;
                                                
                                                
end

